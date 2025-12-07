table 90807 "SEW Calc History Entry"
{
    Caption = 'Calculation History Entry';
    LookupPageId = "SEW Calc History List";
    DrillDownPageId = "SEW Calc History List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            ToolTip = 'Specifies the unique entry number for the history record.';
        }
        field(2; "Calculation No."; Code[20])
        {
            Caption = 'Calculation No.';
            TableRelation = "SEW Calc Header";
            ToolTip = 'Specifies the calculation number this history entry belongs to.';
        }
        field(3; "Version No."; Integer)
        {
            Caption = 'Version No.';
            ToolTip = 'Specifies the version number of the calculation at the time of this change.';
        }
        field(4; "Change Date"; Date)
        {
            Caption = 'Change Date';
            ToolTip = 'Specifies the date when the change was made.';
        }
        field(5; "Change Time"; Time)
        {
            Caption = 'Change Time';
            ToolTip = 'Specifies the time when the change was made.';
        }
        field(6; "Changed By User"; Code[50])
        {
            Caption = 'Changed By User';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ToolTip = 'Specifies the user who made the change.';
        }
        field(7; "Field Name"; Text[100])
        {
            Caption = 'Field Name';
            ToolTip = 'Specifies the name of the field that was changed.';
        }
        field(8; "Old Value"; Text[250])
        {
            Caption = 'Old Value';
            ToolTip = 'Specifies the value before the change.';
        }
        field(9; "New Value"; Text[250])
        {
            Caption = 'New Value';
            ToolTip = 'Specifies the value after the change.';
        }
        field(10; "Change Type"; Enum "SEW Calc Change Type")
        {
            Caption = 'Change Type';
            ToolTip = 'Specifies the type of change (Created, Modified, Archived, Deleted).';
        }
        field(11; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            ToolTip = 'Specifies the item number from the calculation.';
        }
        field(12; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            ToolTip = 'Specifies the item description from the calculation.';
        }
        field(20; "Archived Data"; Blob)
        {
            Caption = 'Archived Data';
            ToolTip = 'Specifies the complete archived calculation data in JSON format.';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(CalcNo; "Calculation No.", "Change Date", "Change Time")
        {
        }
        key(ChangeType; "Change Type", "Change Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Calculation No.", "Change Type", "Change Date")
        {
        }
        fieldgroup(Brick; "Entry No.", "Calculation No.", "Change Type", "Change Date")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Change Date" = 0D then
            "Change Date" := Today();
        if "Change Time" = 0T then
            "Change Time" := Time();
        if "Changed By User" = '' then
            "Changed By User" := CopyStr(UserId(), 1, MaxStrLen("Changed By User"));
    end;
}
