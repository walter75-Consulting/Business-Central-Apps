codeunit 90855 "SEW Calc Integration Mgt."
{
    Permissions = tabledata "Sales Header" = rm,
                  tabledata "Sales Line" = rm,
                  tabledata "SEW Calc Header" = rim,
                  tabledata "SEW Calc Line" = rim;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateSalesLineNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        SalesHeaderRec: Record "Sales Header";
    begin
        if Rec.IsTemporary then
            exit;

        if Rec."Document Type" <> Rec."Document Type"::Quote then
            exit;

        if Rec."No." = '' then
            exit;

        if Rec.Type <> Rec.Type::Item then
            exit;

        if not SalesHeaderRec.Get(Rec."Document Type", Rec."Document No.") then
            exit;

        if not SalesHeaderRec."SEW Auto Calculate" then
            exit;

        CreateCalculationForLine(Rec, SalesHeaderRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Unit Price', false, false)]
    local procedure OnAfterValidateSalesLineUnitPrice(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if Rec.IsTemporary then
            exit;

        if Rec."SEW Calc No." = '' then
            exit;

        if Rec."SEW Calculated Cost" = 0 then
            exit;

        CalculateMargin(Rec);
        Rec.Modify(true);
    end;

    procedure CreateCalculationForLine(var SalesLineRec: Record "Sales Line"; SalesHeaderRec: Record "Sales Header")
    var
        CalcHeaderRec: Record "SEW Calc Header";
        CalcEngineCodeunit: Codeunit "SEW Calc Engine";
        TemplateManagementCodeunit: Codeunit "SEW Calc Template Management";
    begin
        if SalesLineRec."SEW Calc No." <> '' then
            exit;

        if SalesHeaderRec."SEW Default Calc Template" = '' then
            exit;

        CalcHeaderRec.Init();
        CalcHeaderRec."No." := '';
        CalcHeaderRec.Insert(true);

        CalcHeaderRec.Validate("Template Code", SalesHeaderRec."SEW Default Calc Template");
        CalcHeaderRec.Validate("Item No.", SalesLineRec."No.");
        CalcHeaderRec.Validate("Lot Size", SalesLineRec.Quantity);
        CalcHeaderRec.Modify(true);

        TemplateManagementCodeunit.CopyTemplateToCalc(CalcHeaderRec, true);
        CalcEngineCodeunit.Calculate(CalcHeaderRec, true);

        UpdateSalesLineFromCalc(SalesLineRec, CalcHeaderRec);
    end;

    procedure UpdateSalesLineFromCalc(var SalesLineRec: Record "Sales Line"; CalcHeaderRec: Record "SEW Calc Header")
    var
        SalesSetupRec: Record "Sales & Receivables Setup";
        TargetMarginPct: Decimal;
    begin
        SalesLineRec."SEW Calc No." := CalcHeaderRec."No.";
        SalesLineRec."SEW Calculated Cost" := CalcHeaderRec."Total Cost";
        // Cost fields are standard fields, not FlowFields - no CalcFields needed

        if SalesSetupRec.Get() then
            TargetMarginPct := 25.0
        else
            TargetMarginPct := 25.0;

        if CalcHeaderRec."Total Cost" <> 0 then begin
            SalesLineRec."SEW Target Price" := CalcHeaderRec."Total Cost" * (1 + (TargetMarginPct / 100));
            SalesLineRec."Unit Price" := SalesLineRec."SEW Target Price";
        end;

        CalculateMargin(SalesLineRec);

        SalesLineRec.Modify(true);
    end;

    local procedure CalculateMargin(var SalesLineRec: Record "Sales Line")
    begin
        if SalesLineRec."Unit Price" = 0 then begin
            SalesLineRec."SEW Calculated Margin %" := 0;
            exit;
        end;

        if SalesLineRec."SEW Calculated Cost" = 0 then begin
            SalesLineRec."SEW Calculated Margin %" := 100;
            exit;
        end;

        SalesLineRec."SEW Calculated Margin %" :=
            ((SalesLineRec."Unit Price" - SalesLineRec."SEW Calculated Cost") / SalesLineRec."Unit Price") * 100;
    end;

    procedure CalculateSalesLinePrice(var SalesLineRec: Record "Sales Line")
    var
        SalesHeaderRec: Record "Sales Header";
        CalcHeaderRec: Record "SEW Calc Header";
        CalcEngineCodeunit: Codeunit "SEW Calc Engine";
        TemplateManagementCodeunit: Codeunit "SEW Calc Template Management";
        TargetMarginPct: Decimal;
    begin
        TargetMarginPct := 25.0;
        if not SalesHeaderRec.Get(SalesLineRec."Document Type", SalesLineRec."Document No.") then
            exit;

        if SalesLineRec."SEW Calc No." <> '' then begin
            if CalcHeaderRec.Get(SalesLineRec."SEW Calc No.") then begin
                CalcEngineCodeunit.Calculate(CalcHeaderRec, true);
                SalesLineRec."SEW Target Price" := CalcHeaderRec."Total Cost" * (1 + (TargetMarginPct / 100));
                UpdateSalesLineFromCalc(SalesLineRec, CalcHeaderRec);
            end;
        end else
            CreateCalculationForLine(SalesLineRec, SalesHeaderRec);
    end;

    procedure ValidateMargin(SalesLineRec: Record "Sales Line"): Boolean
    var
        MinMarginPct: Decimal;
    begin
        MinMarginPct := 15.0;

        if SalesLineRec."SEW Calculated Margin %" < MinMarginPct then
            exit(false);

        exit(true);
    end;
}
