tableextension 80006 "SEW AI Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        field(80000; "SEW Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            ToolTip = 'Specifies the Lot No.';
            DataClassification = CustomerContent;
        }
        field(80001; "SEW Serial No."; Code[50])
        {
            Caption = 'Serial No.';
            ToolTip = 'Specifies the Serial No.';
            DataClassification = CustomerContent;
        }
        field(80002; "SEW Package No."; Code[50])
        {
            Caption = 'Package No.';
            ToolTip = 'Specifies the Package No.';
            DataClassification = CustomerContent;
        }
        field(80003; "SEW Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            ToolTip = 'Specifies the Expiration Date.';
            DataClassification = CustomerContent;
        }
    }
}
