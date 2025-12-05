table 91300 "SEW Contact Relations"
{
    Caption = 'Contact Relations';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Contact Relation";
    DrillDownPageId = "SEW Contact Relation";

    fields
    {
        field(1; "Contact No. from"; Code[20])
        {
            Caption = 'Contact No. from';
            ToolTip = 'Specifies the source contact number in the relation.';
            TableRelation = Contact where(Type = const("Contact Type"::Company));
            trigger OnValidate()
            begin
                ReverseEntry(Rec."Contact No. from", Rec."Contact No. to", Rec."Relation Type", Rec."Reverse Relation Type");
            end;
        }
        field(2; "Contact from"; Text[100])
        {
            Caption = 'Contact from';
            ToolTip = 'Specifies the name of the source contact.';
            FieldClass = FlowField;
            CalcFormula = lookup(Contact.Name where("No." = field("Contact No. from")));
            Editable = false;
        }
        field(3; "Relation Type"; Code[20])
        {
            Caption = 'Relation Type';
            ToolTip = 'Specifies the type of relation between the contacts.';
            TableRelation = "SEW Contact Relation Type";
            trigger OnValidate()
            var
                SEWContactRelationType: Record "SEW Contact Relation Type";
            begin
                SEWContactRelationType.Reset();
                SEWContactRelationType.SetRange(Code, Rec."Relation Type");
                if SEWContactRelationType.FindFirst() then
                    Rec."Reverse Relation Type" := SEWContactRelationType."Reverse Entry Code";

                ReverseEntry(Rec."Contact No. from", Rec."Contact No. to", Rec."Relation Type", Rec."Reverse Relation Type");
            end;
        }
        field(4; "Reverse Relation Type"; Code[20])
        {
            Caption = 'Reverse Relation Type';
            ToolTip = 'Specifies the reverse relation type for the bidirectional relation.';
            TableRelation = "SEW Contact Relation Type";
            trigger OnValidate()
            begin
                ReverseEntry(Rec."Contact No. from", Rec."Contact No. to", Rec."Relation Type", Rec."Reverse Relation Type");
            end;
        }
        field(5; "Relation Description"; Text[150])
        {
            Caption = 'Description from';
            ToolTip = 'Specifies the description of the relation type.';
            FieldClass = FlowField;
            CalcFormula = lookup("SEW Contact Relation Type"."Description" where("Code" = field("Relation Type")));
            Editable = false;
        }

        field(6; "Contact No. to"; Code[20])
        {
            Caption = 'Contact No. to';
            ToolTip = 'Specifies the target contact number in the relation.';
            TableRelation = Contact where(Type = const("Contact Type"::Company));
            trigger OnValidate()
            begin
                ReverseEntry(Rec."Contact No. from", Rec."Contact No. to", Rec."Relation Type", Rec."Reverse Relation Type");
            end;

        }
        field(7; "Contact to"; Text[100])
        {
            Caption = 'Contact to';
            ToolTip = 'Specifies the name of the target contact.';
            FieldClass = FlowField;
            CalcFormula = lookup(Contact.Name where("No." = field("Contact No. to")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Contact No. from", "Relation Type", "Contact No. to", "Reverse Relation Type")
        {
            Clustered = true;
        }
    }


    procedure ReverseEntry("xContactfrom": Code[20]; "xContactto": Code[20]; "xRelationType": Code[20]; "xReverseRelationType": Code[20])
    var
        SEWContactRelations: Record "SEW Contact Relations";
    begin
        //insert Reverse Entry
        if "xContactfrom" = '' then exit;
        if "xContactto" = '' then exit;
        if "xRelationType" = '' then exit;
        if "xReverseRelationType" = '' then exit;

        SEWContactRelations.Reset();
        SEWContactRelations.SetRange("Contact No. from", "xContactto");
        SEWContactRelations.SetRange("Contact No. to", "xContactfrom");
        SEWContactRelations.SetRange("Relation Type", "xReverseRelationType");
        SEWContactRelations.SetRange("Reverse Relation Type", "xRelationType");
        if not SEWContactRelations.FindFirst() then begin
            SEWContactRelations.Init();
            SEWContactRelations."Contact No. from" := "xContactto";
            SEWContactRelations."Contact No. to" := "xContactfrom";
            SEWContactRelations."Relation Type" := "xReverseRelationType";
            SEWContactRelations."Reverse Relation Type" := "xRelationType";
            SEWContactRelations.Insert(false);
        end;
    end;



    trigger OnDelete()
    var
        SEWContactRelations: Record "SEW Contact Relations";
    begin
        //delete Reverse Entry
        if Rec."Contact No. from" = '' then exit;
        if Rec."Contact No. to" = '' then exit;
        if Rec."Relation Type" = '' then exit;
        if Rec."Reverse Relation Type" = '' then exit;

        SEWContactRelations.Reset();
        SEWContactRelations.SetRange("Contact No. from", Rec."Contact No. from");
        SEWContactRelations.SetRange("Contact No. to", Rec."Contact No. to");
        SEWContactRelations.SetRange("Relation Type", Rec."Relation Type");
        SEWContactRelations.SetRange("Reverse Relation Type", Rec."Reverse Relation Type");
        if SEWContactRelations.FindFirst() then
            SEWContactRelations.Delete();

        SEWContactRelations.Reset();
        SEWContactRelations.SetRange("Contact No. from", Rec."Contact No. to");
        SEWContactRelations.SetRange("Contact No. to", Rec."Contact No. from");
        SEWContactRelations.SetRange("Relation Type", Rec."Reverse Relation Type");
        SEWContactRelations.SetRange("Reverse Relation Type", Rec."Relation Type");
        if SEWContactRelations.FindFirst() then
            SEWContactRelations.Delete();

    end;


}
