page 91400 "SEW Freight Prices"
{
    Caption = 'Freight Prices';
    DataCaptionExpression = PageCaptionText;
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "SEW Freight Prices";
    UsageCategory = Administration;
    ApplicationArea = All;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(SalesTypeFilter; SalesTypeFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Type Filter';
                    OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign,None';
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnValidate()
                    begin
                        SalesTypeFilterOnAfterValidate();
                    end;
                }
                field(SalesCodeFilterCtrl; SalesCodeFilter)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Code Filter';
                    Enabled = SalesCodeFilterCtrlEnable;
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CustList: page "Customer List";
                        CustomerPriceGroupList: page "Customer Price Groups";
                        CampaignList: page "Campaign List";
                    begin
                        if SalesTypeFilter = SalesTypeFilter::"All Customers" then
                            exit;

                        case SalesTypeFilter of
                            SalesTypeFilter::Customer:
                                begin
                                    CustList.LookupMode := true;
                                    if CustList.RunModal() = ACTION::LookupOK then
                                        Text := CustList.GetSelectionFilter()
                                    else
                                        exit(false);
                                end;
                            SalesTypeFilter::"Customer Price Group":
                                begin
                                    CustomerPriceGroupList.LookupMode := true;
                                    if CustomerPriceGroupList.RunModal() = ACTION::LookupOK then
                                        Text := CustomerPriceGroupList.GetSelectionFilter()
                                    else
                                        exit(false);
                                end;
                            SalesTypeFilter::Campaign:
                                begin
                                    CampaignList.LookupMode := true;
                                    if CampaignList.RunModal() = ACTION::LookupOK then
                                        Text := CampaignList.GetSelectionFilter()
                                    else
                                        exit(false);
                                end;
                        end;

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        SalesCodeFilterOnAfterValidate();
                    end;
                }

            }
            group(Filters)
            {
                Caption = 'Filters';
                field(FilterDescription; GetFilterDescription())
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnAssistEdit()
                    begin
                        FilterLines();
                        CurrPage.Update(false);
                    end;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Sales Type"; Rec."Sales Type")
                {
                    Editable = SalesTypeControlEditable;

                    trigger OnValidate()
                    begin
                        SalesCodeControlEditable := SetSalesCodeEditable(Rec."Sales Type");
                    end;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    Editable = SalesCodeControlEditable;
                }

                field("Sales Code Name"; Rec."Sales Code Name")
                {
                    Editable = false;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                }
                field("Maximum Rate"; Rec."Maximum Rate")
                {
                }
                field("Minimum Order Total"; Rec."Minimum Order Total")
                {
                }
                field("Markup %"; Rec."Markup %")
                {
                }
                field("Markup Amount"; Rec."Markup Amount")
                {
                }
                field("Fixed Price"; Rec."Fixed Price")
                {
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                }
                field("Rate Handling"; Rec."Rate Handling")
                {
                }
                field("Rounding Precision"; Rec."Rounding Precision")
                {
                }

            }
        }
        area(FactBoxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(SalesPricesFilter)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Filter';
                Image = "Filter";
                ToolTip = 'Apply the filter.';

                trigger OnAction()
                begin
                    FilterLines();
                end;
            }
            action(ClearFilter)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Clear Filter';
                Image = ClearFilter;
                ToolTip = 'Clear filter.';

                trigger OnAction()
                begin
                    Rec.Reset();
                    UpdateBasicRecFilters();
                    SetEditableFields();
                end;
            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(SalesPricesFilter_Promoted; SalesPricesFilter)
                {
                }
                actionref(ClearFilter_Promoted; ClearFilter)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SalesCodeControlEditable := SetSalesCodeEditable(Rec."Sales Type");
    end;

    trigger OnInit()
    var
    begin
        SalesCodeFilterCtrlEnable := true;
        SalesCodeControlEditable := true;
    end;

    trigger OnOpenPage()
    var
    begin
        GetRecFilters();
        SetRecFilters();
        SetCaption();
    end;

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord();
        SetRecFilters();
        SetCaption();
    end;

    local procedure SetSalesCodeEditable(SalesType: Enum "Sales Price Type"): Boolean
    begin
        exit(SalesType <> Rec."Sales Type"::"All Customers");
    end;

    local procedure SalesTypeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord();
        SalesCodeFilter := '';
        SetRecFilters();
        SetCaption();
    end;

    procedure SetRecFilters()
    begin
        SalesCodeFilterCtrlEnable := true;

        if SalesTypeFilter <> SalesTypeFilter::None then
            Rec.SetRange("Sales Type", SalesTypeFilter)
        else
            Rec.SetRange("Sales Type");

        if SalesTypeFilter in [SalesTypeFilter::"All Customers", SalesTypeFilter::None] then begin
            SalesCodeFilterCtrlEnable := false;
            SalesCodeFilter := '';
        end;

        if SalesCodeFilter <> '' then
            Rec.SetFilter("Sales Code", SalesCodeFilter)
        else
            Rec.SetRange("Sales Code");




        case SalesTypeFilter of
            SalesTypeFilter::Customer:
                CheckFilters(Database::Customer, SalesCodeFilter);
            SalesTypeFilter::"Customer Price Group":
                CheckFilters(Database::"Customer Price Group", SalesCodeFilter);
            SalesTypeFilter::Campaign:
                CheckFilters(Database::Campaign, SalesCodeFilter);
        end;
        CheckFilters(Database::Item, ItemNoFilter);

        SetEditableFields();
        CurrPage.Update(false);
    end;

    local procedure SetCaption()
    begin
        PageCaptionText := GetFilterDescription();
    end;

    local procedure CheckFilters(TableNo: Integer; FilterTxt: Text)
    var
        FilterRecordRef: RecordRef;
        FilterFieldRef: FieldRef;
    begin
        if FilterTxt = '' then
            exit;
        Clear(FilterRecordRef);
        Clear(FilterFieldRef);
        FilterRecordRef.Open(TableNo);
        FilterFieldRef := FilterRecordRef.Field(1);
        FilterFieldRef.SetFilter(FilterTxt);
        if FilterRecordRef.IsEmpty() then
            Error(Text001Lbl, FilterRecordRef.Caption(), FilterTxt);
    end;

    local procedure FilterLines()
    var
        FilterPageBuilder: FilterPageBuilder;
    begin
#pragma warning disable AL0432 
        FilterPageBuilder.AddTable(Rec.TableCaption(), DATABASE::"Sales Price");
#pragma warning restore AL0432

        FilterPageBuilder.SetView(Rec.TableCaption(), Rec.GetView());
        if Rec.GetFilter("Sales Type") = '' then
            FilterPageBuilder.AddFieldNo(Rec.TableCaption(), Rec.FieldNo("Sales Type"));
        if Rec.GetFilter("Sales Code") = '' then
            FilterPageBuilder.AddFieldNo(Rec.TableCaption(), Rec.FieldNo("Sales Code"));

        if FilterPageBuilder.RunModal() then
            Rec.SetView(FilterPageBuilder.GetView(Rec.TableCaption()));

        UpdateBasicRecFilters();
        SetEditableFields();
    end;

    local procedure SetEditableFields()
    begin
        SalesTypeControlEditable := Rec.GetFilter("Sales Type") = '';
        SalesCodeControlEditable :=
          SalesCodeControlEditable and (Rec.GetFilter("Sales Code") = '');
    end;

    local procedure UpdateBasicRecFilters()
    begin
        if Rec.GetFilter("Sales Type") <> '' then
            SalesTypeFilter := GetSalesTypeFilter()
        else
            SalesTypeFilter := SalesTypeFilter::None;

        SalesCodeFilter := Rec.GetFilter("Sales Code");


    end;

    local procedure GetSalesTypeFilter(): Integer
    begin
        case Rec.GetFilter("Sales Type") of
            Format(Rec."Sales Type"::Customer):
                exit(0);
            Format(Rec."Sales Type"::"Customer Price Group"):
                exit(1);
            Format(Rec."Sales Type"::"All Customers"):
                exit(2);
            Format(Rec."Sales Type"::Campaign):
                exit(3);
        end;
    end;

    local procedure GetFilterDescription(): Text
    var
        ObjectTranslation: Record "Object Translation";
        SourceTableName: Text;
        SalesSrcTableName: Text;
        Description: Text;
    begin
        GetRecFilters();

        SourceTableName := '';
        if ItemNoFilter <> '' then
            SourceTableName := ObjectTranslation.TranslateObject(ObjectTranslation."Object Type"::Table, 27);

        SalesSrcTableName := '';
        Description := '';
        case SalesTypeFilter of
            SalesTypeFilter::Customer:
                begin
                    SalesSrcTableName := ObjectTranslation.TranslateObject(ObjectTranslation."Object Type"::Table, 18);
                    Customer."No." := CopyStr(SalesCodeFilter, 1, MaxStrLen(Customer."No."));
                    if Customer.Find() then
                        Description := Customer.Name;
                end;
            SalesTypeFilter::"Customer Price Group":
                begin
                    SalesSrcTableName := ObjectTranslation.TranslateObject(ObjectTranslation."Object Type"::Table, 6);
                    CustomerPriceGroup.Code := CopyStr(SalesCodeFilter, 1, MaxStrLen(CustomerPriceGroup.Code));
                    if CustomerPriceGroup.Find() then
                        Description := CustomerPriceGroup.Description;
                end;
            SalesTypeFilter::Campaign:
                begin
                    SalesSrcTableName := ObjectTranslation.TranslateObject(ObjectTranslation."Object Type"::Table, 5071);
                    Campaign."No." := CopyStr(SalesCodeFilter, 1, MaxStrLen(Campaign."No."));
                    if Campaign.Find() then
                        Description := Campaign.Description;
                end;
            SalesTypeFilter::"All Customers":
                SalesSrcTableName := Text000Lbl;
        end;

        if SalesSrcTableName = Text000Lbl then
            exit(StrSubstNo('%1 %2 %3', SalesSrcTableName, SourceTableName, ItemNoFilter));
        exit(StrSubstNo('%1 %2 %3 %4 %5', SalesSrcTableName, SalesCodeFilter, Description, SourceTableName, ItemNoFilter));
    end;

    local procedure GetRecFilters()
    begin
        if Rec.GetFilters() <> '' then
            UpdateBasicRecFilters();
    end;

    var
        Customer: Record Customer;
        CustomerPriceGroup: Record "Customer Price Group";
        Campaign: Record Campaign;

        SalesTypeFilter: Option Customer,"Customer Price Group","All Customers",Campaign,"None";
        SalesCodeFilter: Text;
        ItemNoFilter: Text;
        SalesCodeFilterCtrlEnable: Boolean;
        SalesTypeControlEditable: Boolean;
        SalesCodeControlEditable: Boolean;
        Text000Lbl: Label 'All Customers';
        Text001Lbl: Label 'No %1 within the filter %2.', Comment = 'No %1 Idea %2';
        PageCaptionText: Text;

}
