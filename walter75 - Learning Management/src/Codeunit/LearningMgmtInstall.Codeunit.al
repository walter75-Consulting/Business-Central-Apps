/// <summary>
/// Codeunit SEW Learning Mgmt Install (ID 91800).
/// Handles installation and initial setup.
/// </summary>
codeunit 91800 "SEW Learning Mgmt Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        InitializeSetup();
        CreateDefaultSkills();
        CreateDefaultRoles();
    end;

    local procedure InitializeSetup()
    var
        Setup: Record "SEW Learning Mgmt Setup";
    begin
        Setup.InsertIfNotExists();
    end;

    local procedure CreateDefaultSkills()
    var
        Skill: Record "SEW Skill";
    begin
        InsertSkillIfNotExists('FIN-GL', 'General Ledger & Financial Management', Skill."Skill Category"::Functional);
        InsertSkillIfNotExists('FIN-AR', 'Accounts Receivable', Skill."Skill Category"::Functional);
        InsertSkillIfNotExists('FIN-AP', 'Accounts Payable', Skill."Skill Category"::Functional);
        InsertSkillIfNotExists('INV-MGMT', 'Inventory Management', Skill."Skill Category"::Functional);
        InsertSkillIfNotExists('SALES', 'Sales Management', Skill."Skill Category"::Functional);
        InsertSkillIfNotExists('PURCH', 'Purchasing Management', Skill."Skill Category"::Functional);
        InsertSkillIfNotExists('WHSE', 'Warehouse Management', Skill."Skill Category"::Functional);
        InsertSkillIfNotExists('MFG', 'Manufacturing', Skill."Skill Category"::Functional);
        InsertSkillIfNotExists('SVC', 'Service Management', Skill."Skill Category"::Functional);

        InsertSkillIfNotExists('DEV-AL', 'AL Development', Skill."Skill Category"::Technical);
        InsertSkillIfNotExists('DEV-API', 'API Development', Skill."Skill Category"::Technical);
        InsertSkillIfNotExists('DEV-EXT', 'Extension Development', Skill."Skill Category"::Technical);
        InsertSkillIfNotExists('ADMIN', 'System Administration', Skill."Skill Category"::Technical);
        InsertSkillIfNotExists('CONFIG', 'System Configuration', Skill."Skill Category"::Technical);

        InsertSkillIfNotExists('BP-IMPL', 'Implementation Management', Skill."Skill Category"::"Business Process");
        InsertSkillIfNotExists('BP-TRAIN', 'User Training', Skill."Skill Category"::"Business Process");
        InsertSkillIfNotExists('BP-SUPP', 'End User Support', Skill."Skill Category"::"Business Process");
    end;

    local procedure CreateDefaultRoles()
    var
        RoleRequirement: Record "SEW Role Skill Requirement";
    begin
        // Functional Consultant role
        InsertRoleRequirementIfNotExists('FUNC-CONS', 'FIN-GL', RoleRequirement."Minimum Proficiency"::Intermediate, true);
        InsertRoleRequirementIfNotExists('FUNC-CONS', 'FIN-AR', RoleRequirement."Minimum Proficiency"::Intermediate, true);
        InsertRoleRequirementIfNotExists('FUNC-CONS', 'FIN-AP', RoleRequirement."Minimum Proficiency"::Intermediate, true);
        InsertRoleRequirementIfNotExists('FUNC-CONS', 'INV-MGMT', RoleRequirement."Minimum Proficiency"::Beginner, true);
        InsertRoleRequirementIfNotExists('FUNC-CONS', 'BP-IMPL', RoleRequirement."Minimum Proficiency"::Intermediate, true);

        // Developer role
        InsertRoleRequirementIfNotExists('DEVELOPER', 'DEV-AL', RoleRequirement."Minimum Proficiency"::Advanced, true);
        InsertRoleRequirementIfNotExists('DEVELOPER', 'DEV-API', RoleRequirement."Minimum Proficiency"::Intermediate, true);
        InsertRoleRequirementIfNotExists('DEVELOPER', 'DEV-EXT', RoleRequirement."Minimum Proficiency"::Intermediate, true);

        // System Administrator role
        InsertRoleRequirementIfNotExists('SYS-ADMIN', 'ADMIN', RoleRequirement."Minimum Proficiency"::Advanced, true);
        InsertRoleRequirementIfNotExists('SYS-ADMIN', 'CONFIG', RoleRequirement."Minimum Proficiency"::Intermediate, true);
    end;

    local procedure InsertSkillIfNotExists(Code: Code[20]; Description: Text[100]; Category: Enum "SEW Skill Category")
    var
        Skill: Record "SEW Skill";
    begin
        if not Skill.Get(Code) then begin
            Skill.Init();
            Skill.Code := Code;
            Skill.Description := Description;
            Skill."Skill Category" := Category;
            Skill.Insert(true);
        end;
    end;

    local procedure InsertRoleRequirementIfNotExists(RoleCode: Code[20]; SkillCode: Code[20]; MinProficiency: Enum "SEW Proficiency Level"; IsMandatory: Boolean)
    var
        RoleRequirement: Record "SEW Role Skill Requirement";
    begin
        if not RoleRequirement.Get(RoleCode, SkillCode) then begin
            RoleRequirement.Init();
            RoleRequirement."Role Code" := RoleCode;
            RoleRequirement."Skill Code" := SkillCode;
            RoleRequirement."Minimum Proficiency" := MinProficiency;
            RoleRequirement.Mandatory := IsMandatory;
            RoleRequirement.Insert(true);
        end;
    end;
}
