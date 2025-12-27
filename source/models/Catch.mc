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
    public var species;
    public var weight;
    public var length;
    public var location;
    public var synced;

    /**
     * Constructor
     * @param options Dictionary with catch properties
     */
    function initialize(options) {
        id = options.get(:id);
        timestamp = options.get(:timestamp);
        baitId = options.get(:baitId);
        species = options.get(:species);
        weight = options.get(:weight);
        length = options.get(:length);
        location = options.get(:location);
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
            :species => species,
            :weight => weight,
            :length => length,
            :location => location,
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
