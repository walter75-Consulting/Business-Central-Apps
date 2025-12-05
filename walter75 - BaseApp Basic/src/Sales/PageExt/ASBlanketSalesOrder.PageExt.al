pageextension 80063 "SEW AS Blanket Sales Order" extends "Blanket Sales Order"
{
    layout
    {

    }

    actions
    {
        addbefore(Print)
        {
            action("SEW SendEmailConfirmation")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Email Confirmation';
                Ellipsis = true;
                Image = SendMail;
                ToolTip = 'Send a sales order confirmation by email. The attachment is sent as a .pdf.';

                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                begin
                    DocPrint.EmailSalesHeader(Rec);
                end;
            }
        }

        addbefore(Print_Promoted)
        {
            actionref(SEW_SendEmailConfirmation; "SEW SendEmailConfirmation") { }
        }

        addafter(Comment)
        {
            action("SEW Customer Comments")
            {

                Caption = 'Customer Comments';
                ToolTip = 'View or add comments for the Customer.';
                Image = ViewComments;
                ApplicationArea = Comments;
                RunObject = page "Comment Sheet";
                RunPageLink = "Table Name" = const(Customer), "No." = field("Sell-to Customer No.");
            }
        }
        addafter(Category_Category7)
        {
            actionref(CustomerComment_Promoted; "SEW Customer Comments") { }
        }
    }
}