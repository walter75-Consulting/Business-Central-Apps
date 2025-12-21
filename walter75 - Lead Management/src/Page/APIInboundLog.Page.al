page 91726 "SEW API Inbound Log"
{
    Caption = 'API Inbound Log';
    PageType = List;
    SourceTable = "SEW API Inbound Log";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique entry number for this log entry.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Caption = 'Timestamp';
                    ToolTip = 'Specifies when this API request was received.';
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source of the API request (e.g., Website Form, Zapier).';
                }
                field("Request Method"; Rec."Request Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the HTTP method used (GET, POST, PUT, DELETE).';
                }
                field("Request Path"; Rec."Request Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the API endpoint path.';
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the request was processed successfully.';
                }
                field(Result; Rec.Result)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the processing result (Success, Duplicate, Error).';
                }
                field("Lead No."; Rec."Lead No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lead number created from this request.';
                }
                field("Response Time (ms)"; Rec."Response Time (ms)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the processing time in milliseconds.';
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the error message if processing failed.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewPayload)
            {
                Caption = 'View Payload';
                Image = ViewDetails;
                ApplicationArea = All;
                ToolTip = 'View the JSON payload received with this request.';

                trigger OnAction()
                var
                    PayloadText: Text;
                begin
                    PayloadText := Rec.GetPayloadText();
                    if PayloadText <> '' then
                        Message(PayloadText)
                    else
                        Message('No payload data available.');
                end;
            }
        }
        area(Navigation)
        {
            action(ViewLead)
            {
                Caption = 'View Lead';
                Image = Document;
                ApplicationArea = All;
                ToolTip = 'Open the lead card created from this request.';
                Enabled = Rec."Lead No." <> '';

                trigger OnAction()
                var
                    SEWLeadRec: Record "SEW Lead";
                begin
                    if SEWLeadRec.Get(Rec."Lead No.") then
                        Page.Run(Page::"SEW Lead Card", SEWLeadRec);
                end;
            }
        }
    }
}
