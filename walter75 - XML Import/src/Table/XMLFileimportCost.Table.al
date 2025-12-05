table 60506 "SEW XML Fileimport Cost"
{
    Caption = 'XML Fileimport Costs';
    DataClassification = CustomerContent;
    LookupPageId = "SEW XML Fileimport Cost";
    DrillDownPageId = "SEW XML Fileimport Cost";

    fields
    {
        field(1; id; Integer)
        {
            Caption = 'ID';
            ToolTip = 'Specifies the unique identifier for each record.';
        }
        field(2; transferID; Integer)
        {
            Caption = 'Transfer ID';
            ToolTip = 'Specifies the identifier of the associated transfer record.';
            AllowInCustomizations = Never;
        }
        field(3; "Cost Code"; Code[20])
        {
            Caption = 'Cost Code';
            ToolTip = 'Specifies the cost code associated with the cost entry.';
            AllowInCustomizations = Never;
        }
        field(4; "Cost Description"; Text[100])
        {
            Caption = 'Cost Description';
            ToolTip = 'Specifies the description of the cost entry.';
            AllowInCustomizations = Never;
        }
        field(5; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount';
            ToolTip = 'Specifies the amount of the cost entry.';
            AutoFormatType = 1;
            AllowInCustomizations = Never;
        }
    }
    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }
        key(Key2; transferID)
        {
            SumIndexFields = "Cost Amount";
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cost Code", "Cost Description", "Cost Amount")
        {
        }
        fieldgroup(Brick; "Cost Code", "Cost Description", "Cost Amount")
        {
        }
    }

    trigger OnInsert()
    begin
        if Rec.transferID <> 0 then
            Rec.transferID := GetLastEntryNo() + 1;
    end;

    procedure GetLastEntryNo(): Integer
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("id")));
    end;
}
