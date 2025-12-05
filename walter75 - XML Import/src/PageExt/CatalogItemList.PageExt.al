pageextension 60500 "SEW Catalog Item List" extends "Catalog Item List"
{



    actions
    {
        addafter("Ca&talog Item")
        {
            action("SEW Delete ALL Items")
            {
                Caption = 'Delete ALL Items';
                ToolTip = 'Delete ALL items from Item Master (use with care!).';
                ApplicationArea = All;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    if not ConfirmManagement.GetResponse('Are you sure you want to delete ALL items from Item Master?', true) then
                        exit;
                    Rec.Reset();
                    Rec.DeleteAll(true);
                    CurrPage.Update();
                end;
            }

        }
    }
}
