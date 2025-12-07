codeunit 90953 "SEW Calc Template Test"
{
    Subtype = Test;
    Permissions = tabledata "SEW Calc Template" = RMID,
                  tabledata "SEW Calc Template Line" = RMID,
                  tabledata "SEW Calc Header" = RMID,
                  tabledata "SEW Calc Line" = RMID;

    var
        SEWTestAssert: Codeunit "SEW Test Assert";
        SEWCalcTestHelper: Codeunit "SEW Calc Test Helper";
        SEWCalcTemplateManagement: Codeunit "SEW Calc Template Management";

    [Test]
    procedure TestTemplateCreation()
    var
        SEWCalcTemplate: Record "SEW Calc Template";
        TemplateCode: Code[20];
    begin
        TemplateCode := SEWCalcTestHelper.CreateTestTemplate(SEWCalcTemplate);
        SEWTestAssert.IsTrue(SEWCalcTemplate.Get(TemplateCode), 'Template should be created');
        SEWCalcTemplate.Delete(true);
    end;

    [Test]
    procedure TestTemplateCopyToCalculation()
    var
        SEWCalcTemplate: Record "SEW Calc Template";
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcLine: Record "SEW Calc Line";
        TemplateCode: Code[20];
    begin
        TemplateCode := SEWCalcTestHelper.CreateTestTemplate(SEWCalcTemplate);
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Template Code" := TemplateCode;
        SEWCalcHeader.Modify(true);

        SEWCalcTemplateManagement.CopyTemplateToCalc(SEWCalcHeader, true);

        SEWCalcLine.SetRange("Calc No.", SEWCalcHeader."No.");
        SEWTestAssert.IsFalse(SEWCalcLine.IsEmpty(), 'Template lines should be copied');

        SEWCalcHeader.Delete(true);
        SEWCalcTemplate.Delete(true);
    end;
}
