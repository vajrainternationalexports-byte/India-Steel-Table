/**
 * Engineering Weight Calculator - Project B Implementation
 * Standard Material Densities, SWG Gauges, Engineering Formulas, Canvas Renderer & Takeoff Store
 */

const DENSITY_DATABASE = [
    { name: "Steel", sg: 7.85 },
    { name: "Stainless Steel (304/316)", sg: 7.93 },
    { name: "Aluminium", sg: 2.70 },
    { name: "Brass", sg: 8.45 },
    { name: "Bronze", sg: 8.73 },
    { name: "Cast Iron", sg: 7.20 },
    { name: "Copper", sg: 8.96 },
    { name: "Steel C15", sg: 7.85 },
    { name: "Steel C35", sg: 7.84 },
    { name: "Steel C60", sg: 7.83 },
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
    { gauge: "26G", mm: 0.457 },
    { gauge: "27G", mm: 0.417 },
    { gauge: "28G", mm: 0.376 }
];

const INCH_FRACTIONS = [
    { fraction: "1/64", decimal: 0.0156, mm: 0.397 },
    { fraction: "1/32", decimal: 0.0313, mm: 0.794 },
    { fraction: "3/64", decimal: 0.0469, mm: 1.191 },
    { fraction: "1/16", decimal: 0.0625, mm: 1.588 },
    { fraction: "5/64", decimal: 0.0781, mm: 1.984 },
    { fraction: "3/32", decimal: 0.0938, mm: 2.381 },
    { fraction: "7/64", decimal: 0.1094, mm: 2.778 },
    { fraction: "1/8", decimal: 0.1250, mm: 3.175 },
    { fraction: "9/64", decimal: 0.1406, mm: 3.572 },
    { fraction: "5/32", decimal: 0.1563, mm: 3.969 },
    { fraction: "11/64", decimal: 0.1719, mm: 4.366 },
    { fraction: "3/16", decimal: 0.1875, mm: 4.763 },
    { fraction: "13/64", decimal: 0.2031, mm: 5.159 },
    { fraction: "7/32", decimal: 0.2188, mm: 5.556 },
    { fraction: "15/64", decimal: 0.2344, mm: 5.953 },
    { fraction: "1/4", decimal: 0.2500, mm: 6.350 },
    { fraction: "17/64", decimal: 0.2656, mm: 6.747 },
    { fraction: "9/32", decimal: 0.2813, mm: 7.144 },
    { fraction: "19/64", decimal: 0.2969, mm: 7.541 },
    { fraction: "5/16", decimal: 0.3125, mm: 7.938 },
    { fraction: "21/64", decimal: 0.3281, mm: 8.334 },
    { fraction: "11/32", decimal: 0.3438, mm: 8.731 },
    { fraction: "23/64", decimal: 0.3594, mm: 9.128 },
    { fraction: "3/8", decimal: 0.3750, mm: 9.525 },
    { fraction: "25/64", decimal: 0.3906, mm: 9.922 },
    { fraction: "13/32", decimal: 0.4063, mm: 10.319 },
    { fraction: "27/64", decimal: 0.4219, mm: 10.716 },
    { fraction: "7/16", decimal: 0.4375, mm: 11.113 },
    { fraction: "29/64", decimal: 0.4531, mm: 11.509 },
    { fraction: "15/32", decimal: 0.4688, mm: 11.906 },
    { fraction: "31/64", decimal: 0.4844, mm: 12.303 },
    { fraction: "1/2", decimal: 0.5000, mm: 12.700 },
    { fraction: "33/64", decimal: 0.5156, mm: 13.097 },
    { fraction: "17/32", decimal: 0.5313, mm: 13.494 },
    { fraction: "35/64", decimal: 0.5469, mm: 13.891 },
    { fraction: "9/16", decimal: 0.5625, mm: 14.288 },
    { fraction: "37/64", decimal: 0.5781, mm: 14.684 },
    { fraction: "19/32", decimal: 0.5938, mm: 15.081 },
    { fraction: "39/64", decimal: 0.6094, mm: 15.478 },
    { fraction: "5/8", decimal: 0.6250, mm: 15.875 },
    { fraction: "41/64", decimal: 0.6406, mm: 16.272 },
    { fraction: "21/32", decimal: 0.6563, mm: 16.669 },
    { fraction: "43/64", decimal: 0.6719, mm: 17.066 },
    { fraction: "11/16", decimal: 0.6875, mm: 17.463 },
    { fraction: "45/64", decimal: 0.7031, mm: 17.859 },
    { fraction: "23/32", decimal: 0.7188, mm: 18.256 },
    { fraction: "47/64", decimal: 0.7344, mm: 18.653 },
    { fraction: "3/4", decimal: 0.7500, mm: 19.050 },
    { fraction: "49/64", decimal: 0.7656, mm: 19.447 },
    { fraction: "25/32", decimal: 0.7813, mm: 19.844 },
    { fraction: "51/64", decimal: 0.7969, mm: 20.241 },
    { fraction: "13/16", decimal: 0.8125, mm: 20.638 },
    { fraction: "53/64", decimal: 0.8281, mm: 21.034 },
    { fraction: "27/32", decimal: 0.8438, mm: 21.431 },
    { fraction: "55/64", decimal: 0.8594, mm: 21.828 },
    { fraction: "7/8", decimal: 0.8750, mm: 22.225 },
    { fraction: "57/64", decimal: 0.8906, mm: 22.622 },
    { fraction: "29/32", decimal: 0.9063, mm: 23.019 },
    { fraction: "59/64", decimal: 0.9219, mm: 23.416 },
    { fraction: "15/16", decimal: 0.9375, mm: 23.813 },
    { fraction: "61/64", decimal: 0.9531, mm: 24.209 },
    { fraction: "31/32", decimal: 0.9688, mm: 24.606 },
    { fraction: "63/64", decimal: 0.9844, mm: 25.003 },
    { fraction: "1\"", decimal: 1.0000, mm: 25.400 }
];

