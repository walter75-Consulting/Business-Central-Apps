tableextension 80002 "SEW AP Vendor" extends Vendor
{
    fields
    {
        field(80000; "SEW Warn Text"; Text[255])
        {
            Caption = 'Warn Text';
            ToolTip = 'Specifies the value of the Warn Text field.';
            DataClassification = CustomerContent;
        }
        field(80001; "SEW Search Description"; Text[255])
        {
            Caption = 'Search Description';
            ToolTip = 'Specifies the value of Search Description.';
            //OptimizeForTextSearch = true;
            Editable = false;
            AllowInCustomizations = Never;
        }
    }

    trigger OnAfterModify()
    begin
        SEWAPActionsTable.VendorSearchDescription(Rec);
    end;

    var
        SEWAPActionsTable: Codeunit "SEW AP Actions Table";
}
