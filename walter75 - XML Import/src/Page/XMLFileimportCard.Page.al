page 60500 "SEW XML Fileimport Card"
{
    Caption = 'XML Fileimport Card';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "SEW XML Fileimport";
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                group(GeneralInfo)
                {
                    Caption = 'General Info';
                    field(transferID; Rec.transferID)
                    {
                        Editable = false;
                    }
                    field("Doc Type"; Rec."Doc Type") { }
                    field("Doc Status"; Rec."Doc Status") { }
                    field("Doc No."; Rec."Doc No.")
                    {
                        Editable = false;
                    }
                    field("Count of Lines"; Rec."Count of Lines") { }
                    field("Doc Count of Lines"; Rec."Doc Count of Lines") { }
                }
                group(DocumentInfoPurchase)
                {
                    Caption = 'Document Info Purchase Order';
                    field("Purch. Order No."; Rec."Purch. Order No.") { }
                    field("Purch. Order Date"; Rec."Purch. Order Date") { }

                }
                group(DocumentInfoExtSales)
                {
                    Caption = 'Document Info Ext. Sales Order';
                    field("Ext. Sales Order No."; Rec."Ext. Sales Order No.") { }
                    field("Ext. Sales Order Date"; Rec."Ext. Sales Order Date") { }

                }
                group(DocumentInfoExtShipment)
                {
                    Caption = 'Document Info Ext. Shipment';
                    field("Ext. Shipment No."; Rec."Ext. Shipment No.") { }
                    field("Ext. Shipment Date"; Rec."Ext. Shipment Date") { }

                }
                group(DocumentInfoExtInvoice)
                {
                    Caption = 'Document Info Ext. Invoice';
                    field("Ext. Invoice No."; Rec."Ext. Invoice No.") { }
                    field("Ext. Invoice Date"; Rec."Ext. Invoice Date") { }
                    field("Faktura Type"; Rec."Faktura Type") { }
                    field("Faktura Type2"; Rec."Faktura Type2") { }
                }
                group(Partners)
                {
                    Caption = 'Partners';
                    field("Partner AG"; Rec."Partner AG") { }
                    field("Partner WE"; Rec."Partner WE") { }
                    field("Partner ZK"; Rec."Partner ZK") { }
                    field("Partner OSP"; Rec."Partner OSP") { }
                    field("Partner OSO"; Rec."Partner OSO") { }
                    field("Partner BK"; Rec."Partner BK") { }
                    field("Partner RG"; Rec."Partner RG") { }
                    field("Partner RE"; Rec."Partner RE") { }
                    field("Partner RS"; Rec."Partner RS") { }
                }
                group(Amounts)
                {
                    Caption = 'Amounts';
                    field("Cost Amount"; Rec."Cost Amount") { }
                    field("Line Amount"; Rec."Line Amount") { }
                    field("Calculated Doc Amount"; CalculatedDocuAmount)
                    {
                        Caption = 'Total Amount';
                        ToolTip = 'Specifies the total amount including line amounts and cost amounts.';
                        AutoFormatType = 1;
                        Editable = false;
                    }
                    field("Doc Amount net"; Rec."Doc Amount net")
                    {
                        StyleExpr = StyleExprTxt;
                    }

                    field("Doc Currency"; Rec."Doc Currency") { }
                }
                group(StatusInfo)
                {
                    Caption = 'Status Info';
                    field("Transfer Date/Time"; Rec."Transfer Date/Time") { }
                    field("Doc Creation Date"; Rec."Doc Creation Date") { }
                    field("Doc Creation Time"; Rec."Doc Creation Time") { }
                    field("Doc Processed Date/Time"; Rec."Doc Processed Date/Time") { }
                    field("Doc Imported"; Rec."Doc Imported") { }
                }
            }

            group(FileContent)
            {
                Caption = 'File Content';
                field(FileContentBlob; FileContentBlob)
                {
                    Caption = 'File Content';
                    ToolTip = 'Specifies the content of the file associated with the transfer.';
                    Editable = false;
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        Rec.SaveFileContent(FileContentBlob);
                    end;
                }
            }
            group(TransferLines)
            {
                Caption = 'Lines';
                part(Lines; "SEW XML Fileimport Card Sub")
                {

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // action(ActionName)
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin

            //     end;
            // }
        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        FileContentBlob := Rec.GetFileContent();

        CalculatedDocuAmount := 0;
        StyleExprTxt := '';
        // Just to make sure that the FlowField is calculated
        if Rec."Doc Type" = Rec."Doc Type"::Invoice then begin
            Rec.SetAutoCalcFields("Cost Amount", "Line Amount");
            CalculatedDocuAmount := Rec."Cost Amount" + Rec."Line Amount";

            StyleExprTxt := '';
            if Round(Rec."Doc Amount net", 0.01) <> Round(CalculatedDocuAmount, 0.01) then
                StyleExprTxt := Format(PageStyle::Attention)
            else
                StyleExprTxt := Format(PageStyle::Strong);
        end else
            StyleExprTxt := Format(PageStyle::None);
    end;

    var
        FileContentBlob: Text;
        CalculatedDocuAmount: Decimal;
        StyleExprTxt: Text;




}