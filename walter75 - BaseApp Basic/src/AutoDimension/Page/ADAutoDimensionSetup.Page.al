page 80011 "SEW AD Auto Dimension Setup"
{
    ApplicationArea = All;
    Caption = 'Auto Dimension Setup';
    PageType = Card;
    SourceTable = "SEW Auto Dimension Setup";
    UsageCategory = Administration;
    Permissions = tabledata "Customer" = rimd,
                    tabledata "Item" = rimd;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Customer Dimension"; Rec."Customer Dimension")
                {
                }
                field("Territory Dimension"; Rec."Territory Dimension")
                {
                }
                field("Item Category Dimension"; Rec."Item Category Dimension")
                {
                }
                field("Item Dimension"; Rec."Item Dimension")
                {
                }
                field("Salesperson Dimension"; Rec."Salesperson Dimension")
                {
                }
                field("Campaign Dimension"; Rec."Campaign Dimension")
                {
                }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action("SEW Dimensions")
            {
                ApplicationArea = Dimensions;
                Caption = 'Create/Update Dimensions';
                Image = Dimensions;
                ToolTip = 'Create and update all default dimensions.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    SEWADDimensionMgmt: Codeunit "SEW AD Dimension Mgmt";
                begin
                    SEWADDimensionMgmt.CreateAndUpdateAllDefaultDimensions();
                    Message(MessageAllLbl);
                end;
            }
            action("SEW DimCustomer")
            {
                ApplicationArea = Dimensions;
                Caption = 'Create/Update Territory Dimensions';
                Image = Customer;
                ToolTip = 'Create and update all Territory dimensions.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    Customer: Record Customer;
                begin
                    if Customer.FindSet(false) then
                        repeat
                            if Customer."Territory Code" <> '' then
                                Customer.Validate("Territory Code", Customer."Territory Code");
                        until Customer.Next() = 0;
                    Message(MessageCustomerLbl);
                end;
            }
            action("SEW DimItem")
            {
                ApplicationArea = Dimensions;
                Caption = 'Create/Update Item Dimensions';
                Image = Item;
                ToolTip = 'Create and update all Item dimensions.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    Item: Record Item;
                begin
                    if Item.FindSet(false) then
                        repeat
                            if Item."Item Category Code" <> '' then
                                Item.Validate("Item Category Code", Item."Item Category Code");
                        until Item.Next() = 0;
                    Message(MessageItemLbl);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;

    var
        MessageItemLbl: Label 'Item Dimensions updated.', Comment = 'Message shown when Item Dimensions have been updated.';
        MessageCustomerLbl: Label 'Customer Dimensions updated.', Comment = 'Message shown when Customer Dimensions have been updated.';
        MessageAllLbl: Label 'Default Dimensions created/updated.', Comment = 'Message shown when all default Dimensions have been created or updated.';
}
