table 92703 "SEW PrintNode Printer"
{
    Caption = 'PrintNode Printers';
    DataClassification = CustomerContent;

    LookupPageId = "SEW PrintNode Printer List";
    DrillDownPageId = "SEW PrintNode Printer List";

    Permissions = tabledata "SEW PrintNode Printer" = r,
                  tabledata "SEW PrintNode Paper Size" = rd;

    fields
    {
        field(1; "Printer ID"; Integer)
        {
            Caption = 'Printer ID';
            ToolTip = 'Specifies the unique identification number for the printer.';
        }
        field(2; "Printer Name"; Text[250])
        {
            Caption = 'Printer Name';
            ToolTip = 'Specifies the name of the printer.';
            Editable = false;
        }

        field(3; "Printer State"; Code[20])
        {
            Caption = 'Printer State';
            ToolTip = 'Specifies the state of the printer.';
            Editable = false;
        }
        field(4; "Printer Computer"; Text[50])
        {
            Caption = 'Printer Computer';
            ToolTip = 'Specifies the computer associated with the printer.';
        }
        field(5; "Printer Default"; Boolean)
        {
            Caption = 'Default Printer';
            ToolTip = 'Indicates whether this printer is set as the default printer.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(6; "Default Paper Tray Width"; Decimal)
        {
            Caption = 'Default Paper Tray Width';
            ToolTip = 'Specifies the width of the default paper tray in millimeters.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(7; "Default Paper Tray Height"; Decimal)
        {
            Caption = 'Default Paper Tray Height';
            ToolTip = 'Specifies the height of the default paper tray in millimeters.';
            Editable = false;
            AllowInCustomizations = Never;
        }
        field(8; "Default Paper Size Code"; Code[50])
        {
            Caption = 'Default Paper Size Code';
            ToolTip = 'Specifies the code of the default paper size.';
            TableRelation = "SEW PrintNode Paper Size"."Code" where("Printer ID" = field("Printer ID"));
            Editable = false;
            AllowInCustomizations = Never;

            trigger OnValidate()
            begin
                SetSystemPaperKind();
            end;
        }
        field(9; "System Paper Kind"; Enum "Printer Paper Kind")
        {
            Caption = 'System Paper Kind';
            ToolTip = 'Specifies the system paper kind.';
            AllowInCustomizations = Never;
        }
    }

    keys
    {
        key(Key1; "Printer ID")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Printer Name", "Printer ID") { }
        fieldgroup(Brick; "Printer State", "Printer Computer") { }
    }
    trigger OnDelete()
    var
        SEWPrintNodePaperSize: Record "SEW PrintNode Paper Size";
    begin
        SEWPrintNodePaperSize.Reset();
        SEWPrintNodePaperSize.SetRange("Printer ID", Rec."Printer ID");
        if not SEWPrintNodePaperSize.IsEmpty() then
            SEWPrintNodePaperSize.DeleteAll(false);
    end;

    trigger OnModify()
    begin
        SetSystemPaperKind();
    end;

    local procedure SetSystemPaperKind()
    var
        SEWPrintNodePaperSize: Record "SEW PrintNode Paper Size";
    begin
        if "Default Paper Size Code" <> '' then begin
            SEWPrintNodePaperSize.SetRange("Printer ID", Rec."Printer ID");
            SEWPrintNodePaperSize.SetRange("Code", "Default Paper Size Code");
            if SEWPrintNodePaperSize.FindFirst() then
                "System Paper Kind" := SEWPrintNodePaperSize."System Paper Kind"
            else
                "System Paper Kind" := "Printer Paper Kind"::Custom;

        end;
    end;

}