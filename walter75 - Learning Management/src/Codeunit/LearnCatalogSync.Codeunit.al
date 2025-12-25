/// <summary>
/// Codeunit SEW Learn Catalog Sync (ID 91860).
/// Synchronizes Microsoft Learn catalog from API.
/// </summary>
codeunit 91860 "SEW Learn Catalog Sync"
{
    Permissions =
    tabledata "SEW Learn Cont" = rimd,
    tabledata "SEW Learn Cont Path Mod" = rimd,
    tabledata "SEW Learn Cont Levels" = rimd,
    tabledata "SEW Learn Cont Roles" = rimd,
    tabledata "SEW Learn Cont Subjects" = rimd,
    tabledata "SEW Learn Cont Levels Map" = rimd,
    tabledata "SEW Learn Cont Roles Map" = rimd,
    tabledata "SEW Learn Cont Subjects Map" = rimd,
    tabledata "SEW Learning Mgmt Setup" = r;

    /// <summary>
    /// Main entry point for full catalog synchronization.
    /// </summary>
    procedure SyncFullCatalog()
    var
        Setup: Record "SEW Learning Mgmt Setup";
        JsonResponse: Text;
        ModulesAdded: Integer;
        PathsAdded: Integer;
        ModulesUpdated: Integer;
        PathsUpdated: Integer;
        StartTime: DateTime;
    begin
        StartTime := CurrentDateTime;

        if not Setup.Get() then begin
            Setup.InsertIfNotExists();
            Setup.Get();
        end;

        // Fetch from API
        if not FetchFromAPI(JsonResponse) then
            Error(SyncFailedErr);

        // Parse and upsert modules and paths
        ParseAndUpsertModules(JsonResponse, ModulesAdded, ModulesUpdated);
        ParseAndUpsertPaths(JsonResponse, PathsAdded, PathsUpdated);

        // Update setup
        Setup."Last Sync Date Time" := CurrentDateTime;
        Setup.Modify(true);

        // Detect content changes
        DetectContentChanges();

        // Fire event
        OnAfterSyncComplete(ModulesAdded, PathsAdded, ModulesUpdated, PathsUpdated);

        Message(SyncCompleteMsg,
          ModulesAdded, ModulesUpdated, PathsAdded, PathsUpdated,
          CurrentDateTime - StartTime);
    end;

    local procedure FetchFromAPI(var JsonResponse: Text): Boolean
    var
        Setup: Record "SEW Learning Mgmt Setup";
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        FullUrl: Text;
    begin
        Setup.Get();
        FullUrl := Setup.GetFullAPIUrl();

        Client.SetBaseAddress(FullUrl);
        Client.DefaultRequestHeaders().Add('User-Agent', 'BC-Learning-Management/1.0');

        if not Client.Get('', ResponseMessage) then
            exit(false);

        if not ResponseMessage.IsSuccessStatusCode() then
            exit(false);

        ResponseMessage.Content().ReadAs(JsonResponse);
        exit(true);
    end;

    local procedure ParseAndUpsertModules(JsonResponse: Text; var ModulesAdded: Integer; var ModulesUpdated: Integer)
    var
        RootJson: JsonObject;
        ModulesToken: JsonToken;
        ModulesArray: JsonArray;
        ModuleToken: JsonToken;
        ModuleObject: JsonObject;
    begin
        if not RootJson.ReadFrom(JsonResponse) then
            exit;

        if not RootJson.Get('modules', ModulesToken) then
            exit;

        ModulesArray := ModulesToken.AsArray();

        foreach ModuleToken in ModulesArray do begin
            ModuleObject := ModuleToken.AsObject();
            if UpsertModule(ModuleObject) then
                ModulesAdded += 1
            else
                ModulesUpdated += 1;
        end;
    end;

    local procedure ParseAndUpsertPaths(JsonResponse: Text; var PathsAdded: Integer; var PathsUpdated: Integer)
    var
        RootJson: JsonObject;
        PathsToken: JsonToken;
        PathsArray: JsonArray;
        PathToken: JsonToken;
        PathObject: JsonObject;
    begin
        if not RootJson.ReadFrom(JsonResponse) then
            exit;

        if not RootJson.Get('learningPaths', PathsToken) then
            exit;

        PathsArray := PathsToken.AsArray();

        foreach PathToken in PathsArray do begin
            PathObject := PathToken.AsObject();
            if UpsertLearningPath(PathObject) then
                PathsAdded += 1
            else
                PathsUpdated += 1;
        end;
    end;

    local procedure UpsertModule(ModuleJson: JsonObject): Boolean
    begin
        exit(UpsertContent(ModuleJson, "SEW Learning Content Type"::Module));
    end;

    local procedure UpsertLearningPath(PathJson: JsonObject): Boolean
    begin
        exit(UpsertContent(PathJson, "SEW Learning Content Type"::"Learning Path"));
    end;

    local procedure UpsertContent(ContentJson: JsonObject; ContentType: Enum "SEW Learning Content Type"): Boolean
    var
        LearningContent: Record "SEW Learn Cont";
        UID: Code[100];
        IsHandled: Boolean;
        IsNew: Boolean;
    begin
        if ContentType = ContentType::Module then begin
            OnBeforeUpsertModule(ContentJson, IsHandled);
            if IsHandled then
                exit(true);
        end;

        UID := GetJsonText(ContentJson, 'uid');
        if UID = '' then
            exit(false);

        IsNew := not LearningContent.Get(UID);

        if IsNew then
            LearningContent.Init();

        LearningContent.UID := UID;
        LearningContent."Content Type" := ContentType;
        LearningContent.Title := CopyStr(GetJsonText(ContentJson, 'title'), 1, MaxStrLen(LearningContent.Title));
        LearningContent.Summary := CopyStr(GetJsonText(ContentJson, 'summary'), 1, MaxStrLen(LearningContent.Summary));
        LearningContent."Duration in Minutes" := GetJsonInteger(ContentJson, 'duration_in_minutes');
        LearningContent."Icon URL" := CopyStr(GetJsonText(ContentJson, 'icon_url'), 1, MaxStrLen(LearningContent."Icon URL"));
        LearningContent."Social Image URL" := CopyStr(GetJsonText(ContentJson, 'social_image_url'), 1, MaxStrLen(LearningContent."Social Image URL"));
        LearningContent.URL := CopyStr(GetJsonText(ContentJson, 'url'), 1, MaxStrLen(LearningContent.URL));

        if ContentType = ContentType::Module then
            LearningContent."First Child URL" := CopyStr(GetJsonText(ContentJson, 'firstUnitUrl'), 1, MaxStrLen(LearningContent."First Child URL"))
        else
            LearningContent."First Child URL" := CopyStr(GetJsonText(ContentJson, 'firstModuleUrl'), 1, MaxStrLen(LearningContent."First Child URL"));

        LearningContent."Last Modified" := GetJsonDateTime(ContentJson, 'last_modified');
        //LearningContent."Number of Children" := GetJsonInteger(ContentJson, 'number_of_children');
        LearningContent.Locale := CopyStr(GetJsonText(ContentJson, 'locale'), 1, MaxStrLen(LearningContent.Locale));
        LearningContent."Catalog Hash" := CalculateContentHash(ContentJson);

        // Rating
        LearningContent."Rating Count" := GetJsonInteger(ContentJson, 'rating.count');
        LearningContent."Rating Average" := GetJsonDecimal(ContentJson, 'rating.average');
        LearningContent.Popularity := GetJsonDecimal(ContentJson, 'popularity');

        if IsNew then
            LearningContent.Insert(true)
        else
            LearningContent.Modify(true);

        // Update relationships
        UpdateContentLevels(UID, ContentJson);
        UpdateContentRoles(UID, ContentJson);
        UpdateContentSubjects(UID, ContentJson);

        // Link modules for learning paths
        if ContentType = ContentType::"Learning Path" then
            LinkPathToModules(UID, ContentJson);

        exit(IsNew);
    end;

    local procedure UpdateContentLevels(ContentUID: Code[100]; ContentJson: JsonObject)
    var
        Level: Record "SEW Learn Cont Levels";
        LevelMapping: Record "SEW Learn Cont Levels Map";
        LevelsToken: JsonToken;
        LevelsArray: JsonArray;
        LevelToken: JsonToken;
        LevelCode: Code[20];
    begin
        // Delete existing mappings for this content
        LevelMapping.SetRange("Content UID", ContentUID);
        LevelMapping.DeleteAll(true);

        if ContentJson.Get('levels', LevelsToken) then begin
            LevelsArray := LevelsToken.AsArray();
            foreach LevelToken in LevelsArray do begin
                LevelCode := CopyStr(LevelToken.AsValue().AsText(), 1, 20);

                // Upsert master level data
                if not Level.Get(LevelCode) then begin
                    Level.Init();
                    Level.Code := LevelCode;
                    Level.Name := LevelCode; // Default name = code, can be changed by user
                    Level.Insert(true);
                end;

                // Create mapping
                LevelMapping.Init();
                LevelMapping."Content UID" := ContentUID;
                LevelMapping."Level Code" := LevelCode;
                LevelMapping.Insert(true);
            end;
        end;
    end;

    local procedure UpdateContentRoles(ContentUID: Code[100]; ContentJson: JsonObject)
    var
        Role: Record "SEW Learn Cont Roles";
        RoleMapping: Record "SEW Learn Cont Roles Map";
        RolesToken: JsonToken;
        RolesArray: JsonArray;
        RoleToken: JsonToken;
        RoleCode: Code[50];
    begin
        // Delete existing mappings for this content
        RoleMapping.SetRange("Content UID", ContentUID);
        RoleMapping.DeleteAll(true);

        if ContentJson.Get('roles', RolesToken) then begin
            RolesArray := RolesToken.AsArray();
            foreach RoleToken in RolesArray do begin
                RoleCode := CopyStr(RoleToken.AsValue().AsText(), 1, 50);

                // Upsert master role data
                if not Role.Get(RoleCode) then begin
                    Role.Init();
                    Role.Code := RoleCode;
                    Role.Name := RoleCode; // Default name = code, can be changed by user
                    Role.Insert(true);
                end;

                // Create mapping
                RoleMapping.Init();
                RoleMapping."Content UID" := ContentUID;
                RoleMapping."Role Code" := RoleCode;
                RoleMapping.Insert(true);
            end;
        end;
    end;

    local procedure UpdateContentSubjects(ContentUID: Code[100]; ContentJson: JsonObject)
    var
        Subject: Record "SEW Learn Cont Subjects";
        SubjectMapping: Record "SEW Learn Cont Subjects Map";
        SubjectsToken: JsonToken;
        SubjectsArray: JsonArray;
        SubjectToken: JsonToken;
        SubjectCode: Code[50];
    begin
        // Delete existing mappings for this content
        SubjectMapping.SetRange("Content UID", ContentUID);
        SubjectMapping.DeleteAll(true);

        if ContentJson.Get('subjects', SubjectsToken) then begin
            SubjectsArray := SubjectsToken.AsArray();
            foreach SubjectToken in SubjectsArray do begin
                SubjectCode := CopyStr(SubjectToken.AsValue().AsText(), 1, 50);

                // Upsert master subject data
                if not Subject.Get(SubjectCode) then begin
                    Subject.Init();
                    Subject.Code := SubjectCode;
                    Subject.Name := SubjectCode; // Default name = code, can be changed by user
                    Subject.Insert(true);
                end;

                // Create mapping
                SubjectMapping.Init();
                SubjectMapping."Content UID" := ContentUID;
                SubjectMapping."Subject Code" := SubjectCode;
                SubjectMapping.Insert(true);
            end;
        end;
    end;

    local procedure LinkPathToModules(PathUID: Code[100]; PathJson: JsonObject)
    var
        PathModule: Record "SEW Learn Cont Path Mod";
        ModulesToken: JsonToken;
        ModulesArray: JsonArray;
        ModuleToken: JsonToken;
        ModuleUID: Text;
        Sequence: Integer;
    begin
        PathModule.SetRange("Learning Path UID", PathUID);
        PathModule.DeleteAll(true);

        if PathJson.Get('modules', ModulesToken) then begin
            ModulesArray := ModulesToken.AsArray();
            Sequence := 0;
            foreach ModuleToken in ModulesArray do begin
                Sequence += 1;
                ModuleUID := ModuleToken.AsValue().AsText();
                PathModule.Init();
                PathModule."Learning Path UID" := PathUID;
                PathModule.Sequence := Sequence;
                PathModule."Module UID" := CopyStr(ModuleUID, 1, MaxStrLen(PathModule."Module UID"));
                PathModule.Insert(true);
            end;
        end;
    end;

    local procedure CalculateContentHash(JsonObject: JsonObject): Code[50]
    var
        JsonText: Text;
    begin
        JsonObject.WriteTo(JsonText);
        exit(CopyStr(Format(GetHashCode(JsonText)), 1, 50));
    end;

    local procedure GetHashCode(InputText: Text): Integer
    var
        i: Integer;
        HashValue: Integer;
        CharValue: Integer;
    begin
        HashValue := 0;
        for i := 1 to StrLen(InputText) do begin
            CharValue := InputText[i];
            HashValue := ((HashValue mod 69997) * 31 + CharValue) mod 2147483647;
        end;
        exit(HashValue);
    end;

    local procedure GetJsonText(JsonObject: JsonObject; KeyName: Text): Text
    var
        Token: JsonToken;
    begin
        if JsonObject.Get(KeyName, Token) then
            if Token.IsValue() then
                exit(Token.AsValue().AsText());
        exit('');
    end;

    local procedure GetJsonInteger(JsonObject: JsonObject; KeyName: Text): Integer
    var
        Token: JsonToken;
        IntValue: Integer;
    begin
        if JsonObject.Get(KeyName, Token) then
            if Token.IsValue() then
                if Evaluate(IntValue, Token.AsValue().AsText()) then
                    exit(IntValue);
        exit(0);
    end;

    local procedure GetJsonDecimal(JsonObject: JsonObject; KeyName: Text): Decimal
    var
        Token: JsonToken;
        DecValue: Decimal;
    begin
        if JsonObject.Get(KeyName, Token) then
            if Token.IsValue() then
                if Evaluate(DecValue, Token.AsValue().AsText()) then
                    exit(DecValue);
        exit(0);
    end;

    local procedure GetJsonDateTime(JsonObject: JsonObject; KeyName: Text): DateTime
    var
        Token: JsonToken;
        DateTimeText: Text;
        ResultDateTime: DateTime;
    begin
        if JsonObject.Get(KeyName, Token) then
            if Token.IsValue() then begin
                DateTimeText := Token.AsValue().AsText();
                if Evaluate(ResultDateTime, DateTimeText, 9) then
                    exit(ResultDateTime);
            end;
        exit(0DT);
    end;

    local procedure DetectContentChanges()
    var
        ChangeDetector: Codeunit "SEW Content Change Detector";
    begin
        ChangeDetector.DetectChanges();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpsertModule(ModuleJson: JsonObject; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSyncComplete(ModulesAdded: Integer; PathsAdded: Integer; ModulesUpdated: Integer; PathsUpdated: Integer)
    begin
    end;

    var
        SyncFailedErr: Label 'Failed to synchronize catalog. Please check your API settings and try again.';
        SyncCompleteMsg: Label 'Catalog synchronized successfully.\Modules: %1 added, %2 updated\Learning Paths: %3 added, %4 updated\Duration: %5';
}
