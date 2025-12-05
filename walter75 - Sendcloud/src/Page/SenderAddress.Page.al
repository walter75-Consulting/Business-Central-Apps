page 95705 "SEW Sender Address"
{
    ApplicationArea = All;
    Caption = 'SendCloud Sender Address';
    PageType = List;
    SourceTable = "SEW Sender Address";
    UsageCategory = None;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Contact Name"; Rec."Contact Name")
                {
                }
                field(eMail; Rec.eMail)
                {
                }
                field(Phone; Rec.Phone)
                {
                }
                field(Street; Rec.Street)
                {
                }
                field("House Nbr"; Rec."House Nbr")
                {
                }
                field("Postal Box"; Rec."Postal Box")
                {
                }
                field("Postal Code"; Rec."Postal Code")
                {
                }
                field(City; Rec.City)
                {
                }
                field(Country; Rec.Country)
                {
                }
                field("Country State"; Rec."Country State")
                {
                }
                field("VAT Number"; Rec."VAT Number")
                {
                }
                field("EORI Number"; Rec."EORI Number")
                {
                }
                field("UKIMS Number"; Rec."UKIMS Number")
                {
                }
                field("Label"; Rec."Label")
                {
                }
                field(brandID; Rec.brandID)
                {
                }
                field("Signature full Name"; Rec."Signature full Name")
                {
                }
                field("Signature Initials"; Rec."Signature Initials")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportSenderAddresses)
            {
                Caption = 'Import Sender Addresses';
                Image = Import;
                ToolTip = 'Imports sender addresses from Sendcloud.';
                trigger OnAction()
                var
                    SEWSCRestRequests: Codeunit "SEW SC Rest Requests";
                begin
                    SEWSCRestRequests.GetSendCloudSenderAddresses();
                end;
            }
        }
    }
}
