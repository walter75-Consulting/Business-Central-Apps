pageextension 80052 "SEW RE VAT Business Posting" extends "VAT Business Posting Groups"
{
    layout
    {
        addafter("Description")
        {
            field("SEW Print Tariff Number Ship"; Rec."SEW Print Tariff Number Ship")
            {
                ApplicationArea = All;
            }
            field("SEW Print Tariff Number Invo"; Rec."SEW Print Tariff Number Invo")
            {
                ApplicationArea = All;
            }
            field("SEW Print CtryofOrigin Ship"; Rec."SEW Print CtryofOrigin Ship")
            {
                ApplicationArea = All;
            }
            field("SEW Print CtryofOrigin Invo"; Rec."SEW Print CtryofOrigin Invo")
            {
                ApplicationArea = All;
            }
        }
    }
}
