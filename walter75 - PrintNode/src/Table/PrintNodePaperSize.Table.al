table 92706 "SEW PrintNode Paper Size"
{
    Caption = 'SEW PrintNode Paper Size';
    DataClassification = CustomerContent;
    LookupPageId = "SEW PrintNode Paper Size";
    DrillDownPageId = "SEW PrintNode Paper Size";

    fields
    {
        field(1; "Printer ID"; Integer)
        {
            Caption = 'Printer ID';
            ToolTip = 'Specifies the ID of the printer.';
        }
        field(2; "Code"; Code[50])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the code of the paper size.';
        }
        field(3; "Paper Name"; Text[100])
        {
            Caption = 'Paper Name';
            ToolTip = 'Specifies the name of the paper size.';
        }
        field(4; "Paper Dimension"; Text[50])
        {
            Caption = 'Paper Dimension';
            ToolTip = 'Specifies the dimension of the paper size (Width x Height in mm).';
        }
        field(5; "Printer Name"; Text[255])
        {
            Caption = 'Printer Name';
            ToolTip = 'Specifies the name of the printer.';
            FieldClass = FlowField;
            CalcFormula = lookup("SEW PrintNode Printer"."Printer Name" where("Printer ID" = field("Printer ID")));
            Editable = false;
        }
        field(6; "Paper Width"; Decimal)
        {
            Caption = 'Paper Width';
            ToolTip = 'Specifies the width of the paper size in mm.';
        }
        field(7; "Paper Height"; Decimal)
        {
            Caption = 'Paper Height';
            ToolTip = 'Specifies the height of the paper size in mm.';
        }
        field(8; "System Paper Kind"; Enum "Printer Paper Kind")
        {
            Caption = 'System Paper Kind';
            ToolTip = 'Specifies the system paper kind.';
            AllowInCustomizations = Never;
        }
    }
    keys
    {
        key(PK; "Printer ID", "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Paper Name", "Paper Dimension") { }
        fieldgroup(Brick; "Printer Name", "Paper Name", "Paper Dimension") { }
    }

}
