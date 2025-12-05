page 90704 "SEW Packing Card FB Parcel"
{
    Caption = 'Parcel List';
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "SEW Parcel";
    SourceTableView = sorting("Parcel No.") order(ascending);
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    UsageCategory = None;

    layout
    {
        area(Content)
        {

            repeater(Group)
            {
                field("No."; Rec."Parcel No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        SEWPKSingleInstance: Codeunit "SEW PK Single Instance";
                    begin
                        SEWPKSingleInstance.SetCurrentParcelNo(Rec."Parcel No.");
                    end;
                }
                field("SC Parcel Status"; Rec."SC Parcel Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Source Type Sub"; Rec."Source Type Sub")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }

            }
        }
    }
}