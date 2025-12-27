using Toybox.Test;
using Toybox.Lang;

/**
 * Unit tests for DataFormatter
 * Tests conversion of Catch objects to JSON format for export
 */

(:test)
function testDataFormatterBasicConversion(logger) {
    // Arrange: Create formatter and mock catch object
    var formatter = new DataFormatter();
    var catchObj = {
        :id => 1,
        :timestamp => 1703721600,  // 2023-12-28 00:00:00
        :baitId => 1,
        :species => "Bass",
        :weight => 2.5,
        :length => 18,
        :synced => false
    };

    // Act: Convert to JSON format
    var jsonString = formatter.toJson(catchObj);

    // Assert: Should return a string
    Test.assertNotEqual(jsonString, null);
    Test.assertEqual(jsonString instanceof String, true);

    // Assert: Should contain key fields
    Test.assertEqual(jsonString.find("\"id\":1") != null, true);
    Test.assertEqual(jsonString.find("\"species\":\"Bass\"") != null, true);
    Test.assertEqual(jsonString.find("\"weight\":2.5") != null, true);

    logger.debug("testDataFormatterBasicConversion: PASSED - JSON contains required fields");
    return true;
}

(:test)
function testDataFormatterWithLocation(logger) {
    // Arrange: Create formatter and catch with GPS coordinates
    var formatter = new DataFormatter();
    var catchObj = {
        :id => 2,
        :timestamp => 1703721600,
        :baitId => 2,
        :species => "Trout",
        :weight => 1.8,
        :location => {
            :lat => 45.5236,
            :lon => -122.6750
        },
        :synced => false
    };

    // Act: Convert to JSON format
    var jsonString = formatter.toJson(catchObj);

    // Assert: Should contain location data
    Test.assertEqual(jsonString.find("\"location\"") != null, true);
    Test.assertEqual(jsonString.find("\"lat\":45.5236") != null, true);
    Test.assertEqual(jsonString.find("\"lon\":-122.675") != null, true);

    logger.debug("testDataFormatterWithLocation: PASSED - JSON includes GPS coordinates");
    return true;
}

(:test)
function testDataFormatterTimestampFormat(logger) {
    // Arrange: Create formatter with specific timestamp
    var formatter = new DataFormatter();
    var catchObj = {
        :id => 3,
        :timestamp => 1703721600,
        :baitId => 1,
        :species => "Pike",
        :weight => 3.2,
        :synced => false
    };

    // Act: Convert to JSON
    var jsonString = formatter.toJson(catchObj);

    // Assert: Timestamp should be included
    Test.assertEqual(jsonString.find("\"timestamp\"") != null, true);
    Test.assertEqual(jsonString.find("1703721600") != null, true);

    logger.debug("testDataFormatterTimestampFormat: PASSED - Timestamp properly formatted");
    return true;
}

(:test)
function testDataFormatterMultipleCatches(logger) {
    // Arrange: Create formatter and array of catches
    var formatter = new DataFormatter();
    var catches = [
        {:id => 4, :species => "Bass", :weight => 2.1, :timestamp => 1703721600},
        {:id => 5, :species => "Trout", :weight => 1.5, :timestamp => 1703721700},
        {:id => 6, :species => "Pike", :weight => 4.0, :timestamp => 1703721800}
    ];

    // Act: Convert array to JSON
    var jsonString = formatter.toJsonArray(catches);

    // Assert: Should return valid JSON array
    Test.assertNotEqual(jsonString, null);
    Test.assertEqual(jsonString instanceof String, true);
    Test.assertEqual(jsonString.find("[") != null, true);
    Test.assertEqual(jsonString.find("]") != null, true);

    // Assert: Should contain all species
    Test.assertEqual(jsonString.find("Bass") != null, true);
    Test.assertEqual(jsonString.find("Trout") != null, true);
    Test.assertEqual(jsonString.find("Pike") != null, true);

    logger.debug("testDataFormatterMultipleCatches: PASSED - Array converted to JSON");
    return true;
}

(:test)
function testDataFormatterNullHandling(logger) {
    // Arrange: Create formatter
    var formatter = new DataFormatter();

    // Act & Assert: Should handle null gracefully
    var jsonString = formatter.toJson(null);
    Test.assertEqual(jsonString, "{}");

    logger.debug("testDataFormatterNullHandling: PASSED - Null handled gracefully");
    return true;
}
