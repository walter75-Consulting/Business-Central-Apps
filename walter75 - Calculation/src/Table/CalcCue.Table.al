table 90808 "SEW Calc Cue"
{
    Caption = 'Calculation Cue';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; "Draft Count"; Integer)
        {
            Caption = 'Draft Count';
            FieldClass = FlowField;
            CalcFormula = count("SEW Calc Header" where(Status = const(Draft)));
            Editable = false;
        }
        field(11; "Released Count"; Integer)
        {
            Caption = 'Released Count';
            FieldClass = FlowField;
            CalcFormula = count("SEW Calc Header" where(Status = const(Released)));
            Editable = false;
        }
        field(12; "Archived Count"; Integer)
        {
            Caption = 'Archived Count';
            FieldClass = FlowField;
            CalcFormula = count("SEW Calc Header" where(Status = const(Archived)));
            Editable = false;
        }
        field(13; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            FieldClass = FlowField;
            CalcFormula = count("SEW Calc Header" where(Status = filter(Draft | Released),
                                                          "Margin %" = filter('< 15')));
            Editable = false;
        }
        field(20; "Average Margin %"; Decimal)
        {
            Caption = 'Average Margin %';
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
            CalcFormula = average("SEW Calc Header"."Margin %" where(Status = const(Released)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure InitializeRecord()
    begin
        if not Get() then begin
            Init();
            "Primary Key" := '';
            Insert();
        end;
    end;
}
