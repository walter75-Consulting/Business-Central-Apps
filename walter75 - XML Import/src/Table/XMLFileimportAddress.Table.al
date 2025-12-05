table 60502 "SEW XML Fileimport Address"
{
    Caption = 'XML Fileimport Address';
    DataClassification = CustomerContent;
    DrillDownPageId = "SEW XML Fileimport Address";
    LookupPageId = "SEW XML Fileimport Address";

    fields
    {
        field(1; PARTNER_ID; Code[35])
        {
            Caption = 'PARTNER_ID';
            ToolTip = 'Specifies the value of the PARTNER_ID field.';
        }
        field(2; PARTNER_Q; Code[10])
        {
            Caption = 'PARTNER_Q';
            ToolTip = 'Specifies the value of the PARTNER_Q field.';
        }
        field(3; LANGUAGE; Code[10])
        {
            Caption = 'LANGUAGE';
            ToolTip = 'Specifies the value of the LANGUAGE field.';
        }
        field(4; NAME1; Text[100])
        {
            Caption = 'NAME1';
            ToolTip = 'Specifies the value of the NAME1 field.';
        }
        field(5; NAME2; Text[100])
        {
            Caption = 'NAME2';
            ToolTip = 'Specifies the value of the NAME2 field.';
        }
        field(6; STREET1; Text[100])
        {
            Caption = 'STREET1';
            ToolTip = 'Specifies the value of the STREET1 field.';
        }
        field(7; POSTL_COD1; Text[20])
        {
            Caption = 'POSTL_COD1';
            ToolTip = 'Specifies the value of the POSTL_COD1 field.';
        }
        field(8; CITY1; Text[100])
        {
            Caption = 'CITY1';
            ToolTip = 'Specifies the value of the CITY1 field.';
        }
        field(9; TELEPHONE1; Text[50])
        {
            Caption = 'TELEPHONE1';
            ToolTip = 'Specifies the value of the TELEPHONE1 field.';
        }

        field(10; TELEFAX; Text[50])
        {
            Caption = 'TELEFAX';
            ToolTip = 'Specifies the value of the TELEFAX field.';
        }
        field(11; E_MAIL; Text[100])
        {
            Caption = 'E_MAIL';
            ToolTip = 'Specifies the value of the E_MAIL field.';
        }
        field(12; COUNTRY1; Code[10])
        {
            Caption = 'COUNTRY1';
            ToolTip = 'Specifies the value of the COUNTRY1 field.';
        }

    }

    keys
    {
        key(PK; "PARTNER_ID", "PARTNER_Q")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "PARTNER_ID", NAME1, "STREET1", "CITY1", "COUNTRY1") { }
        fieldgroup(Brick; "PARTNER_ID", NAME1, "STREET1", "CITY1", "COUNTRY1") { }
    }

}