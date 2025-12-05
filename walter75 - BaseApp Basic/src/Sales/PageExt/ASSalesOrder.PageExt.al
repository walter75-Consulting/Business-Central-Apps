pageextension 80065 "SEW AS Sales Order" extends "Sales Order"
{
    layout
    {
        addbefore(Status)
        {
            field("SEW Blanket Order No."; Rec."SEW Blanket Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Customer")
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
        addafter(Category_Category5)
        {
            actionref(CustomerComment_Promoted; "SEW Customer Comments")
            {
            }
        }
    }
}