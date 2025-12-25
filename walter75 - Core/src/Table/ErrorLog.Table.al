/// <summary>
/// Centralized error log for all SEW applications.
/// Provides error tracking with automatic retention policy support.
/// </summary>
table 71100 "SEW Error Log"
{
    Caption = 'Error Log';
    DataClassification = SystemMetadata;
    DataCaptionFields = "Entry No.", "Error Message";
    LookupPageId = "SEW Error Log List";
    DrillDownPageId = "SEW Error Log List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the unique entry number.';
            AutoIncrement = true;
        }
        field(2; "Error Timestamp"; DateTime)
        {
            Caption = 'Timestamp';
            ToolTip = 'Specifies when the error occurred.';
            Editable = false;
        }
        field(3; Severity; Enum "SEW Error Severity")
        {
            Caption = 'Severity';
            ToolTip = 'Specifies the severity level of the error.';
        }
        field(4; "Error Message"; Text[2048])
        {
            Caption = 'Error Message';
            ToolTip = 'Specifies the error message text.';
        }
        field(5; "Context Info"; Text[2048])
        {
            Caption = 'Context Info';
            ToolTip = 'Specifies additional context information about the error.';
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';
            ToolTip = 'Specifies the user who triggered the error.';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            Editable = false;
        }
        field(7; "Session ID"; Integer)
        {
            Caption = 'Session ID';
            ToolTip = 'Specifies the session ID where the error occurred.';
            Editable = false;
        }
        field(8; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            ToolTip = 'Specifies the company where the error occurred.';
            DataClassification = OrganizationIdentifiableInformation;
            Editable = false;
        }
        field(10; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            ToolTip = 'Specifies the object ID where the error occurred.';
        }
        field(11; "Stack Trace"; Blob)
        {
            Caption = 'Stack Trace';
            ToolTip = 'Specifies the stack trace of the error.';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(TimestampIdx; "Error Timestamp")
        {
        }
        key(SeverityIdx; Severity, "Error Timestamp")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Error Message", Severity, "Error Timestamp")
        {
        }
        fieldgroup(Brick; "Entry No.", "Error Timestamp", Severity, "User ID", "Company Name")
        {
        }
    }

    trigger OnInsert()
    begin
        if Rec."Error Timestamp" = 0DT then
            Rec."Error Timestamp" := CurrentDateTime();

        if Rec."User ID" = '' then
            Rec."User ID" := CopyStr(UserId(), 1, MaxStrLen(Rec."User ID"));

        if Rec."Session ID" = 0 then
            Rec."Session ID" := SessionId();

        if Rec."Company Name" = '' then
            Rec."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(Rec."Company Name"));
    end;

    /// <summary>
    /// Set stack trace from text value.
    /// </summary>
    /// <param name="StackTraceText">Stack trace as text.</param>
    procedure SetStackTrace(StackTraceText: Text)
    var
        OutStream: OutStream;
    begin
        Rec."Stack Trace".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(StackTraceText);
    end;

    /// <summary>
    /// Get stack trace as text value.
    /// </summary>
    /// <returns>Stack trace text.</returns>
    procedure GetStackTrace(): Text
    var
        InStream: InStream;
        StackTraceText: Text;
    begin
        if not Rec."Stack Trace".HasValue() then
            exit('');

        Rec.CalcFields("Stack Trace");
        Rec."Stack Trace".CreateInStream(InStream, TextEncoding::UTF8);
        InStream.ReadText(StackTraceText);
        exit(StackTraceText);
    end;
}
