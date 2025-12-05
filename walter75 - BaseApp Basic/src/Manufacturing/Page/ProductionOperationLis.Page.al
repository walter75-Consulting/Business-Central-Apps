page 80003 "SEW Production Operation Lis"
{
    ApplicationArea = All;
    Caption = 'Production Operation List';
    PageType = List;
    SourceTable = "Prod. Order Routing Line";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ToolTip = 'Specifies the number of the related production order.';
                }
                field("Operation No."; Rec."Operation No.")
                {
                    ToolTip = 'Specifies the operation number.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status of the routing line.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the starting date of the routing line (operation).';
                }
                field("Starting Time"; Rec."Starting Time")
                {
                    ToolTip = 'Specifies the starting time of the routing line (operation).';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the ending date of the routing line (operation).';
                }
                field("Ending Time"; Rec."Ending Time")
                {
                    ToolTip = 'Specifies the ending time of the routing line (operation).';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description of the operation.';
                }
                field(Type; Rec."Type")
                {
                    ToolTip = 'Specifies the type of operation.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Work Center No."; Rec."Work Center No.")
                {
                    ToolTip = 'Specifies the value of the Work Center No. field.', Comment = '%';
                }
                field("Work Center Group Code"; Rec."Work Center Group Code")
                {
                    ToolTip = 'Specifies the value of the Work Center Group Code field.', Comment = '%';
                }
                field("Routing Status"; Rec."Routing Status")
                {
                    ToolTip = 'Specifies the status of the routing line, such as Planned, In Progress, or Finished.';
                }
                field("Posted Output Quantity"; Rec."Posted Output Quantity")
                {
                    ToolTip = 'Specifies the value of the Posted Output Quantity field.', Comment = '%';
                }
                field("Posted Run Time"; Rec."Posted Run Time")
                {
                    ToolTip = 'Specifies the value of the Posted Run Time field.', Comment = '%';
                }
                field("Posted Scrap Quantity"; Rec."Posted Scrap Quantity")
                {
                    ToolTip = 'Specifies the value of the Posted Scrap Quantity field.', Comment = '%';
                }
                field("Posted Setup Time"; Rec."Posted Setup Time")
                {
                    ToolTip = 'Specifies the value of the Posted Setup Time field.', Comment = '%';
                }
            }
        }
    }
}
