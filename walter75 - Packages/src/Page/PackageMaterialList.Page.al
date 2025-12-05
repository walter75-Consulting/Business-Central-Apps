/// <summary>
/// page for listing and managing package materials used in SEW operations.
/// </summary>
page 90700 "SEW Package Material List"
{
    Caption = 'Package Material';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "SEW Package Material";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code) { }
                field(Description; Rec.Description) { }
                field(Length; Rec."Length cm") { }
                field(Width; Rec."Width cm") { }
                field(Height; Rec."Height cm") { }
                field(Cubage; Rec."Cubage cm3") { }
                field("Weight g"; Rec."Weight kg") { }

            }
        }
    }
}