using Toybox.Lang;
using Toybox.Application.Storage;

/**
 * BaitManagerImpl
 * Concrete implementation of IBaitManager
 * Manages user's custom baits with frequency-based sorting
 */
class BaitManagerImpl extends IBaitManager {

    private const STORAGE_KEY_BAITS = "baits_list";
    private const STORAGE_KEY_FREQUENCY = "bait_frequency";

    /**
     * Constructor
     */
    function initialize() {
        IBaitManager.initialize();
        _ensureDefaultBaits();
    }

    /**
     * Get all baits sorted by usage frequency
     * @return Array of bait objects
     */
    function getBaitsSortedByFrequency() {
        var baits = getAllBaits();
        var frequency = _getFrequencyMap();

        // Create array of [bait, count] pairs
        var baitsWithCount = [];
        for (var i = 0; i < baits.size(); i++) {
            var bait = baits[i];
            var count = frequency.get(bait[:id]);
            if (count == null) {
                count = 0;
            }
            baitsWithCount.add([bait, count]);
        }

        // Sort by frequency (bubble sort)
        for (var i = 0; i < baitsWithCount.size() - 1; i++) {
            for (var j = 0; j < baitsWithCount.size() - i - 1; j++) {
                if (baitsWithCount[j][1] < baitsWithCount[j + 1][1]) {
                    var temp = baitsWithCount[j];
                    baitsWithCount[j] = baitsWithCount[j + 1];
                    baitsWithCount[j + 1] = temp;
                }
            }
        }

        // Extract just the baits
        var sorted = [];
        for (var i = 0; i < baitsWithCount.size(); i++) {
            sorted.add(baitsWithCount[i][0]);
        }

        return sorted;
    }

    /**
     * Add a custom bait
     * @param baitName Name of the bait
     * @param baitType Type/category of the bait
     * @return Boolean indicating success
     */
    function addCustomBait(baitName, baitType) {
        try {
            var baits = getAllBaits();

            // Generate new ID
            var newId = _generateNextId(baits);

            var newBait = {
                :id => newId,
                :name => baitName,
                :type => baitType,
                :custom => true
            };

            baits.add(newBait);
            Storage.setValue(STORAGE_KEY_BAITS, baits);
            return true;
        } catch (ex) {
            return false;
        }
    }

    /**
     * Record that a bait was used (updates frequency)
     * @param baitId ID of the bait used
     */
    function recordBaitUsage(baitId) {
        var frequency = _getFrequencyMap();

        var count = frequency.get(baitId);
        if (count == null) {
            count = 0;
        }
        count = count + 1;

        frequency.put(baitId, count);
        Storage.setValue(STORAGE_KEY_FREQUENCY, frequency);
    }

    /**
     * Get all baits (unsorted)
     * @return Array of bait objects
     */
    function getAllBaits() {
        var baits = Storage.getValue(STORAGE_KEY_BAITS);

        if (baits == null || !(baits instanceof Array)) {
            return _getDefaultBaits();
        }

        return baits;
    }

    /**
     * Delete a custom bait
     * @param baitId ID of the bait to delete
     * @return Boolean indicating success
     */
    function deleteCustomBait(baitId) {
        try {
            var baits = getAllBaits();
            var newBaits = [];

            for (var i = 0; i < baits.size(); i++) {
                var bait = baits[i];

                // Only delete if it's custom
                if (bait[:id] == baitId && bait.get(:custom) == true) {
                    // Skip this bait (delete it)
                    continue;
                }

                newBaits.add(bait);
            }

            if (newBaits.size() < baits.size()) {
                Storage.setValue(STORAGE_KEY_BAITS, newBaits);
                return true;
            }

            return false;
        } catch (ex) {
            return false;
        }
    }

    /**
     * Get bait by ID
     * @param baitId The bait identifier
     * @return Bait object or null
     */
    function getBaitById(baitId) {
        var baits = getAllBaits();

        for (var i = 0; i < baits.size(); i++) {
            if (baits[i][:id] == baitId) {
                return baits[i];
            }
        }

        return null;
    }

    /**
     * Ensure default baits are loaded
     * @private
     */
    private function _ensureDefaultBaits() {
        var baits = Storage.getValue(STORAGE_KEY_BAITS);

        if (baits == null) {
            Storage.setValue(STORAGE_KEY_BAITS, _getDefaultBaits());
        }
    }

    /**
     * Get default Polish baits
     * @private
     * @return Array of default bait objects
     */
    private function _getDefaultBaits() {
        return [
            {:id => 1, :name => "Twister", :type => "Guma", :custom => false},
            {:id => 2, :name => "Wobler", :type => "Twarda przynęta", :custom => false},
            {:id => 3, :name => "Błystka obrotowa", :type => "Błystka", :custom => false},
            {:id => 4, :name => "Błystka wahadłowa", :type => "Błystka", :custom => false},
            {:id => 5, :name => "Jig", :type => "Jig", :custom => false},
            {:id => 6, :name => "Przynęta powierzchniowa", :type => "Topwater", :custom => false},
            {:id => 7, :name => "Żywa rybka", :type => "Żywa przynęta", :custom => false},
            {:id => 8, :name => "Robak", :type => "Żywa przynęta", :custom => false},
            {:id => 9, :name => "Kukurydza", :type => "Roślinna", :custom => false},
            {:id => 10, :name => "Pellety", :type => "Sztuczna", :custom => false}
        ];
    }

    /**
     * Get frequency map from storage
     * @private
     * @return Dictionary of baitId -> count
     */
    private function _getFrequencyMap() {
        var frequency = Storage.getValue(STORAGE_KEY_FREQUENCY);

        if (frequency == null || !(frequency instanceof Dictionary)) {
            frequency = {};
            Storage.setValue(STORAGE_KEY_FREQUENCY, frequency);
        }

        return frequency;
    }

    /**
     * Generate next available ID
     * @private
     * @param baits Current baits array
     * @return New ID
     */
    private function _generateNextId(baits) {
        var maxId = 10; // Start after default baits

        for (var i = 0; i < baits.size(); i++) {
            if (baits[i][:id] > maxId) {
                maxId = baits[i][:id];
            }
        }

        return maxId + 1;
    }
}
