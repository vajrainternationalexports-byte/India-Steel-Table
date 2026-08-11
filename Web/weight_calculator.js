/**
 * Engineering Weight Calculator - Project B Full Replica Implementation
 * Comprehensive Standards (IS 808, ANSI, BS 4, AS 3679, ISO 657), Technical Canvas Renderer,
 * Specific Gravity Selector, Unit Converter, Scientific Expression Calculator & Takeoff Store.
 */

const DENSITY_DATABASE = [
    { name: "Aluminium", sg: 2.70 },
    { name: "Brass", sg: 8.45 },
    { name: "Bronze", sg: 8.73 },
    { name: "Cast Iron", sg: 7.20 },
    { name: "Copper", sg: 8.96 },
    { name: "Steel (General / Mild)", sg: 7.85 },
    { name: "Steel C15", sg: 7.85 },
    { name: "Steel C35", sg: 7.84 },
    { name: "Steel C60", sg: 7.83 },
    { name: "Stainless Steel (304/316)", sg: 7.93 },
    { name: "Lead", sg: 11.35 },
    { name: "Titanium", sg: 4.51 },
    { name: "Zinc", sg: 7.14 },
    { name: "Gold", sg: 19.32 },
    { name: "Silver", sg: 10.49 },
    { name: "Nickel", sg: 8.90 }
];

const SWG_GAUGE_TABLE = [
    { gauge: "8G", mm: 4.064 },
    { gauge: "9G", mm: 3.658 },
    { gauge: "10G", mm: 3.251 },
    { gauge: "11G", mm: 2.946 },
    { gauge: "12G", mm: 2.642 },
    { gauge: "13G", mm: 2.337 },
    { gauge: "14G", mm: 2.032 },
    { gauge: "15G", mm: 1.829 },
    { gauge: "16G", mm: 1.626 },
    { gauge: "17G", mm: 1.422 },
    { gauge: "18G", mm: 1.219 },
    { gauge: "19G", mm: 1.016 },
    { gauge: "20G", mm: 0.914 },
    { gauge: "21G", mm: 0.813 },
    { gauge: "22G", mm: 0.711 },
    { gauge: "23G", mm: 0.610 },
    { gauge: "24G", mm: 0.559 },
    { gauge: "25G", mm: 0.508 },
    { gauge: "26G", mm: 0.457 }
];

const INCH_FRACTIONS = [
    { fraction: "1/64", decimal: 0.0156, mm: 0.397 },
    { fraction: "1/32", decimal: 0.0313, mm: 0.794 },
    { fraction: "1/16", decimal: 0.0625, mm: 1.588 },
    { fraction: "1/8", decimal: 0.1250, mm: 3.175 },
    { fraction: "3/16", decimal: 0.1875, mm: 4.763 },
    { fraction: "1/4", decimal: 0.2500, mm: 6.350 },
    { fraction: "5/16", decimal: 0.3125, mm: 7.938 },
    { fraction: "3/8", decimal: 0.3750, mm: 9.525 },
    { fraction: "7/16", decimal: 0.4375, mm: 11.113 },
    { fraction: "1/2", decimal: 0.5000, mm: 12.700 },
    { fraction: "9/16", decimal: 0.5625, mm: 14.288 },
    { fraction: "5/8", decimal: 0.6250, mm: 15.875 },
    { fraction: "3/4", decimal: 0.7500, mm: 19.050 },
    { fraction: "7/8", decimal: 0.8750, mm: 22.225 },
    { fraction: "1\"", decimal: 1.0000, mm: 25.400 }
];

