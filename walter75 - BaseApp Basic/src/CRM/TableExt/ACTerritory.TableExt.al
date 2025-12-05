tableextension 80034 "SEW AC Territory" extends Territory
{
    fields
    {
        field(80200; "SEW Salesperson/Purchaser"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Salesperson Code';
            ToolTip = 'Specifies the value of the Salesperson Code field.';
            TableRelation = "Salesperson/Purchaser";
        }
    }
}