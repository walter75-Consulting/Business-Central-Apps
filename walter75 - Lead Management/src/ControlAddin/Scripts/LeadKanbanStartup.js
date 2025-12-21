// Lead Kanban Control Add-in Startup Script
// Initializes the control add-in when loaded

var kanbanBoard = null;
var currentBoardData = null;

// Notify AL that the control is ready
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('OnControlReady', []);
