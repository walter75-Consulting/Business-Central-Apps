pageextension 80050 "SEW AC Post Codes" extends "Post Codes"
{
    layout
    {
        addafter("TimeZone")
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
                Caption = 'Update Contacts Territory Code & Service Zone';
                ToolTip = 'Update Contacts with Territory Code & Service Zone from Post Code.';
                Image = SparkleFilled;

                trigger OnAction()
                var
                    SEWPostCode: Record "Post Code";
                    SEWTerritoriesProcessing: Codeunit "SEW Territories Processing";

                begin
                    if not ConfirmManagement.GetResponse(DialogUpdateLbl, true) then
                        exit;

                    CurrPage.SetSelectionFilter(SEWPostCode);
                    if SEWPostCode.FindSet() then
                        repeat
                            SEWTerritoriesProcessing.UpdateContactsTerritoryByCountryPostcode(SEWPostCode."Country/Region Code", SEWPostCode.Code, SEWPostCode."SEW Territory Code", SEWPostCode."SEW Service Zone")
                        until SEWPostCode.Next() = 0;
                    Message(DialogUpdateDoneLbl);
                end;
            }
            action("SEW CreateMissingPostCodes")
            {
                ApplicationArea = All;
                Caption = 'Create Missing Post Codes';
                ToolTip = 'Creates Missing Post Codes from existing Contacts.';
                Image = SparkleFilled;

                trigger OnAction()
                var
                    SEWTerritoriesProcessing: Codeunit "SEW Territories Processing";
                begin
                    SEWTerritoriesProcessing.CreatePostCodesFromContacts();
                end;
            }
            action("SEW EmtpyTerritoryCodes")
            {
                ApplicationArea = All;
                Caption = 'Fill empty Territory Code & Service Zone';
                ToolTip = 'Fill empty Territory Code & Service Zone in Post Codes with default values from Marketing Setup.';
                Image = SparkleFilled;

                trigger OnAction()
                var
                    PostCode: Record "Post Code";
                    MarketingSetup: Record "Marketing Setup";

                begin
                    if not ConfirmManagement.GetResponse(DialogEmptyLbl, true) then
                        exit;

                    if not MarketingSetup.Get() then
                        Error(ErrNoMarketingSetupLbl);


                    PostCode.Reset();
                    PostCode.SetFilter("SEW Territory Code", '=%1', ''); // only empty Territory Codes
                    if PostCode.FindSet() then
                        repeat
                            PostCode."SEW Territory Code" := MarketingSetup."Default Territory Code";
                            PostCode.Modify(false);
                        until PostCode.Next() = 0;

                    if ApplicationArea() = 'Service' then begin
                        PostCode.Reset();
                        PostCode.SetFilter("SEW Service Zone", '=%1', ''); // only empty Service Zones
                        if PostCode.FindSet() then
                            repeat
                                PostCode."SEW Service Zone" := MarketingSetup."Default Territory Code";
                                PostCode.Modify(false);
                            until PostCode.Next() = 0;
                    end;
                    Message(DialogEmptyDoneLbl);
                end;
            }
        }
    }

    var
        ConfirmManagement: Codeunit "Confirm Management";


        DialogUpdateLbl: Label 'Update all Contacts with new Territory Code & Service Zone?';
        DialogUpdateDoneLbl: Label 'Finished updating Contacts with new Territory Code & Service Zone';

        DialogEmptyLbl: Label 'Fill empty Territory Code & Service Zone?';
        DialogEmptyDoneLbl: Label 'Finished filling empty Territory Code & Service Zone';

        ErrNoMarketingSetupLbl: Label 'No Marketing Setup found.';

}