table 91713 "SEW Lead Assignment Log"
{
    Caption = 'Lead Assignment Log';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Lead Assignment Log";
    DrillDownPageId = "SEW Lead Assignment Log";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the unique entry number for the assignment log.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Lead No."; Code[20])
        {
            Caption = 'Lead No.';
            ToolTip = 'Specifies the lead that was assigned.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Lead";
        }
        field(10; "Rule Code"; Code[20])
        {
            Caption = 'Rule Code';
            ToolTip = 'Specifies which routing rule triggered the assignment.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Lead Routing Rule";
        }
        field(20; "From Assignment Type"; Enum "SEW Lead Assignment Type")
        {
            Caption = 'From Assignment Type';
            ToolTip = 'Specifies the type of previous assignment.';
            DataClassification = CustomerContent;
        }
        field(21; "From Assigned To"; Code[20])
        {
            Caption = 'From Assigned To';
            ToolTip = 'Specifies the code of the previous assignee (salesperson or team).';
            DataClassification = CustomerContent;
        }
        field(22; "From Assigned To Name"; Text[100])
        {
            Caption = 'From Assigned To Name';
            ToolTip = 'Specifies the name of the previous assignee.';
            DataClassification = CustomerContent;
        }
        field(30; "To Assignment Type"; Enum "SEW Lead Assignment Type")
        {
            Caption = 'To Assignment Type';
            ToolTip = 'Specifies the type of new assignment.';
            DataClassification = CustomerContent;
        }
        field(31; "To Assigned To"; Code[20])
        {
            Caption = 'To Assigned To';
            ToolTip = 'Specifies the code of the new assignee (salesperson or team).';
            DataClassification = CustomerContent;
        }
        field(32; "To Assigned To Name"; Text[100])
        {
            Caption = 'To Assigned To Name';
            ToolTip = 'Specifies the name of the new assignee.';
            DataClassification = CustomerContent;
        }
        field(40; Reason; Text[100])
        {
            Caption = 'Reason';
            ToolTip = 'Specifies the reason for the assignment.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SK1; "Lead No.", SystemCreatedAt)
        {
        }
        key(SK2; "Rule Code", SystemCreatedAt)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Lead No.", "To Assigned To Name", SystemCreatedAt)
        {
        }
    }
}
