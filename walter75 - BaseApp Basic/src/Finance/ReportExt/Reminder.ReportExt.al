reportextension 80013 "SEW Reminder" extends Reminder
{
    dataset
    {

    }

    rendering
    {
        layout("SEW Reminder 01")
        {
            Type = RDLC;
            LayoutFile = './src/Finance/ReportExt/Layout/Reminder01.rdlc';
            Caption = 'SEW Reminder 01 (RDLC)';
            Summary = 'SEW Mahnung (RDLC)';
        }
        layout("SEW Reminder 02")
        {
            Type = RDLC;
            LayoutFile = './src/Finance/ReportExt/Layout/Reminder02.rdlc';
            Caption = 'SEW Reminder 02 (RDLC)';
            Summary = 'SEW Mahnung (RDLC)';
        }
    }
}