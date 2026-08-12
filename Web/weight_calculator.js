/**
 * Engineering Weight Calculator - Project B Full Replica Implementation
 * Comprehensive Standards (IS 808, ANSI, BS 4, AS 3679, ISO 657), 2-Column Calculation Layout,
 * Categorized Section Pickers, Technical Canvas Renderer, Specific Gravity Selector,
 * Scientific Expression Calculator & Takeoff Store.
 */

const DENSITY_DATABASE = [
    { name: "Aluminium", sg: 2.70 },
    { name: "Brass", sg: 8.45 },
    { name: "Bronze", sg: 8.73 },
    { name: "Cast Iron", sg: 7.20 },
    { name: "Copper", sg: 8.96 },
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

// STANDARDS & CATEGORIZED PROFILES DATABASE (IMG_9440, IMG_9445, IMG_9448, IMG_9453, IMG_9459)
const CATEGORIZED_PROFILES = {
    channel: {
        'IS 808': [
            {
                category: "IS Junior Channels",
                items: [
                    { name: "ISJC 100", h: 100, b: 45, tw: 3.0, tf: 4.7, mass: 5.8 },
                    { name: "ISJC 125", h: 125, b: 50, tw: 3.0, tf: 5.0, mass: 7.9 },
                    { name: "ISJC 150", h: 150, b: 55, tw: 3.6, tf: 5.4, mass: 9.9 },
                    { name: "ISJC 175", h: 175, b: 60, tw: 3.6, tf: 5.7, mass: 11.4 },
                    { name: "ISJC 200", h: 200, b: 70, tw: 4.1, tf: 6.2, mass: 13.9 }
                ]
            },
            {
                category: "IS Light Channels",
                items: [
                    { name: "ISLC 75", h: 75, b: 40, tw: 3.7, tf: 6.0, mass: 5.7 },
                    { name: "ISLC 100", h: 100, b: 50, tw: 4.0, tf: 6.4, mass: 7.9 },
                    { name: "ISLC 125", h: 125, b: 65, tw: 4.4, tf: 6.6, mass: 10.7 },
                    { name: "ISLC 150", h: 150, b: 75, tw: 4.8, tf: 7.8, mass: 14.4 },
                    { name: "ISLC 200", h: 200, b: 90, tw: 5.3, tf: 8.6, mass: 20.6 }
                ]
            },
            {
                category: "IS Medium Channels",
                items: [
                    { name: "ISMC 75", h: 75, b: 40, tw: 4.4, tf: 7.3, mass: 7.1 },
                    { name: "ISMC 100", h: 100, b: 50, tw: 4.7, tf: 7.5, mass: 9.6 },
                    { name: "ISMC 125", h: 125, b: 65, tw: 5.3, tf: 8.1, mass: 13.1 },
                    { name: "ISMC 150", h: 150, b: 75, tw: 5.7, tf: 7.8, mass: 16.8 },
                    { name: "ISMC 200", h: 200, b: 75, tw: 6.2, tf: 11.4, mass: 22.3 },
                    { name: "ISMC 250", h: 250, b: 80, tw: 7.2, tf: 14.1, mass: 30.7 },
                    { name: "ISMC 300", h: 300, b: 90, tw: 7.8, tf: 13.6, mass: 36.3 }
                ]
            }
        ],
        'ANSI/AISC': [
            {
                category: "ANSI MC/C Channels",
                items: [
                    { name: "C 3x4.1", h: 76.2, b: 35.8, tw: 4.3, tf: 6.9, mass: 6.1 },
                    { name: "C 4x5.4", h: 101.6, b: 40.2, tw: 4.7, tf: 7.5, mass: 8.0 },
                    { name: "MC 6x12", h: 152.4, b: 63.4, tw: 8.0, tf: 9.8, mass: 17.9 },
                    { name: "C 8x11.5", h: 203.2, b: 57.4, tw: 5.6, tf: 9.9, mass: 17.1 },
                    { name: "C 12x25", h: 304.8, b: 77.4, tw: 9.8, tf: 12.7, mass: 37.2 }
                ]
            }
        ]
    },
    beam: {
        'IS 808': [
            {
                category: "IS Medium Beams",
                items: [
                    { name: "ISMB 100", h: 100, b: 50, tw: 4.7, tf: 7.0, mass: 8.9 },
                    { name: "ISMB 150", h: 150, b: 75, tw: 5.0, tf: 8.0, mass: 15.0 },
                    { name: "ISMB 200", h: 200, b: 100, tw: 5.7, tf: 10.8, mass: 25.4 },
                    { name: "ISMB 250", h: 250, b: 125, tw: 6.9, tf: 12.5, mass: 37.3 },
                    { name: "ISMB 300", h: 300, b: 140, tw: 7.5, tf: 13.1, mass: 44.2 },
                    { name: "ISMB 400", h: 400, b: 140, tw: 8.9, tf: 16.0, mass: 61.6 }
                ]
            },
            {
                category: "IS Wide Flange Beams",
                items: [
                    { name: "ISWB 150", h: 150, b: 100, tw: 5.4, tf: 7.0, mass: 17.0 },
                    { name: "ISWB 200", h: 200, b: 140, tw: 6.1, tf: 9.0, mass: 28.8 },
                    { name: "ISWB 250", h: 250, b: 200, tw: 6.7, tf: 9.0, mass: 40.9 },
                    { name: "ISWB 300", h: 300, b: 200, tw: 7.4, tf: 10.0, mass: 48.1 }
                ]
            },
            {
                category: "IS Column Sections H Beams",
                items: [
                    { name: "ISHB 150", h: 150, b: 150, tw: 5.4, tf: 8.4, mass: 27.1 },
                    { name: "ISHB 200", h: 200, b: 200, tw: 6.1, tf: 9.0, mass: 37.3 },
                    { name: "ISHB 250", h: 250, b: 250, tw: 6.7, tf: 9.0, mass: 51.0 },
                    { name: "ISHB 300", h: 300, b: 300, tw: 7.6, tf: 10.6, mass: 63.0 }
                ]
            }
        ]
    },
    angle: {
        'IS 808': [
            {
                category: "IS Equal Angles",
                items: [
                    { name: "25x25x3", a: 25, b: 25, t: 3, mass: 1.1 },
                    { name: "25x25x4", a: 25, b: 25, t: 4, mass: 1.4 },
                    { name: "30x30x3", a: 30, b: 30, t: 3, mass: 1.4 },
                    { name: "40x40x5", a: 40, b: 40, t: 5, mass: 3.0 },
                    { name: "50x50x6", a: 50, b: 50, t: 6, mass: 4.5 },
                    { name: "65x65x6", a: 65, b: 65, t: 6, mass: 5.8 },
                    { name: "75x75x8", a: 75, b: 75, t: 8, mass: 8.9 },
                    { name: "100x100x10", a: 100, b: 100, t: 10, mass: 14.9 }
                ]
            }
        ]
    },
    tee: {
        'IS 808': [
            {
                category: "IS Normal Tee Bars",
                items: [
                    { name: "ISNT 20", h: 20, b: 20, tw: 3.0, tf: 3.0, mass: 0.9 },
                    { name: "ISNT 30", h: 30, b: 30, tw: 4.0, tf: 4.0, mass: 1.8 },
                    { name: "ISNT 40", h: 40, b: 40, tw: 5.0, tf: 5.0, mass: 2.9 },
                    { name: "ISNT 50", h: 50, b: 50, tw: 6.0, tf: 6.0, mass: 4.5 },
                    { name: "ISNT 60", h: 60, b: 60, tw: 6.0, tf: 6.0, mass: 5.4 },
                    { name: "ISNT 75", h: 75, b: 75, tw: 8.0, tf: 8.0, mass: 8.9 },
                    { name: "ISNT 100", h: 100, b: 100, tw: 10.0, tf: 10.0, mass: 15.0 },
                    { name: "ISNT 150", h: 150, b: 150, tw: 12.0, tf: 12.0, mass: 27.2 }
                ]
            },
            {
                category: "IS Deep Legged Tee Bars",
                items: [
                    { name: "ISDT 100", h: 100, b: 50, tw: 5.0, tf: 7.0, mass: 7.5 },
                    { name: "ISDT 150", h: 150, b: 75, tw: 6.0, tf: 8.0, mass: 12.8 }
                ]
            },
            {
                category: "IS Slit Medium Weight Tee Bars",
                items: [
                    { name: "ISMT 50", h: 50, b: 100, tw: 4.7, tf: 7.0, mass: 4.5 },
                    { name: "ISMT 62.5", h: 62.5, b: 125, tw: 5.3, tf: 8.1, mass: 6.6 },
                    { name: "ISMT 75", h: 75, b: 150, tw: 5.7, tf: 7.8, mass: 8.4 },
                    { name: "ISMT 87.5", h: 87.5, b: 175, tw: 6.0, tf: 8.6, mass: 11.2 },
                    { name: "ISMT 100", h: 100, b: 200, tw: 6.2, tf: 11.4, mass: 14.2 }
                ]
            }
        ]
    }
};

let weightCalcState = {
    activeScreen: 'grid', // 'grid', 'standards', 'form'
    activeShape: 'square',
    activeStandardType: 'channel',
    activeFamily: 'IS 808',
    sg: 7.85,
    materialName: 'Steel C15',
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
        appShell.style.transform = 'translateX(-100vw)';
        tabB.classList.add('active');
        tabA.classList.remove('active');
    }
function openStandardsOrMoreCrossSections() {
    openStandardSelector('beam');
}

function openSurfaceAreaCalculator() {
    openShapeCalculator('plate');
    const title = document.getElementById('wb-app-title');
    if (title) title.innerText = 'Surface Area Calculation';
}

function openVolumeCalculator() {
    openShapeCalculator('box');
    const title = document.getElementById('wb-app-title');
    if (title) title.innerText = 'Volume Calculation';
}

function openStandardSelector(typeKey) {
    weightCalcState.activeStandardType = typeKey;
    weightCalcState.activeScreen = 'standards';
    
    document.getElementById('wb-grid-screen').style.display = 'none';
    document.getElementById('wb-form-screen').style.display = 'none';
    document.getElementById('wb-standards-screen').style.display = 'block';
    document.getElementById('wb-nav-back-btn').style.display = 'flex';

    const titleMap = {
        channel: 'Channel Sections Standard',
        beam: 'Beam Sections Standard',
        angle: 'Angle Sections Standard',
        tee: 'Tee Sections Standard'
    };

    document.getElementById('wb-standards-title').innerText = titleMap[typeKey] || 'Select Standard';
    selectStandardFamily(weightCalcState.activeFamily);
}

function selectStandardFamily(family) {
    weightCalcState.activeFamily = family;
    document.querySelectorAll('.wb-std-btn').forEach(btn => {
        btn.classList.toggle('active', btn.innerText.trim() === family);
    });

    const typeKey = weightCalcState.activeStandardType;
    const container = document.getElementById('wb-categorized-sections-list');
    if (!container) return;

    const categories = (CATEGORIZED_PROFILES[typeKey] && CATEGORIZED_PROFILES[typeKey][family]) || [];
    if (categories.length === 0) {
        container.innerHTML = '<div style="padding: 20px; color: #888; text-align: center;">Select a valid standard (e.g. IS 808 or ANSI)</div>';
        return;
    }

    container.innerHTML = categories.map(cat => `
        <div class="wb-category-block">
            <h4>${cat.category}</h4>
            <div class="wb-section-chips-grid">
                ${cat.items.map((item, idx) => `
                    <button class="wb-section-btn" onclick="applyCategorizedSection('${typeKey}', '${family}', '${cat.category}', ${idx})">
                        ${item.name}
                    </button>
                `).join('')}
            </div>
        </div>
    `).join('');
}

function applyCategorizedSection(typeKey, family, categoryName, index) {
    const categories = CATEGORIZED_PROFILES[typeKey][family];
    const catBlock = categories.find(c => c.category === categoryName);
    if (!catBlock) return;

    const item = catBlock.items[index];
    if (!item) return;

    openShapeCalculator(typeKey);

    setTimeout(() => {
        if (item.h && document.getElementById('inp_h')) document.getElementById('inp_h').value = item.h;
        if (item.b && document.getElementById('inp_w')) document.getElementById('inp_w').value = item.b;
        if (item.a && document.getElementById('inp_a')) document.getElementById('inp_a').value = item.a;
        if (item.b && document.getElementById('inp_b')) document.getElementById('inp_b').value = item.b;
        if (item.tw && document.getElementById('inp_tw')) document.getElementById('inp_tw').value = item.tw;
        if (item.tf && document.getElementById('inp_tf')) document.getElementById('inp_tf').value = item.tf;
        if (item.t && document.getElementById('inp_t')) document.getElementById('inp_t').value = item.t;
        
        document.getElementById('wb-app-title').innerText = `${item.name} Calculations`;
        calculateCurrentMass();
        drawShapeCanvas(typeKey);
    }, 50);
}

function openShapeCalculator(shapeKey) {
    weightCalcState.activeShape = shapeKey;
    weightCalcState.activeScreen = 'form';

    document.getElementById('wb-grid-screen').style.display = 'none';
    document.getElementById('wb-standards-screen').style.display = 'none';
    document.getElementById('wb-form-screen').style.display = 'block';
    document.getElementById('wb-nav-back-btn').style.display = 'flex';

    const dropdown = document.getElementById('wb-shape-selector-dropdown');
    if (dropdown) dropdown.value = shapeKey;

    const formInputsContainer = document.getElementById('wb-form-inputs');
    formInputsContainer.innerHTML = '';

    let html = '';
    const commonTail = `
        <div class="wb-input-group">
            <label>Specific Gravity</label>
            <input type="number" id="inp_sg" value="${weightCalcState.sg}" step="0.01" oninput="calculateCurrentMass()">
        </div>
        <div class="wb-input-group highlighted-calc-field">
            <label>Calculated Weight (kg)</label>
            <input type="text" id="inp_calc_weight" value="0.000 kg" readonly style="color: #00E5FF; font-weight: 700; background: #151a24; border: 1px solid #00bcd4;">
        </div>
        <div class="wb-input-group">
            <label>Quantity</label>
            <input type="number" id="inp_qty" value="1" oninput="calculateCurrentMass()">
        </div>
        <div class="wb-input-group">
            <label>Price Rs./kg</label>
            <input type="number" id="inp_price" value="${weightCalcState.unitPrice}" step="0.01" oninput="calculateCurrentMass()">
        </div>
        <div class="wb-input-group highlighted-calc-field">
            <label>Calculated Price (Rs.)</label>
            <input type="text" id="inp_calc_price" value="Rs. 0.00" readonly style="color: #FFD700; font-weight: 700; background: #151a24; border: 1px solid #ffd700;">
        </div>
    `;

    switch(shapeKey) {
        case 'square':
            html = `
                <div class="wb-input-group">
                    <label>Side (mm)</label>
                    <input type="number" id="inp_s" value="100" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                ${commonTail}
            `;
            break;

        case 'plate':
        case 'flat':
            html = `
                <div class="wb-input-group">
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Width (mm)</label>
                    <input type="number" id="inp_w" value="100" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Thickness T (mm)</label>
                    <input type="number" id="inp_t" value="10" oninput="calculateCurrentMass()">
                </div>
                ${commonTail}
            `;
            break;

        case 'pipe':
            html = `
                <div class="wb-input-group">
                    <label>Outer Diameter (OD) (mm)</label>
                    <input type="number" id="inp_od" value="114.3" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Wall Thickness t (mm)</label>
                    <input type="number" id="inp_t" value="4.5" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="6000" oninput="calculateCurrentMass()">
                </div>
                ${commonTail}
            `;
            break;

        case 'rod':
            html = `
                <div class="wb-input-group">
                    <label>Diameter D (mm)</label>
                    <input type="number" id="inp_d" value="25" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                ${commonTail}
            `;
            break;

        case 'beam':
            html = `
                <div class="wb-input-group">
                    <label>Section Height H (mm)</label>
                    <input type="number" id="inp_h" value="200" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Flange Width B (mm)</label>
                    <input type="number" id="inp_w" value="100" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Web Thickness tw (mm)</label>
                    <input type="number" id="inp_tw" value="5.7" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Flange Thickness tf (mm)</label>
                    <input type="number" id="inp_tf" value="10.8" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                ${commonTail}
            `;
            break;

        case 'channel':
            html = `
                <div class="wb-input-group">
                    <label>Section Height H (mm)</label>
                    <input type="number" id="inp_h" value="150" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Flange Width B (mm)</label>
                    <input type="number" id="inp_w" value="75" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Web Thickness tw (mm)</label>
                    <input type="number" id="inp_tw" value="5.7" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Flange Thickness tf (mm)</label>
                    <input type="number" id="inp_tf" value="7.8" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                ${commonTail}
            `;
            break;

        default:
            html = `
                <div class="wb-input-group">
                    <label>Side A (mm)</label>
                    <input type="number" id="inp_a" value="50" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Side B (mm)</label>
                    <input type="number" id="inp_b" value="50" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Thickness t (mm)</label>
                    <input type="number" id="inp_t" value="6" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                ${commonTail}
            `;
            break;
    }

    formInputsContainer.innerHTML = html;
    drawShapeCanvas(shapeKey);
    calculateCurrentMass();
}
}

