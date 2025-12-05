tableextension 80038 "SEW RE Sales Shipment Line" extends "Sales Shipment Line"
{
    fields
    {
        field(80800; "SEW Shelf No."; Code[10])
        {
            Caption = 'Shelf No.';
            ToolTip = 'Specifies the shelf number.';
            DataClassification = CustomerContent;
            AllowInCustomizations = Never;
        }
    }


    keys
    {
        key(SEWKeyShelf; "SEW Shelf No.") { }
    }


}
