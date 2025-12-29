using Toybox.Test;
using Toybox.Lang;

/**
 * Unit tests for BaitManagerImpl
 * Tests custom bait management with frequency sorting
 */

(:test)
function testBaitManagerGetAll(logger) {
    // Arrange: Create instance
    var manager = new BaitManagerImpl();

    // Act: Get all baits
    var baits = manager.getAllBaits();

    // Assert: Should return array
    Test.assertNotEqual(baits, null);
    Test.assertEqual(baits instanceof Array, true);
    Test.assertEqual(baits.size() > 0, true);

    // Check structure
    var firstBait = baits[0];
    Test.assertEqual(firstBait.hasKey(:id), true);
    Test.assertEqual(firstBait.hasKey(:name), true);
    Test.assertEqual(firstBait.hasKey(:type), true);

    logger.debug("testBaitManagerGetAll: PASSED - Found " + baits.size() + " baits");
    return true;
}

(:test)
function testBaitManagerAddCustom(logger) {
    // Arrange: Create instance
    var manager = new BaitManagerImpl();
    var initialCount = manager.getAllBaits().size();

    // Act: Add custom bait
    var result = manager.addCustomBait("Twister Zielony", "Guma");

    // Assert: Should succeed
    Test.assertEqual(result, true);
    var newCount = manager.getAllBaits().size();
    Test.assertEqual(newCount, initialCount + 1);

    logger.debug("testBaitManagerAddCustom: PASSED - Custom bait added");
    return true;
}

(:test)
function testBaitManagerFrequencySorting(logger) {
    // Arrange: Create instance
    var manager = new BaitManagerImpl();
    var baits = manager.getAllBaits();

    // Record usage of first bait multiple times
    var firstBaitId = baits[0][:id];
    manager.recordBaitUsage(firstBaitId);
    manager.recordBaitUsage(firstBaitId);
    manager.recordBaitUsage(firstBaitId);

    // Act: Get sorted baits
    var sorted = manager.getBaitsSortedByFrequency();

    // Assert: Most used bait should be first
    Test.assertNotEqual(sorted, null);
    Test.assertEqual(sorted.size() > 0, true);
    Test.assertEqual(sorted[0][:id], firstBaitId);

    logger.debug("testBaitManagerFrequencySorting: PASSED - Most used bait first");
    return true;
}

(:test)
function testBaitManagerGetById(logger) {
    // Arrange: Create instance
    var manager = new BaitManagerImpl();
    var baits = manager.getAllBaits();
    var testBaitId = baits[0][:id];

    // Act: Get bait by ID
    var bait = manager.getBaitById(testBaitId);

    // Assert: Should return correct bait
    Test.assertNotEqual(bait, null);
    Test.assertEqual(bait[:id], testBaitId);

    logger.debug("testBaitManagerGetById: PASSED - Bait retrieved: " + bait[:name]);
    return true;
}

(:test)
function testBaitManagerDeleteCustom(logger) {
    // Arrange: Create instance and add custom bait
    var manager = new BaitManagerImpl();
    manager.addCustomBait("Test Bait", "Test Type");

    var baits = manager.getAllBaits();
    var customBaitId = baits[baits.size() - 1][:id]; // Last added

    var initialCount = baits.size();

    // Act: Delete custom bait
    var result = manager.deleteCustomBait(customBaitId);

    // Assert: Should succeed
    Test.assertEqual(result, true);
    var newCount = manager.getAllBaits().size();
    Test.assertEqual(newCount, initialCount - 1);

    logger.debug("testBaitManagerDeleteCustom: PASSED - Custom bait deleted");
    return true;
}

(:test)
function testBaitManagerRecordUsage(logger) {
    // Arrange: Create instance
    var manager = new BaitManagerImpl();
    var baits = manager.getAllBaits();
    var baitId = baits[0][:id];

    // Act: Record usage
    manager.recordBaitUsage(baitId);

    // Get sorted list
    var sorted = manager.getBaitsSortedByFrequency();

    // Assert: Usage should be recorded (bait should be in list)
    var found = false;
    for (var i = 0; i < sorted.size(); i++) {
        if (sorted[i][:id] == baitId) {
            found = true;
            break;
        }
    }
    Test.assertEqual(found, true);

    logger.debug("testBaitManagerRecordUsage: PASSED - Usage recorded");
    return true;
}
