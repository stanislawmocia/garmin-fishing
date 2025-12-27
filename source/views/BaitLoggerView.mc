using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Lang;

/**
 * BaitLoggerView
 * Main menu view using Menu2
 */
class BaitLoggerView extends WatchUi.Menu2 {

    private var _baitProvider;
    private var _catchLogger;
    private var _syncService;

    /**
     * Constructor
     * @param baitProvider IBaitProvider implementation
     * @param catchLogger ICatchLogger implementation
     * @param syncService ISyncService implementation
     */
    function initialize(baitProvider, catchLogger, syncService) {
        Menu2.initialize({:title => "Fishing Log"});

        _baitProvider = baitProvider;
        _catchLogger = catchLogger;
        _syncService = syncService;

        // Build menu
        _buildMenu();
    }

    /**
     * Build the main menu
     * @private
     */
    private function _buildMenu() {
        // Log Catch
        addItem(new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.MenuLogCatch),
            null,
            :log_catch,
            {}
        ));

        // View Catches
        var unsyncedCount = _catchLogger.getUnsyncedCatches().size();
        var viewLabel = WatchUi.loadResource(Rez.Strings.MenuViewCatches);
        if (unsyncedCount > 0) {
            viewLabel += " (" + unsyncedCount + ")";
        }

        addItem(new WatchUi.MenuItem(
            viewLabel,
            null,
            :view_catches,
            {}
        ));

        // Sync Data
        var canSync = _syncService.canSync();
        var syncLabel = WatchUi.loadResource(Rez.Strings.MenuSync);
        if (!canSync) {
            syncLabel += " (No Phone)";
        } else if (unsyncedCount > 0) {
            syncLabel += " (" + unsyncedCount + ")";
        }

        addItem(new WatchUi.MenuItem(
            syncLabel,
            null,
            :sync_data,
            {}
        ));
    }

    /**
     * Update the menu (refresh unsynced counts)
     */
    function updateMenu() {
        // Clear and rebuild menu
        // Note: Menu2 doesn't have a clear method, so we need to work around it
        // For now, the menu will update on next app launch
    }
}
