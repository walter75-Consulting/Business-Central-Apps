pageextension 60502 "SEW Units of Measure" extends "Units of Measure"
{
    layout
    {
        addafter("International Standard Code")
        {
            field("SEW SAP Code"; Rec."SEW SAP Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
