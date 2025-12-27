using Toybox.Test;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Application.Storage;

/**
 * Unit tests for CatchLoggerImpl
 * Tests catch persistence and retrieval from Application.Storage
 */

(:test)
function testCatchLoggerSaveCatch(logger) {
    // Arrange: Create instance and mock catch object
    var catchLogger = new CatchLoggerImpl();
    var catchObj = {
        :id => 1,
        :timestamp => Time.now().value(),
        :baitId => 1,
        :species => "Bass",
        :weight => 2.5,
        :length => 18,
        :location => {
            :lat => 45.5236,
            :lon => -122.6750
        },
        :synced => false
    };

    // Act: Save the catch
    var result = catchLogger.saveCatch(catchObj);

    // Assert: Should return true on success
    Test.assertEqual(result, true);

    logger.debug("testCatchLoggerSaveCatch: PASSED - Catch saved successfully");
    return true;
}

(:test)
function testCatchLoggerGetUnsyncedCatches(logger) {
    // Arrange: Create instance and save multiple catches
    var catchLogger = new CatchLoggerImpl();

    var catch1 = {
        :id => 2,
        :timestamp => Time.now().value(),
        :baitId => 1,
        :species => "Trout",
        :weight => 1.2,
        :synced => false
    };

    var catch2 = {
        :id => 3,
        :timestamp => Time.now().value(),
        :baitId => 2,
        :species => "Pike",
        :weight => 3.8,
        :synced => false
    };

    catchLogger.saveCatch(catch1);
    catchLogger.saveCatch(catch2);

    // Act: Retrieve unsynced catches
    var unsyncedCatches = catchLogger.getUnsyncedCatches();

    // Assert: Should return array with unsynced catches
    Test.assertNotEqual(unsyncedCatches, null);
    Test.assertEqual(unsyncedCatches instanceof Array, true);
    Test.assertEqual(unsyncedCatches.size() >= 2, true);

    logger.debug("testCatchLoggerGetUnsyncedCatches: PASSED - Found " + unsyncedCatches.size() + " unsynced");
    return true;
}

(:test)
function testCatchLoggerMarkAsSynced(logger) {
    // Arrange: Create instance and save a catch
    var catchLogger = new CatchLoggerImpl();
    var catchObj = {
        :id => 4,
        :timestamp => Time.now().value(),
        :baitId => 1,
        :species => "Salmon",
        :weight => 5.0,
        :synced => false
    };

    catchLogger.saveCatch(catchObj);

    // Act: Mark the catch as synced
    var result = catchLogger.markAsSynced(4);

    // Assert: Should return true
    Test.assertEqual(result, true);

    // Act: Get unsynced catches
    var unsyncedCatches = catchLogger.getUnsyncedCatches();

    // Assert: The marked catch should not be in unsynced list
    var foundInUnsynced = false;
    for (var i = 0; i < unsyncedCatches.size(); i++) {
        if (unsyncedCatches[i][:id] == 4) {
            foundInUnsynced = true;
            break;
        }
    }

    Test.assertEqual(foundInUnsynced, false);

    logger.debug("testCatchLoggerMarkAsSynced: PASSED - Catch marked as synced");
    return true;
}

(:test)
function testCatchLoggerPersistence(logger) {
    // Arrange: Create instance and save catch
    var catchLogger = new CatchLoggerImpl();
    var catchObj = {
        :id => 5,
        :timestamp => Time.now().value(),
        :baitId => 3,
        :species => "Catfish",
        :weight => 4.2,
        :synced => false
    };

    catchLogger.saveCatch(catchObj);

    // Act: Create new instance (simulating app restart)
    var newCatchLogger = new CatchLoggerImpl();
    var unsyncedCatches = newCatchLogger.getUnsyncedCatches();

    // Assert: Should still find the saved catch
    var foundCatch = false;
    for (var i = 0; i < unsyncedCatches.size(); i++) {
        if (unsyncedCatches[i][:id] == 5) {
            foundCatch = true;
            Test.assertEqual(unsyncedCatches[i][:species], "Catfish");
            break;
        }
    }

    Test.assertEqual(foundCatch, true);

    logger.debug("testCatchLoggerPersistence: PASSED - Data persists across instances");
    return true;
}
