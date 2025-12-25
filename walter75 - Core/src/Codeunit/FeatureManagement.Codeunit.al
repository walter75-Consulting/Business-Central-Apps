/// <summary>
/// Feature toggle validation and management with 10-minute auto-refresh cache.
/// Always enabled with no configuration required.
/// </summary>
codeunit 71300 "SEW Feature Management"
{
    SingleInstance = true;
    Permissions = tabledata "SEW Feature" = rimd;

    var
        FeatureCache: Dictionary of [Code[50], Boolean];
        LastRefreshMinute: Integer;
        CacheInitialized: Boolean;

    /// <summary>
    /// Check if feature is enabled (with automatic 10-minute cache refresh).
    /// </summary>
    /// <param name="FeatureCode">Feature code to check.</param>
    /// <returns>True if feature is enabled, false otherwise.</returns>
    procedure IsFeatureEnabled(FeatureCode: Code[50]): Boolean
    var
        IsEnabled: Boolean;
        IsHandled: Boolean;
    begin
        // Initialize cache on first call
        if not CacheInitialized then
            RefreshCache();

        // Auto-refresh every 10 minutes
        if (Time2Minute(Time()) div 10) <> LastRefreshMinute then
            RefreshCache();

        // Get cached value
        if FeatureCache.ContainsKey(FeatureCode) then
            IsEnabled := FeatureCache.Get(FeatureCode)
        else
            IsEnabled := false;

        // Allow extensions to override (Phase 3: License check)
        OnBeforeFeatureValidation(FeatureCode, IsEnabled, IsHandled);
        if IsHandled then
            exit(IsEnabled);

        exit(IsEnabled);
    end;

    /// <summary>
    /// Enable a feature (admin action with immediate cache update).
    /// </summary>
    /// <param name="FeatureCode">Feature code to enable.</param>
    procedure EnableFeature(FeatureCode: Code[50])
    var
        SEWFeature: Record "SEW Feature";
        FeatureNotFoundErr: Label 'Feature %1 not found.', Comment = 'DE="Feature %1 nicht gefunden."';
    begin
        if not SEWFeature.Get(FeatureCode) then
            Error(FeatureNotFoundErr, FeatureCode);

        SEWFeature.Enabled := true;
        SEWFeature."Activation Date" := CurrentDateTime();
        SEWFeature."Activation User" := CopyStr(UserId(), 1, MaxStrLen(SEWFeature."Activation User"));
        SEWFeature.Modify(true);

        // Update cache immediately
        UpdateCacheEntry(FeatureCode, true);

        OnAfterFeatureStateChanged(FeatureCode, true);
    end;

    /// <summary>
    /// Disable a feature (admin action with immediate cache update).
    /// </summary>
    /// <param name="FeatureCode">Feature code to disable.</param>
    procedure DisableFeature(FeatureCode: Code[50])
    var
        SEWFeature: Record "SEW Feature";
        FeatureNotFoundErr: Label 'Feature %1 not found.', Comment = 'DE="Feature %1 nicht gefunden."';
    begin
        if not SEWFeature.Get(FeatureCode) then
            Error(FeatureNotFoundErr, FeatureCode);

        SEWFeature.Enabled := false;
        SEWFeature.Modify(true);

        // Update cache immediately
        UpdateCacheEntry(FeatureCode, false);

        OnAfterFeatureStateChanged(FeatureCode, false);
    end;

    /// <summary>
    /// Force cache refresh (called automatically every 10 minutes, or manually by admin).
    /// </summary>
    procedure RefreshCache()
    var
        SEWFeature: Record "SEW Feature";
    begin
        Clear(FeatureCache);

        if SEWFeature.FindSet() then
            repeat
                FeatureCache.Add(SEWFeature.Code, SEWFeature.Enabled);
            until SEWFeature.Next() = 0;

        LastRefreshMinute := Time2Minute(Time()) div 10;
        CacheInitialized := true;
    end;

    /// <summary>
    /// Validate feature access (throws error if feature is disabled).
    /// </summary>
    /// <param name="FeatureCode">Feature code to validate.</param>
    procedure ValidateFeatureAccess(FeatureCode: Code[50])
    var
        SEWFeature: Record "SEW Feature";
        FeatureDisabledErr: Label 'Feature "%1" is currently disabled. Contact your administrator.', Comment = 'DE="Feature \"%1\" ist derzeit deaktiviert. Kontaktieren Sie Ihren Administrator."';
        FeatureNotAvailableErr: Label 'Feature %1 is not available.', Comment = 'DE="Feature %1 ist nicht verfügbar."';
    begin
        if not IsFeatureEnabled(FeatureCode) then
            if SEWFeature.Get(FeatureCode) then
                Error(FeatureDisabledErr, SEWFeature."Feature Name")
            else
                Error(FeatureNotAvailableErr, FeatureCode);
    end;

    /// <summary>
    /// Register a feature (called by Install codeunits).
    /// </summary>
    /// <param name="FeatureCode">Unique feature code (e.g., "BASE-EXPLODE-BOM").</param>
    /// <param name="AppName">App name that owns this feature.</param>
    /// <param name="FeatureName">Display name of the feature.</param>
    /// <param name="Description">Feature description.</param>
    /// <param name="DefaultEnabled">Default enabled state.</param>
    procedure RegisterFeature(FeatureCode: Code[50]; AppName: Text[100]; FeatureName: Text[100]; Description: Text[250]; DefaultEnabled: Boolean)
    var
        SEWFeature: Record "SEW Feature";
    begin
        if SEWFeature.Get(FeatureCode) then
            exit; // Already registered

        SEWFeature.Init();
        SEWFeature.Code := FeatureCode;
        SEWFeature."App Name" := AppName;
        SEWFeature."Feature Name" := FeatureName;
        SEWFeature.Description := Description;
        SEWFeature.Enabled := DefaultEnabled;
        SEWFeature."Default State" := DefaultEnabled;
        SEWFeature.Insert(true);

        // Add to cache immediately
        UpdateCacheEntry(FeatureCode, DefaultEnabled);
    end;

    /// <summary>
    /// Get all features for a specific app.
    /// </summary>
    /// <param name="AppName">App name to filter by.</param>
    /// <returns>Features for the specified app.</returns>
    procedure GetFeaturesByApp(AppName: Text[100]) Features: Record "SEW Feature"
    begin
        Features.SetRange("App Name", AppName);
        exit(Features);
    end;

    /// <summary>
    /// Get cache statistics.
    /// </summary>
    /// <param name="EntryCount">Number of cached features.</param>
    /// <param name="LastRefreshTime">When cache was last refreshed (calculated).</param>
    procedure GetCacheInfo(var EntryCount: Integer; var LastRefreshTime: Text)
    var
        LastRefreshLbl: Label 'Last refresh: 10-minute interval %1', Comment = 'DE="Letzte Aktualisierung: 10-Minuten-Intervall %1"';
    begin
        EntryCount := FeatureCache.Count();
        LastRefreshTime := StrSubstNo(LastRefreshLbl, LastRefreshMinute);
    end;

    local procedure UpdateCacheEntry(FeatureCode: Code[50]; NewState: Boolean)
    begin
        if FeatureCache.ContainsKey(FeatureCode) then
            FeatureCache.Set(FeatureCode, NewState)
        else
            FeatureCache.Add(FeatureCode, NewState);
    end;

    local procedure Time2Minute(TimeValue: Time): Integer
    var
        DT: DateTime;
    begin
        // Convert Time to minutes since midnight
        // Time is stored as milliseconds since midnight (0T = 0, 23:59:59.999 = 86399999)
        DT := CreateDateTime(Today(), TimeValue);
        exit((DT - CreateDateTime(Today(), 0T)) div 60000);
    end;

    /// <summary>
    /// Integration event fired before feature validation.
    /// Allows Phase 3 licensing to override feature state.
    /// </summary>
    /// <param name="FeatureCode">Feature being validated.</param>
    /// <param name="IsEnabled">Current enabled state (can be modified).</param>
    /// <param name="IsHandled">Set to true to override default behavior.</param>
    [IntegrationEvent(false, false)]
    local procedure OnBeforeFeatureValidation(FeatureCode: Code[50]; var IsEnabled: Boolean; var IsHandled: Boolean)
    begin
    end;

    /// <summary>
    /// Integration event fired after feature state changes.
    /// </summary>
    /// <param name="FeatureCode">Feature that changed.</param>
    /// <param name="NewState">New enabled state.</param>
    [IntegrationEvent(false, false)]
    local procedure OnAfterFeatureStateChanged(FeatureCode: Code[50]; NewState: Boolean)
    begin
    end;
}
