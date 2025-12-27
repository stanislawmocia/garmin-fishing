using Toybox.Application;
using Toybox.Lang;
using Toybox.WatchUi;

/**
 * BaitLoggerApp
 * Main application class for Fishing Log
 */
class BaitLoggerApp extends Application.AppBase {

    // Service instances (using duck typing with interface contracts)
    private var _baitProvider;
    private var _catchLogger;
    private var _dataFormatter;
    private var _syncService;

    /**
     * Constructor
     */
    function initialize() {
        AppBase.initialize();

        // Initialize services
        _baitProvider = new BaitProviderImpl();
        _catchLogger = new CatchLoggerImpl();
        _dataFormatter = new DataFormatter();
        _syncService = new SyncServiceImpl(_catchLogger, _dataFormatter);
    }

    /**
     * Handle app start
     * @param state Startup arguments
     */
    function onStart(state as Dictionary?) as Void {
    }

    /**
     * Handle app stop
     * @param state State to save
     */
    function onStop(state as Dictionary?) as Void {
    }

    /**
     * Return the initial view
     * @return Array [View, Delegate]
     */
    function getInitialView() as Array<Views or InputDelegates>? {
        var view = new BaitLoggerView(_baitProvider, _catchLogger, _syncService);
        var delegate = new BaitLoggerDelegate(view, _baitProvider, _catchLogger, _syncService);
        return [view, delegate] as Array<Views or InputDelegates>;
    }

    /**
     * Get bait provider instance
     * @return IBaitProvider implementation
     */
    function getBaitProvider() {
        return _baitProvider;
    }

    /**
     * Get catch logger instance
     * @return ICatchLogger implementation
     */
    function getCatchLogger() {
        return _catchLogger;
    }

    /**
     * Get sync service instance
     * @return ISyncService implementation
     */
    function getSyncService() {
        return _syncService;
    }

    /**
     * Get data formatter instance
     * @return DataFormatter instance
     */
    function getDataFormatter() {
        return _dataFormatter;
    }
}

/**
 * Get the app instance
 * @return BaitLoggerApp instance
 */
function getApp() as BaitLoggerApp {
    return Application.getApp() as BaitLoggerApp;
}
