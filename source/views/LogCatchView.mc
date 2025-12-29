using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Position;
using Toybox.Time;

/**
 * LogCatchView
 * Multi-step view for logging a new catch with enhanced features
 * Step 1: Select Bait -> Step 2: Select Species -> Step 3: Enter Weight -> Step 4: Enter Length -> Save
 * Features: Polish names, frequency-based sorting, weather capture
 */
class LogCatchView extends WatchUi.Menu2 {

    private var _baitManager;
    private var _speciesProvider;
    private var _catchLogger;

    /**
     * Constructor
     * @param baitManager IBaitManager implementation
     * @param speciesProvider ISpeciesProvider implementation
     * @param catchLogger ICatchLogger implementation
     */
    function initialize(baitManager, speciesProvider, catchLogger) {
        Menu2.initialize({:title => WatchUi.loadResource(Rez.Strings.SelectBait)});

        _baitManager = baitManager;
        _speciesProvider = speciesProvider;
        _catchLogger = catchLogger;

        _buildBaitMenu();
    }

    /**
     * Build the bait selection menu (sorted by frequency)
     * @private
     */
    private function _buildBaitMenu() {
        var baits = _baitManager.getBaitsSortedByFrequency();

        for (var i = 0; i < baits.size(); i++) {
            var bait = baits[i];
            addItem(new WatchUi.MenuItem(
                bait[:name],
                bait[:type],
                bait[:id],
                {}
            ));
        }

        // Add option to add custom bait
        addItem(new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.AddCustomBait),
            null,
            :add_custom_bait,
            {}
        ));
    }
}

/**
 * LogCatchDelegate
 * Handles bait selection and navigation through catch logging flow
 */
class LogCatchDelegate extends WatchUi.Menu2InputDelegate {

    private var _view;
    private var _baitManager;
    private var _speciesProvider;
    private var _weatherService;
    private var _catchLogger;
    private var _selectedBaitId;
    private var _selectedBaitName;
    private var _selectedSpecies;
    private var _selectedWeight;
    private var _selectedLength;
    private var _location;
    private var _weather;

    /**
     * Constructor
     * @param view The parent view
     * @param baitManager IBaitManager implementation
     * @param speciesProvider ISpeciesProvider implementation
     * @param weatherService IWeatherService implementation
     * @param catchLogger ICatchLogger implementation
     */
    function initialize(view, baitManager, speciesProvider, weatherService, catchLogger) {
        Menu2InputDelegate.initialize();

        _view = view;
        _baitManager = baitManager;
        _speciesProvider = speciesProvider;
        _weatherService = weatherService;
        _catchLogger = catchLogger;

        // Get current location if available
        var positionInfo = Position.getInfo();
        if (positionInfo.accuracy != Position.QUALITY_NOT_AVAILABLE) {
            var position = positionInfo.position;
            if (position != null) {
                _location = {
                    :lat => position.toDegrees()[0],
                    :lon => position.toDegrees()[1]
                };
            }
        }

        // Get current weather
        _weather = _weatherService.getCurrentWeather();
    }

    /**
     * Handle bait selection
     * @param item The selected menu item
     */
    function onSelect(item as MenuItem) as Void {
        var itemId = item.getId();

        if (itemId == :add_custom_bait) {
            // TODO: Implement custom bait entry (TextPicker if available)
            // For now, skip to species selection
            _showSpeciesSelection();
            return;
        }

        _selectedBaitId = itemId;

        // Get bait name for storage
        var bait = _baitManager.getBaitById(_selectedBaitId);
        if (bait != null) {
            _selectedBaitName = bait[:name];
        }

        // Record bait usage
        _baitManager.recordBaitUsage(_selectedBaitId);

        // Move to species selection
        _showSpeciesSelection();
    }

    /**
     * Show species selection menu (sorted by frequency, Polish names)
     * @private
     */
    private function _showSpeciesSelection() {
        var speciesMenu = new WatchUi.Menu2({:title => WatchUi.loadResource(Rez.Strings.EnterSpecies)});

        // Get species sorted by frequency (most caught first)
        var species = _speciesProvider.getSpeciesSortedByFrequency();

        for (var i = 0; i < species.size(); i++) {
            var speciesName = species[i];
            speciesMenu.addItem(new WatchUi.MenuItem(
                speciesName,
                null,
                speciesName,
                {}
            ));
        }

        // Add option for custom species
        speciesMenu.addItem(new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.AddCustomSpecies),
            null,
            :add_custom_species,
            {}
        ));

        var delegate = new SpeciesSelectionDelegate(self, _speciesProvider);
        WatchUi.pushView(speciesMenu, delegate, WatchUi.SLIDE_LEFT);
    }

    /**
     * Handle species selection callback
     * @param species Selected species name
     */
    function onSpeciesSelected(species) {
        _selectedSpecies = species;

        // Record species catch for frequency sorting
        _speciesProvider.recordSpeciesCatch(species);

        _showWeightInput();
    }

    /**
     * Show weight input using NumberPicker (kg)
     * @private
     */
    private function _showWeightInput() {
        var picker = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_DECIMAL);
        var delegate = new WeightPickerDelegate(self);

        WatchUi.pushView(picker, delegate, WatchUi.SLIDE_LEFT);
    }

    /**
     * Handle weight selection callback
     * @param weight Selected weight in kg
     */
    function onWeightSelected(weight) {
        _selectedWeight = weight;
        _showLengthInput();
    }

    /**
     * Show length input using NumberPicker (cm)
     * @private
     */
    private function _showLengthInput() {
        var picker = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_WHOLE_NUMBER);
        var delegate = new LengthPickerDelegate(self);

        WatchUi.pushView(picker, delegate, WatchUi.SLIDE_LEFT);
    }

    /**
     * Handle length selection callback
     * @param length Selected length in cm
     */
    function onLengthSelected(length) {
        _selectedLength = length;
        _saveCatch();
    }

    /**
     * Save the catch using ICatchLogger interface
     * Includes: bait, species, weight, length, GPS, weather
     * @private
     */
    private function _saveCatch() {
        var catchObj = {
            :timestamp => Time.now().value(),
            :baitId => _selectedBaitId,
            :baitName => _selectedBaitName,
            :species => _selectedSpecies,
            :weight => _selectedWeight,
            :length => _selectedLength,
            :location => _location,
            :weather => _weather,
            :synced => false
        };

        // Call ICatchLogger.saveCatch()
        var success = _catchLogger.saveCatch(catchObj);

        // Show confirmation with weather info
        var message = success ?
            WatchUi.loadResource(Rez.Strings.CatchSaved) :
            WatchUi.loadResource(Rez.Strings.CatchSaveFailed);

        // Add weather info if available
        if (success && _weather != null && _weather.hasKey(:temperature)) {
            message += "\n" + _weather[:temperature] + "°C";
        }

        WatchUi.pushView(
            new WatchUi.Confirmation(message),
            new WatchUi.ConfirmationDelegate(method(:onConfirmationResponse)),
            WatchUi.SLIDE_UP
        );
    }

    /**
     * Handle confirmation response
     * @param response User response
     * @return Boolean
     */
    function onConfirmationResponse(response) {
        // Pop back to main menu
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    /**
     * Handle back button
     */
    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}

/**
 * SpeciesSelectionDelegate
 * Handles species selection with custom species support
 */
class SpeciesSelectionDelegate extends WatchUi.Menu2InputDelegate {

    private var _parentDelegate;
    private var _speciesProvider;

    function initialize(parentDelegate, speciesProvider) {
        Menu2InputDelegate.initialize();
        _parentDelegate = parentDelegate;
        _speciesProvider = speciesProvider;
    }

    function onSelect(item as MenuItem) as Void {
        var itemId = item.getId();

        if (itemId == :add_custom_species) {
            // TODO: Implement custom species entry (TextPicker if available)
            // For now, use "Inne" (Other)
            _parentDelegate.onSpeciesSelected("Inne");
        } else {
            _parentDelegate.onSpeciesSelected(itemId);
        }
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}

/**
 * WeightPickerDelegate
 * Handles weight input via NumberPicker (kg)
 */
class WeightPickerDelegate extends WatchUi.NumberPickerDelegate {

    private var _parentDelegate;

    function initialize(parentDelegate) {
        NumberPickerDelegate.initialize();
        _parentDelegate = parentDelegate;
    }

    function onNumberPicked(value) {
        _parentDelegate.onWeightSelected(value);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}

/**
 * LengthPickerDelegate
 * Handles length input via NumberPicker (cm)
 */
class LengthPickerDelegate extends WatchUi.NumberPickerDelegate {

    private var _parentDelegate;

    function initialize(parentDelegate) {
        NumberPickerDelegate.initialize();
        _parentDelegate = parentDelegate;
    }

    function onNumberPicked(value) {
        _parentDelegate.onLengthSelected(value);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
