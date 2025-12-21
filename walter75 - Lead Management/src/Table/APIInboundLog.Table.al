table 91723 "SEW API Inbound Log"
{
    Caption = 'API Inbound Log';
    DataClassification = SystemMetadata;
    LookupPageId = "SEW API Inbound Log";
    DrillDownPageId = "SEW API Inbound Log";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the unique entry number for this log entry.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(10; Source; Text[50])
        {
            Caption = 'Source';
            ToolTip = 'Specifies the source of the API request (e.g., Website Form, Zapier).';
            DataClassification = SystemMetadata;
        }
        field(20; "Request Method"; Text[10])
        {
            Caption = 'Request Method';
            ToolTip = 'Specifies the HTTP method used (GET, POST, PUT, DELETE).';
            DataClassification = SystemMetadata;
        }
        field(21; "Request Path"; Text[250])
        {
            Caption = 'Request Path';
            ToolTip = 'Specifies the API endpoint path.';
            DataClassification = SystemMetadata;
        }
        field(30; Payload; Blob)
        {
            Caption = 'Payload';
            ToolTip = 'Specifies the JSON payload received.';
            DataClassification = SystemMetadata;
        }
        field(40; Processed; Boolean)
        {
            Caption = 'Processed';
            ToolTip = 'Specifies whether the request was processed successfully.';
            DataClassification = SystemMetadata;
        }
        field(41; Result; Text[50])
        {
            Caption = 'Result';
            ToolTip = 'Specifies the processing result (Success, Duplicate, Error).';
            DataClassification = SystemMetadata;
        }
        field(42; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
            ToolTip = 'Specifies the error message if processing failed.';
            DataClassification = SystemMetadata;
        }
        field(50; "Lead No."; Code[20])
        {
            Caption = 'Lead No.';
            ToolTip = 'Specifies the lead number created from this request.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Lead"."No.";
        }
        field(60; "Response Time (ms)"; Integer)
        {
            Caption = 'Response Time (ms)';
            ToolTip = 'Specifies the processing time in milliseconds.';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SK1; SystemCreatedAt)
        {
        }
        key(SK2; Source, SystemCreatedAt)
        {
        }
        key(SK3; Processed, Result)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", Source, Result, SystemCreatedAt)
        {
        }
    }

    procedure GetPayloadText(): Text
    var
        InStream: InStream;
        PayloadText: Text;
    begin
        CalcFields(Payload);
        if not Payload.HasValue() then
            exit('');

        Payload.CreateInStream(InStream, TextEncoding::UTF8);
        InStream.ReadText(PayloadText);
        exit(PayloadText);
    end;

    procedure SetPayloadText(PayloadText: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Payload);
        Payload.CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(PayloadText);
    end;
}
