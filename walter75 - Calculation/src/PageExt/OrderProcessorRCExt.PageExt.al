pageextension 90840 "SEW Order Processor RC Ext" extends "Order Processor Role Center"
{
    layout
    {
        addlast(RoleCenter)
        {
            part(SEWCalcActivities; "SEW Calc Activities")
            {
                ApplicationArea = All;
                Caption = 'Calculation Activities';
            }
        }
    }

    actions
    {
        addlast(Sections)
        {
            group(SEWCalculation)
            {
                Caption = 'Calculation';
                Image = Calculator;
                ToolTip = 'Access calculation features and tools';

                action(SEWNewCalculation)
                {
                    ApplicationArea = All;
                    Caption = 'New Calculation';
                    ToolTip = 'Create a new calculation';
                    Image = New;
                    RunObject = page "SEW Calc Card";
                    RunPageMode = Create;
                }

                action(SEWCalculationList)
                {
                    ApplicationArea = All;
                    Caption = 'Calculations';
                    ToolTip = 'View all calculations';
                    Image = List;
                    RunObject = page "SEW Calc Headers";
                }

                action(SEWTemplates)
                {
                    ApplicationArea = All;
                    Caption = 'Templates';
                    ToolTip = 'Manage calculation templates';
                    Image = Template;
                    RunObject = page "SEW Calc Templates";
                }

                action(SEWVariables)
                {
                    ApplicationArea = All;
                    Caption = 'Variables';
                    ToolTip = 'Manage calculation variables';
                    Image = VariableList;
                    RunObject = page "SEW Calc Variables";
                }

                action(SEWCalculationReport)
                {
                    ApplicationArea = All;
                    Caption = 'Calculation Report';
                    ToolTip = 'Run calculation reports';
                    Image = Report;
                    RunObject = page "SEW Calc Headers";
                }
            }
        }

        addlast(Embedding)
        {
            action(SEWCalculationsEmbedded)
            {
                ApplicationArea = All;
                Caption = 'Calculations';
                ToolTip = 'View and manage calculations';
                Image = Calculator;
                RunObject = page "SEW Calc Headers";
            }
        }

        addlast(Creation)
        {
            action(SEWNewCalcCreation)
            {
                ApplicationArea = All;
                Caption = 'Calculation';
                ToolTip = 'Create a new calculation';
                Image = Calculator;
                RunObject = page "SEW Calc Card";
                RunPageMode = Create;
            }
        }
    }
}
