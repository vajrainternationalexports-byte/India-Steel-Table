# IS Steel Tables Pro (iOS Native)

> **Professional Offline Reference & Calculation Application for Indian Standard (IS) Structural Steel Sections**  
> Formulated according to the Bureau of Indian Standards (BIS) specifications: **IS 808:1989, IS 1161:2014, IS 1239, IS 4923:1997, IS 1731:1971, IS 1732:1989, IS 2062:2011, and SP 6(1)**.

---

## 🏗 Key Features & Architecture

### 1. 100% Offline-First Architecture
- Bundled immutable JSON dataset with **567 verified structural sections** across 11 standard Indian steel families.
- Verified with SHA-256 integrity checksum (`77f7ebdaf6ef9de110884899e09c790350668288b1dae0f34ad03ccb467c4fa0`).
- Instant startup and zero network latency on construction sites.

### 2. Comprehensive Section Families
1. **Equal Angles (ISA)**: ISA 20x20x3 to ISA 200x200x25 (IS 808)
2. **Unequal Angles (ISA)**: ISA 30x20x3 to ISA 200x150x18 (IS 808)
3. **Beams**: Junior (ISJB), Light (ISLB), Medium (ISMB), Wide Flange (ISWB), Heavy / Columns (ISHB) (IS 808)
4. **Channels**: Junior (ISJC), Light (ISLC), Medium (ISMC) (IS 808)
5. **Circular Steel Tubes / Pipes**: Light, Medium, Heavy classes; 15 NB to 350 NB (IS 1161:2014 / IS 1239)
6. **Square Hollow Sections (SHS)**: 25x25 to 200x200 (IS 4923:1997)
7. **Rectangular Hollow Sections (RHS)**: 40x20 to 200x100 (IS 4923:1997)
8. **Round Steel Bars**: 5mm to 100mm (IS 1732:1989)
9. **Square Steel Bars**: 5mm to 100mm (IS 1732:1989)
10. **Steel Flats**: 12mm to 400mm widths, 3mm to 50mm thicknesses (IS 1731:1971)
11. **Hot Rolled Steel Plates**: 5mm to 100mm thickness (IS 2062:2011)
12. **Tee Sections**: ISNT, ISHT, ISST, ISLT, ISJT (IS 808:1989)

### 3. Parametric Vector Technical Diagrams (SwiftUI Canvas)
- Interactive dynamic vector drafting with real proportional scaling.
- Flange taper slopes ($98^\circ$ for ISMB, $94^\circ$ for ISHB, $95^\circ$ for ISMC).
- Dimension callouts: $h, b_f, t_w, t_f, R_1, R_2, C_y, C_x, OD, t$.
- Coordinate axes: $X-X, Y-Y, U-U, V-V, Z-Z$.

### 4. Dual Browsing Modes
- **Visual Card List Mode**: Grouped properties, quick search, series filtering chips.
- **High-Density Spreadsheet Table Grid**: Horizontally scrollable data table with frozen first column, multi-column ascending/descending sort, and range filters.

### 5. Side-by-Side Comparison Workspace
- Compare 2 to 5 sections simultaneously across all dimensions, sectional properties, and moduli with min/max indicator highlights.

### 6. Full Structural Calculation Hub
- **Section Mass & Weight Calculator**: Quantity $\times$ Length $\times$ Mass/m with unit conversions ($kg, t, kN, N$).
- **Plate Mass Calculator**: Length $\times$ Width $\times$ Thickness $\times \rho$ ($7850\text{ kg/m}^3$).
- **Bar Weight Calculator**: Round bar ($D^2/162$ standard site rule + exact $\pi/4 D^2 \rho$) and Square bar.
- **Pipe / Hollow Tube Calculator**: Mass per metre and internal pipe capacity volume ($cm^3/m$).
- **Universal Unit Converter**: Length, Mass, Force, Area, Moment of Inertia, Section Modulus.
- **Project Take-Off & BOM Estimator**: Multi-item Bill of Materials with aggregate tonnage, total estimated cost ($\text{INR}$), and CSV export.

### 7. Export & Security
- One-tap property copy with clean units (e.g. `Mass per metre: 44.2 kg/m`).
- Formula-injection-safe CSV export (`=`, `+`, `-`, `@` safely escaped).
- Native iOS Share Sheet integration.

---

## 🧪 Validation & Automated Testing

Run the automated test runner:
```bash
python3 Scripts/test_runner.py
```

Output:
```text
==================================================
 IS Steel Tables Pro — Test & Validation Runner
==================================================
[1/4] Verifying master dataset files and SHA-256 signatures...
    [✓] Dataset valid: 567 sections, SHA-256: 77f7ebdaf6ef9de1...
[2/4] Verifying structural engineering calculations...
    [✓] All engineering formulas verified.
[3/4] Verifying Swift module architecture...
    [✓] All 39 Swift source components present and verified.
[4/4] Verifying CSV formula injection protection...
    [✓] Formula injection sanitizer test passed.

==================================================
 [✓] ALL 4 AUTOMATED TEST SUITES PASSED (100%)
==================================================
```

---

## 📁 Repository Layout

```
India Steel Table/
├── Package.swift                    // Swift Package Manifest (iOS 17+, macOS 14+)
├── ISSteelTablesPro.xcodeproj       // Native Xcode project bundle
├── Resources/
│   ├── Info.plist
│   └── Assets.xcassets/
├── Scripts/
│   ├── build_and_validate_dataset.py
│   └── test_runner.py
├── Sources/
│   ├── ISSteelTablesPro/
│   │   ├── App/                     // ISSteelTablesProApp, AppEnvironment
│   │   ├── Domain/                  // Models, Calculations, Validation, Repositories
│   │   ├── Data/                    // BundledData, SearchIndexer, Persistence
│   │   ├── Features/                // Home, Families, TableView, Detail, Compare, Calculators, Diagrams
│   │   └── UIComponents/            // ColorTokens, TypographyTokens, MetricPill, SectionRowCard
│   └── ISSteelTablesProCli/         // Verification CLI tool
└── Tests/
    └── ISSteelTablesProTests/       // Calculation, Dataset, Search, BOM unit tests
```
