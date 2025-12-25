/// <summary>
/// Table SEW Learning Content (ID 91810).
/// Stores Microsoft Learn modules and learning paths catalog synchronized from API.
/// </summary>
table 91810 "SEW Learn Cont"
{
    Caption = 'Learning Content';
    DataClassification = ToBeClassified;
    LookupPageId = "SEW Learn Cont List";
    DrillDownPageId = "SEW Learn Cont Card";
    Extensible = true;
    DataCaptionFields = "Content Type", Title;

    fields
    {
        field(1; UID; Code[100])
        {
            Caption = 'UID';
            ToolTip = 'Specifies the unique identifier from Microsoft Learn.';
            NotBlank = true;
        }
        field(2; "Content Type"; Enum "SEW Learning Content Type")
        {
            Caption = 'Content Type';
            ToolTip = 'Specifies whether this is a module or learning path.';
        }
        field(10; Title; Text[250])
        {
            Caption = 'Title';
            ToolTip = 'Specifies the title.';
        }
        field(11; Summary; Text[2048])
        {
            Caption = 'Summary';
            ToolTip = 'Specifies the description.';
        }
        field(20; "Duration in Minutes"; Integer)
        {
            Caption = 'Duration in Minutes';
            ToolTip = 'Specifies the estimated completion time.';
        }
        field(21; "Icon URL"; Text[250])
        {
            Caption = 'Icon URL';
            ToolTip = 'Specifies the URL to the icon.';
        }
        field(22; "Social Image URL"; Text[250])
        {
            Caption = 'Social Image URL';
            ToolTip = 'Specifies the URL to the social sharing image.';
        }
        field(30; URL; Text[250])
        {
            Caption = 'URL';
            ToolTip = 'Specifies the link to the content on Microsoft Learn.';
        }
        field(31; "First Child URL"; Text[250])
        {
            Caption = 'First Child URL';
            ToolTip = 'Specifies the link to the first unit (for modules) or first module (for learning paths).';
        }
        field(40; "Last Modified"; DateTime)
        {
            Caption = 'Last Modified';
            ToolTip = 'Specifies when the content was last updated on Microsoft Learn.';
        }
        field(41; "Number of Modules"; Integer)
        {
            Caption = 'Number of Modules';
            ToolTip = 'Specifies the number of modules in this learning path.';
            FieldClass = FlowField;
            CalcFormula = count("SEW Learn Cont Path Mod" where("Learning Path UID" = field(UID)));
            Editable = false;
        }
        field(42; "Number of Learning Paths"; Integer)
        {
            Caption = 'Number of Learning Paths';
            ToolTip = 'Specifies the number of learning paths for this module.';
            FieldClass = FlowField;
            CalcFormula = count("SEW Learn Cont Path Mod" where("Module UID" = field(UID)));
            Editable = false;
        }
        field(50; "Rating Count"; Integer)
        {
            Caption = 'Rating Count';
            ToolTip = 'Specifies the number of ratings on Microsoft Learn.';
        }
        field(51; "Rating Average"; Decimal)
        {
            Caption = 'Rating Average';
            ToolTip = 'Specifies the average rating on Microsoft Learn.';
            DecimalPlaces = 0 : 2;
        }
        field(52; Popularity; Decimal)
        {
            Caption = 'Popularity';
            ToolTip = 'Specifies the popularity score from Microsoft Learn.';
            DecimalPlaces = 0 : 4;
        }
        field(60; Locale; Code[10])
        {
            Caption = 'Locale';
            ToolTip = 'Specifies the language locale.';
        }
        field(61; "Catalog Hash"; Code[50])
        {
            Caption = 'Catalog Hash';
            ToolTip = 'Specifies the MD5 hash for change detection.';
        }
    }

    keys
    {
        key(PK; UID)
        {
            Clustered = true;
        }
        key(ContentType; "Content Type", Title)
        {
        }
        key(LastModified; "Last Modified")
        {
        }
        key(Title; Title)
        {
        }
    }

    /// <summary>
    /// Opens the content URL in the default browser.
    /// </summary>
    procedure OpenInBrowser()
    begin
        if Rec.URL <> '' then
            Hyperlink(Rec.URL);
    end;

    /// <summary>
    /// Gets the formatted duration as text.
    /// </summary>
    /// <returns>Duration in format "X hours Y minutes".</returns>
    procedure GetFormattedDuration(): Text
    var
        Hours: Integer;
        Minutes: Integer;
    begin
        if Rec."Duration in Minutes" = 0 then
            exit('');

        Hours := Rec."Duration in Minutes" div 60;
        Minutes := Rec."Duration in Minutes" mod 60;

        if Hours > 0 then
            exit(StrSubstNo('%1 hr %2 min', Hours, Minutes))
        else
            exit(StrSubstNo('%1 min', Minutes));
    end;
}
