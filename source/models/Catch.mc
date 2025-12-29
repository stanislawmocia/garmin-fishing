using Toybox.Lang;
using Toybox.Time;
using Toybox.Position;

/**
 * Catch Model
 * Represents a fishing catch entry with all relevant data
 */
class Catch {
    public var id;
    public var timestamp;
    public var baitId;
    public var baitName;          // Added: Name of bait used
    public var species;
    public var weight;
    public var length;
    public var location;
    public var weather;           // Added: Weather conditions at catch time
    public var synced;

    /**
     * Constructor
     * @param options Dictionary with catch properties
     */
    function initialize(options) {
        id = options.get(:id);
        timestamp = options.get(:timestamp);
        baitId = options.get(:baitId);
        baitName = options.get(:baitName);
        species = options.get(:species);
        weight = options.get(:weight);
        length = options.get(:length);
        location = options.get(:location);
        weather = options.get(:weather);
        synced = options.get(:synced) != null ? options.get(:synced) : false;
    }

    /**
     * Convert catch to dictionary for storage
     * @return Dictionary representation
     */
    function toDictionary() {
        return {
            :id => id,
            :timestamp => timestamp,
            :baitId => baitId,
            :baitName => baitName,
            :species => species,
            :weight => weight,
            :length => length,
            :location => location,
            :weather => weather,
            :synced => synced
        };
    }

    /**
     * Create Catch from dictionary (for deserialization)
     * @param dict Dictionary with catch data
     * @return Catch instance
     */
    static function fromDictionary(dict) {
        return new Catch(dict);
    }
}
