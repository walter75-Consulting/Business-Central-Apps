tableextension 90600 "SEW Prod. Order Routing Line" extends "Prod. Order Routing Line"
{
    fields
    {
        field(70700; "SEW BDE Terminal Code"; Code[10])
        {
            Caption = 'BDE Terminal Code';
            ToolTip = 'Specifies the BDE terminal code assigned to this routing line.';
            TableRelation = "SEW BDE Terminal";
        }
        field(70701; "SEW BDE Rout. Line Plan Status"; Enum "SEW BDE Rout. Line Plan Status")
        {
            Caption = 'BDE Planning Status';
            ToolTip = 'Specifies the planning status of the routing line in the BDE system.';
        }
        field(70702; "SEW BDE Rout. Line Status"; Enum "SEW BDE Rout. Line Status")
        {
            Caption = 'BDE Status';
            ToolTip = 'Specifies the current status of the routing line in the BDE system.';
        }
    }

}