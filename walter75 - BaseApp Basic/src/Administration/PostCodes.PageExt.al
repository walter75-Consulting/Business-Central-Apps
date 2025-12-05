pageextension 80044 "SEW Post Codes" extends "Post Codes"
{
    actions
    {
        addfirst(Processing)
        {
            action("SEW ImportPostCodeDE")
            {
                ApplicationArea = All;
                Caption = 'Import DE Postcodes';
                ToolTip = 'Import DE Postcodes.';
                Image = SparkleFilled;

                trigger OnAction()
                begin
                    this.SEWPostCodes('DE');
                end;
            }
            action("SEW ImportPostCodeAT")
            {
                ApplicationArea = All;
                Caption = 'Import AT Postcodes';
                ToolTip = 'Import AT Postcodes.';
                Image = SparkleFilled;

                trigger OnAction()
                begin
                    this.SEWPostCodes('AT');
                end;
            }
            action("SEW ImportPostCodeCH")
            {
                ApplicationArea = All;
                Caption = 'Import CH Postcodes';
                ToolTip = 'Import CH Postcodes.';
                Image = SparkleFilled;

                trigger OnAction()
                begin
                    this.SEWPostCodes('CH');
                end;
            }
        }
    }

    local procedure SEWPostCodes(SEWCountryCode: Code[10])
    var
        SEWResponseText: Text;
        SEWJsonArray: JsonArray;

        SEWJsonTokenLoop: JsonToken;
        SEWJsonObjectLoop: JsonObject;

        SEWJsonValue: JsonValue;

        SEWxPostCode: Code[20];
        SEWxcity: Text[30];
        SEWxRegion: Text[30];
    begin

        //SEWOverwrite := Confirm(SEWQuestionLbl, true);

        case SEWCountryCode of
            'DE':
                SEWResponseText := NavApp.GetResourceAsText('data/DE-PLZ.json', TextEncoding::UTF8);
            'AT':
                SEWResponseText := NavApp.GetResourceAsText('data/AT-PLZ.json', TextEncoding::UTF8);
            'CH':
                SEWResponseText := NavApp.GetResourceAsText('data/CH-PLZ.json', TextEncoding::UTF8);
        end;

        SEWJsonArray.ReadFrom(SEWResponseText);

        foreach SEWJsonTokenLoop in SEWJsonArray do begin
            SEWJsonObjectLoop := SEWJsonTokenLoop.AsObject();
            SEWxPostCode := '';
            SEWxcity := '';
            SEWxRegion := '';

            if SEWJsonObjectLoop.Get('plz', SEWJsonTokenLoop) then begin
                SEWJsonValue := SEWJsonTokenLoop.AsValue();
                SEWxPostCode := CopyStr(SEWJsonValue.AsText(), 1, MaxStrLen(SEWxPostCode));
            end;

            if SEWJsonObjectLoop.Get('ort', SEWJsonTokenLoop) then begin
                SEWJsonValue := SEWJsonTokenLoop.AsValue();
                SEWxcity := CopyStr(SEWJsonValue.AsText(), 1, MaxStrLen(SEWxcity));
            end;

            if SEWJsonObjectLoop.Get('bundesland', SEWJsonTokenLoop) then begin
                SEWJsonValue := SEWJsonTokenLoop.AsValue();
                SEWxRegion := CopyStr(SEWJsonValue.AsText(), 1, MaxStrLen(SEWxRegion));
            end;

            PostCodeCheck(SEWxPostCode, SEWxcity, SEWCountryCode, SEWxRegion);
        end;

    end;

    local procedure PostCodeCheck(xPostCode: Code[20]; xCity: Text[30]; xCountryCode: Code[10]; xRegion: Text[30])
    var
        PostCode: Record "Post Code";
    begin
        PostCode.Reset();
        PostCode.SetRange(Code, xPostCode);
        PostCode.SetRange("Country/Region Code", xCountryCode);
        PostCode.SetRange(City, xCity);


        if PostCode.FindSet(true) = false then begin
            PostCode.SetRange(City);
            if PostCode.FindSet(true) = false then begin
                PostCodeInsert(xPostCode, xCity, xCountryCode, xRegion);
                exit;
            end;
        end;

        if PostCode.FindSet(true) = true then
            if PostCode.Count() = 1 then begin
                PostCodeUpdate(PostCode, xRegion, '');
                exit;
            end;


        PostCode.SetRange(City);
        if PostCode.FindSet(true) = true then
            if PostCode.Count() = 1 then begin
                PostCodeUpdate(PostCode, xRegion, xCity);
                exit;
            end;

        if PostCode.Count() > 1 then begin
            repeat
                PostCode.Delete(false);
            until PostCode.Next() = 1;
            PostCodeUpdate(PostCode, xRegion, xCity);
            exit;
        end;



    end;


    local procedure PostCodeInsert(xPostCode: Code[20]; xCity: Text[30]; xCountryCode: Code[10]; xRegion: Text[30])
    var
        PostCode: Record "Post Code";
    begin
        PostCode.Init();
        PostCode.Code := xPostCode;
        PostCode.City := xCity;
        PostCode."Country/Region Code" := xCountryCode;
        PostCode.County := xRegion;
        PostCode."Time Zone" := 'W. Europe Standard Time';
        PostCode."Search City" := xCity;
        PostCode.Insert(true);
    end;

    local procedure PostCodeUpdate(var PostCode: Record "Post Code"; xRegion: Text[30]; xCity: Text[30])
    begin
        if xCity <> '' then
            PostCode.Validate(City, xCity);
        PostCode.Validate(County, xRegion);
        PostCode."Time Zone" := 'W. Europe Standard Time';
        PostCode.Modify(false);
    end;

}