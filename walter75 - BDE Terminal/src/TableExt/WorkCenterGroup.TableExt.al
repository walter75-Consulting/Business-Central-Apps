tableextension 90601 "SEW Work Center Group" extends "Work Center Group"
{
    fields
    {
        field(70700; "SEW BDE Enabled"; Boolean)
        {
            Caption = 'BDE Enabled';
            ToolTip = 'Specifies whether the BDE (Betriebsdatenerfassung) terminal is enabled for this work center group.';
        }
    }

}