tableextension 80040 "SEW RE Company Information" extends "Company Information"
{
    fields
    {
        field(80800; "SEW Document Text 01"; Text[150])
        {
            Caption = 'Document Text 01';
            ToolTip = 'Specifies Document Text 01.';
            DataClassification = CustomerContent;
        }
        field(80801; "SEW Document Text 02"; Text[150])
        {
            Caption = 'Document Text 02';
            ToolTip = 'Specifies Document Text 02.';
            DataClassification = CustomerContent;
        }
        field(80802; "SEW Document Text 03"; Text[150])
        {
            Caption = 'Document Text 03';
            ToolTip = 'Specifies Document Text 03.';
            DataClassification = CustomerContent;
        }
        field(80803; "SEW Document Text 04"; Text[150])
        {
            Caption = 'Document Text 04';
            ToolTip = 'Specifies Document Text 04.';
            DataClassification = CustomerContent;
        }
        field(80804; "SEW Document Text 05"; Text[150])
        {
            Caption = 'Document Text 05';
            ToolTip = 'Specifies Document Text 05.';
            DataClassification = CustomerContent;
        }
        field(80805; "SEW Document Text 06"; Text[150])
        {
            Caption = 'Document Text 06';
            ToolTip = 'Specifies Document Text 06.';
            DataClassification = CustomerContent;
        }
        field(80806; "SEW Bank Name 02"; Text[100])
        {
            Caption = 'Bank Name 02';
            ToolTip = 'Specifies Bank Name 02.';
            DataClassification = CustomerContent;
        }
        field(80807; "SEW Bank Branch No. 02"; Text[20])
        {
            Caption = 'Bank Branch No. 02';
            ToolTip = 'Specifies Bank Branch No. 02.';
            DataClassification = CustomerContent;
        }
        field(80808; "SEW Bank Account No. 02"; Text[30])
        {
            Caption = 'Bank Account No. 02';
            ToolTip = 'Specifies Bank Account No. 02.';
            DataClassification = CustomerContent;
        }
        field(80809; "SEW Bank IBAN 02"; Code[50])
        {
            Caption = 'Bank IBAN 02';
            ToolTip = 'Specifies Bank IBAN 02.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CheckIBAN("SEW Bank IBAN 02");
            end;
        }
        field(80810; "SEW Bank SWIFT Code 02"; Code[20])
        {
            Caption = 'Bank SWIFT Code 02';
            ToolTip = 'Specifies Bank SWIFT Code 02.';
            DataClassification = CustomerContent;
            TableRelation = "SWIFT Code";
            ValidateTableRelation = false;
        }
        field(80811; "SEW Bank Name 03"; Text[100])
        {
            Caption = 'Bank Name 03';
            ToolTip = 'Specifies Bank Name 03.';
            DataClassification = CustomerContent;
        }
        field(80812; "SEW Bank Branch No. 03"; Text[20])
        {
            Caption = 'Bank Branch No. 03';
            ToolTip = 'Specifies Bank Branch No. 03.';
            DataClassification = CustomerContent;
        }
        field(80813; "SEW Bank Account No. 03"; Text[30])
        {
            Caption = 'Bank Account No. 03';
            ToolTip = 'Specifies Bank Account No. 03.';
            DataClassification = CustomerContent;
        }
        field(80814; "SEW Bank IBAN 03"; Code[50])
        {
            Caption = 'Bank IBAN 03';
            ToolTip = 'Specifies Bank IBAN 03.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CheckIBAN("SEW Bank IBAN 03");
            end;
        }
        field(80815; "SEW Bank SWIFT Code 03"; Code[20])
        {
            Caption = 'Bank SWIFT Code 03';
            ToolTip = 'Specifies Bank SWIFT Code 03.';
            DataClassification = CustomerContent;
            TableRelation = "SWIFT Code";
            ValidateTableRelation = false;
        }
        field(80816; "SEW Picture 2"; Blob)
        {
            Caption = 'Picture 2';
            ToolTip = 'Specifies Picture 2.';
            Subtype = Bitmap;
        }
        field(80817; "SEW Picture 3"; Blob)
        {
            Caption = 'Picture 3';
            ToolTip = 'Specifies Picture 3.';
            Subtype = Bitmap;
        }
        field(80818; "SEW Picture 4"; Blob)
        {
            Caption = 'Picture 4';
            ToolTip = 'Specifies Picture 4.';
            Subtype = Bitmap;
        }
        field(80819; "SEW Picture 5"; Blob)
        {
            Caption = 'Picture 5';
            ToolTip = 'Specifies Picture 5.';
            Subtype = Bitmap;
        }
        field(80820; "SEW Company Color 1"; Text[7])
        {
            Caption = 'Company Color 1';
            ToolTip = 'Specifies Company Color 1 RGB Code.';
        }
        field(80821; "SEW Company Font Color 1"; Text[7])
        {
            Caption = 'Company Font Color 1';
            ToolTip = 'Specifies Company Font Color 1 RGB Code.';
        }
        field(80899; "SEW Company Font 1"; Enum "SEW Report Font")
        {
            Caption = 'Company Font 1';
            ToolTip = 'Specifies Company Font 1.';
        }
        field(80822; "SEW Company Color 2"; Text[7])
        {
            Caption = 'Company Color 2';
            ToolTip = 'Specifies Company Color 2 RGB Code.';
        }
        field(80823; "SEW Company Font Color 2"; Text[7])
        {
            Caption = 'Company Font Color 2';
            ToolTip = 'Specifies Company Font Color 2 RGB Code.';
        }
        field(80898; "SEW Company Font 2"; Enum "SEW Report Font")
        {
            Caption = 'Company Font 2';
            ToolTip = 'Specifies Company Font 2.';
        }
        field(80830; "SEW Document Footer Text 01"; Text[150])
        {
            Caption = 'Document Footer Text 01';
            ToolTip = 'Specifies Document Footer Text 01.';
            DataClassification = CustomerContent;
        }
        field(80831; "SEW Document Footer Text 02"; Text[150])
        {
            Caption = 'Document Footer Text 02';
            ToolTip = 'Specifies Document Footer Text 02.';
            DataClassification = CustomerContent;
        }
        field(80832; "SEW Document Footer Text 03"; Text[150])
        {
            Caption = 'Document Footer Text 03';
            ToolTip = 'Specifies Document Footer Text 03.';
            DataClassification = CustomerContent;
        }
        field(80833; "SEW Document Footer Text 04"; Text[150])
        {
            Caption = 'Document Footer Text 04';
            ToolTip = 'Specifies Document Footer Text 04.';
            DataClassification = CustomerContent;
        }
        field(80834; "SEW Document Footer Text 05"; Text[150])
        {
            Caption = 'Document Footer Text 05';
            ToolTip = 'Specifies Document Footer Text 05.';
            DataClassification = CustomerContent;
        }
        field(80835; "SEW Document Footer Text 06"; Text[150])
        {
            Caption = 'Document Footer Text 06';
            ToolTip = 'Specifies Document Footer Text 06.';
            DataClassification = CustomerContent;
        }
        field(80836; "SEW Managing Director"; Text[255])
        {
            Caption = 'Managing Director';
            ToolTip = 'Specifies the Managing Director.';
            DataClassification = CustomerContent;
            AllowInCustomizations = Never;
        }
        field(80838; "SEW Commercial Register"; Text[50])
        {
            Caption = 'Commercial Register';
            ToolTip = 'Specifies the Commercial Register.';
            DataClassification = CustomerContent;
            AllowInCustomizations = Never;
        }
        field(80839; "SEW Conditions URL"; Text[255])
        {
            Caption = 'Conditions-URL';
            ToolTip = 'Specifies the Conditions-URL.';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
            AllowInCustomizations = Never;
        }
        field(80040; "SEW Data Protection URL"; Text[255])
        {
            Caption = 'Data Protection-URL';
            ToolTip = 'Specifies the Data Protection-URL.';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
            AllowInCustomizations = Never;
        }
    }
}