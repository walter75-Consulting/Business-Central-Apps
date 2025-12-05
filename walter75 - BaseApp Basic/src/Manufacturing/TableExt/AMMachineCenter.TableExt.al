tableextension 80005 "SEW AM Machine Center" extends "Machine Center"
{
    fields
    {
        field(80000; "SEW No. of Opera. Planned"; Integer)
        {
            Caption = 'No. of Operations Planned';
            ToolTip = 'No. of Operations Planned.';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Prod. Order Routing Line" where("Type" = const("Capacity Type"::"Machine Center"), "No." = field("No."), "Status" = const("Production Order Status"::Planned)));
        }
        field(80001; "SEW No. of Opera. Firm Plan"; Integer)
        {
            Caption = 'No. of Operations Firm Planned';
            ToolTip = 'No. of Operations Firm Planned.';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Prod. Order Routing Line" where("Type" = const("Capacity Type"::"Machine Center"), "No." = field("No."), "Status" = const("Production Order Status"::"Firm Planned")));
        }
        field(80002; "SEW No. of Opera. Released"; Integer)
        {
            Caption = 'No. of Operations Firm Released';
            ToolTip = 'No. of Operations Firm Released.';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Prod. Order Routing Line" where("Type" = const("Capacity Type"::"Machine Center"), "No." = field("No."), "Status" = const("Production Order Status"::Released)));
        }
    }
}
