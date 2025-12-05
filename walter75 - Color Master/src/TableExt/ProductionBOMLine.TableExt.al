tableextension 91601 "SEW Production BOM Line" extends "Production BOM Line"
{
    fields
    {
        field(91600; "SEW Item Color Template"; Boolean)
        {
            Caption = 'Color Template';
            ToolTip = 'Specifies whether this line is part of a color template.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                SEWEventTable: Codeunit "SEW Event Table";
            begin
                SEWEventTable.ItemColorTemplateOnValidate(Rec);
            end;
        }
    }
}