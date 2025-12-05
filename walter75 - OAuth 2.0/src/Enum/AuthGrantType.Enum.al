enum 90000 "SEW Auth Grant Type"
{
#pragma warning disable LC0045
    value(0; "Authorization Code")
    {
        Caption = 'Authorization Code';
    }
#pragma warning restore LC0045
    value(1; "Password Credentials")
    {
        Caption = 'Password Credentials';
    }
    value(2; "Client Credentials")
    {
        Caption = 'Client Credentials';
    }
    value(3; "API Key")
    {
        Caption = 'API Key';
    }

}