/// <summary>
/// Detailed feature configuration card.
/// </summary>
page 71301 "SEW Feature Card"
{
    PageType = Card;
    SourceTable = "SEW Feature";
    Caption = 'Feature Details';
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec.Code)
                {
                    Editable = false;
                }
                field("App Name"; Rec."App Name")
                {
                    Editable = false;
                }
                field("Feature Name"; Rec."Feature Name")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    MultiLine = true;
                }
                field(Enabled; Rec.Enabled)
                {
                }
            }
            group(Licensing)
            {
                Caption = 'Licensing (Phase 3)';

                field("Requires License"; Rec."Requires License")
                {
                    Editable = false;
                }
                field("License Feature Code"; Rec."License Feature Code")
                {
                    Editable = false;
                }
            }
            group(Tracking)
            {
                Caption = 'Tracking';

                field("Default State"; Rec."Default State")
                {
                    Editable = false;
                }
                field("Activation Date"; Rec."Activation Date")
                {
                    Editable = false;
                }
                field("Activation User"; Rec."Activation User")
                {
                    Editable = false;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    Editable = false;
                }
                field("Last Modified User"; Rec."Last Modified User")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ToggleState)
            {
                Caption = 'Toggle State';
                ToolTip = 'Quick enable/disable toggle.';
                Image = SwitchCompanies;

                trigger OnAction()
                var
                    FeatureMgmt: Codeunit "SEW Feature Management";
                begin
                    if Rec.Enabled then
                        FeatureMgmt.DisableFeature(Rec.Code)
                    else
                        FeatureMgmt.EnableFeature(Rec.Code);

                    CurrPage.Update(false);
                end;
            }
            action(TestFeature)
            {
                Caption = 'Test Feature';
                ToolTip = 'Test if feature is currently enabled in your session.';
                Image = TestFile;

                trigger OnAction()
                var
                    FeatureMgmt: Codeunit "SEW Feature Management";
                begin
                    if FeatureMgmt.IsFeatureEnabled(Rec.Code) then
                        Message('Feature "%1" is ENABLED in your session.', Rec."Feature Name")
                    else
                        Message('Feature "%1" is DISABLED in your session.', Rec."Feature Name");
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(ToggleState_Promoted; ToggleState) { }
                actionref(TestFeature_Promoted; TestFeature) { }
            }
        }
    }
}
