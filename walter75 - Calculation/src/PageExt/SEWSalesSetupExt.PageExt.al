pageextension 90895 "SEW Sales Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Number Series")
        {
            group(SEWCalculation)
            {
                Caption = 'SEW Calculation';

                field("SEW Calc Nos."; Rec."SEW Calc Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for calculations';
                }
            }
        }
    }
}
