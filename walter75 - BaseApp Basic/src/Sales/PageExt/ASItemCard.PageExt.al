pageextension 80058 "SEW AS Item Card" extends "Item Card"
{
    layout
    {
        addafter(AssemblyBOM)
        {
            field("SEW Auto-Explode AssemblyBOM"; Rec."SEW Auto-Explode AssemblyBOM")
            {
                ApplicationArea = All;
            }
        }
        addafter("Vendor No.")
        {
            field("SEW Date last Invoice"; Rec."SEW Date last Invoice")
            {
                ApplicationArea = All;
            }
        }
    }
}