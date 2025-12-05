table 90601 "SEW BDE Terminal"
{
    Caption = 'BDE Terminal';
    DataClassification = CustomerContent;
    DataCaptionFields = "Code", "Terminal Name";
    LookupPageId = "SEW BDE Terminals";
    DrillDownPageId = "SEW BDE Terminals";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the code for the BDE terminal.';
            NotBlank = true;
        }
        field(2; "Terminal Name"; Text[100])
        {
            Caption = 'Terminal Name';
            ToolTip = 'Specifies the name of the BDE terminal.';
        }
        field(3; "Allow Fixed User"; Boolean)
        {
            Caption = 'Allow Fixed User';
            ToolTip = 'Specifies whether a fixed user is allowed on this terminal.';
        }
        field(4; "Allow Malfunction"; Boolean)
        {
            Caption = 'Allow Malfunction';
            ToolTip = 'Specifies whether malfunction reporting is allowed on this terminal.';
        }
        field(5; "Allow Call Operator"; Boolean)
        {
            Caption = 'Allow Call Operator';
            ToolTip = 'Specifies whether calling an operator is allowed from this terminal.';
        }
        field(6; "Days in Advanced"; DateFormula)
        {
            Caption = 'Days in Advanced';
            ToolTip = 'Specifies how many days in advance the terminal can display production orders.';
        }
        field(7; "Terminal Status"; Enum "SEW BDE Terminal Status")
        {
            Caption = 'Terminal Status';
            ToolTip = 'Specifies the current status of the terminal.';
        }
        field(8; "Current User"; Code[20])
        {
            Caption = 'Current User';
            ToolTip = 'Specifies the user currently logged in to the terminal.';
            TableRelation = "Resource";
        }
        field(9; "Nbr of Centers"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("SEW BDE Terminal Center" where("Terminal Code" = field("Code")));
            Caption = 'Number of Work & Machine Centers';
            ToolTip = 'Specifies the number of work and machine centers assigned to this terminal.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            ToolTip = 'Specifies the item journal template name for output postings.';
            TableRelation = "Item Journal Template" where("Type" = const("Item Journal Template Type"::Output));
        }
        field(11; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            ToolTip = 'Specifies the item journal batch name for output postings.';
            TableRelation = "Item Journal Batch"."Name" where("Journal Template Name" = field("Journal Template Name"));
        }

        field(12; "Stop Code Pause"; Code[10])
        {
            Caption = 'Stop Code Pause';
            ToolTip = 'Specifies the stop code to use for pauses.';
            TableRelation = "Stop";
        }
        field(13; "Stop Code Malfunction"; Code[10])
        {
            Caption = 'Stop Code Malfunction';
            ToolTip = 'Specifies the stop code to use for malfunctions.';
            TableRelation = "Stop";
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Terminal Name")
        {
        }
        fieldgroup(Brick; "Code", "Terminal Name")
        {
        }
    }

}