using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;

/**
 * ViewCatchesView
 * Displays list of logged catches
 */
class ViewCatchesView extends WatchUi.Menu2 {

    private var _catches;

    /**
     * Constructor
     * @param catches Array of catch objects to display
     */
    function initialize(catches) {
        Menu2.initialize({:title => "My Catches"});

        _catches = catches;
        _buildCatchMenu();
    }

    /**
     * Build the catch list menu
     * @private
     */
    private function _buildCatchMenu() {
        for (var i = 0; i < _catches.size(); i++) {
            var catchObj = _catches[i];

            // Format the catch for display
            var label = catchObj[:species];
            if (label == null) {
                label = "Unknown";
            }

            var sublabel = "";
            if (catchObj[:weight] != null) {
                sublabel += catchObj[:weight] + " lbs";
            }

            if (catchObj[:length] != null) {
                if (sublabel.length() > 0) {
                    sublabel += ", ";
                }
                sublabel += catchObj[:length] + " in";
            }

            // Format timestamp
            if (catchObj[:timestamp] != null) {
                var moment = new Time.Moment(catchObj[:timestamp]);
                var info = Gregorian.info(moment, Time.FORMAT_SHORT);
                var timeStr = info.hour + ":" +
                    (info.min < 10 ? "0" : "") + info.min;

                if (sublabel.length() > 0) {
                    sublabel += " - ";
                }
                sublabel += timeStr;
            }

            addItem(new WatchUi.MenuItem(
                label,
                sublabel,
                i,
                {}
            ));
        }
    }

    /**
     * Get the catch at index
     * @param index Array index
     * @return Catch object
     */
    function getCatchAt(index) {
        if (index >= 0 && index < _catches.size()) {
            return _catches[index];
        }
        return null;
    }
}

/**
 * ViewCatchesDelegate
 * Handles catch list interaction
 */
class ViewCatchesDelegate extends WatchUi.Menu2InputDelegate {

    /**
     * Constructor
     */
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    /**
     * Handle catch selection
     * @param item The selected menu item
     */
    function onSelect(item as MenuItem) as Void {
        // Could show detailed catch view here
        // For now, just return
    }

    /**
     * Handle back button
     */
    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
