table 90803 "SEW Calc Header"
{
    Caption = 'Calculation Header';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Calc Headers";
    DrillDownPageId = "SEW Calc Card";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the unique number for the calculation';
            DataClassification = CustomerContent;

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
            ToolTip = 'Specifies the number series code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            ToolTip = 'Specifies the template used for this calculation';
            DataClassification = CustomerContent;
            TableRelation = "SEW Calc Template".Code where(Status = const(Released));
        }
        field(11; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            ToolTip = 'Specifies the item number for this calculation';
            DataClassification = CustomerContent;
            TableRelation = Item."No.";

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
            ToolTip = 'Specifies the description';
            DataClassification = CustomerContent;
        }
        field(13; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            ToolTip = 'Specifies additional description';
            DataClassification = CustomerContent;
        }
        field(20; "Calculation Date"; Date)
        {
            Caption = 'Calculation Date';
            ToolTip = 'Specifies the date when the calculation was performed';
            DataClassification = CustomerContent;
        }
        field(21; Status; Enum "SEW Calc Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the status of the calculation (Draft, Released, Archived)';
            DataClassification = CustomerContent;
            InitValue = Draft;
        }
        field(30; "Lot Size"; Decimal)
        {
            Caption = 'Lot Size';
            ToolTip = 'Specifies the lot size for the calculation';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            InitValue = 1;
        }
        field(31; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            ToolTip = 'Specifies the base unit of measure';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }
        field(40; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.';
            ToolTip = 'Specifies the production BOM number';
            DataClassification = CustomerContent;
            TableRelation = "Production BOM Header"."No.";
        }
        field(41; "Production BOM Version"; Code[20])
        {
            Caption = 'Production BOM Version';
            ToolTip = 'Specifies the production BOM version';
            DataClassification = CustomerContent;
            TableRelation = "Production BOM Version"."Version Code" where("Production BOM No." = field("Production BOM No."));
        }
        field(42; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            ToolTip = 'Specifies the routing number';
            DataClassification = CustomerContent;
            TableRelation = "Routing Header"."No.";
        }
        field(43; "Routing Version"; Code[20])
        {
            Caption = 'Routing Version';
            ToolTip = 'Specifies the routing version';
            DataClassification = CustomerContent;
            TableRelation = "Routing Version"."Version Code" where("Routing No." = field("Routing No."));
        }
        field(50; "Sales Quote No."; Code[20])
        {
            Caption = 'Sales Quote No.';
            ToolTip = 'Specifies the sales quote number if linked';
            DataClassification = CustomerContent;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Quote));
        }
        field(51; "Sales Quote Line No."; Integer)
        {
            Caption = 'Sales Quote Line No.';
            ToolTip = 'Specifies the sales quote line number if linked';
            DataClassification = CustomerContent;
        }
        field(100; "Total Material Cost"; Decimal)
        {
            Caption = 'Total Material Cost';
            ToolTip = 'Specifies the total material cost';
            DataClassification = CustomerContent;
            Editable = false;
            DecimalPlaces = 2 : 5;
        }
        field(101; "Total Labor Cost"; Decimal)
        {
            Caption = 'Total Labor Cost';
            ToolTip = 'Specifies the total labor cost';
            DataClassification = CustomerContent;
            Editable = false;
            DecimalPlaces = 2 : 5;
        }
        field(102; "Total Overhead Cost"; Decimal)
        {
            Caption = 'Total Overhead Cost';
            ToolTip = 'Specifies the total overhead cost';
            DataClassification = CustomerContent;
            Editable = false;
            DecimalPlaces = 2 : 5;
        }
        field(103; "Total Cost"; Decimal)
        {
            Caption = 'Total Cost';
            ToolTip = 'Specifies the total cost';
            DataClassification = CustomerContent;
            Editable = false;
            DecimalPlaces = 2 : 5;
        }
        field(110; "Target Sales Price"; Decimal)
        {
            Caption = 'Target Sales Price';
            ToolTip = 'Specifies the target sales price';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
        }
        field(111; "Margin %"; Decimal)
        {
            Caption = 'Margin %';
            ToolTip = 'Specifies the margin percentage';
            DataClassification = CustomerContent;
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
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if Rec."No." = '' then begin
            SalesSetup.Get();
            SalesSetup.TestField("SEW Calc Nos.");
            Rec."No." := NoSeriesMgt.GetNextNo(SalesSetup."SEW Calc Nos.", WorkDate(), true);
            Rec."No. Series" := SalesSetup."SEW Calc Nos.";
        end;

        if Rec."Calculation Date" = 0D then
            Rec."Calculation Date" := WorkDate();
    end;

    procedure AssistEdit(OldCalcHeader: Record "SEW Calc Header"): Boolean
    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        SalesSetup.Get();
        SalesSetup.TestField("SEW Calc Nos.");
        if NoSeriesMgt.SelectSeries(SalesSetup."SEW Calc Nos.", OldCalcHeader."No. Series", Rec."No. Series") then begin
            Rec."No." := NoSeriesMgt.GetNextNo(Rec."No. Series", WorkDate(), true);
            exit(true);
        end;
    end;
}
