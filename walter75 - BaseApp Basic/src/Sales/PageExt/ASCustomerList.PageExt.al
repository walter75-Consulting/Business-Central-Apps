pageextension 80014 "SEW AS Customer List" extends "Customer List"
{
    layout
    {
        addafter("Customer Posting Group")
        {
            field("SEW Customer Group Code"; Rec."SEW Customer Group Code")
            {
                ApplicationArea = All;
            }
            field("SEW No. Master"; Rec."SEW No. Master")
            {
                ApplicationArea = All;
            }
            field("SEW Comment"; Rec.Comment)
            {
                ToolTip = 'Specifies a comment for the customer.';
                ApplicationArea = All;
                Visible = true;
                Editable = false;
            }
        }
        addlast(Control1)
        {
            field("SEW SearchDescription"; Rec."SEW Search Description")
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    var
        SEWASActionsTable: Codeunit "SEW AS Actions Table";
    begin
        if Rec.FindSet() then
            repeat
                if Rec."SEW Search Description" = '' then begin
                    Rec."SEW Search Description" := CopyStr(Rec."Search Name" + ' ' + Rec."Post Code", 1, MaxStrLen(Rec."SEW Search Description"));
                    Rec.Modify(false);
                end;
                if Rec."SEW No. Master" = '' then
                    SEWASActionsTable.CustomerMasterNo(Rec);

            until Rec.Next() = 0;
    end;
}

