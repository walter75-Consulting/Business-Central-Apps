controladdin "SEW Sub to Parent"
{
    MaximumHeight = 1;
    MaximumWidth = 1;
    MinimumHeight = 1;
    MinimumWidth = 1;
    HorizontalShrink = true;
    VerticalShrink = true;
    VerticalStretch = true;
    HorizontalStretch = true;
    RequestedHeight = 1;
    RequestedWidth = 1;
    Scripts = 'src/ControlAddin/SubtoParent/interpagecommunication.js';
    event PingFromSubPage(SelectedParcelNo: Code[20]);
    procedure PingParentPage(SelectedParcelNo: Code[20]);
}