codeunit 90853 "SEW Calc Template Management"
{
    Permissions = tabledata "SEW Calc Header" = rm,
                  tabledata "SEW Calc Line" = rimd,
                  tabledata "SEW Calc Template" = ri,
                  tabledata "SEW Calc Template Line" = ri;

    /// <summary>
    /// Copies template lines to a calculation header.
    /// Creates new calculation lines based on the template.
    /// </summary>
    /// <param name="SEWCalcHeader">The calculation header record.</param>
    procedure CopyTemplateToCalc(var SEWCalcHeader: Record "SEW Calc Header")
    begin
        CopyTemplateToCalc(SEWCalcHeader, false);
    end;

    /// <summary>
    /// Copies template lines to a calculation header with optional confirmation skip.
    /// </summary>
    /// <param name="SEWCalcHeader">The calculation header record.</param>
    /// <param name="SkipConfirmation">If true, skips confirmation dialogs.</param>
    procedure CopyTemplateToCalc(var SEWCalcHeader: Record "SEW Calc Header"; SkipConfirmation: Boolean)
    var
        SEWCalcTemplateLine: Record "SEW Calc Template Line";
        SEWCalcLine: Record "SEW Calc Line";
        ConfirmManagement: Codeunit "Confirm Management";
        LineNo: Integer;
        CopyLinesQst: Label 'Do you want to copy template lines to this calculation?', Comment = 'DE="Möchten Sie die Vorlagenzeilen in diese Kalkulation kopieren?"';
        TemplateCopiedMsg: Label 'Template lines copied successfully. %1 lines created.', Comment = 'DE="Vorlagenzeilen erfolgreich kopiert. %1 Zeilen erstellt."';
        NoTemplateErr: Label 'No template code specified', Comment = 'DE="Kein Vorlagencode angegeben"';
    begin
        if SEWCalcHeader."Template Code" = '' then
            Error(NoTemplateErr);

        // Check if lines already exist
        SEWCalcLine.SetRange("Calc No.", SEWCalcHeader."No.");
        if not SEWCalcLine.IsEmpty() then
            if not SkipConfirmation then
                if not ConfirmManagement.GetResponseOrDefault(CopyLinesQst, false) then
                    exit;

        // Delete existing lines
        SEWCalcLine.DeleteAll(true);

        // Get template lines
        SEWCalcTemplateLine.SetRange("Template Code", SEWCalcHeader."Template Code");
        SEWCalcTemplateLine.SetCurrentKey("Template Code", "Line No.");
        if not SEWCalcTemplateLine.FindSet() then
            exit;

        // Copy lines
        LineNo := 10000;
        repeat
            SEWCalcLine.Init();
            SEWCalcLine."Calc No." := SEWCalcHeader."No.";
            SEWCalcLine."Line No." := LineNo;
            SEWCalcLine.Type := SEWCalcTemplateLine.Type;
            SEWCalcLine.Description := SEWCalcTemplateLine.Description;
            SEWCalcLine.Indentation := SEWCalcTemplateLine.Indentation;
            SEWCalcLine.Bold := SEWCalcTemplateLine.Bold;
            SEWCalcLine."Show in Report" := SEWCalcTemplateLine."Show in Report";
            SEWCalcLine.Formula := SEWCalcTemplateLine.Formula;
            SEWCalcLine."Variable Code" := SEWCalcTemplateLine."Variable Code";
            SEWCalcLine."Source Type" := SEWCalcLine."Source Type"::Formula;
            SEWCalcLine.Insert(true);

            LineNo += 10000;
        until SEWCalcTemplateLine.Next() = 0;

        if not SkipConfirmation then
            Message(TemplateCopiedMsg, SEWCalcLine.Count());
    end;

    /// <summary>
    /// Validates a template for circular references and invalid formulas.
    /// </summary>
    /// <param name="TemplateCode">The template code to validate.</param>
    /// <returns>True if valid, false otherwise.</returns>
    procedure ValidateTemplate(TemplateCode: Code[20]): Boolean
    var
        SEWCalcTemplateLine: Record "SEW Calc Template Line";
        SEWCalcFormulaParser: Codeunit "SEW Calc Formula Parser";
    begin
        SEWCalcTemplateLine.SetRange("Template Code", TemplateCode);
        if SEWCalcTemplateLine.FindSet() then
            repeat
                if SEWCalcTemplateLine.Formula <> '' then
                    if not SEWCalcFormulaParser.TestFormula(SEWCalcTemplateLine.Formula) then
                        exit(false);
            until SEWCalcTemplateLine.Next() = 0;

        exit(true);
    end;

    /// <summary>
    /// Creates a new template based on an existing one (template copy).
    /// </summary>
    /// <param name="FromTemplateCode">The source template code to copy from.</param>
    /// <param name="ToTemplateCode">The target template code to create.</param>
    /// <param name="ToDescription">The description for the new template.</param>
    procedure CopyTemplate(FromTemplateCode: Code[20]; ToTemplateCode: Code[20]; ToDescription: Text[100])
    var
        SEWCalcTemplateFrom: Record "SEW Calc Template";
        SEWCalcTemplateTo: Record "SEW Calc Template";
        SEWCalcTemplateLineFrom: Record "SEW Calc Template Line";
        SEWCalcTemplateLineTo: Record "SEW Calc Template Line";
        TemplateExistsErr: Label 'Template %1 already exists', Comment = 'DE="Vorlage %1 existiert bereits"';
    begin
        if not SEWCalcTemplateFrom.Get(FromTemplateCode) then
            exit;

        if SEWCalcTemplateTo.Get(ToTemplateCode) then
            Error(TemplateExistsErr, ToTemplateCode);

        // Copy header
        SEWCalcTemplateTo.Init();
        SEWCalcTemplateTo.Code := ToTemplateCode;
        SEWCalcTemplateTo.Description := ToDescription;
        SEWCalcTemplateTo."Description 2" := SEWCalcTemplateFrom."Description 2";
        SEWCalcTemplateTo."Price Source Item" := SEWCalcTemplateFrom."Price Source Item";
        SEWCalcTemplateTo."Price Source Capacity" := SEWCalcTemplateFrom."Price Source Capacity";
        SEWCalcTemplateTo."Include Material" := SEWCalcTemplateFrom."Include Material";
        SEWCalcTemplateTo."Include Labor" := SEWCalcTemplateFrom."Include Labor";
        SEWCalcTemplateTo."Include Overhead" := SEWCalcTemplateFrom."Include Overhead";
        SEWCalcTemplateTo.Status := SEWCalcTemplateTo.Status::Draft;
        SEWCalcTemplateTo.Insert(true);

        // Copy lines
        SEWCalcTemplateLineFrom.SetRange("Template Code", FromTemplateCode);
        if SEWCalcTemplateLineFrom.FindSet() then
            repeat
                SEWCalcTemplateLineTo.Init();
                SEWCalcTemplateLineTo."Template Code" := ToTemplateCode;
                SEWCalcTemplateLineTo."Line No." := SEWCalcTemplateLineFrom."Line No.";
                SEWCalcTemplateLineTo.Type := SEWCalcTemplateLineFrom.Type;
                SEWCalcTemplateLineTo.Description := SEWCalcTemplateLineFrom.Description;
                SEWCalcTemplateLineTo.Indentation := SEWCalcTemplateLineFrom.Indentation;
                SEWCalcTemplateLineTo.Bold := SEWCalcTemplateLineFrom.Bold;
                SEWCalcTemplateLineTo."Show in Report" := SEWCalcTemplateLineFrom."Show in Report";
                SEWCalcTemplateLineTo.Formula := SEWCalcTemplateLineFrom.Formula;
                SEWCalcTemplateLineTo."Variable Code" := SEWCalcTemplateLineFrom."Variable Code";
                SEWCalcTemplateLineTo.Insert(true);
            until SEWCalcTemplateLineFrom.Next() = 0;
    end;

    /// <summary>
    /// Archives a calculation by changing its status.
    /// </summary>
    /// <param name="SEWCalcHeader">The calculation header record.</param>
    procedure ArchiveCalculation(var SEWCalcHeader: Record "SEW Calc Header")
    begin
        ArchiveCalculation(SEWCalcHeader, false);
    end;

    /// <summary>
    /// Archives a calculation by changing its status with optional confirmation skip.
    /// </summary>
    /// <param name="SEWCalcHeader">The calculation header record.</param>
    /// <param name="SkipConfirmation">If true, skips confirmation dialogs.</param>
    procedure ArchiveCalculation(var SEWCalcHeader: Record "SEW Calc Header"; SkipConfirmation: Boolean)
    var
        ConfirmManagement: Codeunit "Confirm Management";
        ArchiveQst: Label 'Do you want to archive this calculation?', Comment = 'DE="Möchten Sie diese Kalkulation archivieren?"';
    begin
        if not SkipConfirmation then
            if not ConfirmManagement.GetResponseOrDefault(ArchiveQst, false) then
                exit;

        SEWCalcHeader.Status := SEWCalcHeader.Status::Archived;
        SEWCalcHeader.Modify(true);
    end;

    /// <summary>
    /// Releases a calculation for use.
    /// </summary>
    /// <param name="SEWCalcHeader">The calculation header record.</param>
    procedure ReleaseCalculation(var SEWCalcHeader: Record "SEW Calc Header")
    begin
        ReleaseCalculation(SEWCalcHeader, false);
    end;

    /// <summary>
    /// Releases a calculation for use with optional confirmation skip.
    /// </summary>
    /// <param name="SEWCalcHeader">The calculation header record.</param>
    /// <param name="SkipConfirmation">If true, skips confirmation dialogs.</param>
    procedure ReleaseCalculation(var SEWCalcHeader: Record "SEW Calc Header"; SkipConfirmation: Boolean)
    var
        ConfirmManagement: Codeunit "Confirm Management";
        ReleaseQst: Label 'Do you want to release this calculation?', Comment = 'DE="Möchten Sie diese Kalkulation freigeben?"';
    begin
        if not SkipConfirmation then
            if not ConfirmManagement.GetResponseOrDefault(ReleaseQst, false) then
                exit;

        SEWCalcHeader.Status := SEWCalcHeader.Status::Released;
        SEWCalcHeader.Modify(true);
    end;

    /// <summary>
    /// Reopens a released calculation for editing.
    /// </summary>
    /// <param name="SEWCalcHeader">The calculation header record.</param>
    procedure ReopenCalculation(var SEWCalcHeader: Record "SEW Calc Header")
    begin
        ReopenCalculation(SEWCalcHeader, false);
    end;

    /// <summary>
    /// Reopens a released calculation for editing with optional confirmation skip.
    /// </summary>
    /// <param name="SEWCalcHeader">The calculation header record.</param>
    /// <param name="SkipConfirmation">If true, skips confirmation dialogs.</param>
    procedure ReopenCalculation(var SEWCalcHeader: Record "SEW Calc Header"; SkipConfirmation: Boolean)
    var
        ConfirmManagement: Codeunit "Confirm Management";
        ReopenQst: Label 'Do you want to reopen this calculation for editing?', Comment = 'DE="Möchten Sie diese Kalkulation zum Bearbeiten wieder öffnen?"';
    begin
        if not SkipConfirmation then
            if not ConfirmManagement.GetResponseOrDefault(ReopenQst, false) then
                exit;

        SEWCalcHeader.Status := SEWCalcHeader.Status::Draft;
        SEWCalcHeader.Modify(true);
    end;

}
