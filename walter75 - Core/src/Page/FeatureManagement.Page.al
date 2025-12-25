/// <summary>
/// Admin page to enable/disable features across all SEW applications.
/// </summary>
page 71300 "SEW Feature Management"
{
    PageType = List;
    SourceTable = "SEW Feature";
    Caption = 'Feature Management';
    UsageCategory = Administration;
    ApplicationArea = All;
    CardPageId = "SEW Feature Card";

    layout
    {
        area(Content)
        {
            repeater(Features)
            {
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
                }
                field(Enabled; Rec.Enabled)
                {
                }
                field("Requires License"; Rec."Requires License")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Activation Date"; Rec."Activation Date")
                {
                    Editable = false;
                }
                field("Activation User"; Rec."Activation User")
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
            action(EnableFeature)
            {
                Caption = 'Enable Feature';
                ToolTip = 'Enable the selected feature. Your session updates immediately, others within 10 minutes.';
                Image = Approve;


                trigger OnAction()
                var
                    FeatureMgmt: Codeunit "SEW Feature Management";
                begin
                    FeatureMgmt.EnableFeature(Rec.Code);
                    CurrPage.Update(false);
                    Message('Feature "%1" enabled. Your session updated immediately. Other users will see the change within 10 minutes.', Rec."Feature Name");
                end;
            }
            action(DisableFeature)
            {
                Caption = 'Disable Feature';
                ToolTip = 'Disable the selected feature. Your session updates immediately, others within 10 minutes.';
                Image = Cancel;

                trigger OnAction()
                var
                    FeatureMgmt: Codeunit "SEW Feature Management";
                begin
                    if not Confirm('Disable feature "%1"?', false, Rec."Feature Name") then
                        exit;

                    FeatureMgmt.DisableFeature(Rec.Code);
                    CurrPage.Update(false);
                    Message('Feature "%1" disabled. Your session updated immediately. Other users will see the change within 10 minutes.', Rec."Feature Name");
                end;
            }
            action(RefreshCache)
            {
                Caption = 'Refresh Cache';
                ToolTip = 'Reload feature cache from database. Normally refreshes automatically every 10 minutes.';
                Image = Refresh;

                trigger OnAction()
                var
                    FeatureMgmt: Codeunit "SEW Feature Management";
                begin
                    FeatureMgmt.RefreshCache();
                    Message('Feature cache refreshed in your session. Other active user sessions will auto-refresh within 10 minutes.');
                end;
            }
            action(EnableAll)
            {
                Caption = 'Enable All for App';
                ToolTip = 'Enable all features for the selected app.';
                Image = EnableAllBreakpoints;

                trigger OnAction()
                var
                    Feature: Record "SEW Feature";
                    FeatureMgmt: Codeunit "SEW Feature Management";
                    Count: Integer;
                    SelectFeatureErr: Label 'Select a feature first.', Comment = 'DE="Wählen Sie zuerst ein Feature aus."';
                begin
                    if Rec."App Name" = '' then
                        Error(SelectFeatureErr);

                    if not Confirm('Enable all features for app "%1"?', false, Rec."App Name") then
                        exit;

                    Feature.SetRange("App Name", Rec."App Name");
                    if Feature.FindSet() then
                        repeat
                            if not Feature.Enabled then begin
                                FeatureMgmt.EnableFeature(Feature.Code);
                                Count += 1;
                            end;
                        until Feature.Next() = 0;

                    CurrPage.Update(false);
                    Message('%1 features enabled for %2.', Count, Rec."App Name");
                end;
            }
            action(DisableAll)
            {
                Caption = 'Disable All for App';
                ToolTip = 'Disable all features for the selected app.';
                Image = DisableAllBreakpoints;

                trigger OnAction()
                var
                    Feature: Record "SEW Feature";
                    FeatureMgmt: Codeunit "SEW Feature Management";
                    Count: Integer;
                    SelectFeatureErr: Label 'Select a feature first.', Comment = 'DE="Wählen Sie zuerst ein Feature aus."';
                begin
                    if Rec."App Name" = '' then
                        Error(SelectFeatureErr);

                    if not Confirm('Disable all features for app "%1"?', false, Rec."App Name") then
                        exit;

                    Feature.SetRange("App Name", Rec."App Name");
                    if Feature.FindSet() then
                        repeat
                            if Feature.Enabled then begin
                                FeatureMgmt.DisableFeature(Feature.Code);
                                Count += 1;
                            end;
                        until Feature.Next() = 0;

                    CurrPage.Update(false);
                    Message('%1 features disabled for %2.', Count, Rec."App Name");
                end;
            }
            action(ResetToDefault)
            {
                Caption = 'Reset to Default';
                ToolTip = 'Reset the selected feature to its default enabled state.';
                Image = Restore;

                trigger OnAction()
                var
                    FeatureMgmt: Codeunit "SEW Feature Management";
                begin
                    if Rec."Default State" then
                        FeatureMgmt.EnableFeature(Rec.Code)
                    else
                        FeatureMgmt.DisableFeature(Rec.Code);

                    CurrPage.Update(false);
                    Message('Feature "%1" reset to default state: %2.', Rec."Feature Name", Rec."Default State");
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(EnableFeature_Promoted; EnableFeature) { }
                actionref(DisableFeature_Promoted; DisableFeature) { }
                actionref(RefreshCache_Promoted; RefreshCache) { }
            }
        }
    }
}
