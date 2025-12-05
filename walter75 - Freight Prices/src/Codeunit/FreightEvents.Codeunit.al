codeunit 91400 "SEW Freight Events"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post Prepayment (Yes/No)", 'OnPostPrepmtInvoiceYNOnBeforeConfirm', '', false, false)]
    local procedure OnPostPrepmtInvoiceYNOnBeforeConfirm(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var

    begin
        if SalesHeader."Shipping Agent Code" = '' then
            exit;
        if SalesHeader."SEW Freight manually" = true then
            exit;

        FindFreightPriceRule(SalesHeader);
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforePerformManualReleaseProcedure', '', false, false)]
    // local procedure OnBeforePerformManualReleaseProcedure(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean)
    // var

    // begin
    //     Message('OnBeforePerformManualReleaseProcedure');
    // end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforePerformManualRelease', '', false, false)]
    local procedure OnBeforePerformManualRelease(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        if SalesHeader."Shipping Agent Code" = '' then
            exit;
        if SalesHeader."SEW Freight manually" = true then
            exit;

        FindFreightPriceRule(SalesHeader);
    end;

    local procedure FindFreightPriceRule(var SalesHeader: Record "Sales Header")
    var
        SEWFreightPrices: Record "SEW Freight Prices";
        xOrderSum: Decimal;
    begin
        xOrderSum := GetSalesOrderSum(SalesHeader);

        SEWFreightPrices.Reset();
        SEWFreightPrices.SetCurrentKey("Minimum Order Total");
        SEWFreightPrices.SetAscending("Minimum Order Total", true);

        // A single customer with an agent with agent service code will be processed first.
        // A single customer with only an agent code will apply to all other services for the specified carrier.
        // A single customer with no agent options will be used for all other carrier combinations.
        SEWFreightPrices.SetRange("Sales Type", "Sales Price Type"::Customer);
        SEWFreightPrices.SetRange("Sales Code", SalesHeader."Sell-to Customer No.");
        SEWFreightPrices.SetRange("Shipping Agent Code", SalesHeader."Shipping Agent Code");
        SEWFreightPrices.SetRange("Shipping Agent Service Code", SalesHeader."Shipping Agent Service Code");
        SEWFreightPrices.SetFilter("Minimum Order Total", '<=%1', xOrderSum);
        if SEWFreightPrices.FindLast() then begin
            FindFreightPrice(SEWFreightPrices, SalesHeader, xOrderSum);
            exit;
        end;

        SEWFreightPrices.SetRange("Shipping Agent Service Code");
        if SEWFreightPrices.FindLast() then begin
            FindFreightPrice(SEWFreightPrices, SalesHeader, xOrderSum);
            exit;
        end;

        SEWFreightPrices.SetRange("Shipping Agent Code");
        if SEWFreightPrices.FindLast() then begin
            FindFreightPrice(SEWFreightPrices, SalesHeader, xOrderSum);
            exit;
        end;

        // A customer price group will be processed if there was no match for the individual customer.
        // A customer price group with an agent with agent service code will be processed first.
        // A customer price group with only an agent code will apply to all other services for the specified carrier.
        // A customer price group with no agent options will be used for all other carrier combinations.
        SEWFreightPrices.SetRange("Sales Type", "Sales Price Type"::"Customer Price Group");
        SEWFreightPrices.SetRange("Sales Code", SalesHeader."Customer Price Group");
        SEWFreightPrices.SetRange("Shipping Agent Code", SalesHeader."Shipping Agent Code");
        SEWFreightPrices.SetRange("Shipping Agent Service Code", SalesHeader."Shipping Agent Service Code");
        SEWFreightPrices.SetFilter("Minimum Order Total", '<=%1', xOrderSum);
        if SEWFreightPrices.FindLast() then begin
            FindFreightPrice(SEWFreightPrices, SalesHeader, xOrderSum);
            exit;
        end;

        SEWFreightPrices.SetRange("Shipping Agent Service Code");
        if SEWFreightPrices.FindLast() then begin
            FindFreightPrice(SEWFreightPrices, SalesHeader, xOrderSum);
            exit;
        end;

        SEWFreightPrices.SetRange("Shipping Agent Code");
        if SEWFreightPrices.FindLast() then begin
            FindFreightPrice(SEWFreightPrices, SalesHeader, xOrderSum);
            exit;
        end;

        // A campaign rule will take effect for all remaining customers that apply to the campaign criteria.
        // A campaign rule with an agent with agent service code will be processed first.
        // A campaign rule with only an agent code will apply to all other services for the specified carrier.
        // A campaign rule with no agent options will be used for all other carrier combinations.
        SEWFreightPrices.SetRange("Sales Type", "Sales Price Type"::Campaign);
        SEWFreightPrices.SetRange("Sales Code", SalesHeader."Campaign No.");
        SEWFreightPrices.SetRange("Shipping Agent Code", SalesHeader."Shipping Agent Code");
        SEWFreightPrices.SetRange("Shipping Agent Service Code", SalesHeader."Shipping Agent Service Code");
        SEWFreightPrices.SetFilter("Minimum Order Total", '<=%1', xOrderSum);
        if SEWFreightPrices.FindLast() then begin
            FindFreightPrice(SEWFreightPrices, SalesHeader, xOrderSum);
            exit;
        end;

        SEWFreightPrices.SetRange("Shipping Agent Service Code");
        if SEWFreightPrices.FindLast() then begin
            FindFreightPrice(SEWFreightPrices, SalesHeader, xOrderSum);
            exit;
        end;

        SEWFreightPrices.SetRange("Shipping Agent Code");
        if SEWFreightPrices.FindLast() then begin
            FindFreightPrice(SEWFreightPrices, SalesHeader, xOrderSum);
            exit;
        end;

        // Generic rules for an agent with an agent service code will be used for orders that did not match the more specific rules.
        // Generic rules with only an agent code will apply to all other services for the specified carrier.
        // Generic rules with no other criteria will be for any shipments that did not match anything else.
        SEWFreightPrices.SetRange("Sales Type", "Sales Price Type"::"All Customers");
        SEWFreightPrices.SetRange("Shipping Agent Code", SalesHeader."Shipping Agent Code");
        SEWFreightPrices.SetRange("Shipping Agent Service Code", SalesHeader."Shipping Agent Service Code");
        SEWFreightPrices.SetFilter("Minimum Order Total", '<=%1', xOrderSum);
        if SEWFreightPrices.FindLast() then begin
            FindFreightPrice(SEWFreightPrices, SalesHeader, xOrderSum);
            exit;
        end;

        SEWFreightPrices.SetRange("Shipping Agent Service Code");
        if SEWFreightPrices.FindLast() then begin
            FindFreightPrice(SEWFreightPrices, SalesHeader, xOrderSum);
            exit;
        end;

        SEWFreightPrices.SetRange("Shipping Agent Code");
        if SEWFreightPrices.FindLast() then begin
            FindFreightPrice(SEWFreightPrices, SalesHeader, xOrderSum);
            exit;
        end;
    end;


    local procedure FindFreightPrice(var SEWFreightPrices: Record "SEW Freight Prices"; var SalesHeader: Record "Sales Header"; xOrderSum: Decimal)
    var
        ShippingAgent: Record "Shipping Agent";
        xFreight: Decimal;

    begin
        ShippingAgent.SetRange(Code, SalesHeader."Shipping Agent Code");
        ShippingAgent.FindFirst();
        if ShippingAgent.IsEmpty() then
            exit;

        // The Minimum Order Total can be used to apply a rule only to orders above a specified limit.
        // Maximum rate can be used to specify a cap on the rule (freight over the amount is no extra cost).
        // Markup %, Fixed Price and Line Discount Percentage can be used to alter the amount of the shipping cost that is passed back to the sales order. Each of these fields only apply if their applicable rate handling is selected, and they cannot be combined without an extension. Rounding precision can be used to approximate the freight amount.
        // Note: Maximum Rate can only be applied to a specific carrier and service – it cannot be applied generically.

        case SEWFreightPrices."Rate Handling" of

            "SEW Freight Rate Handling"::"Add Actual Freight Charge":
                begin
                    // Fracht aus den Shipping Agents Service nehmen
                    xFreight := GetFreightFromService(SalesHeader."Shipping Agent Code", SalesHeader."Shipping Agent Service Code");
                    if SEWFreightPrices."Maximum Rate" <> 0 then
                        if xFreight > SEWFreightPrices."Maximum Rate" then
                            xFreight := SEWFreightPrices."Maximum Rate";
                    AddLine(SalesHeader, ShippingAgent."SEW Freight Billing Type", ShippingAgent."SEW Freight Billing No.", xFreight, SEWFreightPrices."Line Discount %");
                    exit;
                end;

            "SEW Freight Rate Handling"::"Add Combined Markup":
                begin
                    //Aufschlag in% auf Auftragswert + Fixe Kosten, Rabatt berücksichtigen
                    xFreight := (xOrderSum / 100) * 5;
                    xFreight := xFreight + SEWFreightPrices."Markup Amount";
                    xFreight := Round(xFreight, SEWFreightPrices."Rounding Precision", '=');
                    if SEWFreightPrices."Maximum Rate" <> 0 then
                        if xFreight > SEWFreightPrices."Maximum Rate" then
                            xFreight := SEWFreightPrices."Maximum Rate";
                    AddLine(SalesHeader, ShippingAgent."SEW Freight Billing Type", ShippingAgent."SEW Freight Billing No.", xFreight, SEWFreightPrices."Line Discount %");
                    exit;
                end;

            "SEW Freight Rate Handling"::"Add Fixed Price Freight Charge":
                begin
                    //Fester Preis, Rabatt berücksichtigen
                    xFreight := SEWFreightPrices."Fixed Price";
                    if SEWFreightPrices."Maximum Rate" <> 0 then
                        if xFreight > SEWFreightPrices."Maximum Rate" then
                            xFreight := SEWFreightPrices."Maximum Rate";
                    AddLine(SalesHeader, ShippingAgent."SEW Freight Billing Type", ShippingAgent."SEW Freight Billing No.", xFreight, SEWFreightPrices."Line Discount %");
                    exit;
                end;

            "SEW Freight Rate Handling"::"Add Markup Percentage":
                begin
                    //Aufschlag in% auf Auftragswert, Rabatt berücksichtigen
                    xFreight := (xOrderSum / 100) * 5;
                    xFreight := Round(xFreight, SEWFreightPrices."Rounding Precision", '=');
                    if SEWFreightPrices."Maximum Rate" <> 0 then
                        if xFreight > SEWFreightPrices."Maximum Rate" then
                            xFreight := SEWFreightPrices."Maximum Rate";
                    AddLine(SalesHeader, ShippingAgent."SEW Freight Billing Type", ShippingAgent."SEW Freight Billing No.", xFreight, SEWFreightPrices."Line Discount %");
                    exit;

                end;

            "SEW Freight Rate Handling"::"Don't Add Freight Charge":
                begin
                    //Keine Fracht hinzufügen
                    xFreight := 0;
                    AddLine(SalesHeader, ShippingAgent."SEW Freight Billing Type", ShippingAgent."SEW Freight Billing No.", xFreight, SEWFreightPrices."Line Discount %");
                    exit;
                end;
        end;

    end;

    local procedure GetSalesOrderSum(var SalesHeader: Record "Sales Header"): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.FindLast();
        SalesLine.CalcSums("Amount");
        exit(SalesLine.Amount);
    end;


    local procedure GetFreightFromService(ShippingAgent: Code[10]; ShippingService: Code[10]): Decimal
    var
        ShippingAgentServices: Record "Shipping Agent Services";
    begin
        ShippingAgentServices.SetRange("Shipping Agent Code", ShippingAgent);
        ShippingAgentServices.SetRange(Code, ShippingService);
        if ShippingAgentServices.FindFirst() then
            exit(ShippingAgentServices."SEW Freight Charge");

        exit(0);
    end;


    local procedure AddLine(var SalesHeader: Record "Sales Header"; LineType: Enum "Sales Line Type"; No: Code[20]; xPrice: Decimal; xLineDiscount: Decimal)
    var
        SalesLine: Record "Sales Line";
        SalesLine1: Record "Sales Line";
    begin
        // Modify or Add Line

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, LineType);
        SalesLine.SetRange("No.", No);

        if SalesLine.FindFirst() then begin
            SalesLine.Validate(Quantity, 1);
            SalesLine.Validate("Unit Price", xPrice);
            SalesLine.Validate("Line Discount %", xLineDiscount);
            // Wenn manuell Frachtkosten erfasst wurden, diese ggf. löschen.
            if xPrice = 0 then
                SalesLine.Delete(true)
            else
                SalesLine.Modify(true);
            exit;
        end;

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.FindLast();

        SalesLine.InitNewLine(SalesLine1);
        SalesLine1.Validate("Document Type", SalesHeader."Document Type");
        SalesLine1.Validate("Document No.", SalesHeader."No.");
        SalesLine1."Line No." += 10000;
        SalesLine1.Validate(Type, LineType);
        SalesLine1.Validate("No.", No);
        SalesLine1.Validate(Quantity, 1);
        SalesLine1.Validate("Unit Price", xPrice);
        SalesLine1.Validate("Line Discount %", xLineDiscount);

        SalesLine1.Insert(true);

    end;



}