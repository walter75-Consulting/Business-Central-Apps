table 80006 "SEW Auto Dimension Setup"
{
    Caption = 'Auto Dimension Setup';
    DataClassification = CustomerContent;
    Extensible = true;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the code of the auto dimension setup.';
            NotBlank = true;
            AllowInCustomizations = Never;
        }
        field(2; "Customer Dimension"; Code[20])
        {
            Caption = 'Customer Dimension Code';
            ToolTip = 'Specifies the customer dimension code.';
            TableRelation = Dimension.Code;
        }
        field(3; "Territory Dimension"; Code[20])
        {
            Caption = 'Territory Dimension Code';
            ToolTip = 'Specifies the customer territory dimension code.';
            TableRelation = Dimension.Code;
        }
        field(4; "Item Dimension"; Code[20])
        {
            Caption = 'Item Dimension Code';
            ToolTip = 'Specifies the item dimension code.';
            TableRelation = Dimension.Code;
        }
        field(5; "Item Category Dimension"; Code[20])
        {
            Caption = 'Item Category Dimension Code';
            ToolTip = 'Specifies the item category dimension code.';
            TableRelation = Dimension.Code;
        }
        field(6; "Salesperson Dimension"; Code[20])
        {
            Caption = 'Salesperson Dimension Code';
            ToolTip = 'Specifies the salesperson dimension code.';
            TableRelation = Dimension.Code;
        }
        field(7; "Campaign Dimension"; Code[20])
        {
            Caption = 'Campaign Dimension Code';
            ToolTip = 'Specifies the Campaign dimension code.';
            TableRelation = Dimension.Code;
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
        fieldgroup(DropDown; Code, "Customer Dimension", "Territory Dimension", "Item Dimension", "Item Category Dimension", "Salesperson Dimension", "Campaign Dimension")
        {
        }
        fieldgroup(Brick; Code, "Customer Dimension", "Territory Dimension", "Item Dimension", "Item Category Dimension", "Salesperson Dimension", "Campaign Dimension")
        {
        }
    }

    var
        RecordHasBeenRead: Boolean;

    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;
        Get();
        RecordHasBeenRead := true;
    end;

    procedure InsertIfNotExists()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;


}