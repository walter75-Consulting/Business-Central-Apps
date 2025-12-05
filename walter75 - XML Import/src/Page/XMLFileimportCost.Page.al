page 60512 "SEW XML Fileimport Cost"
{
    ApplicationArea = All;
    Caption = 'XML Fileimport Costs';
    PageType = List;
    SourceTable = "SEW XML Fileimport Cost";
    UsageCategory = None;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.id) { }
                field("Transfer ID"; Rec.transferID) { }
                field("Cost Code"; Rec."Cost Code") { }
                field("Cost Description"; Rec."Cost Description") { }
                field("Cost Amount"; Rec."Cost Amount") { }
            }
        }
    }
}