// STANDARD PROFILES DATABASE (IS 808, ANSI, BS 4, AS 3679, ISO 657)
const STANDARD_PROFILES = {
    beam: {
        IS: [
            { name: "ISJB 150", h: 150, b: 50, tw: 3.0, tf: 4.6, mass: 7.1 },
            { name: "ISLB 175", h: 175, b: 85, tw: 4.8, tf: 6.8, mass: 16.7 },
            { name: "ISLB 200", h: 200, b: 100, tw: 5.0, tf: 7.3, mass: 19.8 },
            { name: "ISLB 225", h: 225, b: 100, tw: 5.8, tf: 8.6, mass: 23.9 },
            { name: "ISMB 100", h: 100, b: 50, tw: 4.7, tf: 7.0, mass: 8.9 },
            { name: "ISMB 150", h: 150, b: 75, tw: 5.0, tf: 8.0, mass: 15.0 },
            { name: "ISMB 200", h: 200, b: 100, tw: 5.7, tf: 10.8, mass: 25.4 },
            { name: "ISMB 250", h: 250, b: 125, tw: 6.9, tf: 12.5, mass: 37.3 },
            { name: "ISMB 300", h: 300, b: 140, tw: 7.5, tf: 13.1, mass: 44.2 },
            { name: "ISHB 200", h: 200, b: 200, tw: 6.1, tf: 9.0, mass: 37.3 }
        ],
        ANSI: [
            { name: "W 6x9", h: 150, b: 100, tw: 4.3, tf: 5.5, mass: 13.4 },
            { name: "W 8x10", h: 200, b: 100, tw: 4.3, tf: 5.2, mass: 14.9 },
            { name: "W 10x12", h: 250, b: 100, tw: 4.8, tf: 5.3, mass: 17.9 },
            { name: "S 3x5.7", h: 76.2, b: 59.2, tw: 4.3, tf: 6.6, mass: 8.5 }
        ],
        BS: [
            { name: "UB 127x76x13", h: 127, b: 76, tw: 4.0, tf: 7.6, mass: 13.0 },
            { name: "UB 152x89x16", h: 152.4, b: 88.7, tw: 4.5, tf: 7.7, mass: 16.0 },
            { name: "UB 203x133x25", h: 203.2, b: 133.2, tw: 5.7, tf: 7.8, mass: 25.1 }
        ]
    },
    channel: {
        IS: [
            { name: "ISJC 100", h: 100, b: 45, tw: 3.0, tf: 4.7, mass: 5.8 },
            { name: "ISLC 100", h: 100, b: 50, tw: 4.0, tf: 6.4, mass: 7.9 },
            { name: "ISMC 75", h: 75, b: 40, tw: 4.4, tf: 7.3, mass: 7.1 },
            { name: "ISMC 100", h: 100, b: 50, tw: 4.7, tf: 7.5, mass: 9.6 },
            { name: "ISMC 125", h: 125, b: 65, tw: 5.3, tf: 8.1, mass: 13.1 },
            { name: "ISMC 150", h: 150, b: 75, tw: 5.7, tf: 7.8, mass: 16.8 },
            { name: "ISMC 200", h: 200, b: 75, tw: 6.2, tf: 11.4, mass: 22.3 },
            { name: "ISMC 250", h: 250, b: 80, tw: 7.2, tf: 14.1, mass: 30.7 }
        ],
        ANSI: [
            { name: "C 3x4.1", h: 76.2, b: 35.8, tw: 4.3, tf: 6.9, mass: 6.1 },
            { name: "MC 6x12", h: 152.4, b: 63.4, tw: 8.0, tf: 9.8, mass: 17.9 },
            { name: "C 8x11.5", h: 203.2, b: 57.4, tw: 5.6, tf: 9.9, mass: 17.1 }
        ],
        BS: [
            { name: "PFC 100x50", h: 100, b: 50, tw: 5.0, tf: 8.5, mass: 10.2 },
            { name: "PFC 150x75", h: 150, b: 75, tw: 5.5, tf: 10.0, mass: 17.9 }
        ]
    },
    equal_angle: {
        IS: [
            { name: "ISA 25x25x3", a: 25, b: 25, t: 3, mass: 1.1 },
            { name: "ISA 30x30x3", a: 30, b: 30, t: 3, mass: 1.4 },
            { name: "ISA 40x40x5", a: 40, b: 40, t: 5, mass: 3.0 },
            { name: "ISA 50x50x6", a: 50, b: 50, t: 6, mass: 4.5 },
            { name: "ISA 65x65x6", a: 65, b: 65, t: 6, mass: 5.8 },
            { name: "ISA 75x75x8", a: 75, b: 75, t: 8, mass: 8.9 },
            { name: "ISA 100x100x10", a: 100, b: 100, t: 10, mass: 14.9 }
        ]
    },
    tee: {
        IS: [
            { name: "ISNT 20", h: 20, b: 20, tw: 3.0, tf: 3.0, mass: 0.9 },
            { name: "ISNT 40", h: 40, b: 40, tw: 5.0, tf: 5.0, mass: 2.9 },
            { name: "ISNT 50", h: 50, b: 50, tw: 6.0, tf: 6.0, mass: 4.5 },
            { name: "ISNT 75", h: 75, b: 75, tw: 8.0, tf: 8.0, mass: 8.9 },
            { name: "ISNT 100", h: 100, b: 100, tw: 10.0, tf: 10.0, mass: 15.0 },
            { name: "ISMT 75", h: 75, b: 150, tw: 7.0, tf: 10.0, mass: 14.2 }
        ]
    }
};

