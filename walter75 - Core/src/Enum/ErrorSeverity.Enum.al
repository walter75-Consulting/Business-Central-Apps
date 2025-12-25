/// <summary>
/// Severity levels for error logging.
/// </summary>
enum 71100 "SEW Error Severity"
{
    Extensible = false;

    value(0; "")
    {
        Caption = '', Locked = true;
    }
    value(1; Info)
    {
        Caption = 'Info';
    }
    value(2; Warning)
    {
        Caption = 'Warning';
    }
    value(3; Error)
    {
        Caption = 'Error';
    }
    value(4; Critical)
    {
        Caption = 'Critical';
    }
}
