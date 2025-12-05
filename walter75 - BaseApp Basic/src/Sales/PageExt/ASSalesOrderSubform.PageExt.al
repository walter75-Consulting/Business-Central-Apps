pageextension 80009 "SEW AS Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var

                SEWASActionsPage: Codeunit "SEW AS Actions Page";
            begin
                if Rec.Reserve = "Reserve Method"::Always then begin
                    CurrPage.SaveRecord();
                    Rec.AutoReserve();
                    CurrPage.Update((false));
                end;

                //Auto-Explode Assembly BOM
                if (Rec.Type = "Sales Line Type"::Item) then
                    if SEWASActionsPage.CheckItemAutoExplodeBOM(Rec."No.") then begin
                        SEWBASingleInstance.SetAutoExplode(true);
                        CurrPage.SaveRecord();
                        Commit(); // To make sure the line is saved before exploding
                        ExplodeBOM();
                        SEWBASingleInstance.SetAutoExplode(false);
                        CurrPage.Update(false);
                    end;

            end;
        }
    }


    trigger OnOpenPage()
    begin
        SEWBASingleInstance.SetAutoExplode(false);
    end;


    var
        SEWBASingleInstance: Codeunit "SEW BA Single Instance";
}


