pageextension 80041 "SEW AD Item Category Card" extends "Item Category Card"
{
    layout
    {

    }

    actions
    {
        addfirst(processing)
        {
            action("SEW Dimensions")
            {
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                RunObject = page "Default Dimensions";
                RunPageLink = "Table ID" = const(5722),
                                  "No." = field(Code);
                ShortcutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
            }
        }
    }

}