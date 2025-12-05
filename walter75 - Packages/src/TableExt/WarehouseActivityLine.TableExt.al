tableextension 90703 "SEW Warehouse Activity Line" extends "Warehouse Activity Line"
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
            CalcFormula = lookup("SEW Parcel Status".Message where("SC Status ID" = field("SEW Parcel Status ID")));
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
        field(90711; "SEW Qty. to Pack"; Decimal)
        {
            Caption = 'Qty. to Pack';
            ToolTip = 'Specifies the quantity to pack.';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            AllowInCustomizations = Never;
            trigger OnValidate()
            begin
                Rec."SEW Qty. to Pack" := Rec."Qty. Outstanding";
                Rec."SEW Qty. to Pack" := Rec."SEW Qty. to Pack" - Rec."SEW Qty. Packed";
            end;
        }
        field(90712; "SEW Qty. Packed"; Decimal)
        {
            Caption = 'Qty. Packed';
            ToolTip = 'Specifies the quantity packed.';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            AllowInCustomizations = Never;
            trigger OnValidate()
            begin
                Rec."SEW Qty. to Pack" := Rec."Qty. Outstanding";
                Rec."SEW Qty. to Pack" := Rec."SEW Qty. to Pack" - Rec."SEW Qty. Packed";
            end;
        }

        modify("Qty. to Handle")
        {
            trigger OnAfterValidate()
            begin
                Rec."SEW Qty. to Pack" := Rec."Qty. Outstanding";
                Rec."SEW Qty. to Pack" := Rec."SEW Qty. to Pack" - Rec."SEW Qty. Packed";
            end;
        }
    }

}