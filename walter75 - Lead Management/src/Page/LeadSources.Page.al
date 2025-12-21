page 91713 "SEW Lead Sources"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SEW Lead Source";
    Caption = 'Lead Sources';

    layout
    {
        area(Content)
        {
            repeater(SourceRows)
            {
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    Caption = 'Source Code';
                    ToolTip = 'Specifies the unique code for the lead source.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the description of the lead source.';
                }
                field(Channel; Rec.Channel)
                {
                    ApplicationArea = All;
                    Caption = 'Channel';
                    ToolTip = 'Specifies the channel category for this source.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    Caption = 'Active';
                    ToolTip = 'Specifies whether this lead source is currently active.';
                }
            }
        }
    }
}
