page 95703 "SEW Carrier Ship Met Ctry Pri"
{
    Caption = 'SEW Shipping Method Cntry Pric';

    PageType = List;
    ApplicationArea = All;
    UsageCategory = None;

    SourceTable = "SEW Carrier Ship Met Cntry Pri";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Shipping Method ID"; Rec."Shipping Method ID")
                {
                    ToolTip = 'Specifies the value of the Shipping Method ID field.', Comment = '%';
                }
                field("Shipping Met Cntry ID"; Rec."Shipping Met Cntry ID")
                {
                    ToolTip = 'Specifies the value of the Shipping Met Cntry ID field.', Comment = '%';
                }
                field(Type; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("Label"; Rec."Label")
                {
                    ToolTip = 'Specifies the value of the Label field.', Comment = '%';
                }
                field(Value; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the Value field.', Comment = '%';
                }
            }
        }
    }
}
