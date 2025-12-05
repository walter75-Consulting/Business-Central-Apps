tableextension 80029 "SEW AD Item Category" extends "Item Category"
{
    fields
    {

    }



    trigger OnDelete()
    var
        SEWADDimensionMgmt: Codeunit "SEW AD Dimension Mgmt";
    begin
        SEWADDimensionMgmt.DeleteMasterDataDefaultDimension(Database::"Item Category", "Code");

    end;

    trigger OnAfterInsert()
    var
        SEWADDimensionMgmt: Codeunit "SEW AD Dimension Mgmt";

    begin
        SEWADDimensionMgmt.CreateDimensionForMasterData(Database::"Item Category", "Code");
    end;


    trigger OnModify()
    var
        SEWADDimensionMgmt: Codeunit "SEW AD Dimension Mgmt";
    begin
        SEWADDimensionMgmt.UpdateDimensionValueDescription(Database::"Item Category", "Code", Description);
    end;


}
