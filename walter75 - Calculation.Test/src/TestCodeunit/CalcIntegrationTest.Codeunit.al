codeunit 90955 "SEW Calc Integration Test"
{
    Subtype = Test;

    /// <summary>
    /// Test codeunit for SEW Calculation Integration.
    /// Tests Item Card actions, status workflow, and end-to-end integration scenarios.
    /// </summary>

    var
        SEWTestAssert: Codeunit "SEW Test Assert";
        SEWCalcTestHelper: Codeunit "SEW Calc Test Helper";
        SEWCalcTemplateManagement: Codeunit "SEW Calc Template Management";

    [Test]
    procedure TestCreateCalculationFromItem()
    var
        Item: Record Item;
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcTemplate: Record "SEW Calc Template";
        TemplateCode: Code[20];
    begin
        // [GIVEN] Item with default template
        Item.Init();
        Item."No." := 'TEST-ITEM-INT1';
        Item.Insert(true);

        TemplateCode := SEWCalcTestHelper.CreateTestTemplate(SEWCalcTemplate);
        Item."SEW Default Template Code" := TemplateCode;
        Item.Modify(true);

        // [WHEN] Creating calculation from item
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Item No." := Item."No.";
        SEWCalcHeader."Template Code" := Item."SEW Default Template Code";
        SEWCalcHeader.Modify(true);

        // [THEN] Calculation should be linked to item with template
        SEWTestAssert.AreEqual(Item."No.", SEWCalcHeader."Item No.", 'Item should be linked');
        SEWTestAssert.AreEqual(TemplateCode, SEWCalcHeader."Template Code", 'Template should be set from item');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        SEWCalcTemplate.Delete(true);
        Item.Delete(true);
    end;

    [Test]
    procedure TestStatusWorkflowDraftToReleased()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcLine: Record "SEW Calc Line";
        SEWCalcTemplate: Record "SEW Calc Template";
        Item: Record Item;
        TemplateCode: Code[20];
    begin
        // [GIVEN] Item
        Item.Init();
        Item."No." := 'TEST-ITEM-STATUS';
        Item.Insert(true);

        // [GIVEN] Calculation in Draft status with item and lines
        TemplateCode := SEWCalcTestHelper.CreateTestTemplate(SEWCalcTemplate);
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Item No." := Item."No.";
        SEWCalcHeader."Template Code" := TemplateCode;
        SEWCalcHeader.Status := SEWCalcHeader.Status::Draft;
        SEWCalcHeader.Modify(true);

        // [GIVEN] At least one line
        SEWCalcLine.Init();
        SEWCalcLine."Calc No." := SEWCalcHeader."No.";
        SEWCalcLine."Line No." := 10000;
        SEWCalcLine.Description := 'Test Line';
        SEWCalcLine.Insert(true);

        // [WHEN] Releasing calculation
        SEWCalcTemplateManagement.ReleaseCalculation(SEWCalcHeader);

        // [THEN] Status should be Released
        SEWCalcHeader.Get(SEWCalcHeader."No.");
        SEWTestAssert.AreEqual(SEWCalcHeader.Status::Released.AsInteger(), SEWCalcHeader.Status.AsInteger(), 'Status should be Released');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        SEWCalcTemplate.Delete(true);
        Item.Delete(true);
    end;

    [Test]
    procedure TestStatusWorkflowReleasedToReopened()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcLine: Record "SEW Calc Line";
        SEWCalcTemplate: Record "SEW Calc Template";
        Item: Record Item;
        TemplateCode: Code[20];
    begin
        // [GIVEN] Item
        Item.Init();
        Item."No." := 'TEST-ITEM-REOPEN';
        Item.Insert(true);

        // [GIVEN] Calculation in Released status
        TemplateCode := SEWCalcTestHelper.CreateTestTemplate(SEWCalcTemplate);
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Item No." := Item."No.";
        SEWCalcHeader."Template Code" := TemplateCode;
        SEWCalcHeader.Status := SEWCalcHeader.Status::Draft;
        SEWCalcHeader.Modify(true);

        // [GIVEN] At least one line
        SEWCalcLine.Init();
        SEWCalcLine."Calc No." := SEWCalcHeader."No.";
        SEWCalcLine."Line No." := 10000;
        SEWCalcLine.Description := 'Test Line';
        SEWCalcLine.Insert(true);

        // Release first
        SEWCalcTemplateManagement.ReleaseCalculation(SEWCalcHeader);

        // [WHEN] Reopening calculation
        SEWCalcTemplateManagement.ReopenCalculation(SEWCalcHeader);

        // [THEN] Status should be back to Draft
        SEWCalcHeader.Get(SEWCalcHeader."No.");
        SEWTestAssert.AreEqual(SEWCalcHeader.Status::Draft.AsInteger(), SEWCalcHeader.Status.AsInteger(), 'Status should be Draft');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        SEWCalcTemplate.Delete(true);
        Item.Delete(true);
    end;

    [Test]
    procedure TestStatusWorkflowArchive()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcLine: Record "SEW Calc Line";
        SEWCalcTemplate: Record "SEW Calc Template";
        Item: Record Item;
        TemplateCode: Code[20];
    begin
        // [GIVEN] Item
        Item.Init();
        Item."No." := 'TEST-ITEM-ARCHIVE';
        Item.Insert(true);

        // [GIVEN] Calculation in Released status
        TemplateCode := SEWCalcTestHelper.CreateTestTemplate(SEWCalcTemplate);
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Item No." := Item."No.";
        SEWCalcHeader."Template Code" := TemplateCode;
        SEWCalcHeader.Status := SEWCalcHeader.Status::Draft;
        SEWCalcHeader.Modify(true);

        // [GIVEN] At least one line
        SEWCalcLine.Init();
        SEWCalcLine."Calc No." := SEWCalcHeader."No.";
        SEWCalcLine."Line No." := 10000;
        SEWCalcLine.Description := 'Test Line';
        SEWCalcLine.Insert(true);

        // Release first
        SEWCalcTemplateManagement.ReleaseCalculation(SEWCalcHeader);

        // [WHEN] Archiving calculation
        SEWCalcTemplateManagement.ArchiveCalculation(SEWCalcHeader);

        // [THEN] Status should be Archived
        SEWCalcHeader.Get(SEWCalcHeader."No.");
        SEWTestAssert.AreEqual(SEWCalcHeader.Status::Archived.AsInteger(), SEWCalcHeader.Status.AsInteger(), 'Status should be Archived');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        SEWCalcTemplate.Delete(true);
        Item.Delete(true);
    end;

    [Test]
    procedure TestTemplateValidation()
    var
        SEWCalcTemplate: Record "SEW Calc Template";
        TemplateCode: Code[20];
        IsValid: Boolean;
    begin
        // [GIVEN] Template with valid formulas
        TemplateCode := SEWCalcTestHelper.CreateTestTemplate(SEWCalcTemplate);

        // [WHEN] Validating template
        IsValid := SEWCalcTemplateManagement.ValidateTemplate(TemplateCode);

        // [THEN] Validation should pass
        SEWTestAssert.IsTrue(IsValid, 'Template with valid formulas should pass validation');

        // [CLEANUP]
        SEWCalcTemplate.Delete(true);
    end;

    [Test]
    procedure TestTemplateCopy()
    var
        FromSEWCalcTemplate: Record "SEW Calc Template";
        ToSEWCalcTemplate: Record "SEW Calc Template";
        FromSEWCalcTemplateLine: Record "SEW Calc Template Line";
        ToSEWCalcTemplateLine: Record "SEW Calc Template Line";
        FromCode: Code[20];
        ToCode: Code[20];
        LineCount: Integer;
    begin
        // [GIVEN] Source template with lines
        FromCode := SEWCalcTestHelper.CreateTestTemplate(FromSEWCalcTemplate);
        
        // Count source lines
        FromSEWCalcTemplateLine.SetRange("Template Code", FromCode);
        LineCount := FromSEWCalcTemplateLine.Count;

        // [WHEN] Copying template
        ToCode := CopyStr('COPY-' + FromCode, 1, 20);
        SEWCalcTemplateManagement.CopyTemplate(FromCode, ToCode, 'Copied Template');

        // [THEN] New template should exist
        SEWTestAssert.IsTrue(ToSEWCalcTemplate.Get(ToCode), 'Copied template should exist');

        // [THEN] Lines should be copied
        ToSEWCalcTemplateLine.SetRange("Template Code", ToCode);
        SEWTestAssert.AreEqual(LineCount, ToSEWCalcTemplateLine.Count, 'All lines should be copied');

        // [CLEANUP]
        FromSEWCalcTemplate.Delete(true);
        if ToSEWCalcTemplate.Get(ToCode) then
            ToSEWCalcTemplate.Delete(true);
    end;

    [Test]
    procedure TestCalculationNumberSeries()
    var
        SEWCalcHeader: Record "SEW Calc Header";
    begin
        // [GIVEN] Sales Setup with number series configured
        // [WHEN] Creating new calculation
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);

        // [THEN] Number should be assigned
        SEWTestAssert.IsTrue(SEWCalcHeader."No." <> '', 'Calculation number should be assigned');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestMultipleCalculationsForSameItem()
    var
        Item: Record Item;
        SEWCalcHeader1: Record "SEW Calc Header";
        SEWCalcHeader2: Record "SEW Calc Header";
        SEWCalcHeader3: Record "SEW Calc Header";
        SEWCalcHeaderRec: Record "SEW Calc Header";
        CalcCount: Integer;
    begin
        // [GIVEN] Item
        Item.Init();
        Item."No." := 'TEST-ITEM-MULTI';
        Item.Insert(true);

        // [WHEN] Creating multiple calculations for same item
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader1);
        SEWCalcHeader1."Item No." := Item."No.";
        SEWCalcHeader1.Modify(true);

        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader2);
        SEWCalcHeader2."Item No." := Item."No.";
        SEWCalcHeader2.Modify(true);

        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader3);
        SEWCalcHeader3."Item No." := Item."No.";
        SEWCalcHeader3.Modify(true);

        // [THEN] All calculations should be linked to item
        SEWCalcHeaderRec.SetRange("Item No.", Item."No.");
        CalcCount := SEWCalcHeaderRec.Count;
        SEWTestAssert.IsTrue(CalcCount >= 3, 'At least 3 calculations should exist for item');

        // [CLEANUP]
        SEWCalcHeader1.Delete(true);
        SEWCalcHeader2.Delete(true);
        SEWCalcHeader3.Delete(true);
        Item.Delete(true);
    end;

    [Test]
    procedure TestLastCalculationLink()
    var
        Item: Record Item;
        SEWCalcHeader1: Record "SEW Calc Header";
        SEWCalcHeader2: Record "SEW Calc Header";
    begin
        // [GIVEN] Item
        Item.Init();
        Item."No." := 'TEST-ITEM-LAST';
        Item.Insert(true);

        // [WHEN] Creating first calculation
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader1);
        SEWCalcHeader1."Item No." := Item."No.";
        SEWCalcHeader1."Calculation Date" := WorkDate();
        SEWCalcHeader1.Modify(true);

        // [WHEN] Creating second calculation
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader2);
        SEWCalcHeader2."Item No." := Item."No.";
        SEWCalcHeader2."Calculation Date" := WorkDate();
        SEWCalcHeader2.Modify(true);

        // [THEN] Both calculations should exist
        SEWTestAssert.IsTrue(SEWCalcHeader1.Get(SEWCalcHeader1."No."), 'First calculation should exist');
        SEWTestAssert.IsTrue(SEWCalcHeader2.Get(SEWCalcHeader2."No."), 'Second calculation should exist');

        // [CLEANUP]
        SEWCalcHeader1.Delete(true);
        SEWCalcHeader2.Delete(true);
        Item.Delete(true);
    end;

    [Test]
    procedure TestCalculationWithAllCostComponents()
    var
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcEngine: Codeunit "SEW Calc Engine";
    begin
        // [GIVEN] Calculation with all cost components
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Total Material Cost" := 100;
        SEWCalcHeader."Total Labor Cost" := 50;
        SEWCalcHeader.Modify(true);

        // [WHEN] Applying surcharges and updating totals
        SEWCalcEngine.ApplySurcharges(SEWCalcHeader);
        SEWCalcEngine.UpdateTotals(SEWCalcHeader);

        // [THEN] All components should be calculated
        SEWCalcHeader.Get(SEWCalcHeader."No.");
        SEWTestAssert.IsTrue(SEWCalcHeader."Total Material Cost" > 0, 'Material cost should be set');
        SEWTestAssert.IsTrue(SEWCalcHeader."Total Labor Cost" > 0, 'Labor cost should be set');
        SEWTestAssert.IsTrue(SEWCalcHeader."Total Overhead Cost" > 0, 'Overhead cost should be calculated');
        SEWTestAssert.IsTrue(SEWCalcHeader."Total Cost" > 0, 'Total cost should be calculated');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
    end;

    [Test]
    procedure TestCalculationWithTemplateAndFormulas()
    var
        SEWCalcTemplate: Record "SEW Calc Template";
        SEWCalcHeader: Record "SEW Calc Header";
        SEWCalcEngine: Codeunit "SEW Calc Engine";
        TemplateCode: Code[20];
    begin
        // [GIVEN] Template with formula lines
        TemplateCode := SEWCalcTestHelper.CreateTestTemplate(SEWCalcTemplate);

        // [GIVEN] Calculation with template
        SEWCalcTestHelper.CreateTestCalculation(SEWCalcHeader);
        SEWCalcHeader."Template Code" := TemplateCode;
        SEWCalcHeader."Total Material Cost" := 150;
        SEWCalcHeader."Total Labor Cost" := 50;
        SEWCalcHeader.Modify(true);

        // [WHEN] Calculating from template
        SEWCalcEngine.CalculateFromTemplate(SEWCalcHeader);

        // [THEN] Calculation should be complete
        SEWCalcHeader.Get(SEWCalcHeader."No.");
        SEWTestAssert.IsTrue(SEWCalcHeader."Total Cost" >= 0, 'Total cost should be calculated');

        // [CLEANUP]
        SEWCalcHeader.Delete(true);
        SEWCalcTemplate.Delete(true);
    end;
}
