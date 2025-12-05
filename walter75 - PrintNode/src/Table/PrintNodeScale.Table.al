table 92708 "SEW PrintNode Scale"
{
    Caption = 'SEW PrintNode Scale';
    DataClassification = CustomerContent;
    LookupPageId = "SEW PrintNode Scales";
    DrillDownPageId = "SEW PrintNode Scales";

    fields
    {
        field(1; "Scale ID"; Integer)
        {
            Caption = 'Scale ID';
            ToolTip = 'Specifies the unique identifier for the PrintNode scale.';
            AllowInCustomizations = Never;
        }
        field(2; "Computer ID"; Integer)
        {
            Caption = 'computerID';
            ToolTip = 'Specifies the PrintNode computer ID where the scale is connected.';
            TableRelation = "SEW PrintNode Computer"."Computer ID";
        }
        field(3; "Scale Name"; Text[150])
        {
            Caption = 'Scale Name';
            ToolTip = 'Specifies the name of the scale as assigned by PrintNode.';
        }
        field(4; "Scale No."; Integer)
        {
            Caption = 'Scale No.';
            ToolTip = 'Specifies the scale number as assigned by PrintNode.';
        }
        field(5; "Scale Vendor"; Text[150])
        {
            Caption = 'Scale Vendor';
            ToolTip = 'Specifies the vendor of the scale as assigned by PrintNode.';
        }

    }
    keys
    {
        key(PK; "Computer ID", "Scale Name", "Scale No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Scale Name") { }
        fieldgroup(Brick; "Scale Name") { }
    }


    trigger OnInsert()
    begin
        Rec."Scale ID" := GetLastEntryNo() + 1;

    end;

    procedure GetLastEntryNo(): Integer
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Scale ID")));
    end;
}