let weightCalcState = {
    activeShape: 'plate',
    activeFamily: 'IS',
    sg: 7.85,
    materialName: 'Steel (General / Mild)',
    unitPrice: 1.00,
    takeoffList: JSON.parse(localStorage.getItem('weight_calc_takeoff') || '[]'),
    lastResult: null
};

document.addEventListener('DOMContentLoaded', () => {
    initWeightCalculatorEvents();
    renderSpecificGravityModal();
    renderSwgModal();
    renderInchFractionsTable();
    renderTakeoffList();
    updateLinearConversion();
});

function initWeightCalculatorEvents() {
    const appShell = document.getElementById('app-swipe-shell');
    const tabA = document.getElementById('tab-project-a');
    const tabB = document.getElementById('tab-project-b');
    
    if (tabA && tabB && appShell) {
        let startX = 0;
        let startY = 0;
        appShell.addEventListener('touchstart', (e) => {
            startX = e.touches[0].clientX;
            startY = e.touches[0].clientY;
        }, { passive: true });

        appShell.addEventListener('touchend', (e) => {
            const endX = e.changedTouches[0].clientX;
            const endY = e.changedTouches[0].clientY;
            const diffX = endX - startX;
            const diffY = endY - startY;

            if (Math.abs(diffX) > 60 && Math.abs(diffX) > Math.abs(diffY)) {
                if (diffX < 0) {
                    switchProjectTab('B');
                } else {
                    switchProjectTab('A');
                }
            }
        }, { passive: true });
    }
}

function switchProjectTab(projectKey) {
    const appShell = document.getElementById('app-swipe-shell');
    const tabA = document.getElementById('tab-project-a');
    const tabB = document.getElementById('tab-project-b');

    if (!appShell || !tabA || !tabB) return;

    if (projectKey === 'A') {
        appShell.style.transform = 'translateX(0%)';
        tabA.classList.add('active');
        tabB.classList.remove('active');
    } else {
        appShell.style.transform = 'translateX(-50%)';
        tabB.classList.add('active');
        tabA.classList.remove('active');
    }
}

