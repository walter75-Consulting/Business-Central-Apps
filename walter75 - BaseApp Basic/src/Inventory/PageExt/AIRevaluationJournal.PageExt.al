pageextension 80016 "SEW AI Revaluation Journal" extends "Revaluation Journal"
{

    layout
    {
        addafter("Applies-to Entry")
        {
            field("SEW Lot No."; Rec."SEW Lot No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("SEW Expiration Date"; Rec."SEW Expiration Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("SEW Serial No."; Rec."SEW Serial No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("SEW Package No."; Rec."SEW Package No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }


    actions
    {
        addafter("Page")
        {
            action("SEW GetTrackingInfo")
            {
                ApplicationArea = All;
                Caption = 'Get Tracking Info';
                Image = Item;
                ToolTip = 'Get Tracking Info from Item Ledger Entries.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SEWAIActionsPage: Codeunit "SEW AI Actions Page";
                begin
                    SEWAIActionsPage.FillTrackingInformation(Rec);
                    CurrPage.Update();
                end;
            }
        }
    }

}