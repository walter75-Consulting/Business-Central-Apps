table 91722 "SEW Lead Attachment Link"
{
    Caption = 'Lead Attachment Link';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the unique entry number for this attachment link.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(10; "Lead No."; Code[20])
        {
            Caption = 'Lead No.';
            ToolTip = 'Specifies the lead number for this attachment.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Lead"."No.";
        }
        field(20; "Document Attachment Entry No."; Integer)
        {
            Caption = 'Document Attachment Entry No.';
            ToolTip = 'Specifies the entry number in the Document Attachment table.';
            DataClassification = SystemMetadata;
            TableRelation = "Document Attachment"."No.";
        }
        field(30; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies a description for this attachment.';
            DataClassification = CustomerContent;
        }
        field(31; "File Name"; Text[250])
        {
            Caption = 'File Name';
            ToolTip = 'Specifies the name of the attached file.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(32; "File Extension"; Text[30])
        {
            Caption = 'File Extension';
            ToolTip = 'Specifies the file extension of the attachment.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(100; "Attached By Name"; Code[50])
        {
            Caption = 'Attached By';
            ToolTip = 'Specifies the user who attached this file.';
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemCreatedBy)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SK1; "Lead No.", SystemCreatedAt)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Lead No.", Description)
        {
        }
    }
}
