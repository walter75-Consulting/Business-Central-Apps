page 80015 "SEW FB Item SellOut History"
{
    Caption = 'FB Item SellOut History';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Sales Line";
    SourceTableTemporary = true;
    Editable = false;
    Permissions = tabledata Item = rmid;


    layout
    {
        area(Content)
        {
            repeater(Item)
            {
                field(ItemNo; Rec."No.")
                {
                    ToolTip = 'Specifies the Item No.';
                }
                field(ItemDesc; Rec.Description)
                {
                    ToolTip = 'Specifies the Item Description.';
                }
                field(ItemQty; Rec."Quantity (Base)")
                {
                    ToolTip = 'Specifies the Quantity (Base).';
                }
                field(SellToCustomer; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Specifies the Sell-to Customer No.';
                    Visible = false;
                }
            }
        }
    }


    procedure FillTempTable(Customer: Record Customer)
    var
        ItemRec: Record Item;
        SEWFBItemSellOut: Query "SEW FB Item SellOut";
        LineNo: Integer;
    begin
        //Filter and Run the Query:
        SEWFBItemSellOut.SetRange(LineTyp, "Sales Line Type"::Item);
        SEWFBItemSellOut.SetRange(SelltoCustomerNo, Customer."No.");
        SEWFBItemSellOut.Open();

        Rec.Reset();
        Rec.DeleteAll(false);
        LineNo := 10000;

        //Copy the Query result(s) in the temp table:
        while SEWFBItemSellOut.Read() do
            if ItemRec.Get(SEWFBItemSellOut.ItemNo) then begin
                Rec.Init();
                Rec."Line No." := LineNo;
                Rec.Type := "Sales Line Type"::Item;
                Rec."No." := ItemRec."No.";
                Rec.Description := ItemRec.Description;
                Rec."Sell-to Customer No." := Customer."No.";
                Rec."Quantity (Base)" := SEWFBItemSellOut.CountOfItem;
                Rec.Insert(false);
                LineNo := LineNo + 10000;
            end;

        //Close Query:
        SEWFBItemSellOut.Close();

    end;


}