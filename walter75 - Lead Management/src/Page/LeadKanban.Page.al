page 91780 "SEW Lead Kanban"
{
    Caption = 'Lead Kanban Board';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "SEW Lead Setup";

    layout
    {
        area(Content)
        {
            group(KanbanControl)
            {
                ShowCaption = false;

                usercontrol(KanbanBoard; "SEW Lead Kanban")
                {
                    ApplicationArea = All;

                    trigger OnControlReady()
                    begin
                        // Control add-in is loaded and ready
                        ControlReady := true;
                        LoadKanbanData();
                    end;

                    trigger OnCardMoved(leadNo: Text; newStageCode: Text)
                    begin
                        // Handle lead card moved to different stage
                        HandleCardMoved(leadNo, newStageCode);
                    end;

                    trigger OnCardClicked(leadNo: Text)
                    begin
                        // Handle lead card clicked - open Lead Card
                        OpenLeadCard(leadNo);
                    end;
                }
            }

            group(Filters)
            {
                Caption = 'Filters';

                field(ScoreBandFilter; ScoreBandFilterOption)
                {
                    Caption = 'Score Band';
                    ToolTip = 'Filter leads by score band.';
                    ApplicationArea = All;
                    OptionCaption = 'All,Hot,Warm,Cold';

                    trigger OnValidate()
                    begin
                        LoadKanbanData();
                    end;
                }

                field(SourceFilter; SourceCodeFilter)
                {
                    Caption = 'Source';
                    ToolTip = 'Filter leads by source code.';
                    ApplicationArea = All;
                    TableRelation = "SEW Lead Source"."Source Code";

                    trigger OnValidate()
                    begin
                        LoadKanbanData();
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                Caption = 'Refresh';
                ToolTip = 'Reload the Kanban board with current data.';
                ApplicationArea = All;
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    LoadKanbanData();
                end;
            }

            action(ClearFilters)
            {
                Caption = 'Clear Filters';
                ToolTip = 'Remove all filters and show all leads.';
                ApplicationArea = All;
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    ScoreBandFilterOption := 0; // All
                    SourceCodeFilter := '';
                    LoadKanbanData();
                end;
            }

            action(ManageStages)
            {
                Caption = 'Manage Stages';
                ToolTip = 'Open the Lead Stages setup page.';
                ApplicationArea = All;
                Image = SetupColumns;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "SEW Lead Stages";
            }

            action(LeadList)
            {
                Caption = 'Lead List';
                ToolTip = 'Open the standard Lead List page.';
                ApplicationArea = All;
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "SEW Lead List";
            }
        }
    }

    var
        KanbanDataBuilder: Codeunit "SEW Kanban Data Builder";
        ControlReady: Boolean;
        ScoreBandFilterOption: Option All,Hot,Warm,Cold;
        SourceCodeFilter: Code[20];
        CardMovedSuccessMsg: Label 'Lead %1 moved to status %2.', Comment = 'DE="Lead %1 wurde zum Status %2 verschoben."';
        StageNotFoundErr: Label 'Status %1 not found.', Comment = 'DE="Status %1 nicht gefunden."';
        LeadNotFoundErr: Label 'Lead %1 not found.', Comment = 'DE="Lead %1 nicht gefunden."';

    local procedure LoadKanbanData()
    var
        FilterText: Text;
        BoardDataJson: Text;
    begin
        if not ControlReady then
            exit;

        // Build filter string based on user selections
        FilterText := BuildFilterString();

        // Get JSON data from builder
        BoardDataJson := KanbanDataBuilder.BuildKanbanBoardJson(FilterText);

        // Send to control add-in
        CurrPage.KanbanBoard.RefreshBoard(BoardDataJson);
    end;

    local procedure BuildFilterString(): Text
    var
        Lead: Record "SEW Lead";
        FilterText: Text;
    begin
        // Build filter view string for Lead table

        // No owner filter (manual assignment only)

        // Score Band filter
        case ScoreBandFilterOption of
            ScoreBandFilterOption::Hot:
                Lead.SetRange("Score Band", Lead."Score Band"::Hot);
            ScoreBandFilterOption::Warm:
                Lead.SetRange("Score Band", Lead."Score Band"::Warm);
            ScoreBandFilterOption::Cold:
                Lead.SetRange("Score Band", Lead."Score Band"::Cold);
        end;

        // Source filter
        if SourceCodeFilter <> '' then
            Lead.SetRange("Source Code", SourceCodeFilter);

        // Exclude converted/disqualified leads
        Lead.SetFilter(Status, '<>%1&<>%2', Lead.Status::Converted, Lead.Status::Disqualified);

        FilterText := Lead.GetView(false);
        exit(FilterText);
    end;

    local procedure HandleCardMoved(leadNo: Text; newStageCode: Text)
    var
        Lead: Record "SEW Lead";
        LeadStatusEnum: Enum "SEW Lead Status";
        LeadNoCode: Code[20];
        NewStatusText: Text[50];
    begin
        // Convert Text parameters to Code
        LeadNoCode := CopyStr(leadNo, 1, MaxStrLen(LeadNoCode));
        NewStatusText := CopyStr(newStageCode, 1, 50);

        // Validate lead exists
        if not Lead.Get(LeadNoCode) then
            Error(LeadNotFoundErr, leadNo);

        // Convert status text to enum and validate
        if not Evaluate(LeadStatusEnum, NewStatusText) then
            Error(StageNotFoundErr, newStageCode);

        // Update lead status (triggers OnValidate)
        Lead.Validate(Status, LeadStatusEnum);
        Lead.Modify(true);

        // Show confirmation message
        Message(CardMovedSuccessMsg, leadNo, NewStatusText);

        // Reload board to reflect changes
        LoadKanbanData();
    end;

    local procedure OpenLeadCard(leadNo: Text)
    var
        Lead: Record "SEW Lead";
        LeadCard: Page "SEW Lead Card";
        LeadNoCode: Code[20];
    begin
        LeadNoCode := CopyStr(leadNo, 1, MaxStrLen(LeadNoCode));
        if not Lead.Get(LeadNoCode) then
            exit;

        LeadCard.SetRecord(Lead);
        LeadCard.RunModal();

        // Reload board after card closes (in case changes were made)
        LoadKanbanData();
    end;

    trigger OnOpenPage()
    begin
        // Ensure setup record exists
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Primary Key" := 'SETUP';
            Rec.Insert();
        end;

        ControlReady := false;
        ScoreBandFilterOption := ScoreBandFilterOption::All;
    end;
}
