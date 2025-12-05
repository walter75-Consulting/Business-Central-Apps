Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('Ready','');

var focusFieldName = null;
var focusAttempts = 0;
var maxFocusAttempts = 10;

function SetFocusOnField(fieldNo)
{
    focusFieldName = fieldNo;
    focusAttempts = 0;
    
    // Use requestAnimationFrame to sync with browser's rendering cycle
    // This prevents fighting with BC's DOM updates
    requestAnimationFrame(function() {
        attemptFocus();
    });
}

function attemptFocus()
{
    try {
        if (!focusFieldName || focusAttempts >= maxFocusAttempts) {
            if (focusAttempts >= maxFocusAttempts) {
                console.warn('SEW Focus: Max attempts reached for field:', focusFieldName);
            }
            return;
        }
        
        focusAttempts++;
        
        // Try to find and focus the input field
        var element = window.parent.document.querySelector(`[controlname^='${focusFieldName}'] input`) ||
                      window.parent.document.querySelector(`[controlname*='${focusFieldName}'] input`) ||
                      window.parent.document.querySelector(`input[aria-label*='Input']`);
        
        if (element && typeof element.focus === 'function' && 
            window.parent.document.activeElement !== element) {
            
            window.parent.focus();
            element.focus();
            element.select();
            console.log('SEW Focus: Set focus on attempt', focusAttempts, 'for field:', focusFieldName);
            
            // Verify focus stuck after a short delay
            setTimeout(function() {
                if (window.parent.document.activeElement !== element) {
                    console.log('SEW Focus: Focus lost, retrying...');
                    requestAnimationFrame(attemptFocus);
                } else {
                    console.log('SEW Focus: Focus confirmed on field:', focusFieldName);
                    focusFieldName = null; // Success, stop trying
                }
            }, 100);
            
        } else if (!element) {
            // Element not found, retry
            console.log('SEW Focus: Element not found on attempt', focusAttempts, ', retrying...');
            setTimeout(function() {
                requestAnimationFrame(attemptFocus);
            }, 150);
        } else {
            // Element already focused, done
            console.log('SEW Focus: Field already focused:', focusFieldName);
            focusFieldName = null;
        }
        
    } catch (error) {
        console.error('SEW Focus: Error on attempt', focusAttempts, ':', error);
        // Retry on error
        if (focusAttempts < maxFocusAttempts) {
            setTimeout(function() {
                requestAnimationFrame(attemptFocus);
            }, 150);
        }
    }
}