// State & Takeoff List Store
let weightCalcState = {
    activeShape: 'box',
    sg: 7.85,
    materialName: 'Steel',
    isChequered: false,
    unitPrice: 1.00,
    takeoffList: JSON.parse(localStorage.getItem('weight_calc_takeoff') || '[]'),
    lastResult: null
};

// Main Initialization
document.addEventListener('DOMContentLoaded', () => {
    initWeightCalculatorEvents();
    renderTakeoffList();
    renderInchFractionsTable();
});

function initWeightCalculatorEvents() {
    const appShell = document.getElementById('app-swipe-shell');
    const tabA = document.getElementById('tab-project-a');
    const tabB = document.getElementById('tab-project-b');
    
    if (tabA && tabB && appShell) {
        tabA.addEventListener('click', () => switchProjectTab('A'));
        tabB.addEventListener('click', () => switchProjectTab('B'));

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

// Shape Selection Handler
function openShapeCalculator(shapeKey) {
    weightCalcState.activeShape = shapeKey;
    document.getElementById('wb-grid-screen').style.display = 'none';
    document.getElementById('wb-form-screen').style.display = 'block';

    const formTitle = document.getElementById('wb-form-title');
    const formInputsContainer = document.getElementById('wb-form-inputs');

    formInputsContainer.innerHTML = '';
    
    let html = '';
    switch(shapeKey) {
        case 'box':
            formTitle.innerText = 'Rectangular Tube / Box Section';
            html = `
                <div class="wb-input-group">
                    <label>Section Height (mm)</label>
                    <input type="number" id="inp_h" value="100" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Section Width (mm)</label>
                    <input type="number" id="inp_w" value="80" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Section Thickness (mm)</label>
                    <input type="number" id="inp_t" value="5" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
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
                    <label>Wall Thickness (mm)</label>
                    <input type="number" id="inp_t" value="4.5" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="6000" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'channel':
            formTitle.innerText = 'Channel Section (ISMC/PFC)';
            html = `
                <div class="wb-input-group">
                    <label>Section Height (H) (mm)</label>
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
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'angle':
            formTitle.innerText = 'Angle Section (ISA)';
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
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'flat':
            formTitle.innerText = 'Flat Bar / Plate';
            html = `
                <div class="wb-input-group">
                    <label>Width (mm)</label>
                    <input type="number" id="inp_w" value="100" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Thickness (mm)</label>
                    <input type="number" id="inp_t" value="10" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-checkbox-group">
                    <label>
                        <input type="checkbox" id="chk_chequered" onchange="toggleChequeredPlate(this.checked)">
                        Chequered Plate (+5% pattern weight)
                    </label>
                </div>
            `;
            break;

        case 'rod':
            formTitle.innerText = 'Round Bar / Solid Rod';
            html = `
                <div class="wb-input-group">
                    <label>Diameter (mm)</label>
                    <input type="number" id="inp_d" value="25" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'beam':
            formTitle.innerText = 'Beam / I-Section (ISMB)';
            html = `
                <div class="wb-input-group">
                    <label>Section Height (H) (mm)</label>
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
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
            `;
            break;

        case 'zsection':
            formTitle.innerText = 'Z-Section';
            html = `
                <div class="wb-input-group">
                    <label>Height (H) (mm)</label>
                    <input type="number" id="inp_h" value="150" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Flange (B) (mm)</label>
                    <input type="number" id="inp_w" value="60" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Lip (C) (mm)</label>
                    <input type="number" id="inp_c" value="20" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Thickness (t) (mm)</label>
                    <input type="number" id="inp_t" value="3" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="1000" oninput="calculateCurrentMass()">
                </div>
            `;
            break;
    }

    html += `
        <div class="wb-input-group">
            <label>Specific Gravity</label>
            <div class="wb-input-with-btn">
                <input type="number" id="inp_sg" value="${weightCalcState.sg}" step="0.01" oninput="weightCalcState.sg = parseFloat(this.value)||7.85; calculateCurrentMass()">
                <button class="wb-inline-btn" onclick="openModal('modal-sg')">Select</button>
            </div>
            <div class="wb-selected-tag" id="tag-sg-name">${weightCalcState.materialName} => ${weightCalcState.sg}</div>
        </div>
        <div class="wb-input-group">
            <label>Quantity</label>
            <input type="number" id="inp_qty" value="1" min="1" oninput="calculateCurrentMass()">
        </div>
        <div class="wb-input-group">
            <label>Price Rs./kg</label>
            <input type="number" id="inp_price" value="${weightCalcState.unitPrice}" step="0.5" oninput="weightCalcState.unitPrice = parseFloat(this.value)||1.00; calculateCurrentMass()">
        </div>
    `;

    formInputsContainer.innerHTML = html;
    drawShapeCanvas();
}

function returnToGridScreen() {
    document.getElementById('wb-form-screen').style.display = 'none';
    document.getElementById('wb-grid-screen').style.display = 'grid';
}

function toggleChequeredPlate(isChequered) {
    weightCalcState.isChequered = isChequered;
    calculateCurrentMass();
}

// Engineering Mass Calculation Logic
function calculateCurrentMass() {
    const shape = weightCalcState.activeShape;
    const sg = parseFloat(document.getElementById('inp_sg')?.value) || weightCalcState.sg || 7.85;
    const qty = parseInt(document.getElementById('inp_qty')?.value) || 1;
    const price = parseFloat(document.getElementById('inp_price')?.value) || 1.00;

    let crossAreaMm2 = 0;
    let lengthMm = 1000;
    let sizeLabel = '';

    if (shape === 'box') {
        const h = parseFloat(document.getElementById('inp_h')?.value) || 0;
        const w = parseFloat(document.getElementById('inp_w')?.value) || 0;
        const t = parseFloat(document.getElementById('inp_t')?.value) || 0;
        lengthMm = parseFloat(document.getElementById('inp_l')?.value) || 0;

        crossAreaMm2 = (h * w) - Math.max(0, (h - 2 * t) * (w - 2 * t));
        sizeLabel = `RHS ${h}x${w}x${t}x${lengthMm}L`;
    } else if (shape === 'pipe') {
        const od = parseFloat(document.getElementById('inp_od')?.value) || 0;
        const t = parseFloat(document.getElementById('inp_t')?.value) || 0;
        lengthMm = parseFloat(document.getElementById('inp_l')?.value) || 0;

        const id = Math.max(0, od - 2 * t);
        crossAreaMm2 = (Math.PI / 4.0) * (od * od - id * id);
        sizeLabel = `PIPE OD${od}x${t}x${lengthMm}L`;
    } else if (shape === 'channel') {
        const h = parseFloat(document.getElementById('inp_h')?.value) || 0;
        const w = parseFloat(document.getElementById('inp_w')?.value) || 0;
        const tw = parseFloat(document.getElementById('inp_tw')?.value) || 0;
        const tf = parseFloat(document.getElementById('inp_tf')?.value) || 0;
        lengthMm = parseFloat(document.getElementById('inp_l')?.value) || 0;

        crossAreaMm2 = (2 * w * tf) + ((h - 2 * tf) * tw);
        sizeLabel = `CHANNEL ${h}x${w}x${tw}x${tf}x${lengthMm}L`;
    } else if (shape === 'angle') {
        const a = parseFloat(document.getElementById('inp_a')?.value) || 0;
        const b = parseFloat(document.getElementById('inp_b')?.value) || 0;
        const t = parseFloat(document.getElementById('inp_t')?.value) || 0;
        lengthMm = parseFloat(document.getElementById('inp_l')?.value) || 0;

        crossAreaMm2 = (a + b - t) * t;
        sizeLabel = `ANGLE ${a}x${b}x${t}x${lengthMm}L`;
    } else if (shape === 'flat') {
        const w = parseFloat(document.getElementById('inp_w')?.value) || 0;
        const t = parseFloat(document.getElementById('inp_t')?.value) || 0;
        lengthMm = parseFloat(document.getElementById('inp_l')?.value) || 0;

        crossAreaMm2 = w * t;
        if (weightCalcState.isChequered) crossAreaMm2 *= 1.05;
        sizeLabel = `FLAT ${w}x${t}x${lengthMm}L`;
    } else if (shape === 'rod') {
        const d = parseFloat(document.getElementById('inp_d')?.value) || 0;
        lengthMm = parseFloat(document.getElementById('inp_l')?.value) || 0;

        crossAreaMm2 = (Math.PI / 4.0) * d * d;
        sizeLabel = `ROD D${d}x${lengthMm}L`;
    } else if (shape === 'beam') {
        const h = parseFloat(document.getElementById('inp_h')?.value) || 0;
        const w = parseFloat(document.getElementById('inp_w')?.value) || 0;
        const tw = parseFloat(document.getElementById('inp_tw')?.value) || 0;
        const tf = parseFloat(document.getElementById('inp_tf')?.value) || 0;
        lengthMm = parseFloat(document.getElementById('inp_l')?.value) || 0;

        crossAreaMm2 = (2 * w * tf) + ((h - 2 * tf) * tw);
        sizeLabel = `BEAM ${h}x${w}x${tw}x${tf}x${lengthMm}L`;
    } else if (shape === 'zsection') {
        const h = parseFloat(document.getElementById('inp_h')?.value) || 0;
        const w = parseFloat(document.getElementById('inp_w')?.value) || 0;
        const c = parseFloat(document.getElementById('inp_c')?.value) || 0;
        const t = parseFloat(document.getElementById('inp_t')?.value) || 0;
        lengthMm = parseFloat(document.getElementById('inp_l')?.value) || 0;

        crossAreaMm2 = (h + 2 * w + 2 * c - 4 * t) * t;
        sizeLabel = `Z ${h}x${w}x${c}x${t}x${lengthMm}L`;
    }

    const unitMassKg = crossAreaMm2 * lengthMm * sg * 1e-6;
    const totalMassKg = unitMassKg * qty;
    const totalCost = totalMassKg * price;

    weightCalcState.lastResult = {
        component: getShapeName(shape),
        size: sizeLabel,
        quantity: qty,
        unitMass: unitMassKg,
        totalMass: totalMassKg,
        pricePerKg: price,
        totalCost: totalCost
    };

    drawShapeCanvas();
    return weightCalcState.lastResult;
}

function getShapeName(shape) {
    const names = {
        box: 'Rectangular Hollow Section',
        pipe: 'Round Pipe / Tube',
        channel: 'Channel Section',
        angle: 'Angle Section',
        flat: weightCalcState.isChequered ? 'Chequered Plate' : 'Flat Plate',
        rod: 'Round Solid Rod',
        beam: 'Beam / I-Section',
        zsection: 'Z-Section'
    };
    return names[shape] || 'Steel Component';
}

function calculateAndShowResultModal() {
    const res = calculateCurrentMass();
    if (!res) return;

    document.getElementById('res-component').innerText = res.component;
    document.getElementById('res-size').innerText = res.size;
    document.getElementById('res-qty').innerText = res.quantity;
    document.getElementById('res-unit-mass').innerText = `${res.unitMass.toFixed(4)} kg`;
    document.getElementById('res-total-mass').innerText = `${res.totalMass.toFixed(4)} kg`;
    document.getElementById('res-cost-kg').innerText = `${res.pricePerKg.toFixed(2)}`;
    document.getElementById('res-total-cost').innerText = `Rs. ${res.totalCost.toFixed(2)}`;

    openModal('modal-result');
}

function addCurrentToTakeoffList() {
    if (!weightCalcState.lastResult) return;
    weightCalcState.takeoffList.push({
        id: Date.now(),
        ...weightCalcState.lastResult
    });
    localStorage.setItem('weight_calc_takeoff', JSON.stringify(weightCalcState.takeoffList));
    renderTakeoffList();
    closeModal('modal-result');
}

function renderTakeoffList() {
    const listBody = document.getElementById('takeoff-table-body');
    const totalMassEl = document.getElementById('takeoff-total-mass');
    const totalCostEl = document.getElementById('takeoff-total-cost');
    if (!listBody) return;

    if (weightCalcState.takeoffList.length === 0) {
        listBody.innerHTML = `<tr><td colspan="6" style="text-align:center; padding: 20px; color: #888;">No items in takeoff list</td></tr>`;
        if (totalMassEl) totalMassEl.innerText = '0.0000 kg';
        if (totalCostEl) totalCostEl.innerText = 'Rs. 0.00';
        return;
    }

    let sumMass = 0;
    let sumCost = 0;

    let html = '';
    weightCalcState.takeoffList.forEach((item, idx) => {
        sumMass += item.totalMass;
        sumCost += item.totalCost;

        html += `
            <tr>
                <td>${idx + 1}</td>
                <td><strong>${item.component}</strong><br><small>${item.size}</small></td>
                <td>${item.quantity}</td>
                <td style="color:#00E5FF; font-weight:bold;">${item.totalMass.toFixed(3)} kg</td>
                <td style="color:#FFD700; font-weight:bold;">Rs. ${item.totalCost.toFixed(2)}</td>
                <td><button class="wb-danger-btn" onclick="removeTakeoffItem(${item.id})">✕</button></td>
            </tr>
        `;
    });

    listBody.innerHTML = html;
    if (totalMassEl) totalMassEl.innerText = `${sumMass.toFixed(4)} kg`;
    if (totalCostEl) totalCostEl.innerText = `Rs. ${sumCost.toFixed(2)}`;
}

function removeTakeoffItem(id) {
    weightCalcState.takeoffList = weightCalcState.takeoffList.filter(item => item.id !== id);
    localStorage.setItem('weight_calc_takeoff', JSON.stringify(weightCalcState.takeoffList));
    renderTakeoffList();
}

function clearTakeoffList() {
    if (confirm('Clear all takeoff items?')) {
        weightCalcState.takeoffList = [];
        localStorage.removeItem('weight_calc_takeoff');
        renderTakeoffList();
    }
}

function renderSGModalList() {
    const container = document.getElementById('sg-modal-list');
    if (!container) return;

    let html = '';
    DENSITY_DATABASE.forEach((mat) => {
        html += `
            <div class="wb-modal-item" onclick="selectSpecificGravity('${mat.name}', ${mat.sg})">
                <span>${mat.name}</span>
                <span class="wb-badge">SG => ${mat.sg}</span>
            </div>
        `;
    });
    container.innerHTML = html;
}

function selectSpecificGravity(name, sg) {
    weightCalcState.materialName = name;
    weightCalcState.sg = sg;
    const inpSg = document.getElementById('inp_sg');
    const tagSg = document.getElementById('tag-sg-name');
    if (inpSg) inpSg.value = sg;
    if (tagSg) tagSg.innerText = `${name} => ${sg}`;
    closeModal('modal-sg');
    calculateCurrentMass();
}

function renderSWGModalList() {
    const container = document.getElementById('swg-modal-list');
    if (!container) return;

    let html = '';
    SWG_GAUGE_TABLE.forEach((item) => {
        html += `
            <div class="wb-modal-item" onclick="selectSWGGauge(${item.mm})">
                <span>British Gauge ${item.gauge}</span>
                <span class="wb-badge">${item.mm} mm</span>
            </div>
        `;
    });
    container.innerHTML = html;
}

function selectSWGGauge(mmVal) {
    const inpT = document.getElementById('inp_t');
    if (inpT) inpT.value = mmVal;
    closeModal('modal-swg');
    calculateCurrentMass();
}

function renderInchFractionsTable() {
    const body = document.getElementById('inch-fractions-body');
    if (!body) return;

    let html = '';
    INCH_FRACTIONS.forEach((row) => {
        html += `
            <tr>
                <td><strong>${row.fraction}</strong></td>
                <td>${row.decimal.toFixed(4)}</td>
                <td style="color:#00E5FF;">${row.mm.toFixed(3)} mm</td>
            </tr>
        `;
    });
    body.innerHTML = html;
}

function openModal(modalId) {
    if (modalId === 'modal-sg') renderSGModalList();
    if (modalId === 'modal-swg') renderSWGModalList();
    document.getElementById(modalId).style.display = 'flex';
}

function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
}

function drawShapeCanvas() {
    const canvas = document.getElementById('shapeCanvas');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    const width = canvas.width;
    const height = canvas.height;

    ctx.clearRect(0, 0, width, height);

    ctx.strokeStyle = '#00E5FF';
    ctx.fillStyle = 'rgba(0, 229, 255, 0.15)';
    ctx.lineWidth = 2;

    const shape = weightCalcState.activeShape;
    const centerX = width / 2;
    const centerY = height / 2;

    ctx.beginPath();

    if (shape === 'box' || shape === 'flat') {
        const rectW = width * 0.5;
        const rectH = height * 0.4;
        const x = centerX - rectW / 2;
        const y = centerY - rectH / 2;

        ctx.rect(x, y, rectW, rectH);
        ctx.fill();
        ctx.stroke();

        if (shape === 'box') {
            const innerW = rectW * 0.7;
            const innerH = rectH * 0.7;
            ctx.rect(centerX - innerW / 2, centerY - innerH / 2, innerW, innerH);
            ctx.stroke();
        }

        drawCalloutArrow(ctx, x, y - 10, x + rectW, y - 10, 'Width');
        drawCalloutArrow(ctx, x - 10, y, x - 10, y + rectH, 'Height');
    } else if (shape === 'pipe' || shape === 'rod') {
        const radius = Math.min(width, height) * 0.25;
        ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
        ctx.fill();
        ctx.stroke();

        if (shape === 'pipe') {
            ctx.beginPath();
            ctx.arc(centerX, centerY, radius * 0.65, 0, 2 * Math.PI);
            ctx.stroke();
        }

        drawCalloutArrow(ctx, centerX - radius, centerY - radius - 10, centerX + radius, centerY - radius - 10, 'OD');
    } else if (shape === 'channel') {
        const w = width * 0.35;
        const h = height * 0.5;
        const x = centerX - w / 2;
        const y = centerY - h / 2;
        const t = 12;

        ctx.moveTo(x + w, y);
        ctx.lineTo(x, y);
        ctx.lineTo(x, y + h);
        ctx.lineTo(x + w, y + h);
        ctx.lineTo(x + w, y + h - t);
        ctx.lineTo(x + t, y + h - t);
        ctx.lineTo(x + t, y + t);
        ctx.lineTo(x + w, y + t);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();

        drawCalloutArrow(ctx, x, y - 10, x + w, y - 10, 'B');
        drawCalloutArrow(ctx, x - 10, y, x - 10, y + h, 'H');
    } else if (shape === 'angle') {
        const w = width * 0.4;
        const h = height * 0.4;
        const x = centerX - w / 2;
        const y = centerY - h / 2;
        const t = 12;

        ctx.moveTo(x, y);
        ctx.lineTo(x + t, y);
        ctx.lineTo(x + t, y + h - t);
        ctx.lineTo(x + w, y + h - t);
        ctx.lineTo(x + w, y + h);
        ctx.lineTo(x, y + h);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();

        drawCalloutArrow(ctx, x, y + h + 10, x + w, y + h + 10, 'Leg B');
        drawCalloutArrow(ctx, x - 10, y, x - 10, y + h, 'Leg A');
    } else if (shape === 'beam') {
        const w = width * 0.4;
        const h = height * 0.5;
        const x = centerX - w / 2;
        const y = centerY - h / 2;
        const tf = 10;
        const tw = 10;

        ctx.moveTo(x, y);
        ctx.lineTo(x + w, y);
        ctx.lineTo(x + w, y + tf);
        ctx.lineTo(centerX + tw / 2, y + tf);
        ctx.lineTo(centerX + tw / 2, y + h - tf);
        ctx.lineTo(x + w, y + h - tf);
        ctx.lineTo(x + w, y + h);
        ctx.lineTo(x, y + h);
        ctx.lineTo(x, y + h - tf);
        ctx.lineTo(centerX - tw / 2, y + h - tf);
        ctx.lineTo(centerX - tw / 2, y + tf);
        ctx.lineTo(x, y + tf);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();

        drawCalloutArrow(ctx, x, y - 10, x + w, y - 10, 'Flange B');
        drawCalloutArrow(ctx, x - 10, y, x - 10, y + h, 'Height H');
    }
}

function drawCalloutArrow(ctx, x1, y1, x2, y2, label) {
    ctx.save();
    ctx.strokeStyle = '#00E5FF';
    ctx.fillStyle = '#00E5FF';
    ctx.font = '11px sans-serif';

    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();

    const midX = (x1 + x2) / 2;
    const midY = (y1 + y2) / 2;
    ctx.fillText(label, midX - 15, midY - 3);

    ctx.restore();
}
