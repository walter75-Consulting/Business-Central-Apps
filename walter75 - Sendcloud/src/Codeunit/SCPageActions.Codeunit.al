codeunit 95709 "SEW SC Page Actions"
{

    Permissions = tabledata "Shipping Agent Services" = rm,
                    tabledata "SEW Carrier Ship Met" = r;

    procedure GetShippingMethDesc(var ShippingAgentServices: Record "Shipping Agent Services")
    var
        SEWCarrierShipMet: Record "SEW Carrier Ship Met";
        ErrMsgLbl: Label 'No SendCloud Shipping Method found with ID %1', Comment = '%1 - SendCloud ID';
    begin
        if ShippingAgentServices."SEW sendCloudID" <> 0 then begin
            if SEWCarrierShipMet.Get(ShippingAgentServices."SEW sendCloudID") then
                ShippingAgentServices."Description" := CopyStr(SEWCarrierShipMet."Shipment Method Name", 1, 100)
            else
                Error(ErrMsgLbl, ShippingAgentServices."SEW sendCloudID");
        end else
            ShippingAgentServices."Description" := '';
    end;
}
