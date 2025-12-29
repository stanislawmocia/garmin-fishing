using Toybox.Lang;
using Toybox.Weather;
using Toybox.System;

/**
 * WeatherServiceImpl
 * Concrete implementation of IWeatherService
 * Retrieves weather data from device sensors and Weather API
 */
class WeatherServiceImpl extends IWeatherService {

    /**
     * Constructor
     */
    function initialize() {
        IWeatherService.initialize();
    }

    /**
     * Get current weather conditions
     * @return Dictionary with weather data or null if unavailable
     */
    function getCurrentWeather() {
        if (!isWeatherAvailable()) {
            return null;
        }

        try {
            var currentConditions = Weather.getCurrentConditions();

            if (currentConditions == null) {
                return _getWeatherFromSystemInfo();
            }

            var weatherData = {
                :temperature => currentConditions.temperature,
                :feelsLike => currentConditions.feelsLikeTemperature,
                :conditions => _conditionToString(currentConditions.condition),
                :humidity => currentConditions.relativeHumidity,
                :pressure => currentConditions.pressure,
                :windSpeed => currentConditions.windSpeed,
                :windBearing => currentConditions.windBearing
            };

            return weatherData;
        } catch (ex) {
            // If Weather API fails, try system info
            return _getWeatherFromSystemInfo();
        }
    }

    /**
     * Check if weather data is available
     * @return Boolean indicating if device supports weather
     */
    function isWeatherAvailable() {
        // Check if device has weather support
        var deviceSettings = System.getDeviceSettings();

        // Some devices have weather capability
        if (Toybox has :Weather) {
            return true;
        }

        return false;
    }

    /**
     * Get basic weather info from system (fallback)
     * @private
     * @return Dictionary with basic weather data or null
     */
    private function _getWeatherFromSystemInfo() {
        try {
            var deviceSettings = System.getDeviceSettings();

            // Some basic info available from device
            return {
                :temperature => null,
                :conditions => "Unknown",
                :pressure => null,
                :note => "Weather data unavailable"
            };
        } catch (ex) {
            return null;
        }
    }

    /**
     * Convert weather condition code to Polish string
     * @private
     * @param condition Weather condition code
     * @return Polish description
     */
    private function _conditionToString(condition) {
        if (condition == null) {
            return "Nieznane";
        }

        // Weather.CONDITION_* constants mapping to Polish
        if (condition == Weather.CONDITION_CLEAR) {
            return "Czyste niebo";
        } else if (condition == Weather.CONDITION_PARTLY_CLOUDY) {
            return "Częściowe zachmurzenie";
        } else if (condition == Weather.CONDITION_MOSTLY_CLOUDY) {
            return "Przeważnie pochmurno";
        } else if (condition == Weather.CONDITION_RAIN) {
            return "Deszcz";
        } else if (condition == Weather.CONDITION_SNOW) {
            return "Śnieg";
        } else if (condition == Weather.CONDITION_WINDY) {
            return "Wietrznie";
        } else if (condition == Weather.CONDITION_THUNDERSTORMS) {
            return "Burza";
        } else if (condition == Weather.CONDITION_WINTRY_MIX) {
            return "Deszcz ze śniegiem";
        } else if (condition == Weather.CONDITION_FOG) {
            return "Mgła";
        } else if (condition == Weather.CONDITION_HAZY) {
            return "Zamglone";
        } else if (condition == Weather.CONDITION_HAIL) {
            return "Grad";
        } else if (condition == Weather.CONDITION_SCATTERED_SHOWERS) {
            return "Przelotne opady";
        } else if (condition == Weather.CONDITION_SCATTERED_THUNDERSTORMS) {
            return "Przelotne burze";
        } else if (condition == Weather.CONDITION_UNKNOWN_PRECIPITATION) {
            return "Opady";
        } else if (condition == Weather.CONDITION_LIGHT_RAIN) {
            return "Lekki deszcz";
        } else if (condition == Weather.CONDITION_HEAVY_RAIN) {
            return "Silny deszcz";
        } else if (condition == Weather.CONDITION_LIGHT_SNOW) {
            return "Lekki śnieg";
        } else if (condition == Weather.CONDITION_HEAVY_SNOW) {
            return "Silny śnieg";
        } else if (condition == Weather.CONDITION_LIGHT_RAIN_SNOW) {
            return "Lekki deszcz ze śniegiem";
        } else if (condition == Weather.CONDITION_HEAVY_RAIN_SNOW) {
            return "Silny deszcz ze śniegiem";
        } else if (condition == Weather.CONDITION_CLOUDY) {
            return "Pochmurno";
        } else if (condition == Weather.CONDITION_RAIN_SNOW) {
            return "Deszcz ze śniegiem";
        } else if (condition == Weather.CONDITION_PARTLY_CLEAR) {
            return "Częściowo czyste";
        } else if (condition == Weather.CONDITION_MOSTLY_CLEAR) {
            return "Przeważnie czyste";
        } else if (condition == Weather.CONDITION_LIGHT_SHOWERS) {
            return "Lekkie przelotne opady";
        } else if (condition == Weather.CONDITION_SHOWERS) {
            return "Przelotne opady";
        } else if (condition == Weather.CONDITION_HEAVY_SHOWERS) {
            return "Silne przelotne opady";
        } else {
            return "Nieznane";
        }
    }
}
