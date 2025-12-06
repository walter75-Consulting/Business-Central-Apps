table 90800 "SEW Calc Template"
{
    Caption = 'Calculation Template';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Calc Templates";
    DrillDownPageId = "SEW Calc Template Card";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the unique code for the calculation template';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of the calculation template';
            DataClassification = CustomerContent;
        }
        field(3; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            ToolTip = 'Specifies additional description for the calculation template';
            DataClassification = CustomerContent;
        }
        field(10; "Price Source Item"; Enum "SEW Calc Price Source")
        {
            Caption = 'Price Source Item';
            ToolTip = 'Specifies the price source for material costs (Unit Cost, Last Direct Cost, etc.)';
            DataClassification = CustomerContent;
        }
        field(11; "Price Source Capacity"; Enum "SEW Calc Price Source")
        {
            Caption = 'Price Source Capacity';
            ToolTip = 'Specifies the price source for capacity costs (Work Center, Machine Center)';
            DataClassification = CustomerContent;
        }
        field(20; "Include Material"; Boolean)
        {
            Caption = 'Include Material';
            ToolTip = 'Specifies whether to include material costs from BOM in calculations';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(21; "Include Labor"; Boolean)
        {
            Caption = 'Include Labor';
            ToolTip = 'Specifies whether to include labor costs from Routing in calculations';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(22; "Include Overhead"; Boolean)
        {
            Caption = 'Include Overhead';
            ToolTip = 'Specifies whether to include overhead costs in calculations';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(30; Status; Enum "SEW Calc Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the status of the template (Draft, Released, Archived)';
            DataClassification = CustomerContent;
            InitValue = Draft;
        }
        field(31; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
            ToolTip = 'Specifies when the template was last modified';
            DataClassification = CustomerContent;
            Editable = false;
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
        fieldgroup(DropDown; "Code", Description)
        {
        }
        fieldgroup(Brick; "Code", Description, Status)
        {
        }
    }

    trigger OnInsert()
    begin
        Rec."Last Modified Date" := Today();
    end;

    trigger OnModify()
    begin
        Rec."Last Modified Date" := Today();
    end;
}
