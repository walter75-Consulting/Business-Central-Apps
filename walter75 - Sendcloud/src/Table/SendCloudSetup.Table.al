table 95709 "SEW SendCloud Setup"
{
    Caption = 'SendCloud Setup';
    DataClassification = CustomerContent;
    Extensible = false;

    fields
    {
#pragma warning disable LC0013 
        field(1; "Primary Key"; Code[10])
#pragma warning restore LC0013 
        {
            Caption = 'Primary Key';
            ToolTip = 'Specifies the Primary Key.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(2; "API Public Key"; Text[250])
        {
            Caption = 'API Public Key';
            ToolTip = 'Specifies the Public Key.';
            AllowInCustomizations = Never;
        }
        field(3; "API Secret Key"; Text[250])
        {
            Caption = 'API Secret Key';
            ToolTip = 'Specifies the Secret Key.';
            AllowInCustomizations = Never;
            //MaskType = Concealed;
        }
        field(4; "Recipient No. Series"; Code[20])
        {
            Caption = 'RecipientNo. Series';
            ToolTip = 'Specifies the Recipient No. Series.';
            TableRelation = "No. Series".Code;
            AllowInCustomizations = Never;
        }
        field(5; "Parcel No. Series"; Code[20])
        {
            Caption = 'Parcel No. Series';
            ToolTip = 'Specifies the Parcel No. Series for SendCloud shipments.';
            TableRelation = "No. Series".Code;
            AllowInCustomizations = Never;
        }
        field(6; "Default SenderID"; Integer)
        {
            Caption = 'Default SenderID';
            ToolTip = 'Specifies the Default SenderID.';
            AllowInCustomizations = Never;
            TableRelation = "SEW Sender Address".ID;
        }
        field(7; "Default PrintNode PrinterID"; Integer)
        {
            Caption = 'Default PrintNode Printer';
            ToolTip = 'Specifies the Default PrintNode Printer.';
            AllowInCustomizations = Never;
            TableRelation = "SEW PrintNode Printer"."Printer ID";
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }


    procedure InsertIfNotExists()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;


}