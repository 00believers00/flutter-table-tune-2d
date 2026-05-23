# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the demo app
flutter run

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Analyze for lints/type errors
flutter analyze

# Format code
dart format lib/

# Build (Android)
flutter build apk

# Build (iOS)
flutter build ios
```

## Architecture

This is a **Flutter package** providing a 2D interactive tuning table widget (ECU tuning use case). The public API is exported via [`lib/tuning_table.dart`](lib/tuning_table.dart).

### Layers

```
TuningTableController (public façade)
  └── TuningTable2DViewModel (all business logic)
        └── TuningTable2dView (StatefulWidget, main entry point)
              ├── ShowTable2d       — renders the grid cells
              ├── PointerTable      — CustomPaint crosshair overlay
              └── ShowSetting2D     — label-editing panel
```

**Controller → ViewModel → View** separation:
- `TuningTableController` (`lib/data/services/`) wraps `TuningTable2DViewModel` and is the only object consumers instantiate.
- `TuningTable2DViewModel` (`lib/data/viewModels/`) owns all grid state: labels, data points (`Map<String, TuningPointModel>`), scale calculations, and a `StreamController<UpdateType>` (`updateData`) that drives rebuilds.
- `TuningTable2dView` (`lib/screens/`) consumes the controller via props and listens to the stream.

### Key Data Flow

1. Consumer creates a `TuningTableController`, sets labels via `setHorizontalLabels()` / `setVerticalLabels()`, and calls `setMinMax()`.
2. Gestures (`onPanStart/Update/End`) on `TuningTable2dView` call `controller.convertPosition()` to map pixel coordinates to grid indices, then `updateSelect()`.
3. Batch operations (`calculator()`, `interpolation()`) mutate selected cells and broadcast an `UpdateType` event on the stream.
4. `PointerTable` uses a 10 ms `Timer` for smooth crosshair animation independent of the rebuild cycle.

### Cell Identity

Cell keys are strings formatted as `[x:y]` by `TuningPointModel.head(horizontal, vertical)`. The ViewModel's data map is keyed by these strings.

### Color Coding

`FunctionTableTune2DHelpers.calColor()` (`lib/shared/utils/table_tune_2d_helpers.dart`) computes per-cell colors based on the cell value relative to the table's min/max range. `invertColor: true` on `TuningTable2dView` reverses the color gradient.

### Enums to Know

| Enum | Values | Used For |
|------|--------|----------|
| `TableType` | `tune`, `preview` | `preview` overlays a blocking container (read-only) |
| `TuningCalculatorType` | `step`, `percent`, `numeric` | How `calculator()` transforms selected cells |
| `UpdateType` | `action`, `setLabels`, `none` | Stream events from ViewModel |
| `DataSortType` | `des`, `asc` | Label sort direction on pointer axis |

### Customization Props on `TuningTable2dView`

- `labelStyle`, `headerStyle`, `bodyStyle` — text styles
- `pointerSettings` — `ChangeNotifier` controlling crosshair visibility, sort order, and current pointer data values
- `settingTextCancel`, `settingTextSave` — custom widgets for the setting panel's Cancel/Save buttons
- `invertColor` — flips the value-to-color gradient
