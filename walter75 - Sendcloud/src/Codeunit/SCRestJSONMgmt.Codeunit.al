codeunit 95708 "SEW SC Rest JSON Mgmt"
{

    Permissions = tabledata "SEW Parcel" = rmi,
                    tabledata "SEW Carrier" = ri,
                    tabledata "Shipping Agent Services" = r,
                    tabledata "SEW Parcel Tracking" = rmi,
                    tabledata "SEW Carrier Ship Met" = rmi,
                    tabledata "SEW Carrier Ship Met Cntry" = rmi,
                    tabledata "SEW Carrier Ship Met Cntry Pri" = rmi;

    procedure CreateParcelPostObject(var SEWParcel: Record "SEW Parcel"; var request: Text; withLabelReqeust: Boolean): Text
    var
        JsonObjectRequest: JsonObject;
        JsonObjectParcel: JsonObject;
        JsonObjectShipment: JsonObject;
    begin
        if withLabelReqeust then begin
            JsonObjectParcel.Add('request_label', true);
            JsonObjectParcel.Add('request_label_async', true);
        end else begin
            JsonObjectParcel.Add('request_label', false);
            JsonObjectParcel.Add('request_label_async', false);
        end;

        //JsonObjectParcel.Add('contract', SEWParcel.Name1);

        JsonObjectParcel.Add('quantity', 1);
        //JsonObjectParcel.Add('shipping_method_checkout_name', SEWParcel.Name1);
        JsonObjectParcel.Add('is_return', false);

        JsonObjectParcel.Add('apply_shipping_rules', false);
        JsonObjectParcel.Add('external_reference', SEWParcel."Parcel No.");


        JsonObjectParcel.Add('name', SEWParcel."Ship-to Name 1");
        JsonObjectParcel.Add('company_name', SEWParcel."Ship-to Name 2");
        JsonObjectParcel.Add('address', SEWParcel."Ship-to Address 1");
        JsonObjectParcel.Add('address_2', SEWParcel."Ship-to Address 2");
        //JsonObjectParcel.Add('house_number', SEWParcel."Recipient House Nbr.");
        JsonObjectParcel.Add('country', SEWParcel."Ship-to Country Code");
        JsonObjectParcel.Add('postal_code', SEWParcel."Ship-to Post Code");
        JsonObjectParcel.Add('city', SEWParcel."Ship-to City");
        JsonObjectParcel.Add('country_state', SEWParcel."Ship-to County");
        JsonObjectParcel.Add('telephone', SEWParcel."Ship-to Phone");
        JsonObjectParcel.Add('email', SEWParcel."Ship-to Email");

        //JsonObjectParcel.Add('to_post_number', SEWParcel.Name1);
        //JsonObjectParcel.Add('to_service_point', SEWParcel.Name1);


        JsonObjectParcel.Add('reference', SEWParcel."Your Reference");
        JsonObjectParcel.Add('order_number', SEWParcel."SC Order Nbr.");
        //JsonObjectParcel.Add('total_order_value_currency', SEWParcel.Name1);
        //JsonObjectParcel.Add('total_order_value', SEWParcel.Name1);
        //JsonObjectParcel.Add('insured_value', SEWParcel.Name1);
        //JsonObjectParcel.Add('total_insured_value', SEWParcel.Name1);

        JsonObjectParcel.Add('weight', SEWParcel."Parcel Weight");
        JsonObjectParcel.Add('length', SEWParcel."Parcel Length");
        JsonObjectParcel.Add('width', SEWParcel."Parcel Width");
        JsonObjectParcel.Add('height', SEWParcel."Parcel Height");


        JsonObjectParcel.Add('sender_address', SEWParcel."SC Sender ID");
        // JsonObjectParcel.Add('from_name', SEWParcel."Sender Name1");
        // JsonObjectParcel.Add('from_company_name', SEWParcel."Sender Name2");
        // JsonObjectParcel.Add('from_address_1', SEWParcel."Sender Address1");
        // JsonObjectParcel.Add('from_address_2', SEWParcel."Sender Address2");
        // JsonObjectParcel.Add('from_house_number', SEWParcel."Sender House Nbr.");
        // JsonObjectParcel.Add('from_city', SEWParcel."Sender City");
        // JsonObjectParcel.Add('from_postal_code', SEWParcel."Sender PostalCode");
        // JsonObjectParcel.Add('from_country', SEWParcel."Sender CountryCode");
        // JsonObjectParcel.Add('from_telephone', SEWParcel."Sender Phone");
        // JsonObjectParcel.Add('from_email', SEWParcel."Sender Email");
        //JsonObjectParcel.Add('from_vat_number', SEWParcel.);

        // >>>> Shipment Object
        //if ShippingAgentServices.Get(SEWParcel."Shipping Agent Code", SEWParcel."Shipping Agent Service Code") then
        //   JsonObjectShipment.Add('id', ShippingAgentServices."SEW sendCloudID")
        //else
        JsonObjectShipment.Add('id', SEWParcel."SC Carrier Ship Meth ID");
        //JsonObjectShipment.Add('name', SEWParcel.Name1);
        JsonObjectParcel.Add('shipment', JsonObjectShipment);
        // >>>> Parcel Item Object
        //JsonObjectParcel.Add('parcel_items', SEWParcel.Name1);
        // >>>> Customs Infomrmation Object
        //JsonObjectParcel.Add('customs_information', SEWParcel.Name1);


        JsonObjectRequest.Add('parcel', JsonObjectParcel);
        JsonObjectRequest.WriteTo(request);
    end;





    procedure ProcessParcelObject(JsonObjectLoop: JsonObject)
    var
        SEWParcel: Record "SEW Parcel";
        ShippingAgentServices: Record "Shipping Agent Services";
        JsonTokenLoop: JsonToken;
        JsonValue: JsonValue;
        ParcelNo: Text[20];
        sendCloudID: Integer;
        shipmentID: Integer;
        FoundParcel: Boolean;
    begin
        FoundParcel := false;
        ParcelNo := CopyStr(JsonObjectLoop.GetText('external_reference', true), 1, MaxStrLen(SEWParcel."Parcel No."));
        sendCloudID := JsonObjectLoop.GetInteger('id', true);

        SEWParcel.SetRange("SC ID", sendCloudID);
        if SEWParcel.FindFirst() then
            FoundParcel := true;

        if not FoundParcel then begin
            SEWParcel.Reset();
            SEWParcel.SetRange("Parcel No.", ParcelNo);
            if SEWParcel.FindFirst() then
                FoundParcel := true;
        end;
        if not FoundParcel then begin
            SEWParcel.Init();
            SEWParcel.Validate("Parcel No.");
            SEWParcel."Source Type" := SEWParcel."Source Type"::Other;
            SEWParcel."Source Type Sub" := "SEW Shipment Source Type Sub"::"SendCloud Import";
            SEWParcel."SC ID" := sendCloudID;
            SEWParcel.Insert(true);
        end;



        SEWParcel."Ship-to Name 1" := CopyStr(JsonObjectLoop.GetText('name', true), 1, MaxStrLen(SEWParcel."Ship-to Name 1"));
        SEWParcel."Ship-to Name 2" := CopyStr(JsonObjectLoop.GetText('company_name', true), 1, MaxStrLen(SEWParcel."Ship-to Name 2"));
        SEWParcel."Ship-to Address 1" := CopyStr(JsonObjectLoop.GetText('address', true), 1, MaxStrLen(SEWParcel."Ship-to Address 1"));
        SEWParcel."Ship-to Address 2" := CopyStr(JsonObjectLoop.GetText('address_2', true), 1, MaxStrLen(SEWParcel."Ship-to Address 2"));
        //address_divived Object
        if JsonObjectLoop.SelectToken('address_divided.house_number', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWParcel."Ship-to House Nbr." := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWParcel."Ship-to House Nbr."));
        end;
        //Country Object
        if JsonObjectLoop.SelectToken('country.iso_2', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWParcel."Ship-to Country Code" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWParcel."Ship-to Country Code"));
        end;

        SEWParcel."Ship-to Post Code" := CopyStr(JsonObjectLoop.GetText('postal_code', true), 1, MaxStrLen(SEWParcel."Ship-to Post Code"));
        SEWParcel."Ship-to City" := CopyStr(JsonObjectLoop.GetText('city', true), 1, MaxStrLen(SEWParcel."Ship-to City"));
        SEWParcel."Ship-to Phone" := CopyStr(JsonObjectLoop.GetText('telephone', true), 1, MaxStrLen(SEWParcel."Ship-to Phone"));
        SEWParcel."Ship-to Email" := CopyStr(JsonObjectLoop.GetText('email', true), 1, MaxStrLen(SEWParcel."Ship-to Email"));
        SEWParcel."Your Reference" := CopyStr(JsonObjectLoop.GetText('reference', true), 1, MaxStrLen(SEWParcel."Your Reference"));

        SEWParcel."SC Tracking Number" := CopyStr(JsonObjectLoop.GetText('tracking_number', true), 1, MaxStrLen(SEWParcel."SC Tracking Number"));
        SEWParcel."SC Order Nbr." := CopyStr(JsonObjectLoop.GetText('order_number', true), 1, MaxStrLen(SEWParcel."SC Order Nbr."));


        if JsonObjectLoop.SelectToken('weight', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWParcel."Parcel Weight" := JsonValue.AsDecimal();
        end;

        if JsonObjectLoop.SelectToken('length', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWParcel."Parcel Length" := JsonValue.AsDecimal();
        end;

        if JsonObjectLoop.SelectToken('width', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWParcel."Parcel Width" := JsonValue.AsDecimal();
        end;

        if JsonObjectLoop.SelectToken('height', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWParcel."Parcel Height" := JsonValue.AsDecimal();
        end;


        SEWParcel."SC ID" := JsonObjectLoop.GetInteger('id', true);
        SEWParcel."SC Tracking Number" := CopyStr(JsonObjectLoop.GetText('tracking_number', true), 1, MaxStrLen(SEWParcel."SC Tracking Number"));
        SEWParcel."SC Note" := CopyStr(JsonObjectLoop.GetText('note', true), 1, MaxStrLen(SEWParcel."SC Note"));
        SEWParcel."SC Shipment uuid" := CopyStr(JsonObjectLoop.GetText('shipment_uuid', true), 1, MaxStrLen(SEWParcel."SC Shipment uuid"));
        SEWParcel."SC External Order Id" := CopyStr(JsonObjectLoop.GetText('external_order_id', true), 1, MaxStrLen(SEWParcel."SC External Order Id"));
        SEWParcel."SC External Shipment Id" := CopyStr(JsonObjectLoop.GetText('external_shipment_id', true), 1, MaxStrLen(SEWParcel."SC External Shipment Id"));
        SEWParcel."SC Colli uuid" := CopyStr(JsonObjectLoop.GetText('colli_uuid', true), 1, MaxStrLen(SEWParcel."SC Colli uuid"));
        SEWParcel."SC Tracking URL" := CopyStr(JsonObjectLoop.GetText('tracking_url', true), 1, MaxStrLen(SEWParcel."SC Tracking URL"));

        if JsonObjectLoop.SelectToken('date_created', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWParcel."SC Date created" := (EvaluateUTCDateTime(JsonValue.AsText()));
        end;
        if JsonObjectLoop.SelectToken('date_updated', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWParcel."SC Date Updated" := (EvaluateUTCDateTime(JsonValue.AsText()));
        end;
        if JsonObjectLoop.SelectToken('date_announced', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWParcel."SC Date announced" := (EvaluateUTCDateTime(JsonValue.AsText()));
        end;

        if JsonObjectLoop.SelectToken('carrier.code', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWParcel."Shipping Agent Code" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWParcel."Shipping Agent Code"));
        end;

        if JsonObjectLoop.SelectToken('shipment.id', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then begin
                shipmentID := JsonValue.AsInteger();
                ShippingAgentServices.Reset();
                ShippingAgentServices.SetRange("SEW sendCloudID", shipmentID);
                if ShippingAgentServices.FindFirst() then
                    SEWParcel."Shipping Agent Service Code" := ShippingAgentServices.Code;
            end;
        end;

        if JsonObjectLoop.SelectToken('label.label_printer', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWParcel."SC Label URL" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWParcel."SC Label URL"));
        end;


        if JsonObjectLoop.SelectToken('status.id', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWParcel.Validate("SC Status ID", JsonValue.AsInteger());
        end;

        SEWParcel.Modify(true);
        Commit(); // To ensure that tracking records can be linked immediately
    end;

    procedure ProcessTrackingObject(JsonObjectLoop: JsonObject; xSendCloudParcelID: Integer)
    var
        SEWParcelTracking: Record "SEW Parcel Tracking";
        JsonTokenLoop: JsonToken;
        JsonValue: JsonValue;
        parcel_status_history_id: Code[30];
    begin
        parcel_status_history_id := CopyStr(JsonObjectLoop.GetText('parcel_status_history_id', true), 1, MaxStrLen(parcel_status_history_id));

        if not SEWParcelTracking.Get(parcel_status_history_id) then begin
            SEWParcelTracking.Init();
            SEWParcelTracking."Parcel Status History ID" := parcel_status_history_id;
            SEWParcelTracking."SC Parcel ID" := xSendCloudParcelID;
            SEWParcelTracking.Insert(true);
        end;

        if JsonObjectLoop.SelectToken('carrier_update_timestamp', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWParcelTracking."Carrier Update Timestamp" := (EvaluateUTCDateTime(JsonValue.AsText()));
        end;

        SEWParcelTracking."Parent Status" := CopyStr(JsonObjectLoop.GetText('parent_status', true), 1, MaxStrLen(SEWParcelTracking."Parent Status"));
        SEWParcelTracking."Carrier Message" := CopyStr(JsonObjectLoop.GetText('carrier_message', true), 1, MaxStrLen(SEWParcelTracking."Carrier Message"));

        SEWParcelTracking.Modify(true);
    end;




    procedure ProcessShippingProcess(Data: Text)
    var
        JsonResponse: JsonObject;
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        JsonTokenLoop: JsonToken;
        JsonObjectLoop: JsonObject;
    begin
        if Data = '' then
            exit;

        JsonResponse.ReadFrom(Data);
        if JsonResponse.Get('shipping_methods', JsonToken) then begin
            JsonArray := JsonToken.AsArray();

            foreach JsonTokenLoop in JsonArray do begin
                JsonObjectLoop := JsonTokenLoop.AsObject();

                ProcessShippingMethod(JsonObjectLoop);
            end;
        end;
    end;

    procedure ProcessShippingMethod(JsonObjectLoop: JsonObject)
    var
        SEWCarrierShipMet: Record "SEW Carrier Ship Met";
        JsonTokenLoop: JsonToken;
        JsonValue: JsonValue;
        JsonArray: JsonArray;

        ShippingMethodID: Integer;
    begin

        if JsonObjectLoop.Get('id', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            ShippingMethodID := JsonValue.AsInteger();
        end;

        if not SEWCarrierShipMet.Get(ShippingMethodID) then begin
            SEWCarrierShipMet.Init();
            SEWCarrierShipMet.ID := ShippingMethodID;
            SEWCarrierShipMet.Insert(true);
        end;


        if JsonObjectLoop.Get('name', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWCarrierShipMet."Shipment Method Name" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWCarrierShipMet."Shipment Method Name"));
        end;

        if JsonObjectLoop.SelectToken('carrier', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWCarrierShipMet."Carrier Code" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWCarrierShipMet."Carrier Code"));
        end;
        ImportCarrierCode(SEWCarrierShipMet."Carrier Code");

        if JsonObjectLoop.SelectToken('min_weight', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWCarrierShipMet."Weight min" := JsonValue.AsDecimal();
        end;

        if JsonObjectLoop.SelectToken('max_weight', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWCarrierShipMet."Weight max" := JsonValue.AsDecimal();
        end;

        if JsonObjectLoop.SelectToken('service_point_input', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWCarrierShipMet."Service Point Input" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWCarrierShipMet."Service Point Input"));
        end;


        if JsonObjectLoop.SelectToken('countries', JsonTokenLoop) then begin
            JsonArray := JsonTokenLoop.AsArray();
            foreach JsonTokenLoop in JsonArray do begin
                JsonObjectLoop := JsonTokenLoop.AsObject();
                ProcessShippingMethodCountry(JsonObjectLoop, ShippingMethodID);
            end;
        end;

        SEWCarrierShipMet.Modify(true);
    end;

    procedure ProcessShippingMethodCountry(JsonObjectLoop: JsonObject; xShippingMethodID: Integer)
    var
        SEWCarrierShipMetCntry: Record "SEW Carrier Ship Met Cntry";
        JsonTokenLoop: JsonToken;
        JsonValue: JsonValue;
        JsonArray: JsonArray;

        countryID: Integer;
    begin

        if JsonObjectLoop.Get('id', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            countryID := JsonValue.AsInteger();
        end;

        if not SEWCarrierShipMetCntry.Get(countryID, xShippingMethodID) then begin
            SEWCarrierShipMetCntry.Init();
            SEWCarrierShipMetCntry."Shipping Method ID" := xShippingMethodID;
            SEWCarrierShipMetCntry.ID := countryID;
            SEWCarrierShipMetCntry.Insert(true);
        end;

        SEWCarrierShipMetCntry.Name := CopyStr(JsonObjectLoop.GetText('name', true), 1, MaxStrLen(SEWCarrierShipMetCntry.Name));
        SEWCarrierShipMetCntry."ISO 2" := CopyStr(JsonObjectLoop.GetText('iso_2', true), 1, MaxStrLen(SEWCarrierShipMetCntry."ISO 2"));
        SEWCarrierShipMetCntry."ISO 3" := CopyStr(JsonObjectLoop.GetText('iso_3', true), 1, MaxStrLen(SEWCarrierShipMetCntry."ISO 3"));
        SEWCarrierShipMetCntry.Price := JsonObjectLoop.GetDecimal('price', true);
        //SEWCarrierShipMetCntry."Lead Time_Hours" := JsonObjectLoop.GetInteger('lead_time_hours', true);

        // if JsonObjectLoop.Get('name', JsonTokenLoop) then begin
        //     JsonValue := JsonTokenLoop.AsValue();
        //     if not JsonValue.IsNull() then
        //         SEWCarrierShipMetCntry.Name := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWCarrierShipMetCntry.Name));
        // end;

        // if JsonObjectLoop.Get('iso_2', JsonTokenLoop) then begin
        //     JsonValue := JsonTokenLoop.AsValue();
        //     if not JsonValue.IsNull() then
        //         SEWCarrierShipMetCntry."ISO 2" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWCarrierShipMetCntry."ISO 2"));
        // end;

        // if JsonObjectLoop.Get('iso_3', JsonTokenLoop) then begin
        //     JsonValue := JsonTokenLoop.AsValue();
        //     if not JsonValue.IsNull() then
        //         SEWCarrierShipMetCntry."ISO 3" := CopyStr(JsonValue.AsText(), 1, MaxStrLen(SEWCarrierShipMetCntry."ISO 3"));
        // end;

        // if JsonObjectLoop.Get('price', JsonTokenLoop) then begin
        //     JsonValue := JsonTokenLoop.AsValue();
        //     if not JsonValue.IsNull() then
        //         SEWCarrierShipMetCntry.Price := JsonValue.AsDecimal();
        // end;

        if JsonObjectLoop.Get('lead_time_hours', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                SEWCarrierShipMetCntry."Lead Time_Hours" := JsonValue.AsInteger();
        end;


        if JsonObjectLoop.SelectToken('price_breakdown', JsonTokenLoop) then begin
            JsonArray := JsonTokenLoop.AsArray();
            foreach JsonTokenLoop in JsonArray do begin
                JsonObjectLoop := JsonTokenLoop.AsObject();
                ProcessShippingMethodCountryPrice(JsonObjectLoop, xShippingMethodID, countryID);
            end;
        end;



        SEWCarrierShipMetCntry.Modify(true);
    end;

    procedure ProcessShippingMethodCountryPrice(JsonObjectLoop: JsonObject; xShippingMethodID: Integer; xCountryID: Integer)
    var
        SEWCarrierShipMetCntryPri: Record "SEW Carrier Ship Met Cntry Pri";
        JsonTokenLoop: JsonToken;
        JsonValue: JsonValue;

        xType: Text[255];
        xLabel: Code[50];
        xValue: Decimal;
    begin

        if JsonObjectLoop.Get('value', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                xValue := JsonValue.AsDecimal();
        end;

        if JsonObjectLoop.Get('label', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                xLabel := CopyStr(JsonValue.AsText(), 1, MaxStrLen(xLabel));
        end;

        if JsonObjectLoop.Get('type', JsonTokenLoop) then begin
            JsonValue := JsonTokenLoop.AsValue();
            if not JsonValue.IsNull() then
                xType := CopyStr(JsonValue.AsText(), 1, MaxStrLen(xType));
        end;

        if not SEWCarrierShipMetCntryPri.Get(xShippingMethodID, xCountryID, xType) then begin
            SEWCarrierShipMetCntryPri.Init();
            SEWCarrierShipMetCntryPri."Shipping Method ID" := xShippingMethodID;
            SEWCarrierShipMetCntryPri."Shipping Met Cntry ID" := xCountryID;
            SEWCarrierShipMetCntryPri.Type := xType;
            SEWCarrierShipMetCntryPri.Label := xLabel;
            SEWCarrierShipMetCntryPri.Value := xValue;
            SEWCarrierShipMetCntryPri.Insert(true);
        end else begin
            SEWCarrierShipMetCntryPri.Label := xLabel;
            SEWCarrierShipMetCntryPri.Value := xValue;
            SEWCarrierShipMetCntryPri.Modify(true);
        end;

    end;



    local procedure EvaluateUTCDateTime(DataTimeText: Text) EvaluatedDateTime: DateTime
    var
        TypeHelper: Codeunit "Type Helper";
        Language: Codeunit Language;
        ValueVariant: Variant;
    begin
        ValueVariant := EvaluatedDateTime;

        if TypeHelper.Evaluate(ValueVariant, DataTimeText, '', Language.GetCurrentCultureName()) then
            EvaluatedDateTime := ValueVariant;

    end;

    local procedure ImportCarrierCode(xCarrierCode: Code[50])
    var
        SEWCarrier: Record "SEW Carrier";
    begin
        if not SEWCarrier.Get(xCarrierCode) then begin
            SEWCarrier.Init();
            SEWCarrier.Code := xCarrierCode;
            SEWCarrier.Insert(true);
        end;
    end;


}
