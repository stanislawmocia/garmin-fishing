using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Position;
using Toybox.Time;

/**
 * LogCatchView
 * Multi-step view for logging a new catch
 * Step 1: Select Bait -> Step 2: Select Species -> Step 3: Enter Weight -> Step 4: Enter Length -> Save
 */
class LogCatchView extends WatchUi.Menu2 {

    private var _baitProvider;
    private var _catchLogger;

    /**
     * Constructor
     * @param baitProvider IBaitProvider implementation
     * @param catchLogger ICatchLogger implementation
     */
    function initialize(baitProvider, catchLogger) {
        Menu2.initialize({:title => WatchUi.loadResource(Rez.Strings.SelectBait)});

        _baitProvider = baitProvider;
        _catchLogger = catchLogger;

        _buildBaitMenu();
    }

    /**
     * Build the bait selection menu
     * @private
     */
    private function _buildBaitMenu() {
        var baits = _baitProvider.getBaits();

        for (var i = 0; i < baits.size(); i++) {
            var bait = baits[i];
            addItem(new WatchUi.MenuItem(
                bait[:name],
                bait[:type],
                bait[:id],
                {}
            ));
        }
    }

    /**
     * Get the bait provider
     * @return IBaitProvider
     */
    function getBaitProvider() {
        return _baitProvider;
    }

    /**
     * Get the catch logger
     * @return ICatchLogger
     */
    function getCatchLogger() {
        return _catchLogger;
    }
}

/**
 * LogCatchDelegate
 * Handles bait selection and navigation to species selection
 */
class LogCatchDelegate extends WatchUi.Menu2InputDelegate {

    private var _view;
    private var _baitProvider;
    private var _catchLogger;
    private var _selectedBaitId;
    private var _selectedSpecies;
    private var _selectedWeight;
    private var _selectedLength;
    private var _location;

    /**
     * Constructor
     * @param view The parent view
     * @param baitProvider IBaitProvider implementation
     * @param catchLogger ICatchLogger implementation
     */
    function initialize(view, baitProvider, catchLogger) {
        Menu2InputDelegate.initialize();

        _view = view;
        _baitProvider = baitProvider;
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
    }

    /**
     * Handle bait selection
     * @param item The selected menu item
     */
    function onSelect(item as MenuItem) as Void {
        _selectedBaitId = item.getId();

        // Move to species selection
        _showSpeciesSelection();
    }

    /**
     * Show species selection menu
     * @private
     */
    private function _showSpeciesSelection() {
        var speciesMenu = new WatchUi.Menu2({:title => WatchUi.loadResource(Rez.Strings.EnterSpecies)});

        // Add species options
        var species = [
            Rez.Strings.SpeciesBass,
            Rez.Strings.SpeciesTrout,
            Rez.Strings.SpeciesPike,
            Rez.Strings.SpeciesSalmon,
            Rez.Strings.SpeciesCatfish,
            Rez.Strings.SpeciesWalleye,
            Rez.Strings.SpeciesOther
        ];

        for (var i = 0; i < species.size(); i++) {
            var speciesName = WatchUi.loadResource(species[i]);
            speciesMenu.addItem(new WatchUi.MenuItem(
                speciesName,
                null,
                speciesName,
                {}
            ));
        }

        var delegate = new SpeciesSelectionDelegate(self);
        WatchUi.pushView(speciesMenu, delegate, WatchUi.SLIDE_LEFT);
    }

    /**
     * Handle species selection callback
     * @param species Selected species name
     */
    function onSpeciesSelected(species) {
        _selectedSpecies = species;
        _showWeightInput();
    }

    /**
     * Show weight input using NumberPicker
     * @private
     */
    private function _showWeightInput() {
        var picker = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_DECIMAL);
        var delegate = new WeightPickerDelegate(self);

        WatchUi.pushView(picker, delegate, WatchUi.SLIDE_LEFT);
    }

    /**
     * Handle weight selection callback
     * @param weight Selected weight in pounds
     */
    function onWeightSelected(weight) {
        _selectedWeight = weight;
        _showLengthInput();
    }

    /**
     * Show length input using NumberPicker
     * @private
     */
    private function _showLengthInput() {
        var picker = new WatchUi.NumberPicker(WatchUi.NUMBER_PICKER_WHOLE_NUMBER);
        var delegate = new LengthPickerDelegate(self);

        WatchUi.pushView(picker, delegate, WatchUi.SLIDE_LEFT);
    }

    /**
     * Handle length selection callback
     * @param length Selected length in inches
     */
    function onLengthSelected(length) {
        _selectedLength = length;
        _saveCatch();
    }

    /**
     * Save the catch using ICatchLogger interface
     * @private
     */
    private function _saveCatch() {
        var catchObj = {
            :timestamp => Time.now().value(),
            :baitId => _selectedBaitId,
            :species => _selectedSpecies,
            :weight => _selectedWeight,
            :length => _selectedLength,
            :location => _location,
            :synced => false
        };

        // Call ICatchLogger.saveCatch()
        var success = _catchLogger.saveCatch(catchObj);

        // Show confirmation
        var message = success ?
            WatchUi.loadResource(Rez.Strings.CatchSaved) :
            WatchUi.loadResource(Rez.Strings.CatchSaveFailed);

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
 * Handles species selection
 */
class SpeciesSelectionDelegate extends WatchUi.Menu2InputDelegate {

    private var _parentDelegate;

    function initialize(parentDelegate) {
        Menu2InputDelegate.initialize();
        _parentDelegate = parentDelegate;
    }

    function onSelect(item as MenuItem) as Void {
        _parentDelegate.onSpeciesSelected(item.getId());
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}

/**
 * WeightPickerDelegate
 * Handles weight input via NumberPicker
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
 * Handles length input via NumberPicker
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
