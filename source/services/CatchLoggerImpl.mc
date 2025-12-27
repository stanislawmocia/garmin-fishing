using Toybox.Lang;
using Toybox.Application.Storage;
using Toybox.Time;

/**
 * CatchLoggerImpl
 * Concrete implementation of ICatchLogger
 * Uses Application.Storage for persistence
 */
class CatchLoggerImpl extends ICatchLogger {
    private const STORAGE_KEY = "catches";

    /**
     * Constructor
     */
    function initialize() {
        ICatchLogger.initialize();
    }

    /**
     * Save a catch entry to storage
     * @param catchObj The catch data object to persist
     * @return Boolean indicating success
     */
    function saveCatch(catchObj) {
        try {
            // Get existing catches from storage
            var catches = _loadCatchesFromStorage();

            // Ensure catchObj has required fields
            if (catchObj[:id] == null) {
                catchObj[:id] = _generateId();
            }

            if (catchObj[:timestamp] == null) {
                catchObj[:timestamp] = Time.now().value();
            }

            if (catchObj[:synced] == null) {
                catchObj[:synced] = false;
            }

            // Add new catch to array
            catches.add(catchObj);

            // Save back to storage
            Storage.setValue(STORAGE_KEY, catches);

            return true;
        } catch (ex) {
            return false;
        }
    }

    /**
     * Retrieve all catches that haven't been synced
     * @return Array of unsynced catch objects
     */
    function getUnsyncedCatches() {
        var catches = _loadCatchesFromStorage();
        var unsynced = [];

        for (var i = 0; i < catches.size(); i++) {
            if (catches[i][:synced] == false || catches[i][:synced] == null) {
                unsynced.add(catches[i]);
            }
        }

        return unsynced;
    }

    /**
     * Mark a specific catch as synced
     * @param id The catch identifier
     * @return Boolean indicating success
     */
    function markAsSynced(id) {
        try {
            var catches = _loadCatchesFromStorage();
            var updated = false;

            for (var i = 0; i < catches.size(); i++) {
                if (catches[i][:id] == id) {
                    catches[i][:synced] = true;
                    updated = true;
                    break;
                }
            }

            if (updated) {
                Storage.setValue(STORAGE_KEY, catches);
                return true;
            }

            return false;
        } catch (ex) {
            return false;
        }
    }

    /**
     * Load catches from Application.Storage
     * @private
     * @return Array of catch objects
     */
    private function _loadCatchesFromStorage() {
        var catches = Storage.getValue(STORAGE_KEY);

        if (catches == null || !(catches instanceof Array)) {
            return [];
        }

        return catches;
    }

    /**
     * Generate a unique ID for a catch
     * @private
     * @return Integer ID
     */
    private function _generateId() {
        var catches = _loadCatchesFromStorage();
        var maxId = 0;

        for (var i = 0; i < catches.size(); i++) {
            if (catches[i][:id] != null && catches[i][:id] > maxId) {
                maxId = catches[i][:id];
            }
        }

        return maxId + 1;
    }

    /**
     * Get all catches (for testing/debugging)
     * @return Array of all catch objects
     */
    function getAllCatches() {
        return _loadCatchesFromStorage();
    }

    /**
     * Clear all catches (for testing)
     * @return Boolean indicating success
     */
    function clearAll() {
        try {
            Storage.deleteValue(STORAGE_KEY);
            return true;
        } catch (ex) {
            return false;
        }
    }
}
