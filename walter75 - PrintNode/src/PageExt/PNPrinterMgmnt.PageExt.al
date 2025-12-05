pageextension 92703 "SEW PN Printer Mgmnt" extends "Printer Management"
{
    AdditionalSearchTerms = 'printnode';
    PromotedActionCategories = 'New, Process, Report, Manage, Email Print, Universal Print, PrintNode';

    actions
    {
        // Adding a new action in the 'Creation' area
        addlast(Creation)
        {
            action("SEW PrintNode Setup")
            {
                ApplicationArea = All;
                Caption = 'PrintNode Printer Setup';
                ToolTip = 'Open the PrintNode setup page.';
                Image = Print;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunPageMode = View;
                PromotedCategory = Category7;
                RunObject = page "SEW PrintNode Setup";
            }
        }
    }
}
