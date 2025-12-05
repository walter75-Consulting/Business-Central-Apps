table 90602 "SEW BDE Terminal Center"
{
    Caption = 'BDE Terminal Center';
    DataClassification = CustomerContent;
    DataCaptionFields = "Type", "No.", "Name";
    LookupPageId = "SEW BDE Terminals Center";
    DrillDownPageId = "SEW BDE Terminals Center";

    fields
    {
        field(1; Type; Enum "Capacity Type")
        {
            Caption = 'Type';
            ToolTip = 'Specifies the type of capacity (Work Center or Machine Center).';
            NotBlank = true;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the number of the work center or machine center.';
            NotBlank = true;
            TableRelation = if (Type = const("Work Center")) "Work Center"
            else
            if (Type = const("Machine Center")) "Machine Center";

            trigger OnValidate()
            var
                WorkCenter: Record "Work Center";
                MaschineCenter: Record "Machine Center";
            begin
                if Rec.Type = "Capacity Type"::"Work Center" then
                    if WorkCenter.Get("No.") then begin
                        Rec.Name := WorkCenter.Name;
                        Rec."Work Center Group Code" := WorkCenter."Work Center Group Code";
                    end;

                if Rec.Type = "Capacity Type"::"Machine Center" then
                    if MaschineCenter.Get("No.") then begin
                        Rec.Name := MaschineCenter.Name;
                        if WorkCenter.Get(MaschineCenter."Work Center No.") then
                            Rec."Work Center Group Code" := WorkCenter."Work Center Group Code";
                    end;
            end;

        }
        field(3; Name; Text[100])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the name of the work center or machine center.';
        }
        field(4; Enabled; Boolean)
        {
            Caption = 'Enabled';
            ToolTip = 'Specifies whether the terminal center is enabled.';
        }
        field(5; "Work Center Group Code"; Code[10])
        {
            Caption = 'Work Center Group Code';
            ToolTip = 'Specifies the work center group code.';
            TableRelation = "Work Center Group";
        }
        field(6; "Nbr Routings Planned"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("Prod. Order Routing Line" where("Type" = field("Type"), "No." = field("No."), "Status" = const("Production Order Status"::"Firm Planned")));
            Caption = 'Number Routing Lines Planned';
            ToolTip = 'Specifies the number of routing lines in planned status.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Nbr Routing Released"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("Prod. Order Routing Line" where("Type" = field("Type"), "No." = field("No."), "Status" = const("Production Order Status"::Released)));
            Caption = 'Number Routing Lines Released';
            ToolTip = 'Specifies the number of routing lines in released status.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Terminal Code"; Code[10])
        {
            Caption = 'Terminal Code';
            ToolTip = 'Specifies the BDE terminal code assigned to this center.';
            TableRelation = "SEW BDE Terminal";
        }
    }

    keys
    {
        key(PK; "Type", "No.")
        {
            Clustered = true;
        }
    }

}