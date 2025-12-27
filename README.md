# Fishing Log - Garmin Fenix 6 Pro Application

A fishing catch logging application for Garmin Fenix 6 Pro Sapphire, built using **strict Test-Driven Development (TDD)** approach with Monkey C 4.x.

## TDD Development Approach

This application was developed following a strict TDD methodology:

### STEP 1: INTERFACES (CONTRACTS) ✓
Defined interface contracts as base classes in `source/interfaces/`:
- **IBaitProvider**: Contract for bait data access
  - `getBaits()`: Retrieve all available baits
  - `getBaitById(id)`: Get specific bait by ID

- **ICatchLogger**: Contract for catch persistence
  - `saveCatch(catchObj)`: Save catch to storage
  - `getUnsyncedCatches()`: Get catches pending sync
  - `markAsSynced(id)`: Mark catch as synchronized

- **ISyncService**: Contract for data synchronization
  - `syncNext()`: Sync next pending catch

All interface methods throw `Lang.Exception("Not Implemented")` until concrete implementations are provided.

### STEP 2: UNIT TESTS ✓
Created comprehensive test suite in `source/tests/` using `:test` annotation:

**BaitProviderImplTest** (4 tests):
- ✓ Retrieve all baits from resources
- ✓ Get specific bait by ID
- ✓ Handle invalid bait IDs
- ✓ Validate bait object structure

**CatchLoggerImplTest** (4 tests):
- ✓ Save catch to Application.Storage
- ✓ Retrieve unsynced catches
- ✓ Mark catch as synced
- ✓ Verify data persistence across instances

**DataFormatterTest** (5 tests):
- ✓ Convert catch to JSON format
- ✓ Include GPS location data
- ✓ Format timestamps correctly
- ✓ Convert multiple catches to JSON array
- ✓ Handle null values gracefully

### STEP 3: IMPLEMENTATION ✓
Implemented concrete classes that pass all tests:

**Models** (`source/models/`):
- `Catch.mc`: Data model with full serialization support

**Services** (`source/services/`):
- `BaitProviderImpl.mc`: Loads baits from JSON resources
- `CatchLoggerImpl.mc`: Persists to Application.Storage
- `DataFormatter.mc`: Converts catches to JSON
- `SyncServiceImpl.mc`: Background sync with phone connectivity check

**Resources** (`resources/`):
- `baits.json`: 10 bait definitions (Plastic Worm, Crankbait, Spinnerbait, Jig, Topwater Popper, Live Minnow, Nightcrawler, Spoon, Buzzbait, Frog Lure)
- `strings.xml`: All UI strings and labels
- `resources.xml`: Master resource configuration

### STEP 4: UI & INTEGRATION ✓
Built Fenix 6 Pro UI (260x260px) with WatchUi.Menu2:

**Application** (`source/`):
- `BaitLoggerApp.mc`: Main application entry point with dependency injection

**Views** (`source/views/`):
- `BaitLoggerView.mc`: Main menu (Log Catch, View Catches, Sync Data)
- `BaitLoggerDelegate.mc`: Main menu event handler
- `LogCatchView.mc`: Multi-step catch logging flow
  - Step 1: Select Bait (Menu2)
  - Step 2: Select Species (Menu2)
  - Step 3: Enter Weight (NumberPicker - decimal)
  - Step 4: Enter Length (NumberPicker - whole number)
  - Captures GPS location via Position.getInfo()
  - Calls `ICatchLogger.saveCatch()` interface
- `ViewCatchesView.mc`: Display logged catches with details

## Architecture

### Interface-Driven Design
All services implement interface contracts, enabling:
- **Duck Typing**: Monkey C uses structural typing
- **Testability**: Easy to mock interfaces for testing
- **Maintainability**: Clear contracts between components

### Data Flow
```
User Input (UI)
  → BaitLoggerDelegate
    → LogCatchDelegate
      → ICatchLogger.saveCatch()
        → Application.Storage
          → ISyncService.syncNext()
            → HTTP POST to backend
```

### Storage
- **Application.Storage**: Persistent key-value store
- **Storage Key**: `"catches"` (array of catch dictionaries)
- **Auto-sync**: Background check using `System.getDeviceSettings().phoneConnected`

### GPS Integration
- Captures location during catch logging
- Uses `Toybox.Position.getInfo()`
- Stores lat/lon in catch object
- Included in JSON export

## Features

### Current Features
✓ Log fishing catches with:
  - Bait selection (10 types)
  - Species selection (Bass, Trout, Pike, Salmon, Catfish, Walleye, Other)
  - Weight input (decimal pounds)
  - Length input (whole inches)
  - GPS location capture
  - Timestamp (automatic)

✓ View logged catches
  - List all unsynced catches
  - Display species, weight, length, time

✓ Sync to backend
  - Phone connectivity check
  - One-at-a-time sync to prevent overwhelming connection
  - Automatic retry support
  - Mark catches as synced after successful upload

### Future Enhancements
- [ ] Add launcher icon (80x80px PNG)
- [ ] Detailed catch view
- [ ] Edit/delete catches
- [ ] Weather conditions capture
- [ ] Photo attachment
- [ ] Fishing session tracking
- [ ] Catch statistics

## Technical Specifications

- **Language**: Monkey C 4.x
- **Target Device**: Fenix 6 Pro (260x260 display)
- **Min SDK**: 4.0.0
- **Permissions**: Communications, Positioning
- **Storage**: Application.Storage (persistent)
- **UI Framework**: WatchUi.Menu2, NumberPicker

## Running Tests

```bash
# Run unit tests using Garmin SDK
monkeyc --unit-test -o fishing-log-test.prg -f monkey.jungle -y <developer_key>
```

## Building the App

```bash
# Build for Fenix 6 Pro
monkeyc -o fishing-log.prg -f monkey.jungle -y <developer_key> -d fenix6pro
```

## Project Structure

```
garmin-fishing/
├── manifest.xml                 # App manifest
├── monkey.jungle                # Build configuration
├── source/
│   ├── BaitLoggerApp.mc        # Main application
│   ├── interfaces/             # Interface contracts
│   │   ├── IBaitProvider.mc
│   │   ├── ICatchLogger.mc
│   │   └── ISyncService.mc
│   ├── models/                 # Data models
│   │   └── Catch.mc
│   ├── services/               # Service implementations
│   │   ├── BaitProviderImpl.mc
│   │   ├── CatchLoggerImpl.mc
│   │   ├── DataFormatter.mc
│   │   └── SyncServiceImpl.mc
│   ├── tests/                  # Unit tests
│   │   ├── BaitProviderImplTest.mc
│   │   ├── CatchLoggerImplTest.mc
│   │   └── DataFormatterTest.mc
│   └── views/                  # UI components
│       ├── BaitLoggerView.mc
│       ├── BaitLoggerDelegate.mc
│       ├── LogCatchView.mc
│       └── ViewCatchesView.mc
└── resources/
    ├── resources.xml           # Master resources
    ├── drawables/
    │   └── drawables.xml
    ├── jsondata/
    │   └── baits.json          # Bait definitions
    └── strings/
        └── strings.xml         # UI strings
```

## Backend Integration

The sync service expects a REST API endpoint:

```
POST https://api.yourfishingapp.com/catches
Content-Type: application/json

{
  "catchData": "{\"id\":1,\"timestamp\":1703721600,...}",
  "deviceId": "<unique_device_id>"
}
```

Expected response:
- `200 OK` or `201 Created`: Catch synced successfully
- Other codes: Sync failed, will retry

## Duck Typing & Interface Pattern

While Monkey C doesn't have native interfaces, this app uses:
1. **Base classes** with `throw Exception("Not Implemented")`
2. **Duck typing** - methods are called based on their signature
3. **Clear contracts** - documented expected behavior

Example:
```monkeyc
// Interface contract
class ICatchLogger {
    function saveCatch(catchObj) {
        throw new Lang.Exception("Not Implemented");
    }
}

// Implementation
class CatchLoggerImpl extends ICatchLogger {
    function saveCatch(catchObj) {
        // Actual implementation
        Storage.setValue("catches", catchObj);
        return true;
    }
}
```

## License

This is a demonstration project built following TDD best practices for Garmin Connect IQ development.

## Author

Built as a Senior Garmin Developer demonstration using strict TDD methodology.
