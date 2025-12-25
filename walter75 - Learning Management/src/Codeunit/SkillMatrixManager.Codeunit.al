/// <summary>
/// Codeunit SEW Skill Matrix Manager (ID 91862).
/// Updates employee skill matrix based on completed training.
/// </summary>
codeunit 91862 "SEW Skill Matrix Manager"
{
    Permissions =
    tabledata "SEW Employee Skill" = rimd,
    tabledata "SEW Skill Learning Mapping" = r,
    tabledata "SEW Empl. Learning Assign." = r;

    /// <summary>
    /// Updates all skills for an employee based on completed training.
    /// </summary>
    /// <param name="EmployeeNo">Employee number.</param>
    procedure UpdateEmployeeSkills(EmployeeNo: Code[20])
    var
        Assignment: Record "SEW Empl. Learning Assign.";
        EmployeeSkill: Record "SEW Employee Skill";
        SkillCode: Code[20];
        NewProficiency: Enum "SEW Proficiency Level";
    begin
        // Get all completed assignments for employee
        Assignment.SetRange("Employee No.", EmployeeNo);
        Assignment.SetRange(Status, Assignment.Status::Completed);
        if not Assignment.FindSet() then
            exit;

        // Process each assignment
        repeat
            ProcessCompletedAssignment(Assignment."Entry No.");
        until Assignment.Next() = 0;
    end;

    /// <summary>
    /// Processes a completed assignment to update employee skills.
    /// </summary>
    /// <param name="AssignmentEntryNo">Assignment Entry No.</param>
    procedure ProcessCompletedAssignment(AssignmentEntryNo: Integer)
    var
        Assignment: Record "SEW Empl. Learning Assign.";
        SkillMapping: Record "SEW Skill Learning Mapping";
        EmployeeSkill: Record "SEW Employee Skill";
    begin
        if not Assignment.Get(AssignmentEntryNo) then
            exit;

        if Assignment.Status <> Assignment.Status::Completed then
            exit;

        // Find skills taught by this content
        SkillMapping.SetRange("Content Type", Assignment."Assignment Type");
        case Assignment."Assignment Type" of
            Assignment."Assignment Type"::Module:
                SkillMapping.SetRange("Content UID", Assignment."Learn Cont UID");
            Assignment."Assignment Type"::"Learning Path":
                SkillMapping.SetRange("Content UID", Assignment."Learn Cont UID");
        end;

        if SkillMapping.FindSet() then
            repeat
                UpdateEmployeeSkillFromMapping(Assignment."Employee No.", SkillMapping);
                OnAfterSkillUpdated(Assignment."Employee No.", SkillMapping."Skill Code", SkillMapping."Proficiency Level Gained");
            until SkillMapping.Next() = 0;
    end;

    /// <summary>
    /// Calculates proficiency level for a skill based on completed training.
    /// </summary>
    /// <param name="EmployeeNo">Employee number.</param>
    /// <param name="SkillCode">Skill code.</param>
    /// <returns>Proficiency level.</returns>
    procedure CalculateProficiencyLevel(EmployeeNo: Code[20]; SkillCode: Code[20]): Enum "SEW Proficiency Level"
    var
        Assignment: Record "SEW Empl. Learning Assign.";
        SkillMapping: Record "SEW Skill Learning Mapping";
        MaxProficiency: Integer;
        CurrentProficiency: Integer;
    begin
        MaxProficiency := 0;

        // Get all completed assignments with this skill
        Assignment.SetRange("Employee No.", EmployeeNo);
        Assignment.SetRange(Status, Assignment.Status::Completed);
        if Assignment.FindSet() then
            repeat
                SkillMapping.SetRange("Skill Code", SkillCode);
                SkillMapping.SetRange("Content Type", Assignment."Assignment Type");
                case Assignment."Assignment Type" of
                    Assignment."Assignment Type"::Module:
                        SkillMapping.SetRange("Content UID", Assignment."Learn Cont UID");
                    Assignment."Assignment Type"::"Learning Path":
                        SkillMapping.SetRange("Content UID", Assignment."Learn Cont UID");
                end;

                if SkillMapping.FindFirst() then begin
                    CurrentProficiency := SkillMapping."Proficiency Level Gained".AsInteger();
                    if CurrentProficiency > MaxProficiency then
                        MaxProficiency := CurrentProficiency;
                end;
            until Assignment.Next() = 0;

        exit(Enum::"SEW Proficiency Level".FromInteger(MaxProficiency));
    end;

    /// <summary>
    /// Gets skill gaps for an employee compared to a role.
    /// </summary>
    /// <param name="EmployeeNo">Employee number.</param>
    /// <param name="RoleCode">Role code.</param>
    /// <returns>List of missing skill codes.</returns>
    procedure GetRoleSkillGaps(EmployeeNo: Code[20]; RoleCode: Code[20]) SkillGaps: List of [Code[20]]
    var
        RoleRequirement: Record "SEW Role Skill Requirement";
        EmployeeSkill: Record "SEW Employee Skill";
    begin
        RoleRequirement.SetRange("Role Code", RoleCode);
        if RoleRequirement.FindSet() then
            repeat
                if not EmployeeSkill.Get(EmployeeNo, RoleRequirement."Skill Code") then
                    SkillGaps.Add(RoleRequirement."Skill Code")
                else
                    if EmployeeSkill."Proficiency Level".AsInteger() < RoleRequirement."Minimum Proficiency".AsInteger() then
                        SkillGaps.Add(RoleRequirement."Skill Code");
            until RoleRequirement.Next() = 0;
    end;

    local procedure UpdateEmployeeSkillFromMapping(EmployeeNo: Code[20]; SkillMapping: Record "SEW Skill Learning Mapping")
    var
        EmployeeSkill: Record "SEW Employee Skill";
    begin
        if not EmployeeSkill.Get(EmployeeNo, SkillMapping."Skill Code") then begin
            // Create new skill record
            EmployeeSkill.Init();
            EmployeeSkill."Employee No." := EmployeeNo;
            EmployeeSkill."Skill Code" := SkillMapping."Skill Code";
            EmployeeSkill."Proficiency Level" := SkillMapping."Proficiency Level Gained";
            EmployeeSkill.Source := EmployeeSkill.Source::"Training Completion";
            EmployeeSkill."Acquired Date" := Today;
            EmployeeSkill."Last Assessed Date" := Today;
            EmployeeSkill.Insert(true);
        end else begin
            // Update existing skill if new proficiency is higher
            if EmployeeSkill.Source = EmployeeSkill.Source::"Training Completion" then
                if SkillMapping."Proficiency Level Gained".AsInteger() > EmployeeSkill."Proficiency Level".AsInteger() then begin
                    EmployeeSkill."Proficiency Level" := SkillMapping."Proficiency Level Gained";
                    EmployeeSkill."Last Assessed Date" := Today;
                    EmployeeSkill.Modify(true);
                end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSkillUpdated(EmployeeNo: Code[20]; SkillCode: Code[20]; NewLevel: Enum "SEW Proficiency Level")
    begin
    end;
}
