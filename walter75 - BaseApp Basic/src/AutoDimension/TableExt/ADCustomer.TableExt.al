tableextension 80027 "SEW AD Customer" extends Customer
{

    fields
    {
        modify("Territory Code")
        {
            trigger OnAfterValidate()
            begin
                CustomerTerritoryDimUpdate();
            end;
        }
    }


    trigger OnAfterModify()
    begin
        CustomerTerritoryDimUpdate();
    end;



    local procedure CustomerTerritoryDimUpdate()
    var
        SEWAutoDimensionSetup: Record "SEW Auto Dimension Setup";
        DefaultDimension: Record "Default Dimension";
    begin
        SEWAutoDimensionSetup.Get();

        if SEWAutoDimensionSetup."Territory Dimension" = '' then
            exit;
        if "Territory Code" = '' then
            exit;

        DefaultDimension.SetRange("Table ID", Database::Customer);
        DefaultDimension.SetRange("No.", "No.");
        DefaultDimension.SetRange("Dimension Code", SEWAutoDimensionSetup."Territory Dimension");
        if DefaultDimension.FindFirst() then
            DefaultDimension.Delete(true);

        if "Territory Code" = '' then
            exit
        else begin
            DefaultDimension.Reset();
            DefaultDimension.Init();
            DefaultDimension."Table ID" := Database::Customer;
            DefaultDimension."No." := "No.";
            DefaultDimension."Dimension Code" := SEWAutoDimensionSetup."Territory Dimension";
            DefaultDimension."Dimension Value Code" := "Territory Code";
            DefaultDimension.Insert(true);
        end;
    end;


}
