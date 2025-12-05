enum 95701 "SEW Shipment Source Type Sub"
{
    Extensible = true;

    value(0; "")
    {
        Caption = '', Locked = true;
    }

    #region 10 Contact
    value(10; Contact)
    {
        Caption = 'Contact';
    }
    value(101; "Contact Alt. Address")
    {
        Caption = 'Contact Alt. Address';
    }
    #endregion

    #region 20 Customer
    value(20; Customer)
    {
        Caption = 'Customer';
    }
    value(201; "Customer Ship-to")
    {
        Caption = 'Customer Ship-to';
    }
    value(202; "Sales Order")
    {
        Caption = 'Sales Order';
    }
    value(203; "Sales Shipment")
    {
        Caption = 'Sales Shipment';
    }
    value(204; "Sales Invoice")
    {
        Caption = 'Sales Invoice';
    }
    value(205; "Sales Order Archive")
    {
        Caption = 'Sales Order Archive';
    }
    value(206; "Sales Return Order")
    {
        Caption = 'Sales Return Order';
    }
    value(207; "Sales Return Shipment")
    {
        Caption = 'Sales Return Shipment';
    }
    value(208; "Sales Credit Memo")
    {
        Caption = 'Sales Credit Memo';
    }
    value(209; "Sales Blanket Order")
    {
        Caption = 'Sales Blanket Order';
    }
    value(210; "Sales Quote")
    {
        Caption = 'Sales Quote';
    }
    value(220; "Subscription Customer")
    {
        Caption = 'Subscription Customer';
    }
    value(221; "Subscription Contract Customer")
    {
        Caption = 'Subscription Contract Customer';
    }
    value(230; "Project")
    {
        Caption = 'Project';
    }
    value(231; "Project Archive")
    {
        Caption = 'Project Archive';
    }
    value(240; "Service Order")
    {
        Caption = 'Service Order';
    }
    value(241; "Service Shipment")
    {
        Caption = 'Service Shipment';
    }
    value(242; "Service Invoice")
    {
        Caption = 'Service Invoice';
    }
    value(243; "Service Order Archive")
    {
        Caption = 'Service Order Archive';
    }
    value(246; "Service Credit Memo")
    {
        Caption = 'Service Credit Memo';
    }
    value(248; "Service Quote")
    {
        Caption = 'Service Quote';
    }
    value(249; "Service Contract Customer")
    {
        Caption = 'Service Contact Customer';
    }


    #endregion

    #region 30 Vendor
    value(30; Vendor)
    {
        Caption = 'Vendor';
    }
    value(301; "Vendor Order Address")
    {
        Caption = 'Vendor Order Address';
    }
    value(302; "Vendor Remit Address")
    {
        Caption = 'Vendor Remit Address';
    }
    value(303; "Purchase Order")
    {
        Caption = 'Purchase Order';
    }
    value(304; "Purchase Receipt")
    {
        Caption = 'Purchase Receipt';
    }
    value(305; "Purchase Invoice")
    {
        Caption = 'Purchase Invoice';
    }
    value(306; "Purchase Order Archive")
    {
        Caption = 'Purchase Order Archive';
    }
    value(307; "Purchase Return Order")
    {
        Caption = 'Purchase Return Order';
    }
    value(308; "Purchase Return Shipment")
    {
        Caption = 'Purchase Return Shipment';
    }
    value(309; "Purchase Credit Memo")
    {
        Caption = 'Purchase Credit Memo';
    }
    value(310; "Purchase Blanket Order")
    {
        Caption = 'Purchase Blanket Order';
    }
    value(311; "Purchase Quote")
    {
        Caption = 'Purchase Quote';
    }
    value(320; "Subscription Contract Vendor")
    {
        Caption = 'Subscription Contract Vendor';
    }
    #endregion

    #region 40 Warehouse
    value(40; Warehouse)
    {
        Caption = 'Warehouse';
    }
    value(401; Location)
    {
        Caption = 'Location';
    }
    value(402; "Warehouse Transfer")
    {
        Caption = 'Warehouse Transfer';
    }
    value(403; "Warehouse Transfer Shipment")
    {
        Caption = 'Warehouse Transfer Shipment';
    }
    value(404; "Warehouse Transfer Receipt")
    {
        Caption = 'Warehouse Transfer Receipt';
    }
    value(405; "Warehouse Direct Transfer")
    {
        Caption = 'Warehouse Direct Transfer';
    }
    value(406; "Warehouse Pick")
    {
        Caption = 'Warehouse Pick';
    }
    value(407; "Warehouse Shipment")
    {
        Caption = 'Warehouse Shipment';
    }
    value(408; "Warehouse Receipt")
    {
        Caption = 'Warehouse Receipt';
    }
    value(409; "Warehouse Pick Posted")
    {
        Caption = 'Posted Warehouse Pick';
    }


    #endregion

    #region 50 other

    value(501; Ressource)
    {
        Caption = 'Resource';
    }
    value(502; Employee)
    {
        Caption = 'Employee';
    }
    value(503; "Recipient Address")
    {
        Caption = 'Recipient Address';
    }
    #endregion

    value(999; "SendCloud Import")
    {
        Caption = 'SendCloud Import';
    }

}