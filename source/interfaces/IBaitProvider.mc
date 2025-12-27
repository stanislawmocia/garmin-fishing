using Toybox.Lang;

/**
 * IBaitProvider Interface
 * Contract for bait data providers
 * Provides access to bait information for logging catches
 */
class IBaitProvider {

    /**
     * Retrieve all available baits
     * @return Array of bait objects
     */
    function getBaits() {
        throw new Lang.Exception("Not Implemented");
    }

    /**
     * Retrieve a specific bait by its ID
     * @param id The bait identifier
     * @return Bait object or null if not found
     */
    function getBaitById(id) {
        throw new Lang.Exception("Not Implemented");
    }
}
