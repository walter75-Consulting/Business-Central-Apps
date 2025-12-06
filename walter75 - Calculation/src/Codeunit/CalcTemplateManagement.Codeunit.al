codeunit 90853 "SEW Calc Template Management"
{
    /// <summary>
    /// Copies template lines to a calculation header.
    /// Creates new calculation lines based on the template.
    /// </summary>
    procedure CopyTemplateToCalc(var CalcHeader: Record "SEW Calc Header")
    begin
        CopyTemplateToCalc(CalcHeader, false);
    end;

    /// <summary>
    /// Copies template lines to a calculation header with optional confirmation skip.
    /// </summary>
    procedure CopyTemplateToCalc(var CalcHeader: Record "SEW Calc Header"; SkipConfirmation: Boolean)
    var
        CalcTemplateLine: Record "SEW Calc Template Line";
        CalcLine: Record "SEW Calc Line";
        LineNo: Integer;
        CopyLinesQst: Label 'Do you want to copy template lines to this calculation?', Comment = 'DE="Möchten Sie die Vorlagenzeilen in diese Kalkulation kopieren?"';
        TemplateCopiedMsg: Label 'Template lines copied successfully. %1 lines created.', Comment = 'DE="Vorlagenzeilen erfolgreich kopiert. %1 Zeilen erstellt."';
        NoTemplateErr: Label 'No template code specified', Comment = 'DE="Kein Vorlagencode angegeben"';
    begin
        if CalcHeader."Template Code" = '' then
            Error(NoTemplateErr);

        // Check if lines already exist
        CalcLine.SetRange("Calc No.", CalcHeader."No.");
        if not CalcLine.IsEmpty() then
            if not SkipConfirmation then
                if not Confirm(CopyLinesQst, false) then
                    exit;

        // Delete existing lines
        CalcLine.DeleteAll(true);

        // Get template lines
        CalcTemplateLine.SetRange("Template Code", CalcHeader."Template Code");
        CalcTemplateLine.SetCurrentKey("Template Code", "Line No.");
        if not CalcTemplateLine.FindSet() then
            exit;

        // Copy lines
        LineNo := 10000;
        repeat
            CalcLine.Init();
            CalcLine."Calc No." := CalcHeader."No.";
            CalcLine."Line No." := LineNo;
            CalcLine.Type := CalcTemplateLine.Type;
            CalcLine.Description := CalcTemplateLine.Description;
            CalcLine.Indentation := CalcTemplateLine.Indentation;
            CalcLine.Bold := CalcTemplateLine.Bold;
            CalcLine."Show in Report" := CalcTemplateLine."Show in Report";
            CalcLine.Formula := CalcTemplateLine.Formula;
            CalcLine."Variable Code" := CalcTemplateLine."Variable Code";
            CalcLine."Source Type" := CalcLine."Source Type"::Formula;
            CalcLine.Insert(true);

            LineNo += 10000;
        until CalcTemplateLine.Next() = 0;

        if not SkipConfirmation then
            Message(TemplateCopiedMsg, CalcLine.Count);
    end;

    /// <summary>
    /// Validates a template for circular references and invalid formulas.
    /// </summary>
    procedure ValidateTemplate(TemplateCode: Code[20]): Boolean
    var
        CalcTemplateLine: Record "SEW Calc Template Line";
        FormulaParser: Codeunit "SEW Calc Formula Parser";
    begin
        CalcTemplateLine.SetRange("Template Code", TemplateCode);
        if CalcTemplateLine.FindSet() then
            repeat
                if CalcTemplateLine.Formula <> '' then begin
                    if not FormulaParser.TestFormula(CalcTemplateLine.Formula) then
                        exit(false);
                end;
            until CalcTemplateLine.Next() = 0;

        exit(true);
    end;

    /// <summary>
    /// Creates a new template based on an existing one (template copy).
    /// </summary>
    procedure CopyTemplate(FromTemplateCode: Code[20]; ToTemplateCode: Code[20]; ToDescription: Text[100])
    var
        FromTemplate: Record "SEW Calc Template";
        ToTemplate: Record "SEW Calc Template";
        FromTemplateLine: Record "SEW Calc Template Line";
        ToTemplateLine: Record "SEW Calc Template Line";
        TemplateExistsErr: Label 'Template %1 already exists', Comment = 'DE="Vorlage %1 existiert bereits"';
    begin
        if not FromTemplate.Get(FromTemplateCode) then
            exit;

        if ToTemplate.Get(ToTemplateCode) then
            Error(TemplateExistsErr, ToTemplateCode);

        // Copy header
        ToTemplate.Init();
        ToTemplate.Code := ToTemplateCode;
        ToTemplate.Description := ToDescription;
        ToTemplate."Description 2" := FromTemplate."Description 2";
        ToTemplate."Price Source Item" := FromTemplate."Price Source Item";
        ToTemplate."Price Source Capacity" := FromTemplate."Price Source Capacity";
        ToTemplate."Include Material" := FromTemplate."Include Material";
        ToTemplate."Include Labor" := FromTemplate."Include Labor";
        ToTemplate."Include Overhead" := FromTemplate."Include Overhead";
        ToTemplate.Status := ToTemplate.Status::Draft;
        ToTemplate.Insert(true);

        // Copy lines
        FromTemplateLine.SetRange("Template Code", FromTemplateCode);
        if FromTemplateLine.FindSet() then
            repeat
                ToTemplateLine.Init();
                ToTemplateLine."Template Code" := ToTemplateCode;
                ToTemplateLine."Line No." := FromTemplateLine."Line No.";
                ToTemplateLine.Type := FromTemplateLine.Type;
                ToTemplateLine.Description := FromTemplateLine.Description;
                ToTemplateLine.Indentation := FromTemplateLine.Indentation;
                ToTemplateLine.Bold := FromTemplateLine.Bold;
                ToTemplateLine."Show in Report" := FromTemplateLine."Show in Report";
                ToTemplateLine.Formula := FromTemplateLine.Formula;
                ToTemplateLine."Variable Code" := FromTemplateLine."Variable Code";
                ToTemplateLine.Insert(true);
            until FromTemplateLine.Next() = 0;
    end;

    /// <summary>
    /// Archives a calculation by changing its status.
    /// </summary>
    procedure ArchiveCalculation(var CalcHeader: Record "SEW Calc Header")
    begin
        ArchiveCalculation(CalcHeader, false);
    end;

    /// <summary>
    /// Archives a calculation by changing its status with optional confirmation skip.
    /// </summary>
    procedure ArchiveCalculation(var CalcHeader: Record "SEW Calc Header"; SkipConfirmation: Boolean)
    var
        ArchiveQst: Label 'Do you want to archive this calculation?', Comment = 'DE="Möchten Sie diese Kalkulation archivieren?"';
    begin
        if not SkipConfirmation then
            if not Confirm(ArchiveQst, false) then
                exit;

        CalcHeader.Status := CalcHeader.Status::Archived;
        CalcHeader.Modify(true);
    end;

    /// <summary>
    /// Releases a calculation for use.
    /// </summary>
    procedure ReleaseCalculation(var CalcHeader: Record "SEW Calc Header")
    begin
        ReleaseCalculation(CalcHeader, false);
    end;

    /// <summary>
    /// Releases a calculation for use with optional confirmation skip.
    /// </summary>
    procedure ReleaseCalculation(var CalcHeader: Record "SEW Calc Header"; SkipConfirmation: Boolean)
    var
        ReleaseQst: Label 'Do you want to release this calculation?', Comment = 'DE="Möchten Sie diese Kalkulation freigeben?"';
    begin
        if not SkipConfirmation then
            if not Confirm(ReleaseQst, false) then
                exit;

        CalcHeader.Status := CalcHeader.Status::Released;
        CalcHeader.Modify(true);
    end;

    /// <summary>
    /// Reopens a released calculation for editing.
    /// </summary>
    procedure ReopenCalculation(var CalcHeader: Record "SEW Calc Header")
    begin
        ReopenCalculation(CalcHeader, false);
    end;

    /// <summary>
    /// Reopens a released calculation for editing with optional confirmation skip.
    /// </summary>
    procedure ReopenCalculation(var CalcHeader: Record "SEW Calc Header"; SkipConfirmation: Boolean)
    var
        ReopenQst: Label 'Do you want to reopen this calculation for editing?', Comment = 'DE="Möchten Sie diese Kalkulation zum Bearbeiten wieder öffnen?"';
    begin
        if not SkipConfirmation then
            if not Confirm(ReopenQst, false) then
                exit;

        CalcHeader.Status := CalcHeader.Status::Draft;
        CalcHeader.Modify(true);
    end;

}
