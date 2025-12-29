using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;

/**
 * BaitLoggerDelegate
 * Main menu delegate
 */
class BaitLoggerDelegate extends WatchUi.Menu2InputDelegate {

    private var _view;
    private var _baitManager;
    private var _speciesProvider;
    private var _weatherService;
    private var _catchLogger;
    private var _syncService;

    /**
     * Constructor
     * @param view The parent view
     * @param baitManager IBaitManager implementation
     * @param speciesProvider ISpeciesProvider implementation
     * @param weatherService IWeatherService implementation
     * @param catchLogger ICatchLogger implementation
     * @param syncService ISyncService implementation
     */
    function initialize(view, baitManager, speciesProvider, weatherService, catchLogger, syncService) {
        Menu2InputDelegate.initialize();

        _view = view;
        _baitManager = baitManager;
        _speciesProvider = speciesProvider;
        _weatherService = weatherService;
        _catchLogger = catchLogger;
        _syncService = syncService;
    }

    /**
     * Handle menu item selection
     * @param item The selected menu item
     */
    function onSelect(item as MenuItem) as Void {
        var id = item.getId();

        if (id == :log_catch) {
            _handleLogCatch();
        } else if (id == :view_catches) {
            _handleViewCatches();
        } else if (id == :sync_data) {
            _handleSyncData();
        }
    }

    /**
     * Handle Log Catch selection
     * @private
     */
    private function _handleLogCatch() {
        var logCatchView = new LogCatchView(_baitManager, _speciesProvider, _catchLogger);
        var logCatchDelegate = new LogCatchDelegate(logCatchView, _baitManager, _speciesProvider, _weatherService, _catchLogger);

        WatchUi.pushView(logCatchView, logCatchDelegate, WatchUi.SLIDE_LEFT);
    }

    /**
     * Handle View Catches selection
     * @private
     */
    private function _handleViewCatches() {
        var unsyncedCatches = _catchLogger.getUnsyncedCatches();

        if (unsyncedCatches.size() == 0) {
            WatchUi.pushView(
                new WatchUi.Confirmation(WatchUi.loadResource(Rez.Strings.NoCatches)),
                new WatchUi.ConfirmationDelegate(method(:onConfirmationResponse)),
                WatchUi.SLIDE_UP
            );
        } else {
            var viewCatchesView = new ViewCatchesView(unsyncedCatches);
            WatchUi.pushView(viewCatchesView, new ViewCatchesDelegate(), WatchUi.SLIDE_LEFT);
        }
    }

    /**
     * Handle Sync Data selection
     * @private
     */
    private function _handleSyncData() {
        if (!_syncService.canSync()) {
            WatchUi.pushView(
                new WatchUi.Confirmation(WatchUi.loadResource(Rez.Strings.NoConnection)),
                new WatchUi.ConfirmationDelegate(method(:onConfirmationResponse)),
                WatchUi.SLIDE_UP
            );
            return;
        }

        var unsyncedCount = _syncService.getUnsyncedCount();

        if (unsyncedCount == 0) {
            WatchUi.pushView(
                new WatchUi.Confirmation(WatchUi.loadResource(Rez.Strings.NoUnsyncedData)),
                new WatchUi.ConfirmationDelegate(method(:onConfirmationResponse)),
                WatchUi.SLIDE_UP
            );
            return;
        }

        // Start sync
        var syncStarted = _syncService.syncNext();

        if (syncStarted) {
            WatchUi.pushView(
                new WatchUi.Confirmation(WatchUi.loadResource(Rez.Strings.SyncComplete)),
                new WatchUi.ConfirmationDelegate(method(:onConfirmationResponse)),
                WatchUi.SLIDE_UP
            );
        } else {
            WatchUi.pushView(
                new WatchUi.Confirmation(WatchUi.loadResource(Rez.Strings.SyncFailed)),
                new WatchUi.ConfirmationDelegate(method(:onConfirmationResponse)),
                WatchUi.SLIDE_UP
            );
        }
    }

    /**
     * Handle confirmation response
     * @param response User response
     * @return Boolean
     */
    function onConfirmationResponse(response) {
        return true;
    }

    /**
     * Handle back button
     * @return Boolean
     */
    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
