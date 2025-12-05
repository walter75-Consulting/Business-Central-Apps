page 90000 "SEW OAuth Applications"
{
    ApplicationArea = All;
    Caption = 'OAuth 2.0 Applications';
    CardPageId = "SEW OAuth Application";
    //Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "SEW OAuth Application";
    UsageCategory = Lists;



    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field("Code"; Rec.Code) { }
                field(Description; Rec.Description) { }
                field(Status; Rec.Status) { }
            }
        }
    }
}
