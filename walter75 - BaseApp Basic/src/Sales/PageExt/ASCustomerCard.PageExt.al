pageextension 80005 "SEW AS Customer Card" extends "Customer Card"
{
    layout
    {
        addafter("Search Name")
        {
            field("SEW No. Master"; Rec."SEW No. Master")
            {
                ApplicationArea = All;
            }
        }

        addafter("Disable Search by Name")
        {
            field("SEW Warntext"; Rec."SEW Warn Text")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
        }

        addafter("Responsibility Center")
        {
            field("SEW Customer Group Code"; Rec."SEW Customer Group Code")
            {
                ApplicationArea = All;
            }
            field("SEW Chain Name"; Rec."Chain Name")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the Chain Name.';
            }
            field("SEW Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Territory Code.';
            }
            field("SEW Our Account No."; Rec."Our Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Our Account No.';
            }
            field("SEW Statistics Group"; Rec."Statistics Group")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the Statistics Group.';
            }
            field("SEW Comment"; Rec."Comment")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a comment for the customer.';
            }
        }

        addafter(Control149)
        {
            part(ItemSellOutFactbox; "SEW FB Item SellOut History")
            {
                Caption = 'Item SellOut History';
                Editable = false;
                ApplicationArea = All;
                SubPageLink = "Sell-to Customer No." = field("No.");
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        CurrPage.ItemSellOutFactbox.Page.FillTempTable(Rec);
    end;
}
