table 80003 "SEW Toolbox Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Toolbox Setup';
    Permissions = tabledata "Application Area Setup" = rimd;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            ToolTip = 'Primary Key field. You can use this field to store a unique identifier for the setup record.';
            NotBlank = true;
            AllowInCustomizations = Never;
        }
        field(80000; SEWCRMFeatures; Boolean)
        {
            Caption = 'CRM Features';
            ToolTip = 'Specifies whether CRM features are enabled.';
            AllowInCustomizations = Never;
        }
        field(80020; SEWFinanceFeatures; Boolean)
        {
            Caption = 'Finance Features';
            ToolTip = 'Specifies whether Finance Features are enabled.';
            AllowInCustomizations = Never;
        }
        field(80040; SEWInventoryFeatures; Boolean)
        {
            Caption = 'Inventory Features';
            ToolTip = 'Specifies whether Inventory Features are enabled.';
            AllowInCustomizations = Never;
        }
        field(80060; SEWManufacturingFeatures; Boolean)
        {
            Caption = 'Manufacturing Features';
            ToolTip = 'Specifies whether Manufacturing Features are enabled.';
            AllowInCustomizations = Never;
        }
        field(80080; SEWPurchaseFeatures; Boolean)
        {
            Caption = 'Purchase Features';
            ToolTip = 'Specifies whether Purchase Features are enabled.';
            AllowInCustomizations = Never;
        }
        field(80100; SEWSalesFeatures; Boolean)
        {
            Caption = 'Sales Features';
            ToolTip = 'Specifies whether Sales Features are enabled.';
            AllowInCustomizations = Never;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {

    }

    // trigger OnInsert()
    // begin

    // end;

    // trigger OnDelete()
    // begin

    // end;

    trigger OnModify()
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        ApplicationAreaMgmtFacade.RefreshExperienceTierCurrentCompany();
    end;

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

    var
        RecordHasBeenRead: Boolean;



}