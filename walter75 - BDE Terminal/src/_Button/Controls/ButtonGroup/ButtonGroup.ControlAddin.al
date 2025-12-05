controladdin "SEW ButtonGroup"
{
    RequestedHeight = 80;
    MinimumHeight = 72;
    MinimumWidth = 84;
    VerticalStretch = false;
    HorizontalStretch = true;
    VerticalShrink = true;
    HorizontalShrink = true;

    Scripts =
        'src/_Button/Controls/BaseControl.js',
        'src/_Button/Controls/Button/Button.js',
        'src/_Button/Controls/ButtonGroup/ButtonGroup.js';
    StyleSheets =
        'src/_Button/Controls/BaseControl.css',
        'src/_Button/Controls/Button/Button.css',
        'src/_Button/Controls/ButtonGroup/ButtonGroup.css';
    StartupScript =
        'src/_Button/Controls/ButtonGroup/startup.js';

    //#region Base Events

    event OnLoad();

    event OnError(message: Text);

    //#endregion

    event OnClick(id: Text);

    procedure AddButton(caption: Text; title: Text; id: Text; "type": Text);

    procedure RemoveButton(id: Text);
}