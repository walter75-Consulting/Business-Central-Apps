page 92704 "SEW PrintNode Computer List"
{
    Caption = 'PrintNode Computer List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "SEW PrintNode Computer";


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Computer ID"; Rec."Computer ID")
                {
                }
                field("Computer Name"; Rec."Computer Name")
                {
                }
                field("Computer State"; Rec."Computer State")
                {
                }
                field(Printers; Rec.Printers)
                {
                }
                field(Scales; Rec.Scales)
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(RefreshComputers)
            {
                Caption = 'Refresh Computers';
                ToolTip = 'Refresh the list of computers from PrintNode service.';
                ApplicationArea = All;
                Image = Refresh;

                trigger OnAction()
                var
                    SEWPNRestRequests: Codeunit "SEW PN Rest Requests";
                begin
                    SEWPNRestRequests.GetComputers();
                    CurrPage.Update();
                end;
            }
            action(GetScaleWeight)
            {
                Caption = 'Get Scale Weight';
                ToolTip = 'Get the current weight from the selected scale.';
                ApplicationArea = All;
                Image = UpdateShipment;

                trigger OnAction()
                var
                    SEWPNRestRequests: Codeunit "SEW PN Rest Requests";
                begin
                    SEWPNRestRequests.GetScaleValue(0, 'PrintNode Test Scale');
                end;
            }
        }
        area(Promoted)
        {
            actionref(RefreshComputersPrm; RefreshComputers)
            {
            }
            actionref(GetScaleWeightPrm; GetScaleWeight)
            {
            }

        }
    }
}