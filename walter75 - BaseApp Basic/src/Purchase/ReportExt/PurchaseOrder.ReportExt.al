reportextension 80012 "SEW Purchase - Order" extends "Standard Purchase - Order"
{
    dataset
    {
        add("Purchase Header")
        {
            column(SEW_DocumentDate; "Document Date") { }

            column(SEW_CompanyPicture2; CompanyInfo."SEW Picture 2") { }
            column(SEW_CompanyPicture3; CompanyInfo."SEW Picture 3") { }
            column(SEW_CompanyPicture4; CompanyInfo."SEW Picture 4") { }
            column(SEW_CompanyPicture5; CompanyInfo."SEW Picture 5") { }

            column(SEW_SalesPersonPhone; SalespersonPurchaser."Phone No.") { }
            column(SEW_SalesPersonPhoneLbl; SalespersonPurchaser.FieldCaption("Phone No.")) { }
            column(SEW_SalesPersonEmail; SalespersonPurchaser."E-Mail") { }
            column(SEW_SalesPersonEmailLbl; SalespersonPurchaser.FieldCaption("E-Mail")) { }
        }
    }

    rendering
    {
        layout("SEW Purchase Order01")
        {
            Type = RDLC;
            LayoutFile = './src/Purchase/ReportExt/Layout/PurchaseOrder01.rdlc';
            Caption = 'SEW Purchase Order 01 (RDLC)';
            Summary = 'SEW Einkaufsbestellung (RDLC)';
        }
    }
}