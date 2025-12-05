page 90607 "SEW Routing Lines List"
{
    Caption = 'Arbeitsgänge Liste';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Prod. Order Routing Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Status; Rec.Status)
                {
                    
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    
                    ToolTip = 'Specifies the setup time of the operation.';
                }

                field("Operation No."; Rec."Operation No.")
                {
                    
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field(Type; Rec.Type)
                {
                    
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("Work Center No."; Rec."Work Center No.")
                {
                    
                    Visible = false;
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("No."; Rec."No.")
                {
                    
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field(Description; Rec.Description)
                {
                    
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("Starting Time"; Rec."Starting Time")
                {
                    
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("Ending Time"; Rec."Ending Time")
                {
                    
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("Setup Time"; Rec."Setup Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("Setup Time Unit of Meas. Code"; Rec."Setup Time Unit of Meas. Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the setup time unit of measure.';
                    Visible = false;
                }
                field("Run Time"; Rec."Run Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the run time of the operation.';
                }
                field("Run Time Unit of Meas. Code"; Rec."Run Time Unit of Meas. Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the run time unit of measure.';
                    Visible = false;
                }
                field("Wait Time"; Rec."Wait Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the wait time after processing.';
                }
                field("Wait Time Unit of Meas. Code"; Rec."Wait Time Unit of Meas. Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the wait time unit of measure.';
                    Visible = false;
                }
                field("Move Time"; Rec."Move Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the move time.';
                }
                field("Move Time Unit of Meas. Code"; Rec."Move Time Unit of Meas. Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the move time unit of measure.';
                    Visible = false;
                }

                field("Fixed Scrap Quantity"; Rec."Fixed Scrap Quantity")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the fixed scrap quantity.';
                    Visible = false;
                }
                field("Lot Size"; Rec."Lot Size")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the lot size.';
                    Visible = false;
                }
                field("Scrap Factor %"; Rec."Scrap Factor %")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the scrap factor in percent.';
                    Visible = false;
                }
                field("Concurrent Capacities"; Rec."Concurrent Capacities")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the concurrent capacity of the operation.';
                }
                field("Send-Ahead Quantity"; Rec."Send-Ahead Quantity")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the send-ahead quantity of the operation.';
                    Visible = false;
                }
                field("Routing Link Code"; Rec."Routing Link Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies a routing link code.';
                    Visible = false;
                }
                field("Unit Cost per"; Rec."Unit Cost per")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the unit cost for this operation if it is different than the unit cost on the work center or machine center card.';
                    Visible = false;
                }
                field("Work Center Group Code"; Rec."Work Center Group Code")
                {
                    
                    Visible = false;
                    ToolTip = 'Specifies the setup time of the operation.';
                }
                field("SEW BDE Terminal Code"; Rec."SEW BDE Terminal Code")
                {
                    
                }
                field("SEW BDE Rout. Line Plan Status"; Rec."SEW BDE Rout. Line Plan Status")
                {
                    
                }
                field("SEW BDE Rout. Line Status"; Rec."SEW BDE Rout. Line Status")
                {
                    
                }
                field("Posted Run Time"; Rec."Posted Run Time")
                {
                    
                }
                field("Posted Setup Time"; Rec."Posted Setup Time")
                {
                    
                }
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
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Co&mments")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = page "Prod. Order Rtng. Cmt. Sh.";
                    RunPageLink = Status = field(Status),
                                  "Prod. Order No." = field("Prod. Order No."),
                                  "Routing Reference No." = field("Routing Reference No."),
                                  "Routing No." = field("Routing No."),
                                  "Operation No." = field("Operation No.");
                    ToolTip = 'View or add comments for the record.';
                }
                action(Tools)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Tools';
                    Image = Tools;
                    RunObject = page "Prod. Order Routing Tools";
                    RunPageLink = Status = field(Status),
                                  "Prod. Order No." = field("Prod. Order No."),
                                  "Routing Reference No." = field("Routing Reference No."),
                                  "Routing No." = field("Routing No."),
                                  "Operation No." = field("Operation No.");
                    ToolTip = 'View or edit information about tools that apply to operations that represent the standard task.';
                }
                action(Personnel)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Personnel';
                    Image = User;
                    RunObject = page "Prod. Order Routing Personnel";
                    RunPageLink = Status = field(Status),
                                  "Prod. Order No." = field("Prod. Order No."),
                                  "Routing Reference No." = field("Routing Reference No."),
                                  "Routing No." = field("Routing No."),
                                  "Operation No." = field("Operation No.");
                    ToolTip = 'View or edit information about personnel that applies to operations that represent the standard task.';
                }
                action("Quality Measures")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Quality Measures';
                    Image = TaskQualityMeasure;
                    RunObject = page "Prod. Order Rtng Qlty Meas.";
                    RunPageLink = Status = field(Status),
                                  "Prod. Order No." = field("Prod. Order No."),
                                  "Routing Reference No." = field("Routing Reference No."),
                                  "Routing No." = field("Routing No."),
                                  "Operation No." = field("Operation No.");
                    ToolTip = 'View or edit information about quality measures that apply to operations that represent the standard task.';
                }
            }
        }
    }
}