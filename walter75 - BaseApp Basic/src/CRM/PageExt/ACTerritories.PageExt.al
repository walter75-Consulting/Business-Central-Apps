pageextension 80051 "SEW AC Territories" extends Territories
{
    layout
    {
        addafter("Name")
        {
            field("SEW Salesperson/Purchaser"; Rec."SEW Salesperson/Purchaser")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action("SEW UpdateSalesPerson")
            {
                ApplicationArea = All;
                Caption = 'Update SalesPerson';
                ToolTip = 'Update Contacts with SalesPerson from Territory.';
                Image = SparkleFilled;

                trigger OnAction()
                var
                    SEWTerritory: Record Territory;
                    SEWTerritoriesProcessing: Codeunit "SEW Territories Processing";
                    ConfirmManagement: Codeunit "Confirm Management";

                    SEWUpdateSalesOrder: Boolean;
                    SEWUpdateSalesQuote: Boolean;
                begin
                    SEWUpdateSalesOrder := false;
                    SEWUpdateSalesQuote := false;

                    if not ConfirmManagement.GetResponse(DialogUpdateSalesPersonLbl, true) then
                        exit;
                    SEWUpdateSalesOrder := ConfirmManagement.GetResponse(DialogUpdateSalesOrderLbl, true);
                    SEWUpdateSalesQuote := ConfirmManagement.GetResponse(DialogUpdateSalesQuoteLbl, true);

                    CurrPage.SetSelectionFilter(SEWTerritory);
                    if SEWTerritory.FindSet() then
                        repeat
                            SEWTerritoriesProcessing.UpdateContactsSalespersonByTerritory(SEWTerritory.Code, SEWTerritory."SEW Salesperson/Purchaser", SEWUpdateSalesOrder, SEWUpdateSalesQuote);
                        until SEWTerritory.Next() = 0;
                    Message(DialogUpdateSalesPersonDoneLbl);
                end;
            }
        }
    }

    var
        DialogUpdateSalesPersonLbl: Label 'Update all Contacts with new SalesPerson?';
        DialogUpdateSalesPersonDoneLbl: Label 'Finished updating Contacts with new SalesPerson.';
        DialogUpdateSalesOrderLbl: Label 'Update all open Sales Orders?';
        DialogUpdateSalesQuoteLbl: Label 'Update all open Sales Quotes?';



}