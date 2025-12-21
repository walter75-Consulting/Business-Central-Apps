table 91711 "SEW Lead Activity"
{
    Caption = 'Lead Activity';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Lead Activity List";
    DrillDownPageId = "SEW Lead Activity List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            ToolTip = 'Specifies the unique entry number for the activity.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Lead No."; Code[20])
        {
            Caption = 'Lead No.';
            ToolTip = 'Specifies the lead this activity is associated with.';
            DataClassification = CustomerContent;
            TableRelation = "SEW Lead";

            trigger OnValidate()
            var
                SEWLeadRec: Record "SEW Lead";
            begin
                if Rec."Lead No." <> '' then
                    if SEWLeadRec.Get(Rec."Lead No.") then begin
                        Rec."Contact No." := SEWLeadRec."Contact No.";
                        Rec."Lead Status" := SEWLeadRec.Status;
                    end;
            end;
        }
        field(3; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            ToolTip = 'Specifies the contact associated with the lead.';
            DataClassification = CustomerContent;
            TableRelation = Contact;
            Editable = false;
        }
        field(4; "Lead Status"; Enum "SEW Lead Status")
        {
            Caption = 'Lead Status';
            ToolTip = 'Specifies the status of the lead at the time of activity.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Type"; Enum "SEW Activity Type")
        {
            Caption = 'Type';
            ToolTip = 'Specifies the type of activity.';
            DataClassification = CustomerContent;
        }
        field(11; Subject; Text[100])
        {
            Caption = 'Subject';
            ToolTip = 'Specifies the subject or title of the activity.';
            DataClassification = CustomerContent;
        }
        field(12; Notes; Text[250])
        {
            Caption = 'Notes';
            ToolTip = 'Specifies additional notes about the activity.';
            DataClassification = CustomerContent;
        }
        field(20; "Due Date"; Date)
        {
            Caption = 'Due Date';
            ToolTip = 'Specifies when the activity is due.';
            DataClassification = CustomerContent;
        }
        field(21; "Start DateTime"; DateTime)
        {
            Caption = 'Start Date Time';
            ToolTip = 'Specifies the start date and time for meetings.';
            DataClassification = CustomerContent;
        }
        field(22; "End DateTime"; DateTime)
        {
            Caption = 'End Date Time';
            ToolTip = 'Specifies the end date and time for meetings.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (Rec."End DateTime" <> 0DT) and (Rec."Start DateTime" <> 0DT) then
                    if Rec."End DateTime" < Rec."Start DateTime" then
                        Error(EndBeforeStartErr);
            end;
        }
        field(23; "Duration (Minutes)"; Integer)
        {
            Caption = 'Duration (Minutes)';
            ToolTip = 'Specifies the duration of the activity in minutes.';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(30; Completed; Boolean)
        {
            Caption = 'Completed';
            ToolTip = 'Specifies whether the activity is completed.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Rec.Completed and (Rec."Completed Date" = 0D) then
                    Rec."Completed Date" := Today();
            end;
        }
        field(31; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            ToolTip = 'Specifies when the activity was completed.';
            DataClassification = CustomerContent;
        }
        field(32; Outcome; Enum "SEW Activity Outcome")
        {
            Caption = 'Outcome';
            ToolTip = 'Specifies the outcome of the activity.';
            DataClassification = CustomerContent;
        }
        field(40; "User ID"; Guid)
        {
            Caption = 'User ID';
            ToolTip = 'Specifies the user assigned to this activity.';
            DataClassification = EndUserPseudonymousIdentifiers;
            TableRelation = User."User Security ID";
        }
        field(41; "User Name"; Code[50])
        {
            Caption = 'User Name';
            ToolTip = 'Specifies the name of the user assigned to this activity.';
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field("User ID")));
            Editable = false;
        }
        field(50; "External Item ID"; Text[100])
        {
            Caption = 'External Item ID';
            ToolTip = 'Specifies the external reference ID for Outlook/Teams integration.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SK1; "Lead No.", "Due Date")
        {
        }
        key(SK2; "User ID", Completed, "Due Date")
        {
        }
        key(SK3; "Contact No.", "Due Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Lead No.", Subject, "Type", "Due Date")
        {
        }
    }

    var
        EndBeforeStartErr: Label 'End date and time cannot be before start date and time.', Comment = 'DE="Enddatum und -uhrzeit können nicht vor Startdatum und -uhrzeit liegen."';

    trigger OnInsert()
    var
        SEWLeadRec: Record "SEW Lead";
    begin
        if IsNullGuid(Rec."User ID") then
            Rec."User ID" := UserSecurityId();

        // Update lead's last activity date
        if SEWLeadRec.Get(Rec."Lead No.") then begin
            SEWLeadRec."Last Activity Date" := Today();
            SEWLeadRec.Modify(true);
        end;
    end;
}
