controladdin "SEW Button"
{
    RequestedHeight = 76;
    MinimumHeight = 72;
    MinimumWidth = 84;
    VerticalStretch = false;
    HorizontalStretch = true;
    VerticalShrink = true;
    HorizontalShrink = true;

    Scripts =
        'src/_Button/Controls/BaseControl.js',
        'src/_Button/Controls/Button/Button.js';
    StyleSheets =
        'src/_Button/Controls/BaseControl.css',
        'src/_Button/Controls/Button/Button.css';
    StartupScript =
        'src/_Button/Controls/Button/startup.js';

    //#region Base Events

    event OnLoad();

    event OnError(message: Text);

    //#endregion

    event OnClick(buttonId: Text);

    procedure SetOption("key": Text; "value": Text);
}