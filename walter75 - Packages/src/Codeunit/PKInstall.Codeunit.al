codeunit 90700 "SEW PK Install"
{
    Subtype = Install;
    Access = Internal;
    Permissions = tabledata "Job Queue Entry" = rimd,
                  tabledata "Job Queue Category" = rimd;




    trigger OnInstallAppPerCompany()
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueCategory: Record "Job Queue Category";
    begin
        Clear(JobQueueCategory);
        if not JobQueueCategory.Get('WH-PRINT') then begin
            JobQueueCategory.Init();
            JobQueueCategory.Code := 'WH-PRINT';
            JobQueueCategory.Description := 'Warehouse Printing Tasks';
            JobQueueCategory.Insert(true);
        end;

        Clear(JobQueueEntry);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"SEW PK Auto Jobs");
        JobQueueEntry.SetRange("Parameter String", 'PrintPicklist');
        if not JobQueueEntry.FindFirst() then begin
            JobQueueEntry.Init();
            JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
            JobQueueEntry.Validate("Object ID to Run", Codeunit::"SEW PK Auto Jobs"); // SEW Packages Auto Jobs
            JobQueueEntry."Parameter String" := 'PrintPicklist';
            JobQueueEntry.Description := 'Print Picklists for Released Warehouse Shipments';
            JobQueueEntry."Job Queue Category Code" := 'WH-PRINT';
            JobQueueEntry."No. of Attempts to Run" := 5;

            JobQueueEntry."Recurring Job" := true;
            JobQueueEntry."Run on Mondays" := true;
            JobQueueEntry."Run on Tuesdays" := true;
            JobQueueEntry."Run on Wednesdays" := true;
            JobQueueEntry."Run on Thursdays" := true;
            JobQueueEntry."Run on Fridays" := true;

            JobQueueEntry."Starting Time" := 073000T;
            JobQueueEntry."Ending Time" := 170000T;
            JobQueueEntry."No. of Minutes between Runs" := 15;
            JobQueueEntry."Inactivity Timeout Period" := 5;

            JobQueueEntry."Maximum No. of Attempts to Run" := 5;
            JobQueueEntry."Rerun Delay (sec.)" := 60;

            JobQueueEntry.Status := JobQueueEntry.Status::"On Hold";

            JobQueueEntry.Insert(true);
        end;


        Clear(JobQueueEntry);
        JobQueueEntry.SetRange("Object ID to Run", Report::"Create Invt Put-away/Pick/Mvmt");
        if not JobQueueEntry.FindFirst() then begin
            JobQueueEntry.Init();
            JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Report;
            JobQueueEntry.Validate("Object ID to Run", Report::"Create Invt Put-away/Pick/Mvmt");
            JobQueueEntry.Description := 'Create Inventory Pick Orders';
            JobQueueEntry."Job Queue Category Code" := 'WH-PRINT';
            JobQueueEntry."No. of Attempts to Run" := 5;
            JobQueueEntry."Report Request Page Options" := true;
            JobQueueEntry."Report Output Type" := JobQueueEntry."Report Output Type"::"None (Processing only)";

            JobQueueEntry."Recurring Job" := true;
            JobQueueEntry."Run on Mondays" := true;
            JobQueueEntry."Run on Tuesdays" := true;
            JobQueueEntry."Run on Wednesdays" := true;
            JobQueueEntry."Run on Thursdays" := true;
            JobQueueEntry."Run on Fridays" := true;

            JobQueueEntry."Starting Time" := 073000T;
            JobQueueEntry."Ending Time" := 170000T;
            JobQueueEntry."No. of Minutes between Runs" := 15;
            JobQueueEntry."Inactivity Timeout Period" := 5;

            JobQueueEntry."Maximum No. of Attempts to Run" := 5;
            JobQueueEntry."Rerun Delay (sec.)" := 60;

            JobQueueEntry.Status := JobQueueEntry.Status::"On Hold";

            JobQueueEntry.Insert(true);
        end;





    end;


}