function openShapeCalculator(shapeKey) {
    weightCalcState.activeShape = shapeKey;
    document.getElementById('wb-grid-screen').style.display = 'none';
    document.getElementById('wb-form-screen').style.display = 'block';

    const formTitle = document.getElementById('wb-form-title');
    const formInputsContainer = document.getElementById('wb-form-inputs');
    const stdSelectorContainer = document.getElementById('wb-standard-selector-container');

    formInputsContainer.innerHTML = '';
    
    // Check if standard selector applies
    if (STANDARD_PROFILES[shapeKey]) {
        stdSelectorContainer.style.display = 'block';
        renderProfileChips(shapeKey, weightCalcState.activeFamily);
    } else {
        stdSelectorContainer.style.display = 'none';
    }

    let html = '';
    switch(shapeKey) {
        case 'plate':
        case 'flat':
            formTitle.innerText = shapeKey === 'plate' ? 'Plate / Sheet' : 'Flat Bar';
            html = `
                <div class="wb-input-group">
                    <label>Length (L) (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Width (W) (mm)</label>
                    <input type="number" id="inp_w" value="100" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Thickness (T) (mm)</label>
                    <input type="number" id="inp_t" value="10" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Quantity</label>
                    <input type="number" id="inp_qty" value="1" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'pipe':
            formTitle.innerText = 'Round Pipe / Tube';
            html = `
                <div class="wb-input-group">
                    <label>Outer Diameter (OD) (mm)</label>
                    <input type="number" id="inp_od" value="114.3" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Wall Thickness (t) (mm)</label>
                    <input type="number" id="inp_t" value="4.5" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (L) (mm)</label>
                    <input type="number" id="inp_l" value="6000" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Quantity</label>
                    <input type="number" id="inp_qty" value="1" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'rod':
            formTitle.innerText = 'Round Bar / Rod';
            html = `
                <div class="wb-input-group">
                    <label>Diameter (D) (mm)</label>
                    <input type="number" id="inp_d" value="25" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (L) (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Quantity</label>
                    <input type="number" id="inp_qty" value="1" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'square':
            formTitle.innerText = 'Square Bar';
            html = `
                <div class="wb-input-group">
                    <label>Side (S) (mm)</label>
                    <input type="number" id="inp_s" value="50" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (L) (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Quantity</label>
                    <input type="number" id="inp_qty" value="1" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'hex':
            formTitle.innerText = 'Hexagonal Bar';
            html = `
                <div class="wb-input-group">
                    <label>Across Flats (A/F) (mm)</label>
                    <input type="number" id="inp_af" value="32" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (L) (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Quantity</label>
                    <input type="number" id="inp_qty" value="1" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'oct':
            formTitle.innerText = 'Octagonal Bar';
            html = `
                <div class="wb-input-group">
                    <label>Across Flats (A/F) (mm)</label>
                    <input type="number" id="inp_af" value="40" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (L) (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Quantity</label>
                    <input type="number" id="inp_qty" value="1" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'box':
            formTitle.innerText = 'Rectangular / Square Tube';
            html = `
                <div class="wb-input-group">
                    <label>Height (H) (mm)</label>
                    <input type="number" id="inp_h" value="100" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Width (W) (mm)</label>
                    <input type="number" id="inp_w" value="80" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Thickness (t) (mm)</label>
                    <input type="number" id="inp_t" value="5" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (L) (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Quantity</label>
                    <input type="number" id="inp_qty" value="1" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'equal_angle':
        case 'unequal_angle':
            formTitle.innerText = shapeKey === 'equal_angle' ? 'Equal Angle' : 'Unequal Angle';
            html = `
                <div class="wb-input-group">
                    <label>Leg A (mm)</label>
                    <input type="number" id="inp_a" value="50" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Leg B (mm)</label>
                    <input type="number" id="inp_b" value="50" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Thickness (t) (mm)</label>
                    <input type="number" id="inp_t" value="6" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (L) (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Quantity</label>
                    <input type="number" id="inp_qty" value="1" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'beam':
            formTitle.innerText = 'I-Beam Section';
            html = `
                <div class="wb-input-group">
                    <label>Height (H) (mm)</label>
                    <input type="number" id="inp_h" value="200" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Flange Width (B) (mm)</label>
                    <input type="number" id="inp_w" value="100" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Web Thickness (tw) (mm)</label>
                    <input type="number" id="inp_tw" value="5.7" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Flange Thickness (tf) (mm)</label>
                    <input type="number" id="inp_tf" value="10.8" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (L) (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Quantity</label>
                    <input type="number" id="inp_qty" value="1" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'channel':
            formTitle.innerText = 'Channel Section';
            html = `
                <div class="wb-input-group">
                    <label>Height (H) (mm)</label>
                    <input type="number" id="inp_h" value="150" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Flange Width (B) (mm)</label>
                    <input type="number" id="inp_w" value="75" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Web Thickness (tw) (mm)</label>
                    <input type="number" id="inp_tw" value="5.7" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Flange Thickness (tf) (mm)</label>
                    <input type="number" id="inp_tf" value="7.8" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (L) (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Quantity</label>
                    <input type="number" id="inp_qty" value="1" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'tee':
            formTitle.innerText = 'Tee Bar Section';
            html = `
                <div class="wb-input-group">
                    <label>Height (H) (mm)</label>
                    <input type="number" id="inp_h" value="75" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Flange Width (B) (mm)</label>
                    <input type="number" id="inp_w" value="75" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Thickness (t) (mm)</label>
                    <input type="number" id="inp_t" value="8" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (L) (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Quantity</label>
                    <input type="number" id="inp_qty" value="1" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        default:
            formTitle.innerText = 'Section Calculator';
            html = `
                <div class="wb-input-group">
                    <label>Length (L) (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Side / Dimension (mm)</label>
                    <input type="number" id="inp_s" value="50" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Quantity</label>
                    <input type="number" id="inp_qty" value="1" oninput="calculateCurrentMass()">
                </div>
            `;
            break;
    }

    formInputsContainer.innerHTML = html;
    drawShapeCanvas(shapeKey);
}

function selectStandardFamily(family) {
    weightCalcState.activeFamily = family;
    document.querySelectorAll('.wb-std-btn').forEach(btn => {
        btn.classList.toggle('active', btn.innerText.includes(family));
    });
    renderProfileChips(weightCalcState.activeShape, family);
}

function renderProfileChips(shapeKey, family) {
    const container = document.getElementById('wb-profile-picker-container');
    if (!container) return;

    const list = (STANDARD_PROFILES[shapeKey] && STANDARD_PROFILES[shapeKey][family]) || [];
    if (list.length === 0) {
        container.innerHTML = '<span style="grid-column: span 2; font-size: 0.75rem; color: #888;">Custom dimensions standard</span>';
        return;
    }

    container.innerHTML = list.map((item, idx) => `
        <div class="wb-profile-chip" onclick="applyStandardProfile('${shapeKey}', '${family}', ${idx})">
            ${item.name}
        </div>
    `).join('');
}

function applyStandardProfile(shapeKey, family, index) {
    const item = STANDARD_PROFILES[shapeKey][family][index];
    if (!item) return;

    if (item.h && document.getElementById('inp_h')) document.getElementById('inp_h').value = item.h;
    if (item.b && document.getElementById('inp_w')) document.getElementById('inp_w').value = item.b;
    if (item.a && document.getElementById('inp_a')) document.getElementById('inp_a').value = item.a;
    if (item.b && document.getElementById('inp_b')) document.getElementById('inp_b').value = item.b;
    if (item.tw && document.getElementById('inp_tw')) document.getElementById('inp_tw').value = item.tw;
    if (item.tf && document.getElementById('inp_tf')) document.getElementById('inp_tf').value = item.tf;
    if (item.t && document.getElementById('inp_t')) document.getElementById('inp_t').value = item.t;

    document.querySelectorAll('.wb-profile-chip').forEach((chip, i) => {
        chip.classList.toggle('active', i === index);
    });

    drawShapeCanvas(shapeKey);
}

function returnToGridScreen() {
    document.getElementById('wb-form-screen').style.display = 'none';
    document.getElementById('wb-grid-screen').style.display = 'grid';
}

// 2D TECHNICAL CANVAS RENDERER WITH DIMENSION LINES (IMG_9450, IMG_9460)
function drawShapeCanvas(shapeKey) {
    const canvas = document.getElementById('shapeCanvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const w = canvas.width;
    const h = canvas.height;

    ctx.clearRect(0, 0, w, h);

    ctx.fillStyle = '#00E5FF';
    ctx.strokeStyle = '#ffffff';
    ctx.lineWidth = 2;

    const cx = w / 2;
    const cy = h / 2;

    ctx.beginPath();
    switch(shapeKey) {
        case 'plate':
        case 'flat':
        case 'square':
            ctx.rect(cx - 50, cy - 40, 100, 80);
            ctx.fill(); ctx.stroke();
            drawDimensionArrow(ctx, cx - 50, cy + 50, cx + 50, cy + 50, "W / Side");
            drawDimensionArrow(ctx, cx - 60, cy - 40, cx - 60, cy + 40, "T / H");
            break;

        case 'pipe':
            ctx.arc(cx, cy, 45, 0, Math.PI * 2);
            ctx.fill(); ctx.stroke();
            ctx.beginPath();
            ctx.fillStyle = '#181a20';
            ctx.arc(cx, cy, 30, 0, Math.PI * 2);
            ctx.fill(); ctx.stroke();
            drawDimensionArrow(ctx, cx - 45, cy - 55, cx + 45, cy - 55, "OD");
            break;

        case 'rod':
            ctx.arc(cx, cy, 45, 0, Math.PI * 2);
            ctx.fill(); ctx.stroke();
            drawDimensionArrow(ctx, cx - 45, cy - 55, cx + 45, cy - 55, "D");
            break;

        case 'beam':
            // I-Beam Profile
            ctx.fillRect(cx - 40, cy - 50, 80, 14); // Top flange
            ctx.fillRect(cx - 6, cy - 50, 12, 100); // Web
            ctx.fillRect(cx - 40, cy + 36, 80, 14); // Bottom flange
            ctx.strokeRect(cx - 40, cy - 50, 80, 14);
            ctx.strokeRect(cx - 6, cy - 50, 12, 100);
            ctx.strokeRect(cx - 40, cy + 36, 80, 14);
            drawDimensionArrow(ctx, cx - 55, cy - 50, cx - 55, cy + 50, "H");
            drawDimensionArrow(ctx, cx - 40, cy + 60, cx + 40, cy + 60, "B");
            break;

        case 'channel':
            // Channel Profile
            ctx.fillRect(cx - 30, cy - 50, 12, 100); // Web
            ctx.fillRect(cx - 30, cy - 50, 60, 14); // Top flange
            ctx.fillRect(cx - 30, cy + 36, 60, 14); // Bottom flange
            ctx.strokeRect(cx - 30, cy - 50, 12, 100);
            ctx.strokeRect(cx - 30, cy - 50, 60, 14);
            ctx.strokeRect(cx - 30, cy + 36, 60, 14);
            drawDimensionArrow(ctx, cx - 42, cy - 50, cx - 42, cy + 50, "H");
            drawDimensionArrow(ctx, cx - 30, cy + 60, cx + 30, cy + 60, "B");
            break;

        case 'equal_angle':
        case 'unequal_angle':
            // Angle Profile
            ctx.fillRect(cx - 40, cy - 40, 14, 80);
            ctx.fillRect(cx - 40, cy + 26, 80, 14);
            ctx.strokeRect(cx - 40, cy - 40, 14, 80);
            ctx.strokeRect(cx - 40, cy + 26, 80, 14);
            drawDimensionArrow(ctx, cx - 52, cy - 40, cx - 52, cy + 40, "Leg A");
            drawDimensionArrow(ctx, cx - 40, cy + 50, cx + 40, cy + 50, "Leg B");
            break;

        case 'tee':
            // Tee Profile
            ctx.fillRect(cx - 40, cy - 40, 80, 14); // Top flange
            ctx.fillRect(cx - 6, cy - 40, 12, 80); // Leg
            ctx.strokeRect(cx - 40, cy - 40, 80, 14);
            ctx.strokeRect(cx - 6, cy - 40, 12, 80);
            drawDimensionArrow(ctx, cx - 20, cy - 40, cx - 20, cy + 40, "H");
            drawDimensionArrow(ctx, cx - 40, cy - 52, cx + 40, cy - 52, "B");
            break;

        default:
            ctx.rect(cx - 40, cy - 40, 80, 80);
            ctx.fill(); ctx.stroke();
            break;
    }
}

function drawDimensionArrow(ctx, x1, y1, x2, y2, label) {
    ctx.save();
    ctx.strokeStyle = '#FFD700';
    ctx.fillStyle = '#FFD700';
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();

    ctx.font = '10px sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText(label, (x1 + x2) / 2, (y1 + y2) / 2 - 4);
    ctx.restore();
}

// MATHEMATICAL CALCULATION ENGINE
function calculateMassEngine() {
    const shape = weightCalcState.activeShape;
    const sg = weightCalcState.sg;
    const qty = parseFloat(document.getElementById('inp_qty')?.value || 1);

    let area_mm2 = 0;
    let length_mm = parseFloat(document.getElementById('inp_l')?.value || 1000);

    switch(shape) {
        case 'plate':
        case 'flat':
            const w = parseFloat(document.getElementById('inp_w')?.value || 100);
            const t = parseFloat(document.getElementById('inp_t')?.value || 10);
            area_mm2 = w * t;
            break;

        case 'pipe':
            const od = parseFloat(document.getElementById('inp_od')?.value || 114.3);
            const pipe_t = parseFloat(document.getElementById('inp_t')?.value || 4.5);
            const id = od - 2 * pipe_t;
            area_mm2 = (Math.PI / 4) * (od * od - id * id);
            break;

        case 'rod':
            const d = parseFloat(document.getElementById('inp_d')?.value || 25);
            area_mm2 = (Math.PI / 4) * (d * d);
            break;

        case 'square':
            const s = parseFloat(document.getElementById('inp_s')?.value || 50);
            area_mm2 = s * s;
            break;

        case 'hex':
            const af_hex = parseFloat(document.getElementById('inp_af')?.value || 32);
            area_mm2 = 0.866025 * af_hex * af_hex;
            break;

        case 'oct':
            const af_oct = parseFloat(document.getElementById('inp_af')?.value || 40);
            area_mm2 = 0.828427 * af_oct * af_oct;
            break;

        case 'box':
            const box_h = parseFloat(document.getElementById('inp_h')?.value || 100);
            const box_w = parseFloat(document.getElementById('inp_w')?.value || 80);
            const box_t = parseFloat(document.getElementById('inp_t')?.value || 5);
            area_mm2 = 2 * box_t * (box_h + box_w - 2 * box_t);
            break;

        case 'equal_angle':
        case 'unequal_angle':
            const leg_a = parseFloat(document.getElementById('inp_a')?.value || 50);
            const leg_b = parseFloat(document.getElementById('inp_b')?.value || 50);
            const angle_t = parseFloat(document.getElementById('inp_t')?.value || 6);
            area_mm2 = angle_t * (leg_a + leg_b - angle_t);
            break;

        case 'beam':
            const bm_h = parseFloat(document.getElementById('inp_h')?.value || 200);
            const bm_w = parseFloat(document.getElementById('inp_w')?.value || 100);
            const bm_tw = parseFloat(document.getElementById('inp_tw')?.value || 5.7);
            const bm_tf = parseFloat(document.getElementById('inp_tf')?.value || 10.8);
            area_mm2 = 2 * (bm_w * bm_tf) + (bm_h - 2 * bm_tf) * bm_tw;
            break;

        case 'channel':
            const ch_h = parseFloat(document.getElementById('inp_h')?.value || 150);
            const ch_w = parseFloat(document.getElementById('inp_w')?.value || 75);
            const ch_tw = parseFloat(document.getElementById('inp_tw')?.value || 5.7);
            const ch_tf = parseFloat(document.getElementById('inp_tf')?.value || 7.8);
            area_mm2 = 2 * (ch_w * ch_tf) + (ch_h - 2 * ch_tf) * ch_tw;
            break;

        case 'tee':
            const tee_h = parseFloat(document.getElementById('inp_h')?.value || 75);
            const tee_w = parseFloat(document.getElementById('inp_w')?.value || 75);
            const tee_t = parseFloat(document.getElementById('inp_t')?.value || 8);
            area_mm2 = (tee_w * tee_t) + (tee_h - tee_t) * tee_t;
            break;

        default:
            area_mm2 = 1000;
            break;
    }

    const volume_cm3 = (area_mm2 / 100) * (length_mm / 10);
    const unit_mass_kg = (volume_cm3 * sg) / 1000;
    const total_mass_kg = unit_mass_kg * qty;
    const total_cost = total_mass_kg * weightCalcState.unitPrice;

    return {
        component: document.getElementById('wb-form-title')?.innerText || 'Section',
        size: `${length_mm} mm (SG: ${sg})`,
        qty: qty,
        unitMass: unit_mass_kg,
        totalMass: total_mass_kg,
        totalCost: total_cost
    };
}

function calculateAndShowResultModal() {
    const res = calculateMassEngine();
    weightCalcState.lastResult = res;

    document.getElementById('res-component').innerText = res.component;
    document.getElementById('res-size').innerText = res.size;
    document.getElementById('res-qty').innerText = res.qty;
    document.getElementById('res-unit-mass').innerText = `${res.unitMass.toFixed(3)} kg`;
    document.getElementById('res-total-mass').innerText = `${res.totalMass.toFixed(3)} kg`;
    document.getElementById('res-cost-kg').innerText = weightCalcState.unitPrice.toFixed(2);
    document.getElementById('res-total-cost').innerText = `Rs. ${res.totalCost.toFixed(2)}`;

    openModal('modal-result');
}

// MODAL DIALOG CONTROLLERS
function openModal(id) {
    document.getElementById(id).style.display = 'flex';
}

function closeModal(id) {
    document.getElementById(id).style.display = 'none';
}

function renderSpecificGravityModal() {
    const list = document.getElementById('sg-modal-list');
    if (!list) return;

    list.innerHTML = DENSITY_DATABASE.map(item => `
        <div class="wb-modal-item ${item.sg === weightCalcState.sg ? 'selected' : ''}" onclick="selectSpecificGravity(${item.sg}, '${item.name}')">
            <span>${item.name}</span>
            <strong class="wb-badge">${item.sg.toFixed(2)} g/cm³</strong>
        </div>
    `).join('');
}

function selectSpecificGravity(sg, name) {
    weightCalcState.sg = sg;
    weightCalcState.materialName = name;
    renderSpecificGravityModal();
    closeModal('modal-sg');
}

function renderSwgModal() {
    const list = document.getElementById('swg-modal-list');
    if (!list) return;

    list.innerHTML = SWG_GAUGE_TABLE.map(item => `
        <div class="wb-modal-item" onclick="applySwgThickness(${item.mm})">
            <span>${item.gauge}</span>
            <strong class="wb-badge">${item.mm.toFixed(3)} mm</strong>
        </div>
    `).join('');
}

function applySwgThickness(mm) {
    const inputT = document.getElementById('inp_t');
    if (inputT) inputT.value = mm;
    closeModal('modal-swg');
}

function renderInchFractionsTable() {
    const body = document.getElementById('inch-fractions-body');
    if (!body) return;

    body.innerHTML = INCH_FRACTIONS.map(item => `
        <tr>
            <td><strong>${item.fraction}</strong></td>
            <td>${item.decimal.toFixed(4)}</td>
            <td>${item.mm.toFixed(3)} mm</td>
        </tr>
    `).join('');
}

// UNIT CONVERTER ENGINE (IMG_9467)
function updateLinearConversion() {
    const select = document.getElementById('conv-linear-select')?.value || 'mm-cm';
    const val = parseFloat(document.getElementById('conv-input-val')?.value || 1);
    
    let factor = 1;
    let fromUnit = 'mm';
    let toUnit = 'cm';

    switch(select) {
        case 'mm-cm': factor = 0.1; fromUnit = 'mm'; toUnit = 'cm'; break;
        case 'mm-m': factor = 0.001; fromUnit = 'mm'; toUnit = 'm'; break;
        case 'mm-in': factor = 0.0393701; fromUnit = 'mm'; toUnit = 'in'; break;
        case 'cm-m': factor = 0.01; fromUnit = 'cm'; toUnit = 'm'; break;
        case 'in-mm': factor = 25.4; fromUnit = 'in'; toUnit = 'mm'; break;
        case 'ft-m': factor = 0.3048; fromUnit = 'ft'; toUnit = 'm'; break;
    }

    const res = val * factor;
    document.getElementById('conv-output-str').innerText = `${val} ${fromUnit} = ${res.toFixed(4)} ${toUnit}`;
    document.getElementById('conv-factor-str').innerText = `Conversion factor: ${factor}`;
}

function updateMassConversion() {
    const select = document.getElementById('conv-mass-select')?.value || 'kg-g';
    const val = parseFloat(document.getElementById('conv-input-val')?.value || 1);
    
    let factor = 1000;
    let fromUnit = 'kg';
    let toUnit = 'g';

    switch(select) {
        case 'kg-g': factor = 1000; fromUnit = 'kg'; toUnit = 'g'; break;
        case 'kg-lb': factor = 2.20462; fromUnit = 'kg'; toUnit = 'lb'; break;
        case 'kg-ton': factor = 0.001; fromUnit = 'kg'; toUnit = 'ton'; break;
        case 'lb-kg': factor = 0.453592; fromUnit = 'lb'; toUnit = 'kg'; break;
    }

    const res = val * factor;
    document.getElementById('conv-output-str').innerText = `${val} ${fromUnit} = ${res.toFixed(4)} ${toUnit}`;
    document.getElementById('conv-factor-str').innerText = `Conversion factor: ${factor}`;
}

// SCIENTIFIC EXPRESSION CALCULATOR ENGINE (IMG_9468)
function calcAppend(val) {
    const inp = document.getElementById('calc-expression-input');
    if (inp) inp.value += val;
}

function calcClear() {
    const inp = document.getElementById('calc-expression-input');
    if (inp) inp.value = '';
    document.getElementById('calc-result-display').innerText = 'Result: 0';
}

function calcEvaluate() {
    const inp = document.getElementById('calc-expression-input')?.value || '';
    try {
        let expr = inp
            .replace(/sin/g, 'Math.sin')
            .replace(/cos/g, 'Math.cos')
            .replace(/tan/g, 'Math.tan')
            .replace(/asin/g, 'Math.asin')
            .replace(/acos/g, 'Math.acos')
            .replace(/atan/g, 'Math.atan')
            .replace(/sqrt/g, 'Math.sqrt')
            .replace(/PI/g, 'Math.PI');

        const res = Function(`'use strict'; return (${expr})`)();
        document.getElementById('calc-result-display').innerText = `Result: ${res}`;
    } catch(e) {
        document.getElementById('calc-result-display').innerText = 'Error in expression';
    }
}

// TAKEOFF LIST STORE
function addCurrentToTakeoffList() {
    if (!weightCalcState.lastResult) return;
    weightCalcState.takeoffList.push(weightCalcState.lastResult);
    localStorage.setItem('weight_calc_takeoff', JSON.stringify(weightCalcState.takeoffList));
    renderTakeoffList();
    closeModal('modal-result');
    openModal('modal-takeoff');
}

function removeFromTakeoffList() {
    if (weightCalcState.takeoffList.length > 0) {
        weightCalcState.takeoffList.pop();
        localStorage.setItem('weight_calc_takeoff', JSON.stringify(weightCalcState.takeoffList));
        renderTakeoffList();
    }
    closeModal('modal-result');
}

function clearTakeoffList() {
    weightCalcState.takeoffList = [];
    localStorage.setItem('weight_calc_takeoff', JSON.stringify(weightCalcState.takeoffList));
    renderTakeoffList();
}

function renderTakeoffList() {
    const body = document.getElementById('takeoff-table-body');
    if (!body) return;

    let totMass = 0;
    let totCost = 0;

    body.innerHTML = weightCalcState.takeoffList.map((item, idx) => {
        totMass += item.totalMass;
        totCost += item.totalCost;
        return `
            <tr>
                <td>${idx + 1}</td>
                <td><strong>${item.component}</strong><br><small>${item.size}</small></td>
                <td>${item.qty}</td>
                <td>${item.totalMass.toFixed(2)} kg</td>
                <td>Rs. ${item.totalCost.toFixed(2)}</td>
                <td><button class="wb-danger-btn" onclick="deleteTakeoffItem(${idx})">✕</button></td>
            </tr>
        `;
    }).join('');

    document.getElementById('takeoff-total-mass').innerText = `${totMass.toFixed(2)} kg`;
    document.getElementById('takeoff-total-cost').innerText = `Rs. ${totCost.toFixed(2)}`;
}

function deleteTakeoffItem(index) {
    weightCalcState.takeoffList.splice(index, 1);
    localStorage.setItem('weight_calc_takeoff', JSON.stringify(weightCalcState.takeoffList));
    renderTakeoffList();
}
