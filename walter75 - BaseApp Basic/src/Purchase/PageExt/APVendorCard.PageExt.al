pageextension 80007 "SEW AP Vendor Card" extends "Vendor Card"
{
    layout
    {
        addafter("Disable Search by Name")
        {
            field("SEW Warntext"; Rec."SEW Warn Text")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
        }
    }
}
