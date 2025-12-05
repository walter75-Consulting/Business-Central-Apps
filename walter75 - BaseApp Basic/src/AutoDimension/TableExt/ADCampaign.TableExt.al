tableextension 80026 "SEW AD Campaign" extends Campaign
{
    fields
    {

    }

    trigger OnDelete()
    var
        SEWADDimensionMgmt: Codeunit "SEW AD Dimension Mgmt";
    begin
        SEWADDimensionMgmt.DeleteMasterDataDefaultDimension(Database::Campaign, "No.");

    end;

    trigger OnAfterInsert()
    var
        SEWADDimensionMgmt: Codeunit "SEW AD Dimension Mgmt";

    begin
        SEWADDimensionMgmt.CreateDimensionForMasterData(Database::Campaign, "No.");
    end;


    trigger OnModify()
    var
        SEWADDimensionMgmt: Codeunit "SEW AD Dimension Mgmt";
    begin
        SEWADDimensionMgmt.UpdateDimensionValueDescription(Database::Campaign, "No.", Description);
    end;

}
