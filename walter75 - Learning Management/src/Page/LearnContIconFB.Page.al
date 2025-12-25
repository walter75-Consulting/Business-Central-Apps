/// <summary>
/// Page SEW Content Icon FactBox (ID 91860).
/// Displays the content icon/image from Microsoft Learn.
/// </summary>
page 91860 "SEW Learn Cont Icon FB"
{
    PageType = CardPart;
    SourceTable = "SEW Learn Cont";
    Caption = 'Learn Content Icon';
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            usercontrol(IconDisplay; "SEW SVG Image Display")
            {
                ApplicationArea = All;

                trigger ControlReady()
                begin
                    ControlIsReady := true;
                    UpdateImage();
                end;

                trigger ImageLoaded()
                begin
                end;

                trigger ImageError(errorMessage: Text)
                begin
                    // Silently handle error - fallback already shown in JS
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateImage();
    end;

    local procedure UpdateImage()
    begin
        if not ControlIsReady then
            exit;

        if Rec."Icon URL" <> '' then
            CurrPage.IconDisplay.LoadImage(Rec."Icon URL")
        else
            CurrPage.IconDisplay.ClearImage();
    end;

    var
        ControlIsReady: Boolean;
}
