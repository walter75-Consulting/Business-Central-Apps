table 92707 "SEW PrintNode Print Setting"
{
    Caption = 'SEW PrintNode Print Setting';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Printer ID"; Integer)
        {
            Caption = 'Printer ID';
            ToolTip = 'Specifies the ID of the printer from PrintNode.';
        }
        field(2; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            ToolTip = 'Specifies the ID of the report for which this print setting applies.';
        }
        field(3; "Printer Name"; Text[255])
        {
            Caption = 'Printer Name';
            ToolTip = 'Specifies the name of the printer from PrintNode.';
        }
        field(4; "Report Caption"; Text[255])
        {
            Caption = 'Report Caption';
            ToolTip = 'Specifies the caption of the report for which this print setting applies.';
        }
        // field(5; "Use Print Setting"; Option)
        // {
        //     Caption = 'Use Print Setting';
        // }
        field(6; "Paper Size Code"; Code[50])
        {
            Caption = 'Paper Size Code';
            ToolTip = 'Specifies the paper size code to be used for printing.';
        }
        // field(7; Orientation; Option)
        // {
        //     Caption = 'Orientation';
        // }
        field(8; "Number of Copies"; Integer)
        {
            Caption = 'Number of Copies';
            ToolTip = 'Specifies the number of copies to print.';
        }
    }
    keys
    {
        key(PK; "Printer ID", "Report ID")
        {
            Clustered = true;
        }
        key(key2; "Report ID", "Printer ID")
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Printer Name", "Report Caption") { }
        fieldgroup(Brick; "Printer Name", "Report Caption") { }
    }
}