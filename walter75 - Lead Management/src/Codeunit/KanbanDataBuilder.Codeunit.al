codeunit 91730 "SEW Kanban Data Builder"
{
    procedure BuildKanbanBoardJson(FilterText: Text): Text
    var
        Lead: Record "SEW Lead";
        LeadStatusEnum: Enum "SEW Lead Status";
        JsonObject: JsonObject;
        BoardsArray: JsonArray;
        BoardJson: JsonObject;
        ItemsArray: JsonArray;
        ItemJson: JsonObject;
        ResultText: Text;
        TempFilter: Text;
        StatusOrdinal: Integer;
        StatusCaption: Text[50];
        StatusCount: Integer;
    begin
        // Build JSON structure for jKanban using Status enum values:
        // { "boards": [ { "id": "New", "title": "New (5)", "item": [ {...}, {...} ] }, ... ] }

        // Iterate through all Status enum values
        for StatusOrdinal := 1 to 6 do begin // Skip value 0 (blank)
            Clear(ItemsArray);
            StatusCount := 0;

            // Convert ordinal to enum
            LeadStatusEnum := Enum::"SEW Lead Status".FromInteger(StatusOrdinal);
            StatusCaption := Format(LeadStatusEnum);

            // Get leads for this status
            Lead.Reset();

            // Apply additional filters FIRST if provided
            if FilterText <> '' then begin
                TempFilter := FilterText;
                Lead.SetView(TempFilter);
            end;

            // THEN apply the specific status filter on top
            Lead.SetRange(Status, LeadStatusEnum);

            // Build items array for this board
            if Lead.FindSet() then
                repeat
                    ItemJson := BuildLeadCardJson(Lead);
                    ItemsArray.Add(ItemJson);
                    StatusCount += 1;
                until Lead.Next() = 0;

            // Build board object (always show all status columns, even if empty)
            Clear(BoardJson);
            BoardJson.Add('id', StatusCaption);
            BoardJson.Add('title', StatusCaption + ' (' + Format(StatusCount) + ')');
            BoardJson.Add('item', ItemsArray);

            BoardsArray.Add(BoardJson);
        end;

        // Build root object
        JsonObject.Add('boards', BoardsArray);
        JsonObject.WriteTo(ResultText);

        exit(ResultText);
    end;

    local procedure BuildLeadCardJson(Lead: Record "SEW Lead"): JsonObject
    var
        ContactRec: Record Contact;
        ItemJson: JsonObject;
        CardHtml: Text;
        ScoreBandText: Text;
        ScoreBandClass: Text;
        ContactName: Text;
    begin
        // Build individual lead card JSON
        // jKanban expects: { "id": "unique-id", "title": "HTML content" }

        // Get contact name if linked
        ContactName := '';
        if Lead."Contact No." <> '' then
            if ContactRec.Get(Lead."Contact No.") then
                ContactName := ContactRec.Name
            else
                ContactName := Lead."Quick Company Name";

        if ContactName = '' then
            ContactName := Lead."Quick Company Name";

        // Determine score band styling
        case Lead."Score Band" of
            Lead."Score Band"::Hot:
                begin
                    ScoreBandText := 'HOT';
                    ScoreBandClass := 'hot';
                end;
            Lead."Score Band"::Warm:
                begin
                    ScoreBandText := 'WARM';
                    ScoreBandClass := 'warm';
                end;
            Lead."Score Band"::Cold:
                begin
                    ScoreBandText := 'COLD';
                    ScoreBandClass := 'cold';
                end;
            else begin
                ScoreBandText := '';
                ScoreBandClass := '';
            end;
        end;

        // Build HTML content for card
        CardHtml := '<div class="lead-card-title">' + ContactName + '</div>';
        CardHtml += '<div class="lead-card-info">Lead: ' + Lead."No." + '</div>';

        if Lead."Source Code" <> '' then
            CardHtml += '<div class="lead-card-info">Source: ' + Lead."Source Code" + '</div>';

        if Lead."Expected Revenue" <> 0 then
            CardHtml += '<div class="lead-card-info">Revenue: ' + Format(Lead."Expected Revenue", 0, '<Precision,2><Standard Format,0>') + '</div>';

        if ScoreBandText <> '' then
            CardHtml += '<div class="lead-card-score ' + ScoreBandClass + '">' + ScoreBandText + ' (' + Format(Lead."Score (Total)") + ')</div>';

        // Build JSON object
        ItemJson.Add('id', Lead."No.");
        ItemJson.Add('title', CardHtml);
        ItemJson.Add('class', 'score-' + LowerCase(ScoreBandClass)); // Add CSS class for border color

        exit(ItemJson);
    end;
}
