using Toybox.Test;
using Toybox.Lang;

/**
 * Unit tests for SpeciesProviderImpl
 * Tests species management with frequency sorting
 */

(:test)
function testSpeciesProviderGetAll(logger) {
    // Arrange: Create instance
    var provider = new SpeciesProviderImpl();

    // Act: Get all species
    var species = provider.getAllSpecies();

    // Assert: Should return array with Polish species names
    Test.assertNotEqual(species, null);
    Test.assertEqual(species instanceof Array, true);
    Test.assertEqual(species.size() > 0, true);

    // Check if names are in Polish (sample check)
    var firstSpecies = species[0];
    Test.assertEqual(firstSpecies instanceof String, true);

    logger.debug("testSpeciesProviderGetAll: PASSED - Found " + species.size() + " species");
    return true;
}

(:test)
function testSpeciesProviderFrequencySorting(logger) {
    // Arrange: Create instance and record catches
    var provider = new SpeciesProviderImpl();

    // Record same species multiple times
    provider.recordSpeciesCatch("Okoń");
    provider.recordSpeciesCatch("Okoń");
    provider.recordSpeciesCatch("Okoń");
    provider.recordSpeciesCatch("Szczupak");

    // Act: Get sorted list
    var sorted = provider.getSpeciesSortedByFrequency();

    // Assert: "Okoń" should be first (most frequent)
    Test.assertNotEqual(sorted, null);
    Test.assertEqual(sorted.size() > 0, true);
    Test.assertEqual(sorted[0], "Okoń");

    logger.debug("testSpeciesProviderFrequencySorting: PASSED - Most caught: " + sorted[0]);
    return true;
}

(:test)
function testSpeciesProviderAddCustom(logger) {
    // Arrange: Create instance
    var provider = new SpeciesProviderImpl();
    var initialCount = provider.getAllSpecies().size();

    // Act: Add custom species
    var result = provider.addCustomSpecies("Sandacz");

    // Assert: Should succeed and increase count
    Test.assertEqual(result, true);
    var newCount = provider.getAllSpecies().size();
    Test.assertEqual(newCount, initialCount + 1);

    logger.debug("testSpeciesProviderAddCustom: PASSED - Added custom species");
    return true;
}

(:test)
function testSpeciesProviderRecordCatch(logger) {
    // Arrange: Create instance
    var provider = new SpeciesProviderImpl();

    // Act: Record multiple catches
    provider.recordSpeciesCatch("Karaś");
    provider.recordSpeciesCatch("Karaś");

    // Get sorted list
    var sorted = provider.getSpeciesSortedByFrequency();

    // Assert: Karaś should appear in list
    var found = false;
    for (var i = 0; i < sorted.size(); i++) {
        if (sorted[i].equals("Karaś")) {
            found = true;
            break;
        }
    }
    Test.assertEqual(found, true);

    logger.debug("testSpeciesProviderRecordCatch: PASSED - Frequency recorded");
    return true;
}
