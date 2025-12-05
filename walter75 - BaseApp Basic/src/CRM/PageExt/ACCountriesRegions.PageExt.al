pageextension 80047 "SEW AC Countries/Regions" extends "Countries/Regions"
{
    layout
    {
        addafter("VAT Scheme")
        {
            field("SEW Territory Code"; Rec."SEW Territory Code")
            {
                ApplicationArea = All;
            }
            field("SEW Service Zone"; Rec."SEW Service Zone")
            {
                ApplicationArea = Service;
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
                Caption = 'Update Territory Code & Service Zone';
                ToolTip = 'Update Contacts with Territory Code & Service Zone from Country/Region.';
                Image = SparkleFilled;

                trigger OnAction()
                var
                    SEWCountryRegion: Record "Country/Region";
                    SEWTerritoriesProcessing: Codeunit "SEW Territories Processing";
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    if not ConfirmManagement.GetResponse(DialogUpdateLbl, true) then
                        exit;

                    CurrPage.SetSelectionFilter(SEWCountryRegion);
                    if SEWCountryRegion.FindSet() then
                        repeat
                            SEWTerritoriesProcessing.UpdateContactsTerritoryByCountryPostcode(SEWCountryRegion."Code", '', SEWCountryRegion."SEW Territory Code", SEWCountryRegion."SEW Service Zone")
                        until SEWCountryRegion.Next() = 0;
                    Message(DialogUpdateDoneLbl);
                end;
            }
        }
    }

    var
        DialogUpdateLbl: Label 'Update all Contacts with new Territory Code & Service Zone?';
        DialogUpdateDoneLbl: Label 'Finished updating Contacts with new Territory Code & Service Zone';
}