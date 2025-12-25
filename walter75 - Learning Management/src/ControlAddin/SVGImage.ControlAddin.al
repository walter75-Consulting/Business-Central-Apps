/// <summary>
/// Control Add-in SEW SVG Image Display (ID 91860).
/// Renders SVG and other image formats in the browser.
/// </summary>
controladdin "SEW SVG Image Display"
{
    RequestedHeight = 120;
    RequestedWidth = 200;
    MinimumHeight = 80;
    MinimumWidth = 150;
    VerticalStretch = false;
    HorizontalStretch = false;
    VerticalShrink = true;
    HorizontalShrink = true;

    Scripts = 'src/ControlAddin/SVGImage.js';
    StyleSheets = 'src/ControlAddin/SVGImage.css';
    StartupScript = 'src/ControlAddin/SVGImageStartup.js';

    /// <summary>
    /// Loads an image from the specified URL.
    /// </summary>
    /// <param name="imageUrl">The URL of the image to display.</param>
    procedure LoadImage(imageUrl: Text);

    /// <summary>
    /// Clears the displayed image.
    /// </summary>
    procedure ClearImage();

    event ImageLoaded();
    event ImageError(errorMessage: Text);
    event ControlReady();
}
