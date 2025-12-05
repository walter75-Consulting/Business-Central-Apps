page 95707 "SEW Carrier Field Check"
{
    Caption = 'Carrier Field Check';

    PageType = List;
    ApplicationArea = All;
    UsageCategory = None;

    SourceTable = "SEW Carrier Field Check";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Carrier Code"; Rec."Carrier Code")
                {

                }
                field("Field Name"; Rec."Field Name")
                {
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Field: Record Field;
                    begin
                        Field.Reset();
                        Field.SetRange("TableNo", Database::"SEW Parcel");
                        if Page.RunModal(Page::"SEW Carrier Field Check LP", Field) = Action::LookupOK then begin
                            Rec."Field Name" := Field.FieldName;
                            Rec."Table No." := Field.TableNo;
                            Rec."Field No." := Field."No.";
                        end;
                    end;

                }
                field(isMandatory; Rec.isMandatory)
                {
                }
                field("Minimum length"; Rec."Minimum length")
                {
                }
                field("Maximum length"; Rec."Maximum length")
                {
                }
                field("Overflow in Field Name"; Rec."Overflow in Field Name")
                {
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Field: Record Field;
                    begin
                        Field.Reset();
                        Field.SetRange("TableNo", Database::"SEW Parcel");
                        if Page.RunModal(Page::"SEW Carrier Field Check LP", Field) = Action::LookupOK then begin
                            Rec."Overflow in Field Name" := Field.FieldName;
                            Rec."Overflow in Field No." := Field."No.";
                        end;
                    end;
                }
                field("API property"; Rec."API property")
                {
                }
                field("Table No."; Rec."Table No.")
                {
                }
                field("Field No."; Rec."Field No.")
                {
                }
                field("Overflow in Field No."; Rec."Overflow in Field No.")
                {
                }
            }
        }
    }
}