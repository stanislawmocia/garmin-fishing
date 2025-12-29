using Toybox.Lang;

/**
 * ISpeciesProvider Interface
 * Contract for species data with frequency-based sorting
 * Provides fish species sorted by catch frequency
 */
class ISpeciesProvider {

    /**
     * Get all species sorted by catch frequency (most caught first)
     * @return Array of species names (Polish)
     */
    function getSpeciesSortedByFrequency() {
        throw new Lang.Exception("Not Implemented");
    }

    /**
     * Record that a species was caught (updates frequency)
     * @param speciesName Name of the species
     */
    function recordSpeciesCatch(speciesName) {
        throw new Lang.Exception("Not Implemented");
    }

    /**
     * Get all available species (unsorted)
     * @return Array of species names
     */
    function getAllSpecies() {
        throw new Lang.Exception("Not Implemented");
    }

    /**
     * Add custom species
     * @param speciesName Name of the custom species
     * @return Boolean indicating success
     */
    function addCustomSpecies(speciesName) {
        throw new Lang.Exception("Not Implemented");
    }
}
