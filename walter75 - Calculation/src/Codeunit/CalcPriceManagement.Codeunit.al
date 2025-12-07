codeunit 90852 "SEW Calc Price Management"
{
    Permissions = tabledata Item = r,
                  tabledata "Work Center" = r,
                  tabledata "Machine Center" = r,
                  tabledata "Production BOM Header" = r,
                  tabledata "Production BOM Line" = r,
                  tabledata "Routing Header" = r,
                  tabledata "Routing Line" = r;

    /// <summary>
    /// Gets the purchase price for an item based on the price source setting.
    /// </summary>
    /// <param name="ItemNo">The item number.</param>
    /// <param name="PriceSource">The price source to use.</param>
    /// <returns>The item price.</returns>
    procedure GetItemPrice(ItemNo: Code[20]; PriceSource: Enum "SEW Calc Price Source"): Decimal
    var
        Item: Record Item;
    begin
        if ItemNo = '' then
            exit(0);

        if not Item.Get(ItemNo) then
            exit(0);

        case PriceSource of
            PriceSource::"Unit Cost":
                exit(Item."Unit Cost");
            PriceSource::"Last Direct Cost":
                exit(Item."Last Direct Cost");
            PriceSource::"Standard Cost":
                exit(Item."Standard Cost");
            else
                exit(Item."Unit Cost");
        end;
    end;

    /// <summary>
    /// Gets the capacity cost for a work center or machine center.
    /// </summary>
    /// <param name="CapacityType">The type of capacity (Work Center or Machine Center).</param>
    /// <param name="CapacityNo">The capacity number.</param>
    /// <param name="PriceSource">The price source to use.</param>
    /// <returns>The capacity cost.</returns>
    procedure GetCapacityCost(CapacityType: Option "Work Center","Machine Center"; CapacityNo: Code[20]; PriceSource: Enum "SEW Calc Price Source"): Decimal
    var
        WorkCenter: Record "Work Center";
        MachineCenter: Record "Machine Center";
    begin
        case CapacityType of
            CapacityType::"Work Center":
                begin
                    if not WorkCenter.Get(CapacityNo) then
                        exit(0);
                    exit(GetWorkCenterCost(WorkCenter, PriceSource));
                end;
            CapacityType::"Machine Center":
                begin
                    if not MachineCenter.Get(CapacityNo) then
                        exit(0);
                    exit(GetMachineCenterCost(MachineCenter, PriceSource));
                end;
        end;
    end;

    local procedure GetWorkCenterCost(var WorkCenter: Record "Work Center"; PriceSource: Enum "SEW Calc Price Source"): Decimal
    begin
        case PriceSource of
            PriceSource::"Work Center Direct Cost":
                exit(WorkCenter."Direct Unit Cost");
            PriceSource::"Work Center Overhead Rate":
                exit(WorkCenter."Indirect Cost %");
            else
                exit(WorkCenter."Unit Cost");
        end;
    end;

    local procedure GetMachineCenterCost(var MachineCenter: Record "Machine Center"; PriceSource: Enum "SEW Calc Price Source"): Decimal
    begin
        case PriceSource of
            PriceSource::"Machine Center Direct Cost":
                exit(MachineCenter."Direct Unit Cost");
            PriceSource::"Machine Center Overhead Rate":
                exit(MachineCenter."Indirect Cost %");
            else
                exit(MachineCenter."Unit Cost");
        end;
    end;

    /// <summary>
    /// Calculates the total material cost from a Production BOM.
    /// </summary>
    /// <param name="ProductionBOMNo">The production BOM number.</param>
    /// <param name="ProductionBOMVersion">The production BOM version.</param>
    /// <param name="Quantity">The quantity to calculate for.</param>
    /// <param name="PriceSource">The price source to use.</param>
    /// <returns>The total BOM cost.</returns>
    procedure GetBOMCost(ProductionBOMNo: Code[20]; ProductionBOMVersion: Code[20]; Quantity: Decimal; PriceSource: Enum "SEW Calc Price Source"): Decimal
    var
        ProductionBOMLine: Record "Production BOM Line";
        ProductionBOMHeader: Record "Production BOM Header";
        TotalCost: Decimal;
        LineCost: Decimal;
        QuantityPer: Decimal;
    begin
        if ProductionBOMNo = '' then
            exit(0);

        if not ProductionBOMHeader.Get(ProductionBOMNo) then
            exit(0);

        TotalCost := 0;

        ProductionBOMLine.SetRange("Production BOM No.", ProductionBOMNo);
        if ProductionBOMVersion <> '' then
            ProductionBOMLine.SetRange("Version Code", ProductionBOMVersion);

        if ProductionBOMLine.FindSet() then
            repeat
                if ProductionBOMLine.Type = ProductionBOMLine.Type::Item then begin
                    QuantityPer := ProductionBOMLine."Quantity per";
                    if QuantityPer = 0 then
                        QuantityPer := 1;

                    LineCost := GetItemPrice(ProductionBOMLine."No.", PriceSource) * QuantityPer * Quantity;
                    TotalCost += LineCost;
                end;
            until ProductionBOMLine.Next() = 0;

        exit(TotalCost);
    end;

    /// <summary>
    /// Calculates the total labor cost from a Routing.
    /// </summary>
    /// <param name="RoutingNo">The routing number.</param>
    /// <param name="RoutingVersion">The routing version.</param>
    /// <param name="Quantity">The quantity to calculate for.</param>
    /// <param name="PriceSource">The price source to use.</param>
    /// <returns>The total routing cost.</returns>
    procedure GetRoutingCost(RoutingNo: Code[20]; RoutingVersion: Code[20]; Quantity: Decimal; PriceSource: Enum "SEW Calc Price Source"): Decimal
    var
        RoutingLine: Record "Routing Line";
        RoutingHeader: Record "Routing Header";
        TotalCost: Decimal;
        LineCost: Decimal;
        SetupTime: Decimal;
        RunTime: Decimal;
    begin
        if RoutingNo = '' then
            exit(0);

        if not RoutingHeader.Get(RoutingNo) then
            exit(0);

        TotalCost := 0;

        RoutingLine.SetRange("Routing No.", RoutingNo);
        if RoutingVersion <> '' then
            RoutingLine.SetRange("Version Code", RoutingVersion);

        if RoutingLine.FindSet() then
            repeat
                SetupTime := RoutingLine."Setup Time";
                RunTime := RoutingLine."Run Time" * Quantity;

                case RoutingLine.Type of
                    RoutingLine.Type::"Work Center":
                        LineCost := GetCapacityCost(0, RoutingLine."No.", PriceSource) * (SetupTime + RunTime) / 60;
                    RoutingLine.Type::"Machine Center":
                        LineCost := GetCapacityCost(1, RoutingLine."No.", PriceSource) * (SetupTime + RunTime) / 60;
                end;

                TotalCost += LineCost;
            until RoutingLine.Next() = 0;

        exit(TotalCost);
    end;

    /// <summary>
    /// Calculates overhead costs based on a base value and percentage.
    /// </summary>
    /// <param name="BaseAmount">The base amount to calculate overhead on.</param>
    /// <param name="OverheadPercent">The overhead percentage.</param>
    /// <returns>The calculated overhead cost.</returns>
    procedure CalculateOverhead(BaseAmount: Decimal; OverheadPercent: Decimal): Decimal
    begin
        exit(BaseAmount * OverheadPercent / 100);
    end;

    /// <summary>
    /// Calculates the target sales price based on cost and margin percentage.
    /// </summary>
    /// <param name="TotalCost">The total cost.</param>
    /// <param name="MarginPercent">The desired margin percentage.</param>
    /// <returns>The calculated target price.</returns>
    procedure CalculateTargetPrice(TotalCost: Decimal; MarginPercent: Decimal): Decimal
    begin
        if MarginPercent >= 100 then
            exit(0);

        exit(TotalCost / (1 - MarginPercent / 100));
    end;

    /// <summary>
    /// Calculates the margin percentage from cost and sales price.
    /// </summary>
    /// <param name="TotalCost">The total cost.</param>
    /// <param name="SalesPrice">The sales price.</param>
    /// <returns>The margin percentage.</returns>
    procedure CalculateMargin(TotalCost: Decimal; SalesPrice: Decimal): Decimal
    begin
        if SalesPrice = 0 then
            exit(0);

        exit((SalesPrice - TotalCost) / SalesPrice * 100);
    end;
}
