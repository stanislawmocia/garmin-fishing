using Toybox.Lang;

/**
 * IBaitManager Interface
 * Contract for managing user's custom baits
 * Extends bait provider functionality with user management
 */
class IBaitManager {

    /**
     * Get all baits sorted by usage frequency
     * @return Array of bait objects
     */
    function getBaitsSortedByFrequency() {
        throw new Lang.Exception("Not Implemented");
    }

    /**
     * Add a custom bait
     * @param baitName Name of the bait
     * @param baitType Type/category of the bait
     * @return Boolean indicating success
     */
    function addCustomBait(baitName, baitType) {
        throw new Lang.Exception("Not Implemented");
    }

    /**
     * Record that a bait was used (updates frequency)
     * @param baitId ID of the bait used
     */
    function recordBaitUsage(baitId) {
        throw new Lang.Exception("Not Implemented");
    }

    /**
     * Get all baits (unsorted)
     * @return Array of bait objects
     */
    function getAllBaits() {
        throw new Lang.Exception("Not Implemented");
    }

    /**
     * Delete a custom bait
     * @param baitId ID of the bait to delete
     * @return Boolean indicating success
     */
    function deleteCustomBait(baitId) {
        throw new Lang.Exception("Not Implemented");
    }

    /**
     * Get bait by ID
     * @param baitId The bait identifier
     * @return Bait object or null
     */
    function getBaitById(baitId) {
        throw new Lang.Exception("Not Implemented");
    }
}
