using Toybox.Lang;

/**
 * DataFormatter
 * Converts Catch objects to JSON format for export/sync
 */
class DataFormatter {

    /**
     * Constructor
     */
    function initialize() {
    }

    /**
     * Convert a catch object to JSON string
     * @param catchObj The catch data object
     * @return JSON string representation
     */
    function toJson(catchObj) {
        if (catchObj == null) {
            return "{}";
        }

        var json = "{";
        var first = true;

        // Add each field to JSON
        var keys = [:id, :timestamp, :baitId, :species, :weight, :length, :location, :synced];

        for (var i = 0; i < keys.size(); i++) {
            var key = keys[i];
            var value = catchObj.get(key);

            if (value != null) {
                if (!first) {
                    json += ",";
                }
                first = false;

                json += "\"" + key + "\":";

                if (value instanceof String) {
                    json += "\"" + value + "\"";
                } else if (value instanceof Dictionary) {
                    json += _dictionaryToJson(value);
                } else if (value instanceof Boolean) {
                    json += value ? "true" : "false";
                } else {
                    json += value.toString();
                }
            }
        }

        json += "}";
        return json;
    }

    /**
     * Convert an array of catches to JSON array string
     * @param catches Array of catch objects
     * @return JSON array string
     */
    function toJsonArray(catches) {
        if (catches == null || catches.size() == 0) {
            return "[]";
        }

        var json = "[";

        for (var i = 0; i < catches.size(); i++) {
            if (i > 0) {
                json += ",";
            }
            json += toJson(catches[i]);
        }

        json += "]";
        return json;
    }

    /**
     * Convert a dictionary to JSON object string
     * @private
     * @param dict Dictionary to convert
     * @return JSON object string
     */
    private function _dictionaryToJson(dict) {
        if (dict == null) {
            return "{}";
        }

        var json = "{";
        var keys = dict.keys();
        var first = true;

        for (var i = 0; i < keys.size(); i++) {
            var key = keys[i];
            var value = dict.get(key);

            if (value != null) {
                if (!first) {
                    json += ",";
                }
                first = false;

                json += "\"" + key + "\":";

                if (value instanceof String) {
                    json += "\"" + value + "\"";
                } else if (value instanceof Boolean) {
                    json += value ? "true" : "false";
                } else {
                    json += value.toString();
                }
            }
        }

        json += "}";
        return json;
    }

    /**
     * Parse a simple JSON string to dictionary (basic implementation)
     * @param jsonString JSON string to parse
     * @return Dictionary representation
     */
    function fromJson(jsonString) {
        // Note: Full JSON parsing would require more complex implementation
        // This is a placeholder for future enhancement
        // In production, use Toybox.Lang.JSON if available in SDK
        return {};
    }
}
