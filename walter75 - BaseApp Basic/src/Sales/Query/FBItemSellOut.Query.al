query 80002 "SEW FB Item SellOut"
{
    QueryType = Normal;
    Caption = 'Customer Item History';
    UsageCategory = ReportsAndAnalysis;
    Permissions = tabledata "Sales Invoice Line" = r;

    elements
    {
        dataitem(SalesInvoiceLine; "Sales Invoice Line")
        {
            filter(LineTyp; Type) { }
            filter(SelltoCustomerNo; "Sell-to Customer No.") { }
            column(CountOfItem)
            {
                Method = Count;
            }
            column(ItemNo; "No.")
            {
                ColumnFilter = ItemNo = filter(<> '');
            }
        }
    }
}