/// <summary>
/// Page SEW Learning Mgmt Setup (ID 91800).
/// Configuration page for Learning Management system.
/// </summary>
page 91800 "SEW Learning Mgmt Setup"
{
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "SEW Learning Mgmt Setup";
    Caption = 'SEW Learning Mgmt Setup';
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(APISettings)
            {
                field("API URL"; Rec."API URL")
                {
                }
                field("API Locale"; Rec."API Locale")
                {
                }
                field("API Product Filter"; Rec."API Product Filter")
                {
                }
            }
            group(SyncSettings)
            {
                field("Last Sync Date Time"; Rec."Last Sync Date Time")
                {
                }
                field("Sync Frequency"; Rec."Sync Frequency")
                {
                }
            }
            group(AssignmentSettings)
            {
                field("Default Assignment Due Days"; Rec."Default Assignment Due Days")
                {
                }
                field("Auto Create User Tasks"; Rec."Auto Create User Tasks")
                {
                }
                field("Notify on Content Update"; Rec."Notify on Content Update")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunSyncNow)
            {
                Image = Refresh;

                trigger OnAction()
                var
                    CatalogSync: Codeunit "SEW Learn Catalog Sync";
                begin
                    CatalogSync.SyncFullCatalog();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(true);
        end;
    end;
}
