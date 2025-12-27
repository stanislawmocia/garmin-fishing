using Toybox.Lang;
using Toybox.Application;
using Toybox.WatchUi;

/**
 * BaitProviderImpl
 * Concrete implementation of IBaitProvider
 * Provides bait data from JSON resources
 */
class BaitProviderImpl extends IBaitProvider {
    private var _baits;

    /**
     * Constructor
     * Loads bait data from resources
     */
    function initialize() {
        IBaitProvider.initialize();
        _loadBaitsFromResources();
    }

    /**
     * Retrieve all available baits
     * @return Array of bait objects
     */
    function getBaits() {
        return _baits;
    }

    /**
     * Retrieve a specific bait by its ID
     * @param id The bait identifier
     * @return Bait object or null if not found
     */
    function getBaitById(id) {
        if (_baits == null) {
            return null;
        }

        for (var i = 0; i < _baits.size(); i++) {
            if (_baits[i][:id] == id) {
                return _baits[i];
            }
        }

        return null;
    }

    /**
     * Load baits from JSON resource file
     * @private
     */
    private function _loadBaitsFromResources() {
        try {
            // Load from JSON resource
            var baitsData = WatchUi.loadResource(Rez.JsonData.baits);

            if (baitsData != null && baitsData instanceof Array) {
                _baits = baitsData;
            } else {
                // Fallback to default baits if resource not found
                _baits = _getDefaultBaits();
            }
        } catch (ex) {
            // If resource loading fails, use default baits
            _baits = _getDefaultBaits();
        }
    }

    /**
     * Get default baits (fallback)
     * @private
     * @return Array of default bait objects
     */
    private function _getDefaultBaits() {
        return [
            {:id => 1, :name => "Plastic Worm", :type => "Soft Plastic"},
            {:id => 2, :name => "Crankbait", :type => "Hard Bait"},
            {:id => 3, :name => "Spinnerbait", :type => "Spinner"},
            {:id => 4, :name => "Jig", :type => "Jig"},
            {:id => 5, :name => "Topwater Popper", :type => "Topwater"},
            {:id => 6, :name => "Live Minnow", :type => "Live Bait"},
            {:id => 7, :name => "Nightcrawler", :type => "Live Bait"},
            {:id => 8, :name => "Spoon", :type => "Metal Lure"}
        ];
    }
}
