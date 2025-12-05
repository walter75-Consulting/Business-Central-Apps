page 60505 "SEW XML Fileimport Address"
{
    ApplicationArea = All;
    Caption = 'XML Fileimport Addresses';
    PageType = List;
    SourceTable = "SEW XML Fileimport Address";
    UsageCategory = None;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(PARTNER_ID; Rec.PARTNER_ID) { }
                field(PARTNER_Q; Rec.PARTNER_Q) { }
                field(NAME1; Rec.NAME1) { }
                field(NAME2; Rec.NAME2) { }
                field(STREET1; Rec.STREET1) { }
                field(COUNTRY1; Rec.COUNTRY1) { }
                field(POSTL_COD1; Rec.POSTL_COD1) { }
                field(CITY1; Rec.CITY1) { }
                field(E_MAIL; Rec.E_MAIL) { }
                field(TELEFAX; Rec.TELEFAX) { }
                field(TELEPHONE1; Rec.TELEPHONE1) { }
                field(LANGUAGE; Rec.LANGUAGE) { }
            }
        }
    }
}
