page 90601 "SEW BDE Booking Dialog"
{
    Caption = 'Start / Stop Task';
    PageType = StandardDialog;


    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'Booking Details';

                group(GroupUser)
                {
                    Caption = 'User';
                    Visible = xUserVisible;
                    field(SEWUser; SEWUser)
                    {
                        ApplicationArea = All;
                        Caption = 'User';
                        ToolTip = 'Specifies the User.';
                        Lookup = true;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            Resource: Record Resource;
                        begin
                            Resource.Reset();
                            if Page.RunModal(Page::"Resource List", Resource) = Action::LookupOK then
                                SEWUser := Resource."No.";
                        end;
                    }
                }

                group(GroupQuatity)
                {
                    Caption = 'Quantities';
                    Visible = xQtyVisible;
                    field(SEWOutputQuantity; SEWOutputQuantity)
                    {
                        ApplicationArea = All;
                        Caption = 'Quantity Output';
                        ToolTip = 'Specifies the Quantity Output.';
                    }
                    field(SEWScrapQuantity; SEWScrapQuantity)
                    {
                        ApplicationArea = All;
                        Caption = 'Quantity Scrap';
                        ToolTip = 'Specifies the Quantity Scrap.';
                    }
                    field(SEWScrapCode; SEWScrapCode)
                    {
                        ApplicationArea = All;
                        Lookup = true;
                        Caption = 'Scrap Code';
                        ToolTip = 'Specifies the Scrap Code.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            Scrap: Record Scrap;
                        begin
                            Scrap.Reset();
                            if Page.RunModal(Page::"Scrap Codes", Scrap) = Action::LookupOK then
                                SEWScrapCode := Scrap."Code";
                        end;
                    }


                }
                group(GroupComment)
                {
                    Caption = 'Comment';
                    Visible = true;
                    field(SEWComment; SEWComment)
                    {
                        ApplicationArea = All;
                        Caption = 'Comment';
                        ToolTip = 'Specifies the Comment.';
                    }
                }
            }
        }
    }


    trigger OnOpenPage()
    begin

    end;

    procedure ActionStart(LineStatus: Enum "SEW BDE Rout. Line Status"; ProdOrderRoutingLine: Record "Prod. Order Routing Line")
    var
        SEWBDETerminal: Codeunit "SEW BDE Terminal";
    begin
        SEWBDETerminal.ActionStart(LineStatus, ProdOrderRoutingLine, SEWUser, SEWComment, SEWTerminalCode);
    end;

    procedure ActionStop(LineStatus: Enum "SEW BDE Rout. Line Status"; ProdOrderRoutingLine: Record "Prod. Order Routing Line")
    var
        SEWBDETerminal: Codeunit "SEW BDE Terminal";
    begin
        SEWBDETerminal.ActionStop(LineStatus, ProdOrderRoutingLine, SEWUser, SEWComment, SEWOutputQuantity, SEWScrapQuantity, SEWScrapCode, SEWFinish);
    end;

    procedure SetUser(xUser: Code[20])
    begin
        xUserVisible := false;

        SEWUser := xUser;

        if SEWUser = '' then
            xUserVisible := true;
    end;

    procedure SetShowQty(xvisible: Boolean)
    begin
        xQtyVisible := xvisible;
    end;

    procedure SetFinish(xFinish: Boolean)
    begin
        SEWFinish := false;
        SEWFinish := xFinish;
    end;

    procedure SetTerminalCode(xTerminalCode: Code[10])
    begin
        SEWTerminalCode := xTerminalCode;
    end;





    var
        SEWOutputQuantity: Decimal;
        SEWScrapQuantity: Decimal;
        SEWUser: Code[20];
        SEWScrapCode: Code[10];
        SEWComment: Text[255];
        SEWFinish: Boolean;
        SEWTerminalCode: Code[10];
        xUserVisible: Boolean;
        xQtyVisible: Boolean;




}