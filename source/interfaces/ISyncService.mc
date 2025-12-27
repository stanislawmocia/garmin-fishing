using Toybox.Lang;

/**
 * ISyncService Interface
 * Contract for data synchronization operations
 * Handles uploading catch data when device is connected
 */
class ISyncService {

    /**
     * Synchronize the next pending catch
     * Uploads one catch at a time to prevent overwhelming the connection
     * @return Boolean indicating if sync was initiated
     */
    function syncNext() {
        throw new Lang.Exception("Not Implemented");
    }
}
