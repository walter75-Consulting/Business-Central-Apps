pageextension 91602 "SEW Production BOM Lines" extends "Production BOM Lines"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("SEW Item Color Template"; Rec."SEW Item Color Template")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
