using Toybox.Test;
using Toybox.Lang;

/**
 * Unit tests for WeatherServiceImpl
 * Tests weather data retrieval and availability
 */

(:test)
function testWeatherServiceGetCurrentWeather(logger) {
    // Arrange: Create instance
    var weatherService = new WeatherServiceImpl();

    // Act: Get current weather
    var weather = weatherService.getCurrentWeather();

    // Assert: Should return dictionary or null (device dependent)
    // If weather is available, it should have required fields
    if (weather != null) {
        Test.assertEqual(weather instanceof Dictionary, true);
        Test.assertEqual(weather.hasKey(:temperature), true);
        Test.assertEqual(weather.hasKey(:conditions), true);
    }

    logger.debug("testWeatherServiceGetCurrentWeather: PASSED - Weather data retrieved");
    return true;
}

(:test)
function testWeatherServiceIsAvailable(logger) {
    // Arrange: Create instance
    var weatherService = new WeatherServiceImpl();

    // Act: Check availability
    var available = weatherService.isWeatherAvailable();

    // Assert: Should return boolean
    Test.assertEqual(available instanceof Boolean, true);

    logger.debug("testWeatherServiceIsAvailable: PASSED - Availability: " + available);
    return true;
}

(:test)
function testWeatherServiceDataStructure(logger) {
    // Arrange: Create instance
    var weatherService = new WeatherServiceImpl();

    // Act: Get weather
    var weather = weatherService.getCurrentWeather();

    // Assert: If available, check structure
    if (weather != null) {
        // Temperature should be numeric
        if (weather.hasKey(:temperature) && weather[:temperature] != null) {
            Test.assertEqual(weather[:temperature] instanceof Number || weather[:temperature] instanceof Float, true);
        }

        // Conditions should be string
        if (weather.hasKey(:conditions) && weather[:conditions] != null) {
            Test.assertEqual(weather[:conditions] instanceof String, true);
        }
    }

    logger.debug("testWeatherServiceDataStructure: PASSED - Weather structure valid");
    return true;
}
