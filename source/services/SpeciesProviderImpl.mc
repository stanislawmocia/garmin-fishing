using Toybox.Lang;
using Toybox.Application.Storage;

/**
 * SpeciesProviderImpl
 * Concrete implementation of ISpeciesProvider
 * Manages fish species with frequency-based sorting (Polish names)
 */
class SpeciesProviderImpl extends ISpeciesProvider {

    private const STORAGE_KEY_SPECIES = "species_list";
    private const STORAGE_KEY_FREQUENCY = "species_frequency";

    /**
     * Constructor
     */
    function initialize() {
        ISpeciesProvider.initialize();
        _ensureDefaultSpecies();
    }

    /**
     * Get all species sorted by catch frequency (most caught first)
     * @return Array of species names (Polish)
     */
    function getSpeciesSortedByFrequency() {
        var species = getAllSpecies();
        var frequency = _getFrequencyMap();

        // Create array of [species, count] pairs
        var speciesWithCount = [];
        for (var i = 0; i < species.size(); i++) {
            var speciesName = species[i];
            var count = frequency.get(speciesName);
            if (count == null) {
                count = 0;
            }
            speciesWithCount.add([speciesName, count]);
        }

        // Sort by frequency (bubble sort - simple for small arrays)
        for (var i = 0; i < speciesWithCount.size() - 1; i++) {
            for (var j = 0; j < speciesWithCount.size() - i - 1; j++) {
                if (speciesWithCount[j][1] < speciesWithCount[j + 1][1]) {
                    var temp = speciesWithCount[j];
                    speciesWithCount[j] = speciesWithCount[j + 1];
                    speciesWithCount[j + 1] = temp;
                }
            }
        }

        // Extract just the species names
        var sorted = [];
        for (var i = 0; i < speciesWithCount.size(); i++) {
            sorted.add(speciesWithCount[i][0]);
        }

        return sorted;
    }

    /**
     * Record that a species was caught (updates frequency)
     * @param speciesName Name of the species
     */
    function recordSpeciesCatch(speciesName) {
        var frequency = _getFrequencyMap();

        var count = frequency.get(speciesName);
        if (count == null) {
            count = 0;
        }
        count = count + 1;

        frequency.put(speciesName, count);
        Storage.setValue(STORAGE_KEY_FREQUENCY, frequency);
    }

    /**
     * Get all available species (unsorted)
     * @return Array of species names
     */
    function getAllSpecies() {
        var species = Storage.getValue(STORAGE_KEY_SPECIES);

        if (species == null || !(species instanceof Array)) {
            return _getDefaultSpecies();
        }

        return species;
    }

    /**
     * Add custom species
     * @param speciesName Name of the custom species
     * @return Boolean indicating success
     */
    function addCustomSpecies(speciesName) {
        try {
            var species = getAllSpecies();

            // Check if already exists
            for (var i = 0; i < species.size(); i++) {
                if (species[i].equals(speciesName)) {
                    return false; // Already exists
                }
            }

            species.add(speciesName);
            Storage.setValue(STORAGE_KEY_SPECIES, species);
            return true;
        } catch (ex) {
            return false;
        }
    }

    /**
     * Ensure default species are loaded
     * @private
     */
    private function _ensureDefaultSpecies() {
        var species = Storage.getValue(STORAGE_KEY_SPECIES);

        if (species == null) {
            Storage.setValue(STORAGE_KEY_SPECIES, _getDefaultSpecies());
        }
    }

    /**
     * Get default Polish fish species
     * @private
     * @return Array of Polish species names
     */
    private function _getDefaultSpecies() {
        return [
            "Okoń",
            "Szczupak",
            "Sandacz",
            "Sum",
            "Karaś",
            "Karp",
            "Płoć",
            "Leszcz",
            "Lin",
            "Amur",
            "Węgorz",
            "Pstrąg",
            "Łosoś",
            "Sieja",
            "Jaź",
            "Kleń",
            "Boleń",
            "Ukleja",
            "Krąp",
            "Jelec",
            "Inne"
        ];
    }

    /**
     * Get frequency map from storage
     * @private
     * @return Dictionary of species -> count
     */
    private function _getFrequencyMap() {
        var frequency = Storage.getValue(STORAGE_KEY_FREQUENCY);

        if (frequency == null || !(frequency instanceof Dictionary)) {
            frequency = {};
            Storage.setValue(STORAGE_KEY_FREQUENCY, frequency);
        }

        return frequency;
    }
}
