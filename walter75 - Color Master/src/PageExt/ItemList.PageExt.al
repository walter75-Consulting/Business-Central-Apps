pageextension 91601 "SEW Item List" extends "Item List"
{
    layout
    {
        addafter("GTIN")
        {
            field("SEW Item Color"; Rec."SEW Item Color")
            {
                ApplicationArea = All;
            }
            field("SEW Item Color Template"; Rec."SEW Item Color Template")
            {
                ApplicationArea = All;
            }
            field("SEW Item Color Master"; Rec."SEW Item Color Master")
            {
                ApplicationArea = All;
            }
        }
    }

}