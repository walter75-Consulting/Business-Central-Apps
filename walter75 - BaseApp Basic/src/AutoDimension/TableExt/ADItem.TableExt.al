tableextension 80028 "SEW AD Item" extends "Item"
{
    fields
    {
        modify("Item Category Code")
        {
            trigger OnAfterValidate()
            begin
                ItemCategoryDimUpdate();
            end;
        }

    }

    trigger OnModify()
    begin
        ItemCategoryDimUpdate();
    end;



    local procedure ItemCategoryDimUpdate()
    var
        SEWAutoDimensionSetup: Record "SEW Auto Dimension Setup";
        DefaultDimension: Record "Default Dimension";
    begin
        SEWAutoDimensionSetup.Get();

        if SEWAutoDimensionSetup."Item Category Dimension" = '' then
            exit;

        DefaultDimension.SetRange("Table ID", Database::Item);
        DefaultDimension.SetRange("No.", "No.");
        DefaultDimension.SetRange("Dimension Code", SEWAutoDimensionSetup."Item Category Dimension");
        if DefaultDimension.FindFirst() then
            DefaultDimension.Delete(true);

        if "Item Category Code" = '' then
            exit
        else begin
            DefaultDimension.Reset();
            DefaultDimension.Init();
            DefaultDimension."Table ID" := Database::Item;
            DefaultDimension."No." := "No.";
            DefaultDimension."Dimension Code" := SEWAutoDimensionSetup."Item Category Dimension";
            DefaultDimension."Dimension Value Code" := "Item Category Code";
            DefaultDimension.Insert(true);
        end;
    end;

}