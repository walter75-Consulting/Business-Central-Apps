tableextension 80035 "SEW AC Customer" extends Customer
{
    fields
    {
        field(80201; "SEW Salesperson manually"; Boolean)
        {
            Caption = 'Salesperson manually';
            ToolTip = 'Specifies if the salesperson is set manually.';
            DataClassification = CustomerContent;
        }
        field(80202; "SEW Territory manually"; Boolean)
        {
            Caption = 'Territory manually';
            ToolTip = 'specifies if the territory is set manually.';
            DataClassification = CustomerContent;
        }
        field(80203; "SEW Service Zone manually"; Boolean)
        {
            Caption = 'Service Zone manually';
            ToolTip = 'Specifies if the service zone is set manually.';
            DataClassification = CustomerContent;
        }

        modify("Post Code")
        {
            trigger OnAfterValidate()
            var
                SEWTerritoriesProcessing: Codeunit "SEW Territories Processing";
            begin
                SEWTerritoriesProcessing.OnAfterValidateCustomerPostCode(Rec);
            end;
        }
    }


}