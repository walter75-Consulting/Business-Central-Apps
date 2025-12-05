page 90600 "SEW BDE Booking"
{
    Caption = 'BDE Booking';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "SEW BDE Booking";
    // The target Help topic is hosted on the website that is specified in the app.json file.
    ContextSensitiveHelpPage = 'sales-rewards';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Prod. Order No."; Rec."Prod. Order No.") { }
                field("Operation No."; Rec."Operation No.") { }
                field(Type; Rec.Type) { }
                field("No."; Rec."No.") { }
                field("User Start"; Rec."User Start") { }
                field("BDE Rout. Line Status Start"; Rec."BDE Rout. Line Status Start") { }
                field("Starting Date/Time"; Rec."Starting Date/Time") { }
                field("Starting Date"; Rec."Starting Date") { }
                field("Starting Time"; Rec."Starting Time") { }
                field("User Stop"; Rec."User Stop") { }
                field("BDE Rout. Line Status Stop"; Rec."BDE Rout. Line Status Stop") { }
                field("Ending Date/Time"; Rec."Ending Date/Time") { }
                field("Ending Date"; Rec."Ending Date") { }
                field("Ending Time"; Rec."Ending Time") { }
                field("Duration Minutes"; Rec."Duration Minutes") { }
                field("Item No."; Rec."Item No.") { }
                field(Processed; Rec.Processed) { }
            }
        }

        area(FactBoxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(TransferJournal)
            {
                Caption = 'Transfer to Journal';
                ToolTip = 'Transfer to Journal.';
                Image = Tools;

                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    SEWBDETerminal: Codeunit "SEW BDE Terminal";

                begin
                    SEWBDETerminal.BDETransfertoItemJournal();
                end;
            }
            action(TerminalsToRouting)
            {
                Caption = 'assign Terminal to Routing Lines';
                ToolTip = 'assign Terminal to Routing Lines.';
                Image = Tools;

                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    SEWBDETerminal: Codeunit "SEW BDE Terminal";
                begin
                    SEWBDETerminal.BDETerminalToRoutingLine();
                end;
            }
        }

    }



    views
    {
        view(NotProcessed)
        {
            Caption = 'not Processed';
            Filters = where("Processed" = const(false));
            SharedLayout = false;
        }

    }



}