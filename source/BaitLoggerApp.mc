using Toybox.Application;
using Toybox.Lang;
using Toybox.WatchUi;

/**
 * BaitLoggerApp
 * Main application class for Fishing Log
 */
class BaitLoggerApp extends Application.AppBase {

    // Service instances (using duck typing with interface contracts)
    private var _baitProvider;        // Legacy - keep for compatibility
    private var _baitManager;         // NEW: Manages user's custom baits
    private var _speciesProvider;     // NEW: Manages species with frequency sorting
    private var _weatherService;      // NEW: Weather data collection
    private var _catchLogger;
    private var _dataFormatter;
    private var _syncService;

    /**
     * Constructor
     */
    function initialize() {
        AppBase.initialize();

        // Initialize services
        _baitProvider = new BaitProviderImpl();  // Legacy
        _baitManager = new BaitManagerImpl();    // NEW
        _speciesProvider = new SpeciesProviderImpl();  // NEW
        _weatherService = new WeatherServiceImpl();    // NEW
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
        var view = new BaitLoggerView(_baitManager, _catchLogger, _syncService);
        var delegate = new BaitLoggerDelegate(view, _baitManager, _speciesProvider, _weatherService, _catchLogger, _syncService);
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

    /**
     * Get bait manager instance
     * @return IBaitManager implementation
     */
    function getBaitManager() {
        return _baitManager;
    }

    /**
     * Get species provider instance
     * @return ISpeciesProvider implementation
     */
    function getSpeciesProvider() {
        return _speciesProvider;
    }

    /**
     * Get weather service instance
     * @return IWeatherService implementation
     */
    function getWeatherService() {
        return _weatherService;
    }
}

/**
 * Get the app instance
 * @return BaitLoggerApp instance
 */
function getApp() as BaitLoggerApp {
    return Application.getApp() as BaitLoggerApp;
}
