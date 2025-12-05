table 92705 "SEW PrintNode Computer"
{

    Caption = 'Printnode Computers';
    DataClassification = CustomerContent;

    LookupPageId = "SEW PrintNode Computer List";
    DrillDownPageId = "SEW PrintNode Computer List";

    fields
    {
        field(1; "Computer ID"; Integer)
        {
            Caption = 'Computer ID';
            ToolTip = 'Specifies the unique identification number for the computer.';
        }
        field(2; "Computer Name"; Text[50])
        {
            Caption = 'Computer Name';
            ToolTip = 'Specifies the name of the computer.';
            Editable = false;
        }

        field(3; "Computer State"; Code[20])
        {
            Caption = 'Computer State';
            ToolTip = 'Specifies the state of the computer.';
            Editable = false;
        }
        field(5; Printers; Integer)
        {
            Caption = 'Printers';
            ToolTip = 'Specifies the number of printers associated with the computer.';
            CalcFormula = count("SEW PrintNode Printer" where("Printer Computer" = field("Computer Name")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; Scales; Integer)
        {
            Caption = 'Scales';
            ToolTip = 'Specifies the number of scales associated with the computer.';
            CalcFormula = count("SEW PrintNode Scale" where("Computer ID" = field("Computer ID")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Computer ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Computer Name", Printers) { }
        fieldgroup(Brick; "Computer Name", Printers) { }
    }

    // trigger OnDelete()
    // var
    //     PrintersRec: Record "CMS Printers";
    //     PrinterSelect: Record "CMS Cloud Printer Selection";
    //     PrinterSelect2: Record "CMS Cloud Printer Selection";

    // begin
    //     PrintersRec.setrange("CMS Computer (PrintNode)", Rec.Name);
    //     if PrintersRec.FindSet() then
    //         repeat
    //             PrinterSelect.SetRange(Printertype, PrinterSelect.Printertype::PrintNode);
    //             PrinterSelect.SetRange("Printer ID", PrintersRec."Printer ID");
    //             if PrinterSelect.Findset() then
    //                 repeat
    //                     PrinterSelect2 := PrinterSelect;
    //                     clear(PrinterSelect."Printer ID");
    //                     //da teil des key, statt rename insert und delete
    //                     if PrinterSelect2.Delete() then;
    //                     if PrinterSelect.Insert() then;
    //                 until PrinterSelect.Next() = 0;
    //             PrintersRec.Delete(true);
    //         until PrintersRec.Next() = 0;

    // end;

}
