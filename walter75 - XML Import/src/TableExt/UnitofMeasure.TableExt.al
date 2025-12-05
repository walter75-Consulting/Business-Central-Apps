tableextension 60502 "SEW Unit of Measure" extends "Unit of Measure"
{
    fields
    {
        field(50000; "SEW SAP Code"; Code[10])
        {
            Caption = 'SAP Code';
            ToolTip = 'Specifies the SAP code associated with the unit of measure.';
            DataClassification = ToBeClassified;
            AllowInCustomizations = Never;
        }
    }
}
