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
        CalcHeader: Record "SEW Calc Header";
        CalcLine: Record "SEW Calc Line";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileName: Text;
        RowNo: Integer;
    begin
        if not CalcHeader.Get(CalcNo) then
            Error('Calculation %1 not found', CalcNo);

        CalcLine.SetRange("Calc No.", CalcNo);
        if not CalcLine.FindSet() then
            Error(NoLinesErr, CalcNo);

        TempExcelBuffer.DeleteAll();
        RowNo := 1;

        // Add header information
        AddExcelHeader(TempExcelBuffer, RowNo, CalcHeader);
        RowNo += 4;

        // Add column headers
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Line No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Type', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Base Value', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Formula', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Factor', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Result', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        // Add calculation lines
        repeat
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn(Format(CalcLine."Line No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(CalcLine.Type), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(CalcLine.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Format(CalcLine."Base Value"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(CalcLine.Formula, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Format(CalcLine.Factor), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(CalcLine.Result), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            RowNo += 1;
        until CalcLine.Next() = 0;

        // Add summary
        RowNo += 2;
        AddExcelSummary(TempExcelBuffer, RowNo, CalcHeader);

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
        SimHeader: Record "SEW Calc Simulation Header";
        SimLine: Record "SEW Calc Simulation Line";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileName: Text;
        RowNo: Integer;
    begin
        if not SimHeader.Get(SimulationNo) then
            Error('Simulation %1 not found', SimulationNo);

        SimLine.SetRange("Simulation No.", SimulationNo);
        if not SimLine.FindSet() then
            Error(NoLinesErr, SimulationNo);

        TempExcelBuffer.DeleteAll();
        RowNo := 1;

        // Add simulation header
        AddSimulationExcelHeader(TempExcelBuffer, RowNo, SimHeader);
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
            TempExcelBuffer.AddColumn(SimLine."Scenario Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Format(SimLine."Lot Size"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SimLine."Unit Cost"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SimLine."Suggested Sales Price"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SimLine."Margin %"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SimLine."Break-Even Quantity"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SimLine."Recommendation Score"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(SimLine."Is Recommended"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            RowNo += 1;
        until SimLine.Next() = 0;

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
        Template: Record "SEW Calc Template";
        TemplateLine: Record "SEW Calc Template Line";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileName: Text;
        RowNo: Integer;
    begin
        if not Template.Get(TemplateCode) then
            Error('Template %1 not found', TemplateCode);

        TemplateLine.SetRange("Template Code", TemplateCode);
        if not TemplateLine.FindSet() then
            Error(NoLinesErr, TemplateCode);

        TempExcelBuffer.DeleteAll();
        RowNo := 1;

        // Add template header
        AddTemplateExcelHeader(TempExcelBuffer, RowNo, Template);
        RowNo += 4;

        // Add column headers
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Line No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Type', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Formula', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Factor', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        // Add template lines
        repeat
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn(Format(TemplateLine."Line No."), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(Format(TemplateLine.Type), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(TemplateLine.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(TemplateLine.Formula, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Format(TemplateLine.Factor), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            RowNo += 1;
        until TemplateLine.Next() = 0;

        // Export file
        FileName := StrSubstNo(TemplateFileNameTxt, TemplateCode);
        TempExcelBuffer.CreateNewBook('Template');
        TempExcelBuffer.WriteSheet('Template', CompanyName(), UserId());
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.OpenExcel();

        Message(ExportSuccessMsg);
    end;

    local procedure AddExcelHeader(var TempExcelBuffer: Record "Excel Buffer" temporary; var RowNo: Integer; CalcHeader: Record "SEW Calc Header")
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Calculation Export', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Calculation No.:', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CalcHeader."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Item:', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CalcHeader."Item No." + ' - ' + CalcHeader.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;
    end;

    local procedure AddSimulationExcelHeader(var TempExcelBuffer: Record "Excel Buffer" temporary; var RowNo: Integer; SimHeader: Record "SEW Calc Simulation Header")
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Lot Size Simulation', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Simulation No.:', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SimHeader."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Calculation:', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(SimHeader."Calc No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;
    end;

    local procedure AddTemplateExcelHeader(var TempExcelBuffer: Record "Excel Buffer" temporary; var RowNo: Integer; Template: Record "SEW Calc Template")
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Calculation Template', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Template Code:', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Template.Code, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Description:', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Template.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;
    end;

    local procedure AddExcelSummary(var TempExcelBuffer: Record "Excel Buffer" temporary; var RowNo: Integer; CalcHeader: Record "SEW Calc Header")
    begin
        CalcHeader.CalcFields("Total Material Cost", "Total Labor Cost", "Total Overhead Cost", "Total Cost");

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Cost Summary', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Total Material Cost:', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(CalcHeader."Total Material Cost"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Total Labor Cost:', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(CalcHeader."Total Labor Cost"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Total Overhead Cost:', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(CalcHeader."Total Overhead Cost"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        RowNo += 1;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Total Cost:', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(CalcHeader."Total Cost"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        RowNo += 1;
    end;
}
