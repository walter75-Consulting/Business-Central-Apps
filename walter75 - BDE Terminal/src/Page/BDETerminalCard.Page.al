page 90602 "SEW BDE Terminal Card"
{
    Caption = 'BDE Terminal Card';
    PageType = ListPlus;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SEW BDE Terminal";
    //RefreshOnActivate = true;
    //Editable = false;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                ShowCaption = false;
                grid("TerminalInfo")
                {
                    group(GeneralInfo)
                    {
                        Caption = 'Terminal Info';

                        field("Terminal Name"; Rec."Terminal Name")
                        {
                            
                            Editable = false;
                        }
                    }
                    group(TerminalStatus)
                    {
                        Caption = 'Terminal Status';
                        Visible = VisibleMalfunction;
                        field("Terminal Status"; Rec."Terminal Status")
                        {
                            
                            Editable = false;
                        }
                        usercontrol(ALButtonTerminalStatus; "SEW ButtonGroup")
                        {
                            Visible = true;
                            

                            trigger OnLoad()
                            begin
                                CurrPage.ALButtonTerminalStatus.AddButton(btnStartMalfunctionLbl, btnStartMalfunctionToolTipLbl, 'btnMalfunction', 'danger');
                                if VisibleCallOperator then
                                    CurrPage.ALButtonTerminalStatus.AddButton(btnStartOperatorLbl, btnStartOperatorToolTipLbl, 'btnCallOperator', 'danger');
                            end;

                            trigger OnClick(id: Text)
                            var
                            begin
                                ButtonAction(id);
                            end;
                        }
                    }
                    group(TerminalUser)
                    {
                        Caption = 'Terminal User';
                        Visible = VisibleFixedUser;
                        field("Current User"; Rec."Current User")
                        {
                            
                            Editable = false;
                        }
                        usercontrol(ALButtonTerminalUser; "SEW ButtonGroup")
                        {
                            Visible = true;
                            

                            trigger OnLoad()
                            begin
                                CurrPage.ALButtonTerminalUser.AddButton(btnChangeUserLbl, btnChangeUserToolTipLbl, 'btnChangeUser', '');
                            end;

                            trigger OnClick(id: Text)
                            var
                            begin
                                ButtonAction(id);
                            end;
                        }
                    }
                }
            }
            group(PackAction)
            {
                ShowCaption = false;
                part(SEWBDETerminalCardToDo; "SEW BDE Terminal Card ToDo")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Tasks';
                    SubPageLink = "SEW BDE Terminal Code" = field("Code");
                    SubPageView = sorting("Starting Date", "Starting Time", "Routing Status");
                    Editable = false;
                }
            }
            group(PackAction3)
            {
                ShowCaption = false;
                part(SEWBDETerminalCardBook; "SEW BDE Terminal Card Book")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bookings';
                    Provider = SEWBDETerminalCardToDo;
                    SubPageLink = "Prod. Order No." = field("Prod. Order No."), "Operation No." = field("Operation No.");
                }
            }

        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        VisibleFixedUser := Rec."Allow Fixed User";
        CurrPage.SEWBDETerminalCardToDo.Page.SetVisibleFixedUser(VisibleFixedUser);
        CurrPage.SEWBDETerminalCardToDo.Page.SetCurrentUser(Rec."Current User");

        VisibleMalfunction := Rec."Allow Malfunction";
        CurrPage.SEWBDETerminalCardToDo.Page.SetVisibleMalfunction(VisibleMalfunction);

        VisibleCallOperator := Rec."Allow Call Operator";
        CurrPage.SEWBDETerminalCardToDo.Page.SetVisibleCallOperator(VisibleCallOperator);

        CurrPage.SEWBDETerminalCardToDo.Page.SetDayinAdvanced(Rec."Days in Advanced");

        CurrPage.SEWBDETerminalCardToDo.Page.SetCurrentTerminal(Rec.Code);

        CurrPage.Update(false);
    end;


    local procedure ButtonAction(id: Text)
    var
        Resource: Record Resource;
    begin
        case id of
            'btnChangeUser':
                begin
                    Resource.Reset();
                    if Page.RunModal(Page::"Resource List", Resource) = Action::LookupOK then
                        Rec."Current User" := Resource."No.";

                    CurrPage.SEWBDETerminalCardToDo.Page.SetCurrentUser(Rec."Current User");
                    CurrPage.Update();
                end;

            'btnMalfunction':
                begin
                    Rec."Terminal Status" := "SEW BDE Terminal Status"::Malfunction;
                    CurrPage.ALButtonTerminalStatus.RemoveButton('btnMalfunction');
                    CurrPage.ALButtonTerminalStatus.AddButton(btnStopMalfunctionLbl, btnStopMalfunctionToolTipLbl, 'btnMalfunctionStop', 'primary');
                end;
            'btnMalfunctionStop':
                begin
                    Rec."Terminal Status" := "SEW BDE Terminal Status"::"in Time";
                    CurrPage.ALButtonTerminalStatus.RemoveButton('btnMalfunctionStop');
                    CurrPage.ALButtonTerminalStatus.AddButton(btnStartMalfunctionLbl, btnStartMalfunctionToolTipLbl, 'btnMalfunction', 'danger');
                end;

            'btnCallOperator':
                begin
                    Rec."Terminal Status" := "SEW BDE Terminal Status"::"Operator Call";
                    CurrPage.ALButtonTerminalStatus.RemoveButton('btnCallOperator');
                    CurrPage.ALButtonTerminalStatus.AddButton(btnStopOperatorLbl, btnStopOperatorToolTipLbl, 'btnCallOperatorStop', 'primary');
                end;

            'btnCallOperatorStop':
                begin
                    Rec."Terminal Status" := "SEW BDE Terminal Status"::"in Time";
                    CurrPage.ALButtonTerminalStatus.RemoveButton('btnCallOperatorStop');
                    CurrPage.ALButtonTerminalStatus.AddButton(btnStartOperatorLbl, btnStartOperatorToolTipLbl, 'btnCallOperator', 'danger');
                end;
        end;

    end;


    var
        VisibleFixedUser: Boolean;
        VisibleMalfunction: Boolean;
        VisibleCallOperator: Boolean;

        btnChangeUserLbl: Label 'Change User';
        btnChangeUserToolTipLbl: Label 'Change User';
        btnStartOperatorLbl: Label 'Call Operator';
        btnStartOperatorToolTipLbl: Label 'Call Operator';
        btnStopOperatorLbl: Label 'Operator here';
        btnStopOperatorToolTipLbl: Label 'Operator is here';

        btnStartMalfunctionLbl: Label 'Start Malfunction';
        btnStartMalfunctionToolTipLbl: Label 'Start Malfunction for this Task';
        btnStopMalfunctionLbl: Label 'Stop Malfunction';
        btnStopMalfunctionToolTipLbl: Label 'Stop Malfunction for this Task';

}