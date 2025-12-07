pageextension 90895 "SEW Sales Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Number Series")
        {
            group("SEW SEWCalculation")
            {
                Caption = 'SEW Calculation';

                field("SEW Calc Nos."; Rec."SEW Calc Nos.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
