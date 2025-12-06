table 90805 "SEW Calc Simulation Header"
{
    Caption = 'Calculation Simulation Header';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Calc Simulation List";
    DrillDownPageId = "SEW Calc Simulation List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the unique identifier for the simulation';
        }
        field(2; "Calc No."; Code[20])
        {
            Caption = 'Calc No.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Calc Header"."No.";
            ToolTip = 'Specifies the calculation that this simulation is based on';

            trigger OnValidate()
            var
                CalcHeader: Record "SEW Calc Header";
            begin
                if CalcHeader.Get("Calc No.") then begin
                    "Item No." := CalcHeader."Item No.";
                    "Template Code" := CalcHeader."Template Code";
                    Description := CalcHeader.Description;
                end;
            end;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item."No.";
            ToolTip = 'Specifies the item for which the simulation is run';
        }
        field(4; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            DataClassification = CustomerContent;
            TableRelation = "SEW Calc Template".Code where(Status = const(Released));
            ToolTip = 'Specifies the template used for calculations';
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies a description for the simulation';
        }
        field(11; "Simulation Date"; Date)
        {
            Caption = 'Simulation Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies when the simulation was run';
        }
        field(12; "No. of Scenarios"; Integer)
        {
            Caption = 'No. of Scenarios';
            FieldClass = FlowField;
            CalcFormula = count("SEW Calc Simulation Line" where("Simulation No." = field("No.")));
            Editable = false;
            ToolTip = 'Specifies how many scenarios are in this simulation';
        }
        field(13; "Recommended Scenario Code"; Code[20])
        {
            Caption = 'Recommended Scenario Code';
            DataClassification = CustomerContent;
            TableRelation = "SEW Calc Simulation Line"."Scenario Code" where("Simulation No." = field("No."));
            ToolTip = 'Specifies which scenario is recommended';
        }
        field(20; "Target Sales Price"; Decimal)
        {
            Caption = 'Target Sales Price';
            DataClassification = CustomerContent;
            MinValue = 0;
            ToolTip = 'Specifies the target sales price used for margin calculations';
        }
        field(21; "Target Margin %"; Decimal)
        {
            Caption = 'Target Margin %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
            ToolTip = 'Specifies the target margin percentage';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(CalcNo; "Calc No.")
        {
        }
        key(SimDate; "Simulation Date")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Simulation Date" = 0D then
            "Simulation Date" := Today();
    end;
}
