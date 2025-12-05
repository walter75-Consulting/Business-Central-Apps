tableextension 80001 "SEW AS Customer" extends Customer
{
    fields
    {
        field(80000; "SEW Warn Text"; Text[255])
        {
            Caption = 'Warn Text';
            ToolTip = 'Specifies the value of the Warn Text field.';
            DataClassification = CustomerContent;
        }
        field(80001; "SEW Customer Group Code"; Code[20])
        {
            Caption = 'Customer Group';
            ToolTip = 'Specifies the value of the Customer Group field.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Customer Group";
        }
        field(80002; "SEW Search Description"; Text[255])
        {
            Caption = 'Search Description';
            ToolTip = 'Specifies the value of Search Description.';
            //OptimizeForTextSearch = true;
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(80003; "SEW No. Master"; Code[20])
        {
            Caption = 'No. Master';
            ToolTip = 'Specifies the Master Customer No.';
            DataClassification = CustomerContent;
            AllowInCustomizations = Never;
            TableRelation = Customer;
        }
    }


    trigger OnAfterModify()
    begin
        SEWASActionsTable.CustomerSearchDescription(Rec);
    end;

    trigger OnAfterInsert()
    begin
        SEWASActionsTable.CustomerMasterNo(Rec);
    end;

    var
        SEWASActionsTable: Codeunit "SEW AS Actions Table";

}
