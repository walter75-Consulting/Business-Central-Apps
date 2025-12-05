page 90701 "SEW Packing Card"

{
    Caption = 'Packing';
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Warehouse Activity Line";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Extensible = true;

    Permissions = tabledata "Inventory Setup" = r,
                    tabledata "SEW Package Setup" = r;

    layout
    {
        area(Content)
        {
            group(PackHeader)
            {
                Caption = 'Packvorgang';
                ShowCaption = false;
                grid(SEWScan)
                {

                    group(General)
                    {
                        Caption = 'Pickorder';
                        ShowCaption = true;

                        field("No.1"; Rec."No.")
                        {
                            ApplicationArea = Warehouse;
                            ToolTip = 'Specifies the number of the warehouse activity line.';
                            Editable = false;
                            QuickEntry = false;
                        }
                        field("Location Code"; Rec."Location Code")
                        {
                            ApplicationArea = Warehouse;
                            ToolTip = 'Specifies the code of the location where the warehouse activity is performed.';
                            Editable = false;
                            QuickEntry = false;
                        }
                        field("SEW unpacked Qty"; SEWUnpackedQty)
                        {
                            Caption = 'unpacked Qty';
                            ToolTip = 'Specifies the unpacked quantity.';
                            ApplicationArea = Warehouse;
                            Editable = false;
                            QuickEntry = false;
                        }
                        field("SEW unpacked Lines"; SEWUnpackedLines)
                        {
                            Caption = 'unpacked Lines';
                            ToolTip = 'Specifies the unpacked lines.';
                            ApplicationArea = Warehouse;
                            Editable = false;
                            QuickEntry = false;
                        }
                    }
                    group(ScanAction)
                    {
                        Caption = 'Scan Action';
                        ShowCaption = true;

                        field(TextDisplay; this.TextDisplay)
                        {
                            Caption = 'Display';
                            ToolTip = 'Specifies the display text.';
                            Editable = false;
                            Style = Unfavorable;
                            ShowCaption = false;
                            QuickEntry = false;
                        }
                        field(ScanInput; this.ScanInput)
                        {
                            Caption = 'Input';
                            ToolTip = 'Specifies the input text.';
                            Editable = true;
                            QuickEntry = true;
                            Importance = Promoted;
                            trigger OnValidate()
                            begin
                                InputScan();
                            end;
                        }
                        field(SEWCurrentParcelNo; this.CurrentParcelNo)
                        {
                            Caption = 'Current Shipment Order No.';
                            ToolTip = 'Specifies the current shipment order number.';
                            Enabled = false;
                            QuickEntry = false;
                        }
                        field(SEWCurrentParcelStatus; this.CurrentParcelStatus)
                        {
                            Caption = 'Current Shipment Order Status';
                            ToolTip = 'Specifies the current shipment order status.';
                            Enabled = false;
                            QuickEntry = false;
                        }
                        field(SEWCurrentPackageMaterial; this.CurrentPackageMaterial)
                        {
                            Caption = 'Current Package Material';
                            ToolTip = 'Specifies the current package material.';
                            Enabled = false;
                            QuickEntry = false;
                        }
                        field(CurrentItemNo; this.CurrentItemNo)
                        {
                            Caption = 'Current Item No.';
                            ToolTip = 'Specifies the current item number.';
                            Enabled = false;
                            QuickEntry = false;
                        }
                        field(TextLastScan; this.TextLastScan)
                        {
                            Caption = 'Last Scan';
                            ToolTip = 'Specifies the last scan time.';
                            Enabled = false;
                            QuickEntry = false;
                        }
                    }
                }
            }
            repeater(Group)
            {
                Caption = 'Lines';
                ShowCaption = false;

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the warehouse activity line.';
                    Visible = false;
                    StyleExpr = StyleExprTxt;
                    Editable = false;
                    QuickEntry = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the line number.';
                    Visible = false;
                    StyleExpr = StyleExprTxt;
                    Editable = false;
                    QuickEntry = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the item number.';
                    StyleExpr = StyleExprTxt;
                    Editable = false;
                    QuickEntry = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the line description.';
                    StyleExpr = StyleExprTxt;
                    Editable = false;
                    QuickEntry = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ToolTip = 'Specifies the second line description.';
                    StyleExpr = StyleExprTxt;
                    Editable = false;
                    QuickEntry = false;
                }

                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the lot number.';
                    StyleExpr = StyleExprTxt;
                    Editable = false;
                    QuickEntry = false;
                }
                field("Qty. Outstanding"; Rec."Qty. Outstanding")
                {
                    ToolTip = 'Specifies the quantity outstanding.';
                    StyleExpr = StyleExprTxt;
                    Editable = false;
                    Visible = false;
                    QuickEntry = false;
                }
                field("Qty. to Handle"; Rec."Qty. to Handle")
                {
                    ToolTip = 'Specifies the quantity to handle.';
                    StyleExpr = StyleExprTxt;
                    Editable = false;
                    Visible = false;
                    QuickEntry = false;
                }
                field("SEW Qty. to Pack"; Rec."SEW Qty. to Pack")
                {
                    StyleExpr = StyleExprTxt;
                    Editable = false;
                    QuickEntry = false;
                }
                field("SEW Qty. Packed"; Rec."SEW Qty. Packed")
                {
                    StyleExpr = StyleExprTxt;
                    Editable = false;
                    QuickEntry = false;
                }
                field("SEW Parcel No."; Rec."SEW Parcel No.")
                {
                    Editable = false;
                    QuickEntry = false;
                }
                field("SEW Parcel Status"; Rec."SEW Parcel Status")
                {
                    Editable = false;
                    QuickEntry = false;
                }
            }
            group(SEWSetFieldFocusUC)
            {
                ShowCaption = false;
                usercontrol(SEWSetFieldFocus; "SEW SetFieldFocus")
                {
                    trigger Ready()
                    begin
                        CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                    end;
                }
            }
        }

        area(FactBoxes)
        {
            part(PackageList; "SEW Packing Card FB Parcel")
            {
                SubPageLink = "Source No." = field("No.");
                ApplicationArea = all;
            }
            part(Total; "SEW Packing Card FB Details")
            {
                SubPageLink = "Activity Type" = field("Activity Type"), "No." = field("No."), "Line No." = field("Line No.");
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ItemPack)
            {
                Image = DeleteQtyToHandle;
                ApplicationArea = All;
                Caption = 'Pack Selected Item';
                ToolTip = 'Pack the selected line.';

                trigger OnAction()
                begin
                    SEWPKActionsPage.CmdLinePack(Rec);
                    CurrPage.Update(false);
                    CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                end;
            }
            action(ItemUnpack)
            {
                Image = DeleteQtyToHandle;
                ApplicationArea = All;
                Caption = 'Unpack Selected';
                ToolTip = 'Unpack the selected line.';

                trigger OnAction()
                begin
                    SEWPKActionsPage.CmdLineUnpack(Rec);
                    CurrPage.Update(false);
                    CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                end;
            }
            action(PackageNew)
            {
                Image = ItemGroup;
                ApplicationArea = All;
                Caption = 'New Package';
                ToolTip = 'Create a new package.';

                trigger OnAction()
                begin
                    SEWPKActionsPage.CmdPackageNew();
                    CurrPage.Update(false);
                    CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                end;
            }
            action(PackageDelete)
            {
                Image = "Invoicing-Delete";
                ApplicationArea = All;
                Caption = 'Delete Package';
                ToolTip = 'Delete the selected package.';

                trigger OnAction()
                begin
                    SEWPKActionsPage.CmdPackageDelete(Rec);
                    CurrPage.Update(false);
                    CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                end;
            }
            action(PackageClear)
            {
                Image = ClearLog;
                ApplicationArea = All;
                Caption = 'Clear Package';
                ToolTip = 'Clear the selected package.';

                trigger OnAction()
                begin
                    SEWPKActionsPage.CmdPackageClear(Rec);
                    CurrPage.Update(false);
                    CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                end;
            }
            action(PackagePost)
            {
                Image = DeleteQtyToHandle;
                ApplicationArea = All;
                Caption = 'Post Package';
                ToolTip = 'Post the selected package.';

                trigger OnAction()
                begin
                    SEWPKActionsPage.CmdPackagePost();
                    CurrPage.Update(false);
                    CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                end;
            }
            // action(PackageInformation)
            // {
            //     Image = DeleteQtyToHandle;
            //     ApplicationArea = All;
            //     Caption = 'Package Information';
            //     ToolTip = 'View information about the selected package.';

            //     trigger OnAction()
            //     var
            //         ShipmentParcelCard: Page "SEW Shipment Parcel Card";
            //         ShipmentParcel: Record "SEW Shipment Parcel";
            //     begin
            //         ShipmentParcel.Reset();
            //         ShipmentParcel.Get(CurrentParcelNo);
            //         ShipmentParcelCard.SetRecord(ShipmentParcel);
            //         ShipmentParcelCard.Run();
            //     end;
            // }



        }

        area(Navigation)
        {
            action(PrintLabel)
            {
                ApplicationArea = All;
                Caption = 'Print Label';
                Image = Print;
                ToolTip = 'Print Label.';

                trigger OnAction()
                begin
                    SEWPKActionsPage.CmdPackagePrintLabel();
                    CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                end;
            }
            action(PrintPackingList)
            {
                ApplicationArea = All;
                Caption = 'Print Packing List';
                Image = Print;
                ToolTip = 'Print Packing List.';

                trigger OnAction()
                begin
                    SEWPKActionsPage.CmdPackagePrintPackingList();
                    CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                end;
            }
            action(PrintDeliveryNote)
            {
                ApplicationArea = All;
                Caption = 'Print Delivery Note';
                Image = Print;
                ToolTip = 'Print Delivery Note.';

                trigger OnAction()
                begin
                    SEWPKActionsPage.CmdPackagePrintDelNote();
                    CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                end;
            }
            action(PrintInvoice)
            {
                ApplicationArea = All;
                Caption = 'Print Invoice';
                Image = Print;
                ToolTip = 'Print Invoice.';

                trigger OnAction()
                begin
                    SEWPKActionsPage.CmdDocPrintInvoice();
                    CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                end;
            }

            action(PrintCommand)
            {
                Image = Check;
                ApplicationArea = All;
                Caption = 'Print Commands';
                ToolTip = 'Print Commands.';
                trigger OnAction()
                begin
                    SEWPKActionsPage.PrintCommands();
                    CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                end;
            }
            action("Move Up")
            {
                Caption = 'Move Up';
                ApplicationArea = All;
                Image = MoveUp;
                ToolTip = 'Move current line up.';

                trigger OnAction()
                begin
                    SEWPKActionsPage.CmdLineUp(Rec);
                    CurrPage.Update(false);
                    CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                end;
            }
            action("Move Down")
            {
                Caption = 'Move Down';
                ApplicationArea = All;
                Image = MoveDown;

                ToolTip = 'Move current line down.';

                trigger OnAction()
                begin
                    SEWPKActionsPage.CmdLineDown(Rec);
                    CurrPage.Update(false);
                    CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                end;
            }
            action("Select Parcel from List")
            {
                Caption = 'Select Package from List';
                ApplicationArea = All;
                Image = PickLines;
                ToolTip = 'Select package from list.';

                trigger OnAction()
                begin
                    GetCurrentValues();
                    CurrPage.Update(false);
                    CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
                end;
            }
        }
        area(Promoted)
        {
            group(Home)
            {
                Caption = 'Home';
                actionref(PrintLabelRef; PrintLabel)
                {
                }
                actionref(PrintPackingListRef; PrintPackingList)
                {
                }
                actionref(PrintDeliveryNoteRef; PrintDeliveryNote)
                {
                }
                actionref(PrintInvoiceRef; PrintInvoice)
                {
                }

            }
            group(Packing)
            {
                Caption = 'Packing';
                actionref(ItemPackRef; ItemPack) { }
                actionref(ItemUnpackRef; ItemUnpack) { }
                actionref(PackageNewRef; PackageNew) { }
                actionref(PackageClearRef; PackageClear) { }
                actionref(PackageDeleteRef; PackageDelete) { }
                actionref(PackagePostRef; PackagePost) { }
                actionref(MoveUpRef; "Move Up") { }
                actionref(MoveDownRef; "Move Down") { }
                actionref(SelectParcelfromListRef; "Select Parcel from List") { }
            }
            group(Print)
            {
                //ShowAs = SplitButton;
                Caption = 'Print';

                actionref(MyOtherSplitButtonPromotedActionRef1; PackagePost)
                {
                }
                actionref(MyOtherSplitButtonPromotedActionRef; PrintCommand)
                {
                }
            }
        }
    }


    var
        SEWPKActionsPage: Codeunit "SEW PK Actions Page";
        SEWPKSingleInstance: Codeunit "SEW PK Single Instance";
        ScanInput: Text;
        TextDisplay: Text;
        TextLastScan: Text;

        CurrentParcelNo: Code[20];
        CurrentParcelStatus: Text[250];
        CurrentPackageMaterial: Code[10];
        CurrentItemNo: Code[20];


        SEWUnpackedQty: Integer;
        SEWUnpackedLines: Integer;
        SEWScanAction: Enum "SEW Scan Action";

        StyleExprTxt: Text;


    #region Init Page
    trigger OnOpenPage()
    begin
        GetCurrentValues();

        SEWPKActionsPage.SetDocument(Rec, false);
        if Rec.FindFirst() then; //Damit der Filter greift

        //SEWPKActionsPage.UpdateUnpackedInfo(Rec);
        CurrPage.Update(false);

        CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
    end;

    trigger OnInit()
    begin
        //GetCurrentValues();
    end;

    trigger OnClosePage()
    begin
        SEWPKSingleInstance.StopPackingStation();
    end;

    trigger OnAfterGetRecord()
    begin
        Rec."SEW Qty. to Pack" := Rec."Qty. Outstanding";
        Rec."SEW Qty. to Pack" := Rec."SEW Qty. to Pack" - Rec."SEW Qty. Packed";
        Rec.Modify(false);

        StyleExprTxt := '';
        if Rec."SEW Qty. to Pack" = 0 then
            StyleExprTxt := Format(PageStyle::Favorable)
        else
            StyleExprTxt := Format(PageStyle::Attention);
    end;

    local procedure GetCurrentValues()
    begin
        CurrentParcelNo := SEWPKSingleInstance.GetCurrentParcelNo();
        CurrentParcelStatus := SEWPKSingleInstance.GetCurrentParcelStatus();
        CurrentPackageMaterial := SEWPKSingleInstance.GetCurrentPackageMaterial();

        ScanInput := SEWPKSingleInstance.GetScanInput();

        TextDisplay := SEWPKSingleInstance.GetTextDisplay();
        TextLastScan := SEWPKSingleInstance.GetTextLastScan();
        SEWScanAction := SEWPKSingleInstance.GetScanAction();

        SEWUnpackedQty := SEWPKSingleInstance.GetCountItemsUnpacked();
        SEWUnpackedLines := SEWPKSingleInstance.GetCountLinesUnpacked();
    end;

    #endregion


    local procedure InputScan()
    begin
        if ScanInput.StartsWith('--') then begin
            case ScanInput of
                '--SDC':
                    SEWPKActionsPage.CmdDocScan();
                '--CDC':
                    SEWPKActionsPage.CmdDocClear();
                '--CLD':
                    SEWPKActionsPage.CmdDocClose();
                '--SIT':
                    SEWPKActionsPage.CmdScanItem();
                '--LUP':
                    SEWPKActionsPage.CmdLineUp(Rec);
                '--LDN':
                    SEWPKActionsPage.CmdLineDown(Rec);
                '--LPK':
                    SEWPKActionsPage.CmdLinePack(Rec);
                '--LUPK':
                    SEWPKActionsPage.CmdLineUnpack(Rec);
                '--NPK':
                    SEWPKActionsPage.CmdPackageNew();
                '--DPK':
                    SEWPKActionsPage.CmdPackageDelete(Rec);
                '--CPK':
                    SEWPKActionsPage.CmdPackageClear(Rec);
                '--PPK':
                    SEWPKActionsPage.CmdPackagePost();
                '--PLB':
                    SEWPKActionsPage.CmdPackagePrintLabel();
                '--PDN':
                    SEWPKActionsPage.CmdPackagePrintDelNote();
                '--PPL':
                    SEWPKActionsPage.CmdPackagePrintPackingList();
                '--PPP':
                    SEWPKActionsPage.CmdPackagePostAndPrint();
                '--PDC':
                    SEWPKActionsPage.CmdDocPost();
                '--PDN2':
                    SEWPKActionsPage.CmdDocPrintDelNote();
                '--PPC':
                    SEWPKActionsPage.CmdDocPostAndPrint();
                '--PIN':
                    SEWPKActionsPage.CmdDocPrintInvoice();

                '--HELP':
                    Message('Available Commands:\' +
                              '--LUP  : Line Up\' +
                              '--LDN  : Line Down\' +
                              '--CLD  : Close Document\' +
                              '--DPK  : Delete Package\' +
                              '--LUPK : Unpack Line\' +
                              '--HELP : This Help'
                      );
            end;

            SEWPKSingleInstance.SetScanInput('');
        end else
            case SEWScanAction of
                "SEW Scan Action"::"Scan Document":
                    // Handle Scan Document action
                    SEWPKActionsPage.ActionScanDocument(ScanInput, Rec);

                "SEW Scan Action"::"Scan Package Material":
                    // Handle Scan Package Material action
                    SEWPKActionsPage.ActionScanPackageMaterial(ScanInput);

                "SEW Scan Action"::"Scan Item":
                    // Handle Scan Item or Pack End action
                    SEWPKActionsPage.ActionScanItem(ScanInput, Rec);

            end;

        SEWPKActionsPage.SetDocument(Rec, false);
        if Rec.FindFirst() then; //Damit der Filter greift

        GetCurrentValues();

        CurrPage.Update(false);
        CurrPage.PackageList.Page.Update(false);

        CurrPage.SEWSetFieldFocus.SetFocusOnField('ScanInput');
    end;








}