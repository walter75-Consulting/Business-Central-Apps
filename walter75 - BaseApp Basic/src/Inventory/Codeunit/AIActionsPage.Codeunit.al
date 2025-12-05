codeunit 80002 "SEW AI Actions Page"
{

    Permissions = tabledata "Item Journal Line" = rim,
                    tabledata "Item Ledger Entry" = rim;


    procedure FillTrackingInformation(var ItemJournalLine: Record "Item Journal Line")
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin

        repeat
            ItemLedgerEntry.Reset();
            if ItemLedgerEntry.Get(ItemJournalLine."Applies-to Entry") then begin
                ItemJournalLine."SEW Lot No." := ItemLedgerEntry."Lot No.";
                ItemJournalLine."SEW Expiration Date" := ItemLedgerEntry."Expiration Date";
                ItemJournalLine."SEW Serial No." := ItemLedgerEntry."Serial No.";
                ItemJournalLine."SEW Package No." := ItemLedgerEntry."Package No.";
                ItemJournalLine.Modify(true);
            end;

        until ItemJournalLine.Next() = 0;
    end;

}