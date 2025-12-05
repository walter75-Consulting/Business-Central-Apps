page 90718 "SEW Packing Station List"
{
    ApplicationArea = All;
    Caption = 'Packing Station List';
    PageType = List;
    SourceTable = "SEW Packing Station";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(stationID; Rec.stationID)
                {
                    Visible = false;
                    trigger OnDrillDown()
                    var
                        SEWPKSingleInstance: Codeunit "SEW PK Single Instance";
                        SEWPackingCardPage: Page "SEW Packing Card";
                    begin
                        if not SEWPKSingleInstance.GetInstanceRunning() then
                            SEWPKSingleInstance.SetInstanceRunning(true);

                        SEWPKSingleInstance.StartPackingStation(Rec.stationID);
                        SEWPackingCardPage.Run();
                    end;
                }
                field("Station Name"; Rec."Station Name")
                {
                    trigger OnDrillDown()
                    var
                        SEWPKSingleInstance: Codeunit "SEW PK Single Instance";
                        SEWPackingCardPage: Page "SEW Packing Card";
                    begin
                        if not SEWPKSingleInstance.GetInstanceRunning() then
                            SEWPKSingleInstance.SetInstanceRunning(true);

                        SEWPKSingleInstance.StartPackingStation(Rec.stationID);
                        SEWPackingCardPage.Run();
                    end;
                }
                field("Label PrinterID"; Rec."Label PrinterID")
                {
                    Visible = false;
                }
                field("Cur. Warenhouse Activity Type"; Rec."Cur. Warenhouse Activity Type")
                {
                    Visible = false;
                }
                field("Cur. Warehouse Activity No."; Rec."Cur. Warehouse Activity No.")
                {
                    Visible = false;
                }
                field("Package Material Usage"; Rec."Package Material Usage")
                {
                    Visible = false;
                }
                field("use Scale"; Rec."use Scale")
                {
                    Visible = true;
                }
                field("Scale ID"; Rec."Scale ID")
                {
                    Visible = true;
                }
                field("Delivery Note per Parcel"; Rec."Delivery Note per Parcel") { }
                field("Full User Name"; Rec."Full User Name") { }
                field("Packing is Active"; Rec."Packing is Active") { }
                field("Last Shipment No."; Rec."Last Shipment No.") { }
                field("Last Invoice No."; Rec."Last Invoice No.") { }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ResetStation)
            {
                Caption = 'Reset Station';
                ToolTip = 'Resets the packing station.';
                Image = Delete;

                trigger OnAction()
                begin
                    Clear(Rec."Cur. Warehouse Activity No.");
                    Clear(Rec."Cur. Warenhouse Activity Type");
                    Clear(Rec."Cur. User ID");
                    Rec.Modify(false);
                end;
            }
        }
    }
}