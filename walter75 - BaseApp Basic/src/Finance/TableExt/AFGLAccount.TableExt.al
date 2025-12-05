tableextension 80043 "SEW AF G/L Account" extends "G/L Account"
{
    fields
    {
        field(70505; "SEW Account purpose"; Text[250])
        {
            Caption = 'Account purpose';
            ToolTip = 'Specifies the purpose of the G/L account.';
            DataClassification = CustomerContent;
        }
    }

}