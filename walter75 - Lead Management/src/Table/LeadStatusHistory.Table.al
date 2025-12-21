table 91704 "SEW Lead Status History"
{
    Caption = 'Lead Status History';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Lead Status History";
    DrillDownPageId = "SEW Lead Status History";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the entry number for this status history record.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(10; "Lead No."; Code[20])
        {
            Caption = 'Lead No.';
            ToolTip = 'Specifies the lead associated with this status change.';
            TableRelation = "SEW Lead";
            DataClassification = CustomerContent;
        }
        field(20; "Old Status"; Enum "SEW Lead Status")
        {
            Caption = 'Old Status';
            ToolTip = 'Specifies the previous status of the lead.';
            DataClassification = CustomerContent;
        }
        field(21; "New Status"; Enum "SEW Lead Status")
        {
            Caption = 'New Status';
            ToolTip = 'Specifies the new status of the lead.';
            DataClassification = CustomerContent;
        }
        field(30; Reason; Text[100])
        {
            Caption = 'Reason';
            ToolTip = 'Specifies the reason for the status change.';
            DataClassification = CustomerContent;
        }
        field(100; "Changed By User Name"; Code[50])
        {
            Caption = 'Changed By';
            ToolTip = 'Specifies the name of the user who made the status change.';
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemCreatedBy)));
            Editable = false;
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
    }
}
