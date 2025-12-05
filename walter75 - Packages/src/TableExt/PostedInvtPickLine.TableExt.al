tableextension 90701 "SEW Posted Invt. Pick Line" extends "Posted Invt. Pick Line"
{
    fields
    {
        field(90700; "SEW Parcel No."; Code[20])
        {
            Caption = 'Shipment No.';
            ToolTip = 'Specifies the Shipment No.';
            TableRelation = "SEW Parcel"."Parcel No.";
            DataClassification = CustomerContent;
            AllowInCustomizations = Never;

        }
        field(90701; "SEW Parcel Status"; Text[250])
        {
            Caption = 'Shipmentorder Status';
            ToolTip = 'Specifies the Shipmentorder Status.';
            FieldClass = FlowField;
            CalcFormula = lookup("SEW Parcel"."SC Parcel Status" where("Parcel No." = field("SEW Parcel No.")));
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(90702; "SEW Parcel Status ID"; Integer)
        {
            Caption = 'Status ID';
            ToolTip = 'Specifies the Status ID.';
            FieldClass = FlowField;
            CalcFormula = lookup("SEW Parcel"."SC Status ID" where("Parcel No." = field("SEW Parcel No.")));
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(90710; "SEW Gross Weight Item kg"; Decimal)
        {
            Caption = 'Gross Weight Item in kg';
            ToolTip = 'Specifies the gross weight of the item in kg.';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            AllowInCustomizations = Never;
        }
    }

}