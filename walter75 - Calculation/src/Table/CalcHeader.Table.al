table 90803 "SEW Calc Header"
{
    Caption = 'Calculation Header';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Calc Headers";
    DrillDownPageId = "SEW Calc Card";
    Permissions = tabledata "Sales & Receivables Setup" = r,
                  tabledata Item = r;

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = true;
            Caption = 'No.';
            ToolTip = 'Specifies the unique number for the calculation.';

            trigger OnValidate()
            var
                SalesSetup: Record "Sales & Receivables Setup";
                NoSeriesMgt: Codeunit "No. Series";
            begin
                if Rec."No." <> xRec."No." then begin
                    SalesSetup.Get();
                    NoSeriesMgt.TestManual(SalesSetup."SEW Calc Nos.");
                    Rec."No. Series" := '';
                end;
            end;
        }
        field(2; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            ToolTip = 'Specifies the number series code.';
            Editable = false;
            AllowInCustomizations = AsReadOnly;
        }
        field(10; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            ToolTip = 'Specifies the template used for this calculation.';
            TableRelation = "SEW Calc Template".Code where(Status = const(Released));
            ValidateTableRelation = true;
            AllowInCustomizations = AsReadOnly;
        }
        field(11; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            ToolTip = 'Specifies the item number for this calculation.';
            TableRelation = Item."No.";
            ValidateTableRelation = true;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if Rec."Item No." <> '' then begin
                    Item.Get(Rec."Item No.");
                    Rec.Description := Item.Description;
                    Rec."Description 2" := Item."Description 2";
                    Rec."Base Unit of Measure" := Item."Base Unit of Measure";
                    Rec."Production BOM No." := Item."Production BOM No.";
                    Rec."Routing No." := Item."Routing No.";
                end;
            end;
        }
        field(12; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description.';
        }
        field(13; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            ToolTip = 'Specifies additional description.';
        }
        field(20; "Calculation Date"; Date)
        {
            Caption = 'Calculation Date';
            ToolTip = 'Specifies the date when the calculation was performed.';
        }
        field(21; Status; Enum "SEW Calc Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the status of the calculation (Draft, Released, Archived).';
            InitValue = Draft;
        }
        field(30; "Lot Size"; Decimal)
        {
            Caption = 'Lot Size';
            ToolTip = 'Specifies the lot size for the calculation.';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            InitValue = 1;
        }
        field(31; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            ToolTip = 'Specifies the base unit of measure.';
            TableRelation = "Unit of Measure";
            ValidateTableRelation = true;
        }
        field(40; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.';
            ToolTip = 'Specifies the production BOM number.';
            TableRelation = "Production BOM Header"."No.";
            ValidateTableRelation = true;
        }
        field(41; "Production BOM Version"; Code[20])
        {
            Caption = 'Production BOM Version';
            ToolTip = 'Specifies the production BOM version.';
            TableRelation = "Production BOM Version"."Version Code" where("Production BOM No." = field("Production BOM No."));
            ValidateTableRelation = true;
            AllowInCustomizations = AsReadOnly;
        }
        field(42; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            ToolTip = 'Specifies the routing number.';
            TableRelation = "Routing Header"."No.";
            ValidateTableRelation = true;
        }
        field(43; "Routing Version"; Code[20])
        {
            Caption = 'Routing Version';
            ToolTip = 'Specifies the routing version.';
            TableRelation = "Routing Version"."Version Code" where("Routing No." = field("Routing No."));
            ValidateTableRelation = true;
            AllowInCustomizations = AsReadOnly;
        }
        field(50; "Sales Quote No."; Code[20])
        {
            Caption = 'Sales Quote No.';
            ToolTip = 'Specifies the sales quote number if linked.';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Quote));
            ValidateTableRelation = true;
            AllowInCustomizations = AsReadOnly;
        }
        field(51; "Sales Quote Line No."; Integer)
        {
            Caption = 'Sales Quote Line No.';
            ToolTip = 'Specifies the sales quote line number if linked.';
            AllowInCustomizations = AsReadOnly;
        }
        field(100; "Total Material Cost"; Decimal)
        {
            Caption = 'Total Material Cost';
            ToolTip = 'Specifies the total material cost.';
            Editable = false;
            DecimalPlaces = 2 : 5;
        }
        field(101; "Total Labor Cost"; Decimal)
        {
            Caption = 'Total Labor Cost';
            ToolTip = 'Specifies the total labor cost.';
            Editable = false;
            DecimalPlaces = 2 : 5;
        }
        field(102; "Total Overhead Cost"; Decimal)
        {
            Caption = 'Total Overhead Cost';
            ToolTip = 'Specifies the total overhead cost.';
            Editable = false;
            DecimalPlaces = 2 : 5;
        }
        field(103; "Total Cost"; Decimal)
        {
            Caption = 'Total Cost';
            ToolTip = 'Specifies the total cost.';
            Editable = false;
            DecimalPlaces = 2 : 5;
        }
        field(110; "Target Sales Price"; Decimal)
        {
            Caption = 'Target Sales Price';
            ToolTip = 'Specifies the target sales price.';
            DecimalPlaces = 2 : 5;
        }
        field(111; "Margin %"; Decimal)
        {
            Caption = 'Margin %';
            ToolTip = 'Specifies the margin percentage.';
            Editable = false;
            DecimalPlaces = 0 : 2;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(ItemNo; "Item No.", "Calculation Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Item No.", Description, Status)
        {
        }
        fieldgroup(Brick; "No.", "Item No.", Description, "Total Cost", Status)
        {
        }
    }

    trigger OnInsert()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesCU: Codeunit "No. Series";
    begin
        if Rec."No." = '' then begin
            SalesReceivablesSetup.Get();
            SalesReceivablesSetup.TestField("SEW Calc Nos.");
            Rec."No." := NoSeriesCU.GetNextNo(SalesReceivablesSetup."SEW Calc Nos.", WorkDate(), true);
            Rec."No. Series" := SalesReceivablesSetup."SEW Calc Nos.";
        end;

        if Rec."Calculation Date" = 0D then
            Rec."Calculation Date" := WorkDate();
    end;

    procedure AssistEdit(OldSEWCalcHeader: Record "SEW Calc Header"): Boolean
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        SalesReceivablesSetup.TestField("SEW Calc Nos.");

        if Rec."No." <> '' then
            exit(false);

        Rec."No. Series" := SalesReceivablesSetup."SEW Calc Nos.";
        exit(true);
    end;
}
