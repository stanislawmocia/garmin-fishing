using Toybox.Test;
using Toybox.Lang;

/**
 * Unit tests for BaitProviderImpl
 * Tests bait retrieval from resource files
 */

(:test)
function testBaitProviderGetBaits(logger) {
    // Arrange: Create instance of BaitProviderImpl
    var provider = new BaitProviderImpl();

    // Act: Retrieve all baits
    var baits = provider.getBaits();

    // Assert: Should return an array
    Test.assertNotEqual(baits, null);
    Test.assertEqual(baits instanceof Array, true);

    // Assert: Should have at least one bait
    Test.assertEqual(baits.size() > 0, true);

    logger.debug("testBaitProviderGetBaits: PASSED - Retrieved " + baits.size() + " baits");
    return true;
}

(:test)
function testBaitProviderGetBaitById(logger) {
    // Arrange: Create instance and get first bait
    var provider = new BaitProviderImpl();
    var baits = provider.getBaits();

    // Act: Retrieve specific bait by ID
    var firstBaitId = baits[0][:id];
    var bait = provider.getBaitById(firstBaitId);

    // Assert: Should return the correct bait
    Test.assertNotEqual(bait, null);
    Test.assertEqual(bait[:id], firstBaitId);
    Test.assertNotEqual(bait[:name], null);

    logger.debug("testBaitProviderGetBaitById: PASSED - Found bait: " + bait[:name]);
    return true;
}

(:test)
function testBaitProviderGetBaitByIdInvalid(logger) {
    // Arrange: Create instance
    var provider = new BaitProviderImpl();

    // Act: Try to retrieve non-existent bait
    var bait = provider.getBaitById(99999);

    // Assert: Should return null for invalid ID
    Test.assertEqual(bait, null);

    logger.debug("testBaitProviderGetBaitByIdInvalid: PASSED - Null returned for invalid ID");
    return true;
}

(:test)
function testBaitProviderBaitStructure(logger) {
    // Arrange: Create instance
    var provider = new BaitProviderImpl();
    var baits = provider.getBaits();

    // Act: Check first bait structure
    var bait = baits[0];

    // Assert: Bait should have required properties
    Test.assertEqual(bait.hasKey(:id), true);
    Test.assertEqual(bait.hasKey(:name), true);
    Test.assertEqual(bait.hasKey(:type), true);

    logger.debug("testBaitProviderBaitStructure: PASSED - Bait has id, name, type");
    return true;
}
