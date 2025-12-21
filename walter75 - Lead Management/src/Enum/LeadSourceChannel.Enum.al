enum 91701 "SEW Lead Source Channel"
{
    Caption = 'Lead Source Channel';
    Extensible = true;

    value(0; "")
    {
        Caption = '', Locked = true;
    }
    value(1; Web)
    {
        Caption = 'Web';
    }
    value(2; "Event")
    {
        Caption = 'Event';
    }
    value(3; Referral)
    {
        Caption = 'Referral';
    }
    value(4; Social)
    {
        Caption = 'Social Media';
    }
    value(5; InboundCall)
    {
        Caption = 'Inbound Call';
    }
    value(6; Outbound)
    {
        Caption = 'Outbound';
    }
}
