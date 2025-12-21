controladdin "SEW Lead Kanban"
{
    RequestedHeight = 600;
    RequestedWidth = 1200;
    MinimumHeight = 400;
    MinimumWidth = 800;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;

    Scripts = 'src/ControlAddin/Scripts/jkanban.min.js',
              'src/ControlAddin/Scripts/LeadKanbanController.js';

    StyleSheets = 'src/ControlAddin/Styles/jkanban.min.css',
                  'src/ControlAddin/Styles/LeadKanban.css';

    StartupScript = 'src/ControlAddin/Scripts/LeadKanbanStartup.js';

    /// <summary>
    /// Initialize the Kanban board with stage and lead data
    /// </summary>
    /// <param name="boardDataJson">JSON string containing boards array with stages and leads</param>
    procedure InitializeBoard(boardDataJson: Text);

    /// <summary>
    /// Refresh the Kanban board with updated data
    /// </summary>
    /// <param name="boardDataJson">JSON string containing updated board data</param>
    procedure RefreshBoard(boardDataJson: Text);

    /// <summary>
    /// Event triggered when a lead card is moved to a different stage
    /// </summary>
    /// <param name="leadNo">The lead number</param>
    /// <param name="newStageCode">The new stage code</param>
    event OnCardMoved(leadNo: Text; newStageCode: Text);

    /// <summary>
    /// Event triggered when a lead card is clicked
    /// </summary>
    /// <param name="leadNo">The lead number that was clicked</param>
    event OnCardClicked(leadNo: Text);

    /// <summary>
    /// Event triggered when the control add-in is ready
    /// </summary>
    event OnControlReady();
}
