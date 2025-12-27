using Toybox.Lang;
using Toybox.Communications;
using Toybox.System;

/**
 * SyncServiceImpl
 * Concrete implementation of ISyncService
 * Handles background synchronization of catch data
 */
class SyncServiceImpl extends ISyncService {
    private var _catchLogger;
    private var _formatter;

    /**
     * Constructor
     * @param catchLogger Instance of ICatchLogger
     * @param formatter Instance of DataFormatter
     */
    function initialize(catchLogger, formatter) {
        ISyncService.initialize();
        _catchLogger = catchLogger;
        _formatter = formatter;
    }

    /**
     * Synchronize the next pending catch
     * Uploads one catch at a time to prevent overwhelming the connection
     * @return Boolean indicating if sync was initiated
     */
    function syncNext() {
        // Check if phone is connected
        var deviceSettings = System.getDeviceSettings();
        if (deviceSettings.phoneConnected != true) {
            return false;
        }

        // Get unsynced catches
        var unsyncedCatches = _catchLogger.getUnsyncedCatches();

        if (unsyncedCatches.size() == 0) {
            return false;
        }

        // Get the first unsynced catch
        var catchToSync = unsyncedCatches[0];

        // Convert to JSON
        var jsonData = _formatter.toJson(catchToSync);

        // Prepare sync parameters
        var params = {
            "catchData" => jsonData,
            "deviceId" => System.getDeviceSettings().uniqueIdentifier
        };

        // Make HTTP request (placeholder URL - customize for your backend)
        var url = "https://api.yourfishingapp.com/catches";

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        // Register callback
        Communications.makeWebRequest(
            url,
            params,
            options,
            method(:onSyncComplete)
        );

        return true;
    }

    /**
     * Callback for sync completion
     * @param responseCode HTTP response code
     * @param data Response data
     */
    function onSyncComplete(responseCode, data) {
        if (responseCode == 200 || responseCode == 201) {
            // Sync successful - mark the catch as synced
            var unsyncedCatches = _catchLogger.getUnsyncedCatches();
            if (unsyncedCatches.size() > 0) {
                var syncedCatchId = unsyncedCatches[0][:id];
                _catchLogger.markAsSynced(syncedCatchId);

                // Continue syncing if more catches are pending
                if (unsyncedCatches.size() > 1) {
                    syncNext();
                }
            }
        } else {
            // Sync failed - will retry on next attempt
            // Could implement retry logic here
        }
    }

    /**
     * Check if device is ready to sync
     * @return Boolean indicating readiness
     */
    function canSync() {
        var deviceSettings = System.getDeviceSettings();
        return deviceSettings.phoneConnected == true;
    }

    /**
     * Get count of unsynced catches
     * @return Integer count
     */
    function getUnsyncedCount() {
        var unsyncedCatches = _catchLogger.getUnsyncedCatches();
        return unsyncedCatches.size();
    }
}
