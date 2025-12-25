// SEW SVG Image Display Control Add-in
// Renders SVG and other image formats

function LoadImage(imageUrl) {
    if (!imageUrl || imageUrl === '') {
        ClearImage();
        return;
    }

    var container = document.getElementById(Microsoft.Dynamics.NAV.GetImageResource('controlAddIn'));
    if (!container) {
        container = document.body;
    }

    // Create image element
    var img = document.createElement('img');
    img.src = imageUrl;
    img.alt = 'Content Icon';
    img.className = 'sew-svg-image';
    
    // Handle load success
    img.onload = function() {
        container.innerHTML = '';
        container.appendChild(img);
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ImageLoaded', []);
    };
    
    // Handle load error
    img.onerror = function() {
        container.innerHTML = '<div class="sew-image-error">Image not available</div>';
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ImageError', ['Failed to load image']);
    };
}

function ClearImage() {
    var container = document.getElementById(Microsoft.Dynamics.NAV.GetImageResource('controlAddIn'));
    if (!container) {
        container = document.body;
    }
    container.innerHTML = '';
}
