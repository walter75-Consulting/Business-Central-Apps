tableextension 80037 "SEW RE VAT Business Posting" extends "VAT Business Posting Group"
{
    fields
    {
        field(80800; "SEW Print Tariff Number Ship"; Boolean)
        {
            Caption = 'Print Tariff Number on Ship';
            ToolTip = 'Specifies if the Tariff Number should be printed on documents.';
            DataClassification = CustomerContent;
        }
        field(80801; "SEW Print Tariff Number Invo"; Boolean)
        {
            Caption = 'Print Tariff Number on Invo';
            ToolTip = 'Specifies if the Tariff Number should be printed on documents.';
            DataClassification = CustomerContent;
        }
        field(80802; "SEW Print CtryofOrigin Ship"; Boolean)
        {
            Caption = 'Print CountryofOrigin on Ship';
            ToolTip = 'Specifies if the Country of Origin should be printed on documents.';
            DataClassification = CustomerContent;
        }
        field(80803; "SEW Print CtryofOrigin Invo"; Boolean)
        {
            Caption = 'Print CountryofOrigin on Invo';
            ToolTip = 'Specifies if the Country of Origin should be printed on documents.';
            DataClassification = CustomerContent;
        }
    }
}
