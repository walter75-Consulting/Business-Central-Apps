table 90703 "SEW Package Setup"
{
    Caption = 'Package Setup';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Package Setup";
    DrillDownPageId = "SEW Package Setup";
    Extensible = true;


    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            ToolTip = 'Specifies the code.';
            NotBlank = true;
            AllowInCustomizations = Never;
        }

        // field(70350; "SEW Shipment Activity Nos."; Code[20])
        // {
        //     Caption = 'Shipment Activity Nos.';
        //     ToolTip = 'Specifies the Shipment Activity Nos.';
        //     TableRelation = "No. Series";
        // }
        // field(70351; "SEW Parcel Nos."; Code[20])
        // {
        //     Caption = 'Parcel Nos.';
        //     ToolTip = 'Specifies the Parcel Nos.';
        //     TableRelation = "No. Series";
        // }
        // field(70352; "SEW Parcel with pack slip"; Boolean)
        // {
        //     Caption = 'Parcel with pack slip?';
        //     ToolTip = 'Specifies if the parcel has a pack slip.';
        // }


    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code") { }
        fieldgroup(Brick; "Code") { }
    }


    /// <summary>
    /// Ensures a package setup record exists in the table by creating one if it doesn't exist.
    /// This is typically called during installation or first-time setup.
    /// </summary>
    /// <example>
    /// var
    ///     PackageSetup: Record "SEW Package Setup";
    /// begin
    ///     PackageSetup.InsertIfNotExists();
    /// end;
    /// </example>
    procedure InsertIfNotExists()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;


}