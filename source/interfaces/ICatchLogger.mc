using Toybox.Lang;

/**
 * ICatchLogger Interface
 * Contract for catch logging operations
 * Handles persistence and synchronization of fishing catch data
 */
class ICatchLogger {

    /**
     * Save a catch entry to storage
     * @param catchObj The catch data object to persist
     * @return Boolean indicating success
     */
    function saveCatch(catchObj) {
        throw new Lang.Exception("Not Implemented");
    }

    /**
     * Retrieve all catches that haven't been synced
     * @return Array of unsynced catch objects
     */
    function getUnsyncedCatches() {
        throw new Lang.Exception("Not Implemented");
    }

    /**
     * Mark a specific catch as synced
     * @param id The catch identifier
     * @return Boolean indicating success
     */
    function markAsSynced(id) {
        throw new Lang.Exception("Not Implemented");
    }
}
