table 91400 "SEW Freight Prices"
{
    Caption = 'Freight Prices';
    DataClassification = CustomerContent;
    LookupPageId = "SEW Freight Prices";
    DrillDownPageId = "SEW Freight Prices";

    fields
    {
        field(1; "Sales Type"; Enum "Sales Price Type")
        {
            Caption = 'Sales Type';
            ToolTip = 'Specifies the sales price type, which defines whether the price is for an individual, group, all customers, or a campaign.';
        }
        field(2; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            ToolTip = 'Specifies the code that belongs to the Sales Type.';
            TableRelation = if ("Sales Type" = const("Customer Price Group")) "Customer Price Group"
            else
            if ("Sales Type" = const(Customer)) Customer
            else
            if ("Sales Type" = const(Campaign)) Campaign;


            trigger OnValidate()
            var
                Customer: Record "Customer";
                CustomerPriceGroup: Record "Customer Price Group";
                Campaign: Record Campaign;
            begin
                case Rec."Sales Type"
                of
                    "Sales Price Type"::Customer:
                        begin
                            Customer.SetRange("No.", Rec."Sales Code");
                            Rec."Sales Code Name" := Customer.Name;
                        end;

                    "Sales Price Type"::"Customer Price Group":
                        begin
                            CustomerPriceGroup.SetRange(Code, Rec."Sales Code");
                            Rec."Sales Code Name" := CustomerPriceGroup.Description;
                        end;

                    "Sales Price Type"::Campaign:
                        begin
                            Campaign.SetRange("No.", Rec."Sales Code");
                            Rec."Sales Code Name" := Campaign.Description;
                        end;
                end;
            end;
        }
        field(3; "Sales Code Name"; Text[100])
        {
            Caption = 'Sales Code Name';
            ToolTip = 'Specifies the name of the sales code.';
        }
        field(4; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            ToolTip = 'Specifies the code for the shipping agent.';
            TableRelation = "Shipping Agent";
        }
        field(5; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            ToolTip = 'Specifies the code for the shipping agent service.';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));
        }
        field(6; "Maximum Rate"; Decimal)
        {
            Caption = 'Maximum Rate';
            ToolTip = 'Specifies the maximum freight rate that can be charged.';
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(7; "Minimum Order Total"; Decimal)
        {
            Caption = 'Minimum Order Total';
            ToolTip = 'Specifies the minimum order total required for this freight price to apply.';
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(8; "Markup %"; Decimal)
        {
            Caption = 'Markup %';
            ToolTip = 'Specifies the markup percentage to add to the freight charge.';
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(9; "Markup Amount"; Decimal)
        {
            Caption = 'Markup Amount';
            ToolTip = 'Specifies the markup amount to add to the freight charge.';
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(10; "Fixed Price"; Decimal)
        {
            Caption = 'Fixed Price';
            ToolTip = 'Specifies a fixed price for the freight charge.';
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            ToolTip = 'Specifies the line discount percentage to apply to the freight charge.';
            AutoFormatType = 2;
            MinValue = 0;
        }

        field(12; "Rate Handling"; Enum "SEW Freight Rate Handling")
        {
            Caption = 'Rate Handling';
            ToolTip = 'Specifies how the freight rate is handled.';
        }
        field(13; "Rounding Precision"; Decimal)
        {
            Caption = 'Rounding Precision';
            ToolTip = 'Specifies the rounding precision for freight calculations.';
            DecimalPlaces = 0 : 5;
            InitValue = 0.01;
        }







    }


    keys
    {
        key(PK; "Sales Type", "Sales Code", "Shipping Agent Code", "Shipping Agent Service Code", "Minimum Order Total", "Rate Handling")
        {
            Clustered = true;
        }

        key(SEW1; "Sales Type", "Shipping Agent Code", "Shipping Agent Service Code", "Minimum Order Total")
        { }
        key(MINI; "Minimum Order Total")
        { }
    }

}