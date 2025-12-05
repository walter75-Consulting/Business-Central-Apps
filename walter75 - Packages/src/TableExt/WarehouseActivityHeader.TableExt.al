tableextension 90702 "SEW Warehouse Activity Header" extends "Warehouse Activity Header"
{
    fields
    {
        field(90700; "SEW Unpacked Count Items"; Decimal)
        {
            Caption = 'Count Items Unpacked';
            ToolTip = 'Specifies the count of items unpacked.';
            AllowInCustomizations = Never;
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Activity Line"."SEW Qty. to Pack" where("Activity Type" = field("Type"), "No." = field("No.")));
            Editable = false;
        }
        field(90701; "SEW Unpacked Count Lines"; Integer)
        {
            Caption = 'Count Lines Unpacked';
            ToolTip = 'Specifies the count of lines unpacked.';
            AllowInCustomizations = Never;
            FieldClass = FlowField;
            CalcFormula = count("Warehouse Activity Line" where("Activity Type" = field("Type"), "No." = field("No."), "SEW Qty. to Pack" = filter(<> 0)));
            Editable = false;
        }
        field(90702; "SEW Current Parcel No."; Code[20])
        {
            Caption = 'Parcel No.';
            ToolTip = 'Specifies the Parcel No.';
            TableRelation = "SEW Parcel"."Parcel No.";
            AllowInCustomizations = Never;
        }
        field(90703; "SEW Current Parcel Status"; Text[250])
        {
            Caption = 'Parcel Status';
            ToolTip = 'Specifies the Parcel Status.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("SEW Parcel"."SC Parcel Status" where("Parcel No." = field("SEW Current Parcel No.")));
            AllowInCustomizations = Never;
        }
        field(90704; "SEW Parcel Status ID"; Integer)
        {
            Caption = 'Status ID';
            ToolTip = 'Specifies the Status ID.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("SEW Parcel"."SC Status ID" where("Parcel No." = field("SEW Current Parcel No.")));
            AllowInCustomizations = Never;
        }
        field(90705; "SEW Current Package Material"; Code[10])
        {
            Caption = 'Package Material';
            ToolTip = 'Specifies the current package material.';
            TableRelation = "SEW Package Material";
            AllowInCustomizations = Never;
        }
        field(90706; "SEW Current Scan Action"; Enum "SEW Scan Action")
        {
            Caption = 'Scan Action';
            ToolTip = 'Specifies the scan action.';
            AllowInCustomizations = Never;
        }
        field(90707; "SEW Text Last Scan"; Text[255])
        {
            Caption = 'Last Scan';
            ToolTip = 'Specifies the last scan input.';
            AllowInCustomizations = Never;
        }
        field(90708; "SEW Text Display"; Text[255])
        {
            Caption = 'Display Text';
            ToolTip = 'Specifies the display text for the user.';
            AllowInCustomizations = Never;
        }
        field(90709; "SEW Package Material Desc"; Text[100])
        {
            Caption = 'Package Material Description';
            ToolTip = 'Specifies the current package material description.';
            AllowInCustomizations = Never;
        }
    }

}