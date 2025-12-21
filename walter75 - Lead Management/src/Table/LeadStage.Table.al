table 91710 "SEW Lead Stage"
{
    Caption = 'Lead Stage';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Lead Stages";
    DrillDownPageId = "SEW Lead Stages";

    fields
    {
        field(1; "Stage Code"; Code[20])
        {
            Caption = 'Stage Code';
            ToolTip = 'Specifies the unique code for the lead stage.';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the description of the lead stage.';
            DataClassification = CustomerContent;
        }
        field(10; Sequence; Integer)
        {
            Caption = 'Sequence';
            ToolTip = 'Specifies the sort order for this stage in the pipeline.';
            DataClassification = CustomerContent;
        }
        field(20; "Is Closed"; Boolean)
        {
            Caption = 'Is Closed';
            ToolTip = 'Specifies whether this is a terminal stage.';
            DataClassification = CustomerContent;
        }
        field(21; "Is Won"; Boolean)
        {
            Caption = 'Is Won';
            ToolTip = 'Specifies whether this stage represents a successful close.';
            DataClassification = CustomerContent;
        }
        field(30; "Default Probability %"; Decimal)
        {
            Caption = 'Default Probability %';
            ToolTip = 'Specifies the default win probability when a lead enters this stage.';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 0 : 2;
        }
        field(40; "SLA (Hours)"; Integer)
        {
            Caption = 'SLA (Hours)';
            ToolTip = 'Specifies the maximum hours a lead should remain in this stage.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }

    keys
    {
        key(PK; "Stage Code")
        {
            Clustered = true;
        }
        key(SK1; Sequence)
        {
        }
    }

    trigger OnDelete()
    var
        SEWLeadRec: Record "SEW Lead";
        CannotDeleteStageErr: Label 'Cannot delete stage %1 because it is assigned to %2 lead(s).', Comment = 'DE="Die Phase %1 kann nicht gelöscht werden, da sie %2 Lead(s) zugewiesen ist."';
    begin
        SEWLeadRec.SetRange("Stage Code", Rec."Stage Code");
        if not SEWLeadRec.IsEmpty() then
            Error(CannotDeleteStageErr, Rec."Stage Code", SEWLeadRec.Count());
    end;
}
