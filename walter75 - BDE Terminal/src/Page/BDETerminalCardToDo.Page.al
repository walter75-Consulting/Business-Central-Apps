page 90604 "SEW BDE Terminal Card ToDo"
{
    Caption = 'ToDo';
    //AutoSplitKey = true;
    //DelayedInsert = false;
    LinksAllowed = false;
    //MultipleNewLines = false;
    PageType = ListPart;
    SourceTable = "Prod. Order Routing Line";
    //Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    //RefreshOnActivate = true;



    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Upcoming Tasks';
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the setup time of the operation.';
                }

                field("Operation No."; Rec."Operation No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("Work Center No."; Rec."Work Center No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("Starting Time"; Rec."Starting Time")
                {
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("Ending Time"; Rec."Ending Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("SEW BDE Rout. Line Plan Status"; Rec."SEW BDE Rout. Line Plan Status")
                {
                    ApplicationArea = All;
                }
                field("SEW BDE Rout. Line Status"; Rec."SEW BDE Rout. Line Status")
                {
                    ApplicationArea = All;
                }
            }
            grid("TerminalInfo")
            {
                usercontrol(ALButtonGroup1; "SEW ButtonGroup")
                {
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnLoad()
                    begin
                        CurrPage.ALButtonGroup1.AddButton(btnTaskUpcomingLbl, btnTaskUpcomingToolTipLbl, 'TaskNew', 'primary');
                        if VisibleCallOperator then
                            CurrPage.ALButtonGroup1.AddButton(btnCallOperatorLbl, btnCallOperatorToolTipLbl, 'btnCallOperator', 'danger');
                    end;

                    trigger OnClick(id: Text)
                    begin
                        ExecuteAction(id);
                    end;
                }

                usercontrol(ALButtonGroup; "SEW ButtonGroup")
                {
                    Visible = true;
                    ApplicationArea = All;

                    trigger OnLoad()
                    begin
                        ArrangeButton(Rec."SEW BDE Rout. Line Status");
                    end;

                    trigger OnClick(id: Text)
                    begin
                        ExecuteAction(id);
                    end;
                }
            }
        }

    }


    trigger OnOpenPage()
    begin
        Rec.Reset();
        Rec.SetRange("SEW BDE Terminal Code", CurrentTerminal);
        Rec.SetRange("SEW BDE Rout. Line Status", "SEW BDE Rout. Line Status"::"not Started");
        Rec.SetFilter("Starting Date", '<=%1', CalcDate(DayinAdvanced, WorkDate()));
        CurrPage.Update();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ArrangeButton(Rec."SEW BDE Rout. Line Status");
        //ProdOrderRoutingLine := Rec;
    end;

    trigger OnAfterGetRecord()
    begin
        StyleText := 'None';
        if Rec."Starting Date-Time" < CurrentDateTime() then
            StyleText := 'Attention';
    end;

    local procedure ArrangeButton(xxx: Enum "SEW BDE Rout. Line Status")
    begin
        CurrPage.ALButtonGroup.RemoveButton('btnStartSetup'); // Start Rüsten
        CurrPage.ALButtonGroup.RemoveButton('btnStopSetup'); // Stop Rüsten
        CurrPage.ALButtonGroup.RemoveButton('btnStartProduction'); // Start Produktion
        CurrPage.ALButtonGroup.RemoveButton('btnStopProduction'); // Stop Produktion
        CurrPage.ALButtonGroup.RemoveButton('btnStartPause'); // Start Pause
        CurrPage.ALButtonGroup.RemoveButton('btnStopPause'); // Stop Pause
        CurrPage.ALButtonGroup.RemoveButton('btnStartMalfunction'); // Start Fehler
        CurrPage.ALButtonGroup.RemoveButton('btnStopMalfunction'); // Stop Fehler
        CurrPage.ALButtonGroup.RemoveButton('btnFinish'); // fertig melden


        case xxx of
            "SEW BDE Rout. Line Status"::"not Started":
                begin
                    CurrPage.ALButtonGroup.AddButton(btnStartSetupLbl, btnStartSetupToolTipLbl, 'btnStartSetup', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnStartProductionLbl, btnStartProductionToolTipLbl, 'btnStartProduction', 'primary');
                    if VisibleMalfunction then
                        CurrPage.ALButtonGroup.AddButton(btnStartMalfunctionLbl, btnStartMalfunctionToolTipLbl, 'btnStartMalfunction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnTaskFinishLbl, btnTaskFinishToolTipLbl, 'btnFinish', 'finish');
                end;

            "SEW BDE Rout. Line Status"::"Start Setup":
                begin
                    CurrPage.ALButtonGroup.AddButton(btnStopSetupLbl, btnStopSetupToolTipLbl, 'btnStopSetup', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnStartProductionLbl, btnStartProductionToolTipLbl, 'btnStartProduction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnStartPauseLbl, btnStartPauseToolTipLbl, 'btnStartPause', 'primary');
                    if VisibleMalfunction then
                        CurrPage.ALButtonGroup.AddButton(btnStartMalfunctionLbl, btnStartMalfunctionToolTipLbl, 'btnStartMalfunction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnTaskFinishLbl, btnTaskFinishToolTipLbl, 'btnFinish', 'finish');
                end;

            "SEW BDE Rout. Line Status"::"Stop Setup":
                begin
                    CurrPage.ALButtonGroup.AddButton(btnStartSetupLbl, btnStartSetupToolTipLbl, 'btnStartSetup', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnStartProductionLbl, btnStartProductionToolTipLbl, 'btnStartProduction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnStartPauseLbl, btnStartPauseToolTipLbl, 'btnStartPause', 'primary');
                    if VisibleMalfunction then
                        CurrPage.ALButtonGroup.AddButton(btnStartMalfunctionLbl, btnStartMalfunctionToolTipLbl, 'btnStartMalfunction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnTaskFinishLbl, btnTaskFinishToolTipLbl, 'btnFinish', 'finish');
                end;

            "SEW BDE Rout. Line Status"::"Start Production":
                begin
                    CurrPage.ALButtonGroup.AddButton(btnStopProductionLbl, btnStopProductionToolTipLbl, 'btnStopProduction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnStartPauseLbl, btnStartPauseToolTipLbl, 'btnStartPause', 'primary');
                    if VisibleMalfunction then
                        CurrPage.ALButtonGroup.AddButton(btnStartMalfunctionLbl, btnStartMalfunctionToolTipLbl, 'btnStartMalfunction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnTaskFinishLbl, btnTaskFinishToolTipLbl, 'btnFinish', 'finish');
                end;

            "SEW BDE Rout. Line Status"::"Stop Production":
                begin
                    CurrPage.ALButtonGroup.AddButton(btnStartProductionLbl, btnStartProductionToolTipLbl, 'btnStartProduction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnStartPauseLbl, btnStartPauseToolTipLbl, 'btnStartPause', 'primary');
                    if VisibleMalfunction then
                        CurrPage.ALButtonGroup.AddButton(btnStartMalfunctionLbl, btnStartMalfunctionToolTipLbl, 'btnStartMalfunction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnTaskFinishLbl, btnTaskFinishToolTipLbl, 'btnFinish', 'finish');
                end;

            "SEW BDE Rout. Line Status"::"Start Pause":
                begin
                    CurrPage.ALButtonGroup.AddButton(btnStopPauseLbl, btnStopPauseToolTipLbl, 'btnStopPause', 'primary');
                    if VisibleMalfunction then
                        CurrPage.ALButtonGroup.AddButton(btnStartMalfunctionLbl, btnStartMalfunctionToolTipLbl, 'btnStartMalfunction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnTaskFinishLbl, btnTaskFinishToolTipLbl, 'btnFinish', 'finish');
                end;

            "SEW BDE Rout. Line Status"::"Stop Pause":
                begin
                    CurrPage.ALButtonGroup.AddButton(btnStartProductionLbl, btnStartProductionToolTipLbl, 'btnStartProduction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnStartPauseLbl, btnStartPauseToolTipLbl, 'btnStartPause', 'primary');
                    if VisibleMalfunction then
                        CurrPage.ALButtonGroup.AddButton(btnStartMalfunctionLbl, btnStartMalfunctionToolTipLbl, 'btnStartMalfunction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnTaskFinishLbl, btnTaskFinishToolTipLbl, 'btnFinish', 'finish');
                end;

            "SEW BDE Rout. Line Status"::"Start Malfunction":
                begin
                    CurrPage.ALButtonGroup.AddButton(btnStopMalfunctionLbl, btnStopMalfunctionToolTipLbl, 'btnStopMalfunction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnTaskFinishLbl, btnTaskFinishToolTipLbl, 'btnFinish', 'finish');
                end;

            "SEW BDE Rout. Line Status"::"Stop Malfunction":
                begin
                    CurrPage.ALButtonGroup.AddButton(btnStartProductionLbl, btnStartProductionToolTipLbl, 'btnStartProduction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnStartPauseLbl, btnStartPauseToolTipLbl, 'btnStartPause', 'primary');
                    if VisibleMalfunction then
                        CurrPage.ALButtonGroup.AddButton(btnStartMalfunctionLbl, btnStartMalfunctionToolTipLbl, 'btnStartMalfunction', 'primary');
                    CurrPage.ALButtonGroup.AddButton(btnTaskFinishLbl, btnTaskFinishToolTipLbl, 'btnFinish', 'finish');
                end;

            else begin
                CurrPage.ALButtonGroup.RemoveButton('btnStartSetup'); // Start Rüsten
                CurrPage.ALButtonGroup.RemoveButton('btnStopSetup'); // Stop Rüsten
                CurrPage.ALButtonGroup.RemoveButton('btnStartProduction'); // Start Produktion
                CurrPage.ALButtonGroup.RemoveButton('btnStopProduction'); // Stop Produktion
                CurrPage.ALButtonGroup.RemoveButton('btnStartPause'); // Start Pause
                CurrPage.ALButtonGroup.RemoveButton('btnStopPause'); // Stop Pause
                CurrPage.ALButtonGroup.RemoveButton('btnStartMalfunction'); // Start Fehler
                CurrPage.ALButtonGroup.RemoveButton('btnStopMalfunction'); // Stop Fehler
                CurrPage.ALButtonGroup.RemoveButton('btnFinish'); // fertig melden
            end;
        end;

    end;


    local procedure ExecuteAction(id: Text)
    var
    //SEWBDEBooking: Record "SEW BDE Booking";
    begin
        case id of
            'TaskNew':
                begin
                    //Message('%1 button was clicked.', id);
                    CurrPage.ALButtonGroup1.RemoveButton('TaskNew');
                    CurrPage.ALButtonGroup1.AddButton(btnTaksProgressLbl, btnTaksProgressToolTipLbl, 'TaskProgress', 'primary');
                    Rec.Reset();
                    Rec.SetRange("SEW BDE Terminal Code", CurrentTerminal);
                    Rec.SetRange("SEW BDE Rout. Line Status", "SEW BDE Rout. Line Status"::"not Started");
                    Rec.SetFilter("Starting Date", '<=%1', CalcDate(DayinAdvanced, WorkDate()));
                    CurrPage.Update();
                end;


            'TaskProgress':
                begin
                    //Message('%1 button was clicked.', id);
                    CurrPage.ALButtonGroup1.RemoveButton('TaskProgress');
                    CurrPage.ALButtonGroup1.AddButton(btnTaskUpcomingLbl, btnTaskUpcomingToolTipLbl, 'TaskNew', 'primary');
                    Rec.Reset();
                    Rec.SetRange("SEW BDE Terminal Code", CurrentTerminal);
                    Rec.SetFilter("SEW BDE Rout. Line Status", '<>%1|%2', "SEW BDE Rout. Line Status"::"not Started", "SEW BDE Rout. Line Status"::Done);
                    CurrPage.Update();
                end;


            'btnStartSetup':
                ActionStart("SEW BDE Rout. Line Status"::"Start Setup");

            'btnStopSetup':
                ActionStop("SEW BDE Rout. Line Status"::"Stop Setup", false);

            'btnStartProduction':
                ActionStart("SEW BDE Rout. Line Status"::"Start Production");

            'btnStopProduction':
                ActionStop("SEW BDE Rout. Line Status"::"Stop Production", false);

            'btnStartPause':
                ActionStart("SEW BDE Rout. Line Status"::"Start Pause");

            'btnStopPause':
                ActionStop("SEW BDE Rout. Line Status"::"Stop Pause", false);

            'btnStartMalfunction':
                ActionStart("SEW BDE Rout. Line Status"::"Start Malfunction");

            'btnStopMalfunction':
                ActionStop("SEW BDE Rout. Line Status"::"Stop Malfunction", false);

            'btnFinish':
                ActionStop("SEW BDE Rout. Line Status"::Done, true);

        end;

    end;

    local procedure ActionStart(LineStatus: Enum "SEW BDE Rout. Line Status")
    var
        SEWBDEBookingDialog: Page "SEW BDE Booking Dialog";
    begin

        if VisibleFixedUser = true then
            SEWBDEBookingDialog.SetUser(xCurrentUser)
        else
            SEWBDEBookingDialog.SetUser('');

        SEWBDEBookingDialog.SetTerminalCode(CurrentTerminal);
        SEWBDEBookingDialog.SetShowQty(false);

        if SEWBDEBookingDialog.RunModal() = Action::OK then
            SEWBDEBookingDialog.ActionStart(LineStatus, Rec);

        CurrPage.Update();
    end;

    local procedure ActionStop(LineStatus: Enum "SEW BDE Rout. Line Status"; xFinish: Boolean)
    var
        SEWBDEBookingDialog: Page "SEW BDE Booking Dialog";
    begin
        if xFinish = true then
            if not Confirm(xFinishLbl, true) then
                exit;

        if VisibleFixedUser = true then
            SEWBDEBookingDialog.SetUser(xCurrentUser)
        else
            SEWBDEBookingDialog.SetUser('');

        SEWBDEBookingDialog.SetFinish(xFinish);

        SEWBDEBookingDialog.SetShowQty(true);

        if SEWBDEBookingDialog.RunModal() = Action::OK then
            SEWBDEBookingDialog.ActionStop(LineStatus, Rec);

        CurrPage.Update();
    end;


    procedure SetCurrentUser(xUser: Code[20])
    begin
        xCurrentUser := xUser;
    end;

    procedure SetVisibleFixedUser(xVisibleFixedUser: Boolean)
    begin
        VisibleFixedUser := xVisibleFixedUser;
    end;

    procedure SetVisibleMalfunction(xVisibleMalfunction: Boolean)
    begin
        VisibleMalfunction := xVisibleMalfunction;
    end;

    procedure SetVisibleCallOperator(xVisibleCallOperator: Boolean)
    begin
        VisibleCallOperator := xVisibleCallOperator;
    end;

    procedure SetDayinAdvanced(xDayinAdvanced: DateFormula)
    begin
        DayinAdvanced := xDayinAdvanced;
    end;

    procedure SetCurrentTerminal(xCurrentTerminal: Code[10])
    begin
        CurrentTerminal := xCurrentTerminal;
    end;



    var
        //ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        DayinAdvanced: DateFormula;
        VisibleFixedUser: Boolean;
        VisibleMalfunction: Boolean;
        VisibleCallOperator: Boolean;
        xCurrentUser: Code[20];
        CurrentTerminal: Code[10];
        StyleText: Text;
        xFinishLbl: Label 'Really want to finish this Task?';
        btnTaskUpcomingLbl: Label 'upcoming Tasks';
        btnTaskUpcomingToolTipLbl: Label 'Show upcoming Tasks for this Terminal';
        btnTaksProgressLbl: Label 'Tasks in Progress';
        btnTaksProgressToolTipLbl: Label 'Show Tasks in Progress for this Terminal';
        btnStartSetupLbl: Label 'Start Setup';
        btnStartSetupToolTipLbl: Label 'Start Setup for this Task';
        btnStopSetupLbl: Label 'Stop Setup';
        btnStopSetupToolTipLbl: Label 'Stop Setup for this Task';
        btnStartProductionLbl: Label 'Start Production';
        btnStartProductionToolTipLbl: Label 'Start Production for this Task';
        btnStopProductionLbl: Label 'Stop Production';
        btnStopProductionToolTipLbl: Label 'Stop Production for this Task';
        btnStartMalfunctionLbl: Label 'Start Malfunction';
        btnStartMalfunctionToolTipLbl: Label 'Start Malfunction for this Task';
        btnStopMalfunctionLbl: Label 'Stop Malfunction';
        btnStopMalfunctionToolTipLbl: Label 'Stop Malfunction for this Task';
        btnStartPauseLbl: Label 'Start Pause';
        btnStartPauseToolTipLbl: Label 'Start Pause for this Task';
        btnStopPauseLbl: Label 'Stop Pause';
        btnStopPauseToolTipLbl: Label 'Stop Pause for this Task';
        btnTaskFinishLbl: Label 'finish Task';
        btnTaskFinishToolTipLbl: Label 'finish Task for this Task';
        btnCallOperatorLbl: Label 'Call Operator';
        btnCallOperatorToolTipLbl: Label 'Call Operator';

}