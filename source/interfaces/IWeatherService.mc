using Toybox.Lang;

/**
 * IWeatherService Interface
 * Contract for weather data retrieval
 * Captures weather conditions at the time of catch
 */
class IWeatherService {

    /**
     * Get current weather conditions
     * @return Dictionary with weather data (temp, pressure, conditions) or null if unavailable
     */
    function getCurrentWeather() {
        throw new Lang.Exception("Not Implemented");
    }

    /**
     * Check if weather data is available
     * @return Boolean indicating if device supports weather
     */
    function isWeatherAvailable() {
        throw new Lang.Exception("Not Implemented");
    }
}
