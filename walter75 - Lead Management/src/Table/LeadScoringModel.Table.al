table 91714 "SEW Lead Scoring Model"
{
    Caption = 'Lead Scoring Model';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Lead Scoring Models";
    DrillDownPageId = "SEW Lead Scoring Models";

    fields
    {
        field(1; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            ToolTip = 'Specifies the unique code for the scoring model.';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the name of the scoring model.';
            DataClassification = CustomerContent;
        }
        field(10; Active; Boolean)
        {
            Caption = 'Active';
            ToolTip = 'Specifies whether this is the active scoring model. Only one model can be active.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                OtherModelRec: Record "SEW Lead Scoring Model";
            begin
                if Rec.Active then begin
                    OtherModelRec.SetRange(Active, true);
                    OtherModelRec.SetFilter("Model Code", '<>%1', Rec."Model Code");
                    if OtherModelRec.FindSet() then
                        repeat
                            OtherModelRec.Active := false;
                            OtherModelRec.Modify(false);
                        until OtherModelRec.Next() = 0;
                end;
            end;
        }
        field(20; "Decay Per Day"; Integer)
        {
            Caption = 'Decay Per Day';
            ToolTip = 'Specifies the points to subtract from intent score per day of inactivity.';
            DataClassification = CustomerContent;
            MinValue = 0;
            InitValue = 2;
        }
        field(30; "Band Hot Threshold"; Integer)
        {
            Caption = 'Band Hot Threshold';
            ToolTip = 'Specifies the minimum score for Hot band classification.';
            DataClassification = CustomerContent;
            MinValue = 0;
            InitValue = 80;
        }
        field(31; "Band Warm Threshold"; Integer)
        {
            Caption = 'Band Warm Threshold';
            ToolTip = 'Specifies the minimum score for Warm band classification.';
            DataClassification = CustomerContent;
            MinValue = 0;
            InitValue = 40;
        }
    }

    keys
    {
        key(PK; "Model Code")
        {
            Clustered = true;
        }
        key(SK1; Active)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Model Code", Name, Active)
        {
        }
    }

    trigger OnDelete()
    var
        SEWLeadScoringRule: Record "SEW Lead Scoring Rule";
    begin
        SEWLeadScoringRule.SetRange("Model Code", Rec."Model Code");
        SEWLeadScoringRule.DeleteAll(true);
    end;
}
