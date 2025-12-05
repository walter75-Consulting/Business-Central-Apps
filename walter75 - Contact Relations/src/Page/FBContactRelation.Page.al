page 91302 "SEW FB Contact Relation"
{
    ApplicationArea = All;
    Caption = 'SEW FactBox Contact Relation';
    PageType = ListPart;
    SourceTable = "SEW Contact Relations";
    Editable = false;



    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Relation Description"; Rec."Relation Description")
                {
                }
                field("Contact to"; Rec."Contact to")
                {
                }
            }
        }
    }
}
