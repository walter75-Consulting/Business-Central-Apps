tableextension 80030 "SEW AD Territory" extends "Territory"
{
    fields
    {

    }



    trigger OnDelete()
    var
        SEWADDimensionMgmt: Codeunit "SEW AD Dimension Mgmt";
    begin
        SEWADDimensionMgmt.DeleteMasterDataDefaultDimension(Database::"Territory", "Code");

    end;

    trigger OnAfterInsert()
    var
        SEWADDimensionMgmt: Codeunit "SEW AD Dimension Mgmt";

    begin
        SEWADDimensionMgmt.CreateDimensionForMasterData(Database::"Territory", "Code");
    end;


    trigger OnModify()
    var
        SEWADDimensionMgmt: Codeunit "SEW AD Dimension Mgmt";
    begin
        SEWADDimensionMgmt.UpdateDimensionValueDescription(Database::"Territory", "Code", Name);
    end;


}
