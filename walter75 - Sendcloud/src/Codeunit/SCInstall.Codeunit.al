codeunit 95700 "SEW SC Install"
{
    Subtype = Install;
    Access = Internal;
    Permissions = tabledata "SEW SendCloud Setup" = rimd,
                  tabledata "No. Series" = rimd,
                  tabledata "No. Series Line" = rimd,
                  tabledata "Job Queue Entry" = rimd,
                  tabledata "Job Queue Category" = rimd;

    trigger OnInstallAppPerCompany()
    var
        SEWSendCloudSetup: Record "SEW SendCloud Setup";
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueCategory: Record "Job Queue Category";
    begin

        NoSeries.SetRange("Code", 'SC-PARCEL');
        if not NoSeries.FindFirst() then begin
            NoSeries.Init();
            NoSeries."Code" := 'SC-PARCEL';
            NoSeries.Description := 'SendCloud Parcel No. Series';
            NoSeries."Default Nos." := true;
            NoSeries.Insert(false);
        end;

        NoSeriesLine.SetRange("Series Code", 'SC-PARCEL');
        if not NoSeriesLine.FindFirst() then begin
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'SC-PARCEL';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'PAR20001';
            NoSeriesLine."Increment-by No." := 1;
            NoSeriesLine."Last No. Used" := 'PAR20001';
            NoSeriesLine.Open := true;
            NoSeriesLine."Starting Sequence No." := 100000;
            NoSeriesLine.Implementation := NoSeriesLine.Implementation::Sequence;
            NoSeriesLine.Insert(false);
        end;

        NoSeries.SetRange("Code", 'SC-RECIPIENT');
        if not NoSeries.FindFirst() then begin
            NoSeries.Init();
            NoSeries."Code" := 'SC-RECIPIENT';
            NoSeries.Description := 'SendCloud Recipient No. Series';
            NoSeries."Default Nos." := true;
            NoSeries.Insert(false);
        end;

        NoSeriesLine.SetRange("Series Code", 'SC-RECIPIENT');
        if not NoSeriesLine.FindFirst() then begin
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'SC-RECIPIENT';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'REC20001';
            NoSeriesLine."Increment-by No." := 1;
            NoSeriesLine."Last No. Used" := 'REC20001';
            NoSeriesLine.Open := true;
            NoSeriesLine."Starting Sequence No." := 100000;
            NoSeriesLine.Implementation := NoSeriesLine.Implementation::Sequence;
            NoSeriesLine.Insert(false);
        end;

        SEWSendCloudSetup.InsertIfNotExists();

        if not SEWSendCloudSetup.Get() then
            SEWSendCloudSetup.InsertIfNotExists();

        SEWSendCloudSetup."API Public Key" := '21bb96d5-8973-43c4-bd32-438795f60a01';
        SEWSendCloudSetup."API Secret Key" := '24d708ee781d4c9d8a8dec6dfde4bd97';
        SEWSendCloudSetup."Parcel No. Series" := 'SC-PARCEL';
        SEWSendCloudSetup."Recipient No. Series" := 'SC-RECIPIENT';
        SEWSendCloudSetup.Modify(false);


        // Job Queue Setup for SendCloud Auto Jobs

        Clear(JobQueueCategory);
        if not JobQueueCategory.Get('SENDCLOUD') then begin
            JobQueueCategory.Init();
            JobQueueCategory.Code := 'SENDCLOUD';
            JobQueueCategory.Description := 'SendCloud Update Tasks';
            JobQueueCategory.Insert(true);
        end;

        Clear(JobQueueEntry);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"SEW SC Auto Jobs");
        JobQueueEntry.SetRange("Parameter String", 'ParcelListUpdates');
        if not JobQueueEntry.FindFirst() then begin
            JobQueueEntry.Init();
            JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
            JobQueueEntry.Validate("Object ID to Run", Codeunit::"SEW SC Auto Jobs"); // SEW Packages Auto Jobs
            JobQueueEntry."Parameter String" := 'ParcelListUpdates';
            JobQueueEntry.Description := 'SendCloud Parcel List Update';
            JobQueueEntry."Job Queue Category Code" := 'SENDCLOUD';
            JobQueueEntry."No. of Attempts to Run" := 5;

            JobQueueEntry."Recurring Job" := true;
            JobQueueEntry."Run on Mondays" := true;
            JobQueueEntry."Run on Tuesdays" := true;
            JobQueueEntry."Run on Wednesdays" := true;
            JobQueueEntry."Run on Thursdays" := true;
            JobQueueEntry."Run on Fridays" := true;
            JobQueueEntry."Run on Saturdays" := true;
            JobQueueEntry."Run on Sundays" := true;


            JobQueueEntry."Starting Time" := 000001T;
            JobQueueEntry."Ending Time" := 235959T;
            JobQueueEntry."No. of Minutes between Runs" := 15;
            JobQueueEntry."Inactivity Timeout Period" := 5;

            JobQueueEntry."Maximum No. of Attempts to Run" := 5;
            JobQueueEntry."Rerun Delay (sec.)" := 60;

            JobQueueEntry.Status := JobQueueEntry.Status::"On Hold";

            JobQueueEntry.Insert(true);
        end;

        Clear(JobQueueEntry);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"SEW SC Auto Jobs");
        JobQueueEntry.SetRange("Parameter String", 'SenderAddressList');
        if not JobQueueEntry.FindFirst() then begin
            JobQueueEntry.Init();
            JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
            JobQueueEntry.Validate("Object ID to Run", Codeunit::"SEW SC Auto Jobs"); // SEW Packages Auto Jobs
            JobQueueEntry."Parameter String" := 'SenderAddressList';
            JobQueueEntry.Description := 'SendCloud Update Sender Addresses';
            JobQueueEntry."Job Queue Category Code" := 'SENDCLOUD';
            JobQueueEntry."No. of Attempts to Run" := 5;

            JobQueueEntry."Recurring Job" := true;
            JobQueueEntry."Run on Mondays" := true;
            JobQueueEntry."Run on Tuesdays" := true;
            JobQueueEntry."Run on Wednesdays" := true;
            JobQueueEntry."Run on Thursdays" := true;
            JobQueueEntry."Run on Fridays" := true;

            JobQueueEntry."Starting Time" := 073000T;
            JobQueueEntry."Ending Time" := 170000T;
            JobQueueEntry."No. of Minutes between Runs" := 120;
            JobQueueEntry."Inactivity Timeout Period" := 5;

            JobQueueEntry."Maximum No. of Attempts to Run" := 5;
            JobQueueEntry."Rerun Delay (sec.)" := 60;

            JobQueueEntry.Status := JobQueueEntry.Status::"On Hold";

            JobQueueEntry.Insert(true);
        end;

        Clear(JobQueueEntry);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"SEW SC Auto Jobs");
        JobQueueEntry.SetRange("Parameter String", 'ShippingMethods');
        if not JobQueueEntry.FindFirst() then begin
            JobQueueEntry.Init();
            JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
            JobQueueEntry.Validate("Object ID to Run", Codeunit::"SEW SC Auto Jobs"); // SEW Packages Auto Jobs
            JobQueueEntry."Parameter String" := 'ShippingMethods';
            JobQueueEntry.Description := 'Update SendCloud Shipping Methods';
            JobQueueEntry."Job Queue Category Code" := 'SENDCLOUD';
            JobQueueEntry."No. of Attempts to Run" := 5;

            JobQueueEntry."Recurring Job" := true;
            JobQueueEntry."Run on Mondays" := true;
            JobQueueEntry."Run on Tuesdays" := true;
            JobQueueEntry."Run on Wednesdays" := true;
            JobQueueEntry."Run on Thursdays" := true;
            JobQueueEntry."Run on Fridays" := true;

            JobQueueEntry."Starting Time" := 073000T;
            JobQueueEntry."Ending Time" := 170000T;
            JobQueueEntry."No. of Minutes between Runs" := 120;
            JobQueueEntry."Inactivity Timeout Period" := 5;

            JobQueueEntry."Maximum No. of Attempts to Run" := 5;
            JobQueueEntry."Rerun Delay (sec.)" := 60;

            JobQueueEntry.Status := JobQueueEntry.Status::"On Hold";

            JobQueueEntry.Insert(true);
        end;


    end;


}

