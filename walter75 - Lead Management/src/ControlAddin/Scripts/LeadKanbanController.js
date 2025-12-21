// Lead Kanban Control Add-in Controller
// Manages jKanban board initialization and event handling

var kanbanBoard = null;
var currentBoardData = null;

function InitializeBoard(boardDataJson) {
    try {
        console.log('InitializeBoard called with data:', boardDataJson);
        currentBoardData = JSON.parse(boardDataJson);
        console.log('Parsed board data:', currentBoardData);
        
        // Destroy existing board if present
        if (kanbanBoard) {
            var kanbanContainer = document.getElementById('kanban-board');
            if (kanbanContainer) {
                kanbanContainer.innerHTML = '';
            }
        }

        // Get or create container - must use the control add-in's root element
        var container = document.getElementById('kanban-board');
        if (!container) {
            // In BC control add-ins, use the first div in the document (the control container)
            var controlRoot = document.querySelector('div');
            if (!controlRoot) {
                controlRoot = document.body;
            }
            
            container = document.createElement('div');
            container.id = 'kanban-board';
            container.style.width = '100%';
            container.style.height = '100%';
            container.style.overflow = 'auto';
            controlRoot.appendChild(container);
            console.log('Created kanban-board container inside control add-in');
        }

        // Initialize jKanban
        kanbanBoard = new jKanban({
            element: '#kanban-board',
            gutter: '12px',
            widthBoard: '220px',
            boards: currentBoardData.boards,
            dragBoards: false, // Don't allow stage reordering
            dragEl: function(el, source) {
                // Drag start - add visual feedback
                el.classList.add('is-dragging');
            },
            dropEl: function(el, target, source, sibling) {
                // Drag end - remove visual feedback
                el.classList.remove('is-dragging');
                
                // Get lead number from data attribute
                var leadNo = el.getAttribute('data-eid');
                
                // Get new stage code from target board
                var targetBoardId = target.parentElement.getAttribute('data-id');
                
                // Notify AL about the move
                Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('OnCardMoved', [leadNo, targetBoardId]);
            },
            click: function(el) {
                // Card clicked - open lead card
                var leadNo = el.getAttribute('data-eid');
                Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('OnCardClicked', [leadNo]);
            }
        });

        console.log('Kanban board initialized successfully');

    } catch (error) {
        console.error('Error initializing Kanban board:', error);
    }
}

function RefreshBoard(boardDataJson) {
    // Re-initialize the board with new data
    InitializeBoard(boardDataJson);
}