function onShapeDropdownChange(shapeKey) {
    openShapeCalculator(shapeKey);
}

function wbGoBack() {
    if (weightCalcState.activeScreen === 'form') {
        if (['channel', 'beam', 'angle', 'tee'].includes(weightCalcState.activeShape)) {
            openStandardSelector(weightCalcState.activeShape);
        } else {
            returnToGridScreen();
        }
    } else if (weightCalcState.activeScreen === 'standards') {
        returnToGridScreen();
    }
}

function returnToGridScreen() {
    weightCalcState.activeScreen = 'grid';
    document.getElementById('wb-form-screen').style.display = 'none';
    document.getElementById('wb-standards-screen').style.display = 'none';
    document.getElementById('wb-grid-screen').style.display = 'grid';
    document.getElementById('wb-nav-back-btn').style.display = 'none';
    document.getElementById('wb-app-title').innerText = 'Engineering Weight Calculator';
}

// TECHNICAL CANVAS RENDERER WITH DIMENSION ARROWS (IMG_9450, IMG_9460)
function drawShapeCanvas(shapeKey) {
    const canvas = document.getElementById('shapeCanvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const w = canvas.width;
    const h = canvas.height;

    ctx.clearRect(0, 0, w, h);
    ctx.fillStyle = '#00E5FF';
    ctx.strokeStyle = '#ffffff';
    ctx.lineWidth = 1.5;

    const cx = w / 2;
    const cy = h / 2;

    ctx.beginPath();
    switch(shapeKey) {
        case 'square':
        case 'plate':
        case 'flat':
            ctx.rect(cx - 35, cy - 30, 70, 60);
            ctx.fill(); ctx.stroke();
            drawDimensionArrow(ctx, cx - 35, cy + 40, cx + 35, cy + 40, "W");
            drawDimensionArrow(ctx, cx - 45, cy - 30, cx - 45, cy + 30, "H");
            break;

        case 'pipe':
            ctx.arc(cx, cy, 35, 0, Math.PI * 2);
            ctx.fill(); ctx.stroke();
            ctx.beginPath();
            ctx.fillStyle = '#181a20';
            ctx.arc(cx, cy, 22, 0, Math.PI * 2);
            ctx.fill(); ctx.stroke();
            drawDimensionArrow(ctx, cx - 35, cy - 42, cx + 35, cy - 42, "OD");
            break;

        case 'rod':
            ctx.arc(cx, cy, 35, 0, Math.PI * 2);
            ctx.fill(); ctx.stroke();
            drawDimensionArrow(ctx, cx - 35, cy - 42, cx + 35, cy - 42, "D");
            break;

        case 'beam':
            ctx.fillRect(cx - 30, cy - 40, 60, 10);
            ctx.fillRect(cx - 5, cy - 40, 10, 80);
            ctx.fillRect(cx - 30, cy + 30, 60, 10);
            ctx.strokeRect(cx - 30, cy - 40, 60, 10);
            ctx.strokeRect(cx - 5, cy - 40, 10, 80);
            ctx.strokeRect(cx - 30, cy + 30, 60, 10);
            drawDimensionArrow(ctx, cx - 42, cy - 40, cx - 42, cy + 40, "H");
            drawDimensionArrow(ctx, cx - 30, cy + 48, cx + 30, cy + 48, "B");
            break;

        case 'channel':
            ctx.fillRect(cx - 25, cy - 40, 10, 80);
            ctx.fillRect(cx - 25, cy - 40, 50, 10);
            ctx.fillRect(cx - 25, cy + 30, 50, 10);
            ctx.strokeRect(cx - 25, cy - 40, 10, 80);
            ctx.strokeRect(cx - 25, cy - 40, 50, 10);
            ctx.strokeRect(cx - 25, cy + 30, 50, 10);
            drawDimensionArrow(ctx, cx - 36, cy - 40, cx - 36, cy + 40, "H");
            drawDimensionArrow(ctx, cx - 25, cy + 48, cx + 25, cy + 48, "B");
            break;

        default:
            ctx.rect(cx - 30, cy - 30, 60, 60);
            ctx.fill(); ctx.stroke();
            break;
    }
}

function drawDimensionArrow(ctx, x1, y1, x2, y2, label) {
    ctx.save();
    ctx.strokeStyle = '#FFD700';
    ctx.fillStyle = '#FFD700';
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();

    ctx.font = '9px sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText(label, (x1 + x2) / 2, (y1 + y2) / 2 - 2);
    ctx.restore();
}

// MATHEMATICAL CALCULATION ENGINE
function calculateCurrentMass() {
    return calculateMassEngine();
}

function calculateMassEngine() {
    const shape = weightCalcState.activeShape;
    const sg = parseFloat(document.getElementById('inp_sg')?.value || weightCalcState.sg);
    const qty = parseFloat(document.getElementById('inp_qty')?.value || 1);
    const price = parseFloat(document.getElementById('inp_price')?.value || weightCalcState.unitPrice);

    let area_mm2 = 0;
    let length_mm = parseFloat(document.getElementById('inp_l')?.value || 1000);

    switch(shape) {
        case 'square':
            const s = parseFloat(document.getElementById('inp_s')?.value || 100);
            area_mm2 = s * s;
            break;

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

        default:
            area_mm2 = 1000;
            break;
    }

    const volume_cm3 = (area_mm2 / 100) * (length_mm / 10);
    const unit_mass_kg = (volume_cm3 * sg) / 1000;
    const total_mass_kg = unit_mass_kg * qty;
    const total_cost = total_mass_kg * price;

    const calcW = document.getElementById('inp_calc_weight');
    if (calcW) {
        calcW.value = `${total_mass_kg.toFixed(3)} kg`;
    }
    const calcP = document.getElementById('inp_calc_price');
    if (calcP) {
        calcP.value = `Rs. ${total_cost.toFixed(2)}`;
    }

    return {
        component: document.getElementById('wb-app-title')?.innerText || 'Section',
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
            <strong class="wb-badge">${item.sg.toFixed(2)}</strong>
        </div>
    `).join('');
}

function selectSpecificGravity(sg, name) {
    weightCalcState.sg = sg;
    weightCalcState.materialName = name;
    const inpSg = document.getElementById('inp_sg');
    if (inpSg) inpSg.value = sg;
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
    
    let factor = 0.1;
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
