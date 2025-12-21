page 91715 "SEW Lead Status History"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "SEW Lead Status History";
    Caption = 'Lead Status History';
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(HistoryRows)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique entry number.';
                }
                field("Lead No."; Rec."Lead No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lead number.';
                }
                field("Old Status"; Rec."Old Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the previous status.';
                }
                field("New Status"; Rec."New Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the new status.';
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reason for the status change.';
                }
                field("Changed By User Name"; Rec."Changed By User Name")
                {
                    ApplicationArea = All;
                    Caption = 'Changed By';
                    ToolTip = 'Specifies the user who changed the status.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the status change occurred.';
                }
            }
        }
    }
}
