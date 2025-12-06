codeunit 90858 "SEW Calc Export Management"
{
    Permissions = tabledata "SEW Calc Header" = r,
                  tabledata "SEW Calc Line" = r,
                  tabledata "SEW Calc Template" = r,
                  tabledata "SEW Calc Template Line" = r,
                  tabledata "SEW Calc Simulation Header" = r,
                  tabledata "SEW Calc Simulation Line" = r;

    var
        ExcelFileNameTxt: Label 'Calculation_%1.xlsx', Comment = 'DE="Kalkulation_%1.xlsx"';
        SimulationFileNameTxt: Label 'Simulation_%1.xlsx', Comment = 'DE="Simulation_%1.xlsx"';
        TemplateFileNameTxt: Label 'Template_%1.xlsx', Comment = 'DE="Vorlage_%1.xlsx"';
        ExportSuccessMsg: Label 'Excel file exported successfully', Comment = 'DE="Excel-Datei erfolgreich exportiert"';
        NoLinesErr: Label 'No lines to export for %1', Comment = 'DE="Keine Zeilen zum Exportieren für %1"';

    procedure ExportCalculationToExcel(CalcNo: Code[20])
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcLine: Record "SEW Calc Line";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileName: Text;
        RowNo: Integer;
    begin
        if not SEWCalcHeader.Get(CalcNo) then
            Error('Calculation %1 not found', CalcNo);

        SEWCalcLine.SetRange("Calc No.", CalcNo);
        if not SEWCalcLine.FindSet() then
            Error(NoLinesErr, CalcNo);

        TempExcelBuffer.DeleteAll();
        RowNo := 1;

        // Add header information
        AddExcelHeader(TempExcelBuffer, RowNo, SEWCalcHeader);
        RowNo += 4;

        // Add column headers
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Line No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Type', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Base Value', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Formula', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Factor', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Calculated Value', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        // Add calculation lines
        repeat
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn(Format(SEWCalcLine."Line No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SEWCalcLine.Type), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(SEWCalcLine.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Format(SEWCalcLine."Base Value"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(SEWCalcLine.Formula, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Format(SEWCalcLine."Factor / Percentage"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SEWCalcLine."Calculated Value"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            RowNo += 1;
        until SEWCalcLine.Next() = 0;

        // Add summary
        RowNo += 2;
        AddExcelSummary(TempExcelBuffer, RowNo, SEWCalcHeader);

        // Export file
        FileName := StrSubstNo(ExcelFileNameTxt, CalcNo);
        TempExcelBuffer.CreateNewBook('Calculation');
        TempExcelBuffer.WriteSheet('Calculation', CompanyName(), UserId());
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.OpenExcel();

        Message(ExportSuccessMsg);
    end;

    procedure ExportSimulationToExcel(SimulationNo: Code[20])
    var
        SEWSimHeader: Record "SEW Calc Simulation Header";
        SEWSimLine: Record "SEW Calc Simulation Line";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileName: Text;
        RowNo: Integer;
    begin
        if not SEWSimHeader.Get(SimulationNo) then
            Error('Simulation %1 not found', SimulationNo);

        SEWSimLine.SetRange("Simulation No.", SimulationNo);
        if not SEWSimLine.FindSet() then
            Error(NoLinesErr, SimulationNo);

        TempExcelBuffer.DeleteAll();
        RowNo := 1;

        // Add simulation header
        AddSimulationExcelHeader(TempExcelBuffer, RowNo, SEWSimHeader);
        RowNo += 4;

        // Add column headers
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Scenario', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Lot Size', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Unit Cost', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Sales Price', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Margin %', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Break-Even', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Score', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Recommended', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        // Add scenario lines
        repeat
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn(SEWSimLine."Scenario Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Format(SEWSimLine."Lot Size"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SEWSimLine."Unit Cost"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SEWSimLine."Suggested Sales Price"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SEWSimLine."Margin %"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SEWSimLine."Break-Even Quantity"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SEWSimLine."Recommendation Score"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SEWSimLine."Is Recommended"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            RowNo += 1;
        until SEWSimLine.Next() = 0;

        // Export file
        FileName := StrSubstNo(SimulationFileNameTxt, SimulationNo);
        TempExcelBuffer.CreateNewBook('Simulation');
        TempExcelBuffer.WriteSheet('Simulation', CompanyName(), UserId());
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.OpenExcel();

        Message(ExportSuccessMsg);
    end;

    procedure ExportTemplateToExcel(TemplateCode: Code[20])
    var
        SEWCalcTemplate: Record "SEW Calc Template";
        SEWTemplateLine: Record "SEW Calc Template Line";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileName: Text;
        RowNo: Integer;
    begin
        if not SEWCalcTemplate.Get(TemplateCode) then
            Error('Template %1 not found', TemplateCode);

        SEWTemplateLine.SetRange("Template Code", TemplateCode);
        if not SEWTemplateLine.FindSet() then
            Error(NoLinesErr, TemplateCode);

        TempExcelBuffer.DeleteAll();
        RowNo := 1;

        // Add template header
        AddTemplateExcelHeader(TempExcelBuffer, RowNo, SEWCalcTemplate);
        RowNo += 4;

        // Add column headers
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Line No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Type', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Formula', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        // Add template lines
        repeat
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn(Format(SEWTemplateLine."Line No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SEWTemplateLine.Type), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(SEWTemplateLine.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(SEWTemplateLine.Formula, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            RowNo += 1;
        until SEWTemplateLine.Next() = 0;

        // Export file
        FileName := StrSubstNo(TemplateFileNameTxt, TemplateCode);
        TempExcelBuffer.CreateNewBook('Template');
        TempExcelBuffer.WriteSheet('Template', CompanyName(), UserId());
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.OpenExcel();

        Message(ExportSuccessMsg);
    end;

    local procedure AddExcelHeader(var TempExcelBuffer: Record "Excel Buffer" temporary; var RowNo: Integer; SEWCalcHeader: Record "SEW Calc Header")
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Calculation Export', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Calculation No.:', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SEWCalcHeader."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Item:', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SEWCalcHeader."Item No." + ' - ' + SEWCalcHeader.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;
    end;

    local procedure AddSimulationExcelHeader(var TempExcelBuffer: Record "Excel Buffer" temporary; var RowNo: Integer; SEWSimHeader: Record "SEW Calc Simulation Header")
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Lot Size Simulation', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Simulation No.:', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SEWSimHeader."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Calculation:', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SEWSimHeader."Calc No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;
    end;

    local procedure AddTemplateExcelHeader(var TempExcelBuffer: Record "Excel Buffer" temporary; var RowNo: Integer; SEWCalcTemplate: Record "SEW Calc Template")
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Calculation Template', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Template Code:', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SEWCalcTemplate.Code, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Description:', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SEWCalcTemplate.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;
    end;

    local procedure AddExcelSummary(var TempExcelBuffer: Record "Excel Buffer" temporary; var RowNo: Integer; SEWCalcHeader: Record "SEW Calc Header")
    var
        TotalMaterial: Decimal;
        TotalLabor: Decimal;
        TotalOverhead: Decimal;
        TotalCost: Decimal;
    begin
        // Calculate totals from lines
        TotalMaterial := GetTotalCostByType(SEWCalcHeader."No.", 1); // Material
        TotalLabor := GetTotalCostByType(SEWCalcHeader."No.", 2); // Labor
        TotalOverhead := GetTotalCostByType(SEWCalcHeader."No.", 3); // Overhead
        TotalCost := TotalMaterial + TotalLabor + TotalOverhead;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Cost Summary', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Total Material Cost:', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(TotalMaterial), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Total Labor Cost:', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(TotalLabor), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Total Overhead Cost:', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(TotalOverhead), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Total Cost:', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(TotalCost), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        RowNo += 1;
    end;

    local procedure GetTotalCostByType(CalcNo: Code[20]; LineType: Integer): Decimal
    var
        CalcLine: Record "SEW Calc Line";
        Total: Decimal;
    begin
        CalcLine.SetRange("Calc No.", CalcNo);
        CalcLine.SetRange(Type, LineType);
        if CalcLine.FindSet() then
            repeat
                Total += CalcLine."Calculated Value";
            until CalcLine.Next() = 0;
        exit(Total);
    end;
}
