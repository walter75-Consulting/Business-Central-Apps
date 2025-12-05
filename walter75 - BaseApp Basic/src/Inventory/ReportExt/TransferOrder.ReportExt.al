reportextension 80019 "SEW Transfer Order" extends "Transfer Order"
{
    dataset
    {


    }




    rendering
    {
        layout("SEW Transfer Order01")
        {
            Type = RDLC;
            LayoutFile = './src/Inventory/ReportExt/Layout/TransferOrder01.rdlc';
            Caption = 'SEW Transfer Order 01 (RDLC)';
            Summary = 'SEW Umlagerungsauftrag (RDLC)';
        }
    }


}