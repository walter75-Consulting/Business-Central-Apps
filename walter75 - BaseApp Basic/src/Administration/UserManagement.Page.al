page 80004 "SEW User Management"
{

    Caption = 'User Management';
    PageType = List;
    SourceTable = User;
    UsageCategory = Administration;
    Editable = false;
    ApplicationArea = All;
    Permissions = tabledata "User" = rmid,
                    tabledata "User Setup" = rmid,
                    tabledata "Warehouse Employee" = rmid,
                    tabledata "FA Journal Setup" = rmid,
                    tabledata Resource = rmid,
                    tabledata Employee = rmid,
                    tabledata "Salesperson/Purchaser" = rmid;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the user name.';
                    Width = 5;
                }
                field("Full Name"; Rec."Full Name")
                {

                    ToolTip = 'Specifies the full name of the user.';
                    Width = 10;
                }
                field(State; Rec.State)
                {
                    ToolTip = 'Specifies the state of the user.';
                    Width = 5;
                }
                field(SettingsCtl; Settings)
                {
                    Editable = false;
                    Caption = 'Settings';
                    Width = 1;
                    ToolTip = 'Specifies whether the user has personalized settings.';
                    trigger OnDrillDown()
                    var
                        UserSettings: Record "User Personalization";
                    begin
                        UserSettings.SetRange("User SID", Rec."User Security ID");
                        Page.RunModal(Page::"User Personalization", UserSettings);
                        CurrPage.Update();
                    end;
                }
                field(AccountingSetupCtl; AccountingSetup)
                {
                    Editable = false;
                    Caption = 'Accounting';
                    Width = 1;
                    ToolTip = 'Specifies whether the user has accounting setup.';
                    trigger OnDrillDown()
                    var
                        UserSetup: Record "User Setup";
                    begin
                        UserSetup.SetRange("User ID", Rec."User Name");
                        Page.RunModal(Page::"User Setup", UserSetup);
                        CurrPage.Update();
                    end;
                }
                field(ApprovalCtl; Approval)
                {
                    Editable = false;
                    Caption = 'Approval';
                    Width = 1;
                    ToolTip = 'Specifies whether the user has approval settings.';
                    trigger OnDrillDown()
                    var
                        UserSetup: Record "User Setup";
                    begin
                        UserSetup.SetRange("User ID", Rec."User Name");
                        Page.RunModal(Page::"Approval User Setup", UserSetup);
                        CurrPage.Update();
                    end;
                }
                field(WarehouseCtl; Warehouse)
                {
                    Editable = false;
                    Caption = 'Warehouse';
                    Width = 1;
                    ToolTip = 'Specifies whether the user is associated with a warehouse.';
                    trigger OnDrillDown()
                    var
                        WarehouseEmployee: Record "Warehouse Employee";
                    begin
                        WarehouseEmployee.SetRange("User ID", Rec."User Name");
                        Page.RunModal(Page::"Warehouse Employees", WarehouseEmployee);
                        CurrPage.Update();
                    end;
                }
                field(FACtl; FA)
                {
                    Editable = false;
                    Caption = 'Fixed Assets';
                    Width = 1;
                    ToolTip = 'Specifies whether the user is associated with fixed assets.';
                    trigger OnDrillDown()
                    var
                        FAJournalSetup: Record "FA Journal Setup";
                    begin
                        FAJournalSetup.SetRange("User ID", Rec."User Name");
                        Page.RunModal(Page::"FA Journal Setup", FAJournalSetup);
                        CurrPage.Update();
                    end;
                }
                field(EmployeeCtl; Employee)
                {
                    Editable = false;
                    Caption = 'Employee';
                    Width = 1;
                    ToolTip = 'Specifies whether the user is associated with an employee.';
                    trigger OnDrillDown()
                    var
                        Employee: Record Employee;
                    begin
                        Employee.SetRange("No.", Rec."User Name");
                        Page.RunModal(Page::"Employee Card", Employee);
                        CurrPage.Update();
                    end;
                }
                field(ResourceCtl; Resource)
                {
                    Editable = false;
                    Caption = 'Resource';
                    Width = 1;
                    ToolTip = 'Specifies whether the user is associated with a resource.';
                    trigger OnDrillDown()
                    var
                        Resource: Record Resource;
                    begin
                        Resource.SetRange("No.", Rec."User Name");
                        Page.RunModal(Page::"Resource Card", Resource);
                        CurrPage.Update();
                    end;
                }
                field(SalesPersonCtl; SalesPerson)
                {
                    Editable = false;
                    Caption = 'Salesperson';
                    Width = 1;
                    ToolTip = 'Specifies whether the user is associated with a salesperson.';
                    trigger OnDrillDown()
                    var
                        SalespersonPurchaser: Record "Salesperson/Purchaser";
                    begin
                        SalespersonPurchaser.SetRange("E-Mail", Rec."Authentication Email");
                        Page.RunModal(Page::"Salesperson/Purchaser Card", SalespersonPurchaser);
                        CurrPage.Update();
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        UpdateGlobals();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateGlobals();
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Authentication Email", '*@*');
    end;

    local procedure UpdateGlobals()
    var
        UserPersonalization: Record "User Personalization";
        UserSetup: Record "User Setup";
        WarehouseEmployee: Record "Warehouse Employee";
        FAJournalSetup: Record "FA Journal Setup";
        ResourceRec: Record Resource;
        EmployeeRec: Record Employee;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
    begin

        UserPersonalization.SetRange("User SID", Rec."User Security ID");
        if UserPersonalization.IsEmpty() then
            Settings := '❌'
        else
            Settings := '✅';


        UserSetup.SetRange("User ID", Rec."User Name");
        if UserSetup.IsEmpty() then
            AccountingSetup := '❌'
        else
            AccountingSetup := '✅';
        Approval := '❌';
        if UserSetup.FindFirst() then
            if (UserSetup."Sales Amount Approval Limit" <> 0) or
               (UserSetup."Purchase Amount Approval Limit" <> 0) or
               (UserSetup."Unlimited Sales Approval") or
               (UserSetup."Unlimited Purchase Approval") or
               (UserSetup."Unlimited Request Approval") or
               (UserSetup."Unlimited Request Approval") or
               (UserSetup."Approver ID" <> '') then
                Approval := '✅';

        WarehouseEmployee.SetRange("User ID", Rec."User Name");
        if WarehouseEmployee.IsEmpty() then
            Warehouse := '❌'
        else
            Warehouse := '✅';

        FAJournalSetup.SetRange("User ID", Rec."User Name");
        if FAJournalSetup.IsEmpty() then
            FA := '❌'
        else
            FA := '✅';

        EmployeeRec.Reset();
        EmployeeRec.SetFilter("Company E-Mail", CopyStr(Rec."Authentication Email", 1, MaxStrLen(EmployeeRec."Company E-Mail")));
        if EmployeeRec.IsEmpty() then
            Employee := '❌'
        else begin
            Employee := '✅';
            EmployeeRec.FindFirst();
        end;


        ResourceRec.SetRange("No.", CopyStr(EmployeeRec."Resource No.", 1, MaxStrLen(ResourceRec."No.")));
        if ResourceRec.IsEmpty() then
            Resource := '❌'
        else
            Resource := '✅';

        SalespersonPurchaser.SetRange("Code", CopyStr(EmployeeRec."Salespers./Purch. Code", 1, MaxStrLen(SalespersonPurchaser."Code")));
        if SalespersonPurchaser.IsEmpty() then
            SalesPerson := '❌'
        else
            SalesPerson := '✅';


    end;

    var
        Settings: Text;
        AccountingSetup: Text;
        Approval: Text;
        Warehouse: Text;
        FA: Text;
        Resource: Text;
        Employee: Text;
        SalesPerson: Text;
}