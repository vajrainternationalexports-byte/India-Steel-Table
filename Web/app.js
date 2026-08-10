// IS Steel Table — Exact 1:1 Replica of Android App
let allSections = MASTER_DATASET;
let currentFamily = "Equal Angles";
let currentSection = null;
let currentScreen = "categories"; // 'categories' | 'detail' | 'size_picker' | 'calculator'
let activeCalcField = "rate"; // 'length' | 'rate'
let calcLengthVal = "1";
let calcRateVal = "";

// 13 Exact Families matching Android App
const CATEGORY_NAMES = [
  "EQUAL ANGLES",
  "UNEQUAL ANGLES",
  "REGULAR BEAMS",
  "HEAVY WEIGHT BEAMS",
  "SLOPING FLANGE CHANNELS",
  "PARALLEL FLANGE CHANNELS",
  "PIPES",
  "RECTANGULAR TUBES",
  "SQUARE TUBES",
  "SQUARE BARS",
  "ROUND BARS",
  "FLATS",
  "HR PLATES"
];

function init() {
  console.log(`[✓] IS Steel Table Loaded ${allSections.length} sections.`);
  showCategoryListScreen();
  setupEvents();
}

// SCREEN 1: CATEGORY LIST
function showCategoryListScreen() {
  currentScreen = "categories";
  document.getElementById("appTitle").textContent = "IS Steel Table";
  document.getElementById("appVersion").style.display = "inline";
  document.getElementById("shareBtn").style.display = "none";
  document.getElementById("calcBtn").style.display = "none";
  document.getElementById("bookmarkBtn").style.display = "flex";

  const content = document.getElementById("screenContent");
  content.innerHTML = "";

  const list = document.createElement("div");
  list.className = "category-list";

  CATEGORY_NAMES.forEach(cat => {
    const btn = document.createElement("button");
    btn.className = "category-btn";
    btn.textContent = cat;
    btn.onclick = () => {
      const fam = mapCategoryToFamily(cat);
      selectCategory(fam);
    };
    list.appendChild(btn);
  });

  content.appendChild(list);
}

function mapCategoryToFamily(cat) {
  const map = {
    "EQUAL ANGLES": "Equal Angles",
    "UNEQUAL ANGLES": "Unequal Angles",
    "REGULAR BEAMS": "Regular Beams",
    "HEAVY WEIGHT BEAMS": "Heavy Weight Beams",
    "SLOPING FLANGE CHANNELS": "Sloping Flange Channels",
    "PARALLEL FLANGE CHANNELS": "Parallel Flange Channels",
    "PIPES": "Pipes",
    "RECTANGULAR TUBES": "Rectangular Tubes",
    "SQUARE TUBES": "Square Tubes",
    "SQUARE BARS": "Square Bars",
    "ROUND BARS": "Round Bars",
    "FLATS": "Flats",
    "HR PLATES": "HR Plates"
  };
  return map[cat] || "Equal Angles";
}

function selectCategory(fam) {
  currentFamily = fam;
  const sectionsInFam = allSections.filter(s => s.family === fam);
  currentSection = sectionsInFam[0] || allSections[0];
  showDetailScreen();
}

// SCREEN 2: DETAIL VIEW
function showDetailScreen() {
  currentScreen = "detail";
  document.getElementById("appTitle").textContent = currentFamily;
  document.getElementById("appVersion").style.display = "none";
  document.getElementById("shareBtn").style.display = "flex";
  document.getElementById("calcBtn").style.display = "flex";
  document.getElementById("bookmarkBtn").style.display = "flex";

  const content = document.getElementById("screenContent");
  content.innerHTML = "";

  // Top Size Selector Bar with Upward Triangle Icon (as in Android App)
  const sizeBar = document.createElement("div");
  sizeBar.className = "size-selector-bar";
  sizeBar.onclick = showSizePickerScreen;

  const arrowLeft = document.createElement("span");
  arrowLeft.className = "dropdown-arrow-left";
  arrowLeft.innerHTML = "&#9650;"; // Upward triangle ▲

  const sizeText = document.createElement("span");
  sizeText.className = "size-selector-text";
  sizeText.textContent = getCleanDesignation(currentSection);

  sizeBar.appendChild(arrowLeft);
  sizeBar.appendChild(sizeText);
  content.appendChild(sizeBar);

  // Split View Container
  const split = document.createElement("div");
  split.className = "detail-split-view";

  // Left Technical CAD Diagram Pane
  const diagramPane = document.createElement("div");
  diagramPane.className = "detail-diagram-pane";

  const canvas = document.createElement("canvas");
  canvas.id = "detailCanvas";
  diagramPane.appendChild(canvas);

  // Right Properties Pane
  const propsPane = document.createElement("div");
  propsPane.className = "detail-props-pane";
  propsPane.innerHTML = generatePropertiesHtml(currentSection);

  split.appendChild(diagramPane);
  split.appendChild(propsPane);
  content.appendChild(split);

  // Bottom Legend & BIS Standard Subtitle (Matching Screenshots)
  const legendBox = document.createElement("div");
  legendBox.className = "detail-legend-box";
  legendBox.innerHTML = generateLegendHtml(currentSection);
  content.appendChild(legendBox);

  // Render diagram on Canvas
  setTimeout(() => drawDiagram(currentSection, canvas), 10);
}

function getCleanDesignation(s) {
  let d = s.designation;
  d = d.replace(/^ISA\s+/i, "");
  d = d.replace(/^FLAT\s+/i, "");
  d = d.replace(/^PLATE\s+/i, "");
  return d;
}

// SCREEN 3: 2-COLUMN SIZE GRID PICKER
function showSizePickerScreen() {
  currentScreen = "size_picker";
  document.getElementById("appTitle").textContent = currentFamily;
  document.getElementById("appVersion").style.display = "none";
  document.getElementById("shareBtn").style.display = "none";
  document.getElementById("calcBtn").style.display = "none";

  const content = document.getElementById("screenContent");
  content.innerHTML = "";

  // Top Bar with Up Arrow (Matching Screenshot)
  const sizeBar = document.createElement("div");
  sizeBar.className = "size-selector-bar";
  sizeBar.onclick = showDetailScreen;

  const arrowLeft = document.createElement("span");
  arrowLeft.className = "dropdown-arrow-left";
  arrowLeft.innerHTML = "&#9650;";

  const sizeText = document.createElement("span");
  sizeText.className = "size-selector-text";
  sizeText.textContent = getCleanDesignation(currentSection);

  sizeBar.appendChild(arrowLeft);
  sizeBar.appendChild(sizeText);
  content.appendChild(sizeBar);

  // 2-Column Grid
  const grid = document.createElement("div");
  grid.className = "size-grid-container";

  const sameFam = allSections.filter(s => s.family === currentFamily);
  sameFam.forEach(s => {
    const btn = document.createElement("button");
    btn.className = "size-grid-btn";
    btn.textContent = getCleanDesignation(s);
    btn.onclick = () => {
      currentSection = s;
      showDetailScreen();
    };
    grid.appendChild(btn);
  });

  content.appendChild(grid);
}

// SCREEN 4: CALCULATOR PAGE
function showCalculatorScreen() {
  currentScreen = "calculator";
  document.getElementById("appTitle").textContent = `${currentFamily} ${getCleanDesignation(currentSection)}`;
  document.getElementById("appVersion").style.display = "none";
  document.getElementById("shareBtn").style.display = "none";
  document.getElementById("calcBtn").style.display = "none";
  document.getElementById("bookmarkBtn").style.display = "none";

  calcLengthVal = "1";
  calcRateVal = "";
  activeCalcField = "rate";

  renderCalculatorScreen();
}

function renderCalculatorScreen() {
  const content = document.getElementById("screenContent");
  content.innerHTML = "";

  const screen = document.createElement("div");
  screen.className = "calc-screen";

  const lenNum = parseFloat(calcLengthVal) || 0;
  const rateNum = parseFloat(calcRateVal) || 0;
  const massKg = lenNum * currentSection.massPerMetre;
  const totalPrice = rateNum > 0 ? (massKg * rateNum) : null;

  // Display Section
  const displaySection = document.createElement("div");
  displaySection.className = "calc-display-section";

  displaySection.innerHTML = `
    <div class="calc-result-text">Total Weight: ${massKg.toFixed(1)} Kg</div>
    <div class="calc-result-text">Total Price: ${totalPrice !== null ? "₹ " + totalPrice.toFixed(2) : ""}</div>

    <div class="calc-input-row" onclick="focusCalcField('length')">
      <span class="calc-input-label">Length (in meter)</span>
      <input id="calcLenInput" class="calc-input-field ${activeCalcField === 'length' ? 'focused' : ''}" readonly value="${calcLengthVal}">
    </div>

    <div class="calc-input-row" onclick="focusCalcField('rate')">
      <span class="calc-input-label">Rate (in ₹/kg)</span>
      <input id="calcRateInput" class="calc-input-field ${activeCalcField === 'rate' ? 'focused' : ''}" readonly placeholder="Enter rate" value="${calcRateVal}">
    </div>
  `;

  screen.appendChild(displaySection);

  // 7x3 Keypad Grid
  const keypad = document.createElement("div");
  keypad.className = "calc-keypad-grid";

  const keys = [
    { label: "⬆", action: "up" },
    { label: "⇤", action: "tab_prev" },
    { label: "1", action: "num", val: "1" },
    { label: "2", action: "num", val: "2" },
    { label: "3", action: "num", val: "3" },
    { label: "⇥", action: "tab_next" },
    { label: "⌫", action: "backspace", red: true },

    { label: "/", action: "num", val: "/" },
    { label: "*", action: "num", val: "*" },
    { label: "4", action: "num", val: "4" },
    { label: "5", action: "num", val: "5" },
    { label: "6", action: "num", val: "6" },
    { label: "+", action: "num", val: "+" },
    { label: "-", action: "num", val: "-" },

    { label: "⬇", action: "down" },
    { label: ".", action: "num", val: "." },
    { label: "7", action: "num", val: "7" },
    { label: "8", action: "num", val: "8" },
    { label: "9", action: "num", val: "9" },
    { label: "0", action: "num", val: "0" },
    { label: "=", action: "calc" }
  ];

  keys.forEach(k => {
    const keyEl = document.createElement("div");
    keyEl.className = `calc-key ${k.red ? 'key-red' : ''}`;
    keyEl.textContent = k.label;
    keyEl.onclick = () => handleKeypadPress(k);
    keypad.appendChild(keyEl);
  });

  screen.appendChild(keypad);
  content.appendChild(screen);
}

function focusCalcField(field) {
  activeCalcField = field;
  renderCalculatorScreen();
}

function handleKeypadPress(k) {
  if (k.action === "num") {
    if (activeCalcField === "length") {
      calcLengthVal = (calcLengthVal === "0" ? "" : calcLengthVal) + k.val;
    } else {
      calcRateVal += k.val;
    }
  } else if (k.action === "backspace") {
    if (activeCalcField === "length") {
      calcLengthVal = calcLengthVal.slice(0, -1);
    } else {
      calcRateVal = calcRateVal.slice(0, -1);
    }
  } else if (k.action === "tab_prev" || k.action === "up") {
    activeCalcField = "length";
  } else if (k.action === "tab_next" || k.action === "down") {
    activeCalcField = "rate";
  } else if (k.action === "calc") {
    try {
      if (activeCalcField === "length" && calcLengthVal) {
        calcLengthVal = String(eval(calcLengthVal));
      } else if (activeCalcField === "rate" && calcRateVal) {
        calcRateVal = String(eval(calcRateVal));
      }
    } catch (e) {}
  }
  renderCalculatorScreen();
}

// Generate Properties List Matching Android Screenshots
function generatePropertiesHtml(s) {
  const lines = [];
  const d = s.dimensions || {};
  const st = s.structural || {};

  if (s.family.includes("Angles")) {
    lines.push(`M = ${s.massPerMetre} Kg/m`);
    lines.push(`Ar = ${s.area} cm²`);
    lines.push(`A,B = ${d.legA_mm} ${d.legB_mm || d.legA_mm} mm`);
    lines.push(`t = ${d.thickness_t_mm || 0} mm`);
    lines.push(`R₁ = ${d.rootRadius_r1_mm || 4} mm`);
    lines.push(`R₂ = ${d.toeRadius_r2_description || "Square"}`);
    if (st.cx_cm) lines.push(`C_x = ${st.cx_cm} cm`);
    if (st.cy_cm) lines.push(`C_y = ${st.cy_cm} cm`);
    if (st.tanAlpha) lines.push(`Tan α = ${st.tanAlpha}`);
    if (st.ixx_cm4) lines.push(`I_x = ${st.ixx_cm4} cm⁴`);
    if (st.iyy_cm4) lines.push(`I_y = ${st.iyy_cm4} cm⁴`);
    if (st.iuMax_cm4) lines.push(`I_u max = ${st.iuMax_cm4} cm⁴`);
    if (st.ivMin_cm4) lines.push(`I_v min = ${st.ivMin_cm4} cm⁴`);
    if (st.rxx_cm) lines.push(`r_x = ${st.rxx_cm} cm`);
    if (st.ryy_cm) lines.push(`r_y = ${st.ryy_cm} cm`);
    if (st.ruMax_cm) lines.push(`r_u max = ${st.ruMax_cm} cm`);
    if (st.rvMin_cm) lines.push(`r_v min = ${st.rvMin_cm} cm`);
    if (st.zxx_cm3) lines.push(`Z_x = ${st.zxx_cm3} cm³`);
    if (st.zyy_cm3) lines.push(`Z_y = ${st.zyy_cm3} cm³`);
  } else if (s.family === "Pipes") {
    lines.push(`OD = ${d.outerDiameter_od_mm} mm`);
    lines.push(`t = ${d.wallThickness_t_mm} mm`);
    lines.push(`Wt = ${s.massPerMetre} Kg/m`);
    lines.push(`Ar = ${s.area} cm²`);
    if (st.internalVolume_v_cm3_m) lines.push(`V = ${st.internalVolume_v_cm3_m} cm³/m`);
    if (st.externalSurface_se_cm2_m) lines.push(`Se = ${st.externalSurface_se_cm2_m} cm²/m`);
    if (st.internalSurface_si_cm2_m) lines.push(`Si = ${st.internalSurface_si_cm2_m} cm²/m`);
    if (st.ixx_cm4) lines.push(`Ixx = ${st.ixx_cm4} cm⁴`);
    if (st.zxx_cm3) lines.push(`Z = ${st.zxx_cm3} cm³`);
    if (st.rxx_cm) lines.push(`Rx = ${st.rxx_cm} cm`);
  } else if (s.family === "Rectangular Tubes" || s.family === "Square Tubes") {
    if (s.family === "Square Tubes") {
      lines.push(`D = ${d.side_s_mm || d.depth_h_mm} mm`);
    }
    lines.push(`t = ${d.wallThickness_t_mm || d.thickness_t_mm} mm`);
    lines.push(`Wt = ${s.massPerMetre} Kg/m`);
    lines.push(`Ar = ${s.area} cm²`);
    if (st.ixx_cm4 && s.family === "Rectangular Tubes") lines.push(`Ixx = ${st.ixx_cm4} cm⁴`);
    if (st.iyy_cm4) lines.push(`${s.family === "Square Tubes" ? "Iy" : "Iyy"} = ${st.iyy_cm4} cm⁴`);
    if (st.rxx_cm) lines.push(`Rx = ${st.rxx_cm} cm`);
    if (st.ryy_cm && s.family === "Rectangular Tubes") lines.push(`Ry = ${st.ryy_cm} cm`);
    if (st.zxx_cm3) lines.push(`Zx = ${st.zxx_cm3} cm³`);
    if (st.zyy_cm3 && s.family === "Rectangular Tubes") lines.push(`Zy = ${st.zyy_cm3} cm³`);
    if (st.plasticSx_cm3) lines.push(`Sx = ${st.plasticSx_cm3} cm³`);
    if (st.plasticSy_cm3 && s.family === "Rectangular Tubes") lines.push(`Sy = ${st.plasticSy_cm3} cm³`);
  } else if (s.family.includes("Beams")) {
    lines.push(`M = ${s.massPerMetre} Kg/m`);
    lines.push(`Ar = ${s.area} cm²`);
    lines.push(`D = ${d.depth_h_mm} mm`);
    lines.push(`B = ${d.width_b_mm} mm`);
    lines.push(`t = ${d.webThickness_tw_mm} mm`);
    lines.push(`T = ${d.flangeThickness_tf_mm} mm`);
    lines.push(`Slope α = ${d.flangeSlope_deg || 98} deg`);
    lines.push(`R₁ = ${d.rootRadius_r1_mm || 9} mm`);
    lines.push(`R₂ = ${d.toeRadius_r2_mm || 4.5} mm`);
    if (st.ixx_cm4) lines.push(`I_x = ${st.ixx_cm4} cm⁴`);
    if (st.iyy_cm4) lines.push(`I_y = ${st.iyy_cm4} cm⁴`);
    if (st.rxx_cm) lines.push(`r_x = ${st.rxx_cm} cm`);
    if (st.ryy_cm) lines.push(`r_y = ${st.ryy_cm} cm`);
    if (st.zxx_cm3) lines.push(`Z_x = ${st.zxx_cm3} cm³`);
    if (st.zyy_cm3) lines.push(`Z_y = ${st.zyy_cm3} cm³`);
  } else if (s.family.includes("Channels")) {
    lines.push(`M = ${s.massPerMetre} Kg/m`);
    lines.push(`Ar = ${s.area} cm²`);
    lines.push(`D = ${d.depth_h_mm} mm`);
    lines.push(`B = ${d.width_b_mm} mm`);
    lines.push(`t = ${d.webThickness_tw_mm} mm`);
    lines.push(`T = ${d.flangeThickness_tf_mm} mm`);
    if (d.rootRadius_r1_mm) lines.push(`R₁ = ${d.rootRadius_r1_mm} mm`);
    if (d.toeRadius_r2_mm) lines.push(`R₂ = ${d.toeRadius_r2_mm} mm`);
    if (st.cy_cm) lines.push(`C_y = ${st.cy_cm} cm`);
    if (st.ixx_cm4) lines.push(`I_x = ${st.ixx_cm4} cm⁴`);
    if (st.iyy_cm4) lines.push(`I_y = ${st.iyy_cm4} cm⁴`);
    if (st.rxx_cm) lines.push(`r_x = ${st.rxx_cm} cm`);
    if (st.ryy_cm) lines.push(`r_y = ${st.ryy_cm} cm`);
    if (st.zxx_cm3) lines.push(`Z_x = ${st.zxx_cm3} cm³`);
    if (st.zyy_cm3) lines.push(`Z_y = ${st.zyy_cm3} cm³`);
  } else if (s.family === "Flats") {
    lines.push(`M = ${s.massPerMetre} Kg/m`);
    lines.push(`t = ${d.thickness_t_mm} mm`);
    lines.push(`w = ${d.width_b_mm} mm`);
  } else if (s.family === "HR Plates") {
    lines.push(`M = ${s.massPerMetre} Kg/m²`);
    lines.push(`t = ${d.thickness_t_mm} mm`);
  } else if (s.family === "Square Bars" || s.family === "Round Bars") {
    lines.push(`M = ${s.massPerMetre} Kg/m`);
    lines.push(`Ar = ${s.area} cm²`);
    lines.push(`t = ${d.side_s_mm || d.diameter_d_mm} mm`);
  }

  return lines.map(l => `<div class="prop-line">${l}</div>`).join("");
}

// Generate Legend & Standard Subtitle Matching Screenshots
function generateLegendHtml(s) {
  if (s.family === "Pipes") {
    return `
      <div class="legend-text">Ar=Area of cross-section  V=Internal volume<br>Si=Internal Surface area  Se=External Surface area<br>Ixx=MI about X-X axis  Rx=Radius of Gyration</div>
      <div class="standard-text">IS:1161(1998)</div>
    `;
  } else if (s.family === "Rectangular Tubes" || s.family === "Square Tubes") {
    return `
      <div class="legend-text">Moment of Inertia = I  Radius of Gyration = R<br>Elastic Modulus = Z  Plastic Modulus = S</div>
      <div class="standard-text">IS:4923</div>
    `;
  } else if (s.family.includes("Beams") || s.family.includes("Channels") || s.family.includes("Angles")) {
    return `<div class="standard-text">IS:808</div>`;
  } else if (s.family === "Square Bars" || s.family === "Round Bars" || s.family === "Flats") {
    return `<div class="standard-text">IS:1732 / IS:1730</div>`;
  } else if (s.family === "HR Plates") {
    return `<div class="standard-text">IS:1730</div>`;
  }
  return "";
}

// Technical White CAD Drawing on Canvas
function drawDiagram(section, canvas) {
  const ctx = canvas.getContext("2d");
  const dpr = window.devicePixelRatio || 1;
  const w = canvas.parentElement.clientWidth || 180;
  const h = 420;

  canvas.width = w * dpr;
  canvas.height = h * dpr;
  ctx.scale(dpr, dpr);

  ctx.clearRect(0, 0, w, h);

  if (section.family.includes("Angles")) {
    drawDualAngleBlueprint(ctx, section, w, h);
  } else if (section.family === "Flats") {
    drawFlatBlueprint(ctx, section, w, h);
  } else if (section.family === "HR Plates") {
    drawPlateBlueprint(ctx, section, w, h);
  } else if (section.family.includes("Beams")) {
    drawBeamBlueprint(ctx, section, w, h);
  } else if (section.family.includes("Channels")) {
    drawChannelBlueprint(ctx, section, w, h);
  } else if (section.family === "Pipes") {
    drawPipeBlueprint(ctx, section, w, h);
  } else if (section.family === "Rectangular Tubes") {
    drawRectTubeBlueprint(ctx, section, w, h);
  } else if (section.family === "Square Tubes") {
    drawSquareTubeBlueprint(ctx, section, w, h);
  } else if (section.family === "Square Bars") {
    drawSquareBarBlueprint(ctx, section, w, h);
  } else if (section.family === "Round Bars") {
    drawRoundBarBlueprint(ctx, section, w, h);
  }
}

// 1. Dual Diagram for Angles (Matching Screenshots 2, 6, 9346, 9347, 9364, 9366)
function drawDualAngleBlueprint(ctx, section, w, h) {
  const legA = section.dimensions.legA_mm || 30;
  const legB = section.dimensions.legB_mm || 20;
  const isUnequal = legA !== legB;

  // --- TOP SCHEMATIC: CROSS SECTION WITH R1, R2, A, B, t ---
  const ox1 = 30;
  const oy1 = 160;
  const scale = 2.8;
  const da = Math.min(Math.max(legA * scale, 85), 130);
  const db = Math.min(Math.max(legB * scale, 65), 110);
  const dt = 14;

  ctx.strokeStyle = "#ffffff";
  ctx.fillStyle = "#ffffff";
  ctx.lineWidth = 1.8;

  // Outer and Inner Profile
  ctx.beginPath();
  ctx.moveTo(ox1, oy1);
  ctx.lineTo(ox1 + db, oy1);
  ctx.lineTo(ox1 + db, oy1 - dt);
  ctx.lineTo(ox1 + dt + 8, oy1 - dt);
  ctx.quadraticCurveTo(ox1 + dt, oy1 - dt, ox1 + dt, oy1 - dt - 8);
  ctx.lineTo(ox1 + dt, oy1 - da);
  ctx.lineTo(ox1, oy1 - da);
  ctx.closePath();
  ctx.stroke();

  // 45 deg Cross Hatching
  ctx.save();
  ctx.clip();
  ctx.strokeStyle = "rgba(255, 255, 255, 0.4)";
  ctx.lineWidth = 1;
  for (let x = ox1 - 150; x < ox1 + db + 150; x += 6) {
    ctx.beginPath();
    ctx.moveTo(x, oy1);
    ctx.lineTo(x + 150, oy1 - 150);
    ctx.stroke();
  }
  ctx.restore();

  // Dimension Lines & Callouts
  ctx.font = "bold 9px Arial";
  ctx.fillStyle = "#ffffff";
  ctx.strokeStyle = "#ffffff";
  ctx.lineWidth = 1;

  // A Dimension (Vertical)
  drawDimArrow(ctx, ox1 - 12, oy1, ox1 - 12, oy1 - da, true);
  ctx.fillText("A", ox1 - 24, oy1 - da / 2 + 3);

  // B Dimension (Horizontal)
  drawDimArrow(ctx, ox1, oy1 + 12, ox1 + db, oy1 + 12, false);
  ctx.fillText("B", ox1 + db / 2 - 3, oy1 + 24);

  // t Dimension
  drawDimArrow(ctx, ox1 + dt + 8, oy1 - da + 18, ox1 + dt + 8, oy1 - da + 18 + dt, true);
  ctx.fillText("t", ox1 + dt + 14, oy1 - da + 18 + dt / 2 + 3);

  // R1 Root Radius Leader Callout
  ctx.fillText("R₁ ROOT RADIUS", ox1 + dt + 20, oy1 - dt - 4);
  drawLeader(ctx, ox1 + dt + 18, oy1 - dt - 6, ox1 + dt + 2, oy1 - dt - 2);

  // R2 Toe Radius Leader Callout
  ctx.fillText("R₂ TOE RADIUS", ox1 + dt + 14, oy1 - da + 8);
  drawLeader(ctx, ox1 + dt + 12, oy1 - da + 6, ox1 + dt, oy1 - da + 1);

  // --- BOTTOM SCHEMATIC: COORDINATE AXES (X-X, Y-Y, U-U, V-V, Cx, Cy, Tan α) ---
  const ox2 = 30;
  const oy2 = 370;

  ctx.strokeStyle = "#ffffff";
  ctx.lineWidth = 1.8;
  ctx.beginPath();
  ctx.moveTo(ox2, oy2);
  ctx.lineTo(ox2 + db, oy2);
  ctx.lineTo(ox2 + db, oy2 - dt);
  ctx.lineTo(ox2 + dt, oy2 - dt);
  ctx.lineTo(ox2 + dt, oy2 - da);
  ctx.lineTo(ox2, oy2 - da);
  ctx.closePath();
  ctx.stroke();

  // Centroid point G
  const cx = ox2 + (isUnequal ? 22 : 28);
  const cy = oy2 - (isUnequal ? 44 : 28);

  // X-X Axis (Horizontal dashed)
  ctx.setLineDash([8, 3, 2, 3]);
  ctx.beginPath();
  ctx.moveTo(ox2 - 16, cy);
  ctx.lineTo(ox2 + db + 18, cy);
  ctx.stroke();

  // Y-Y Axis (Vertical dashed)
  ctx.beginPath();
  ctx.moveTo(cx, oy2 - da - 14);
  ctx.lineTo(cx, oy2 + 14);
  ctx.stroke();

  // U-U & V-V Axes (Diagonal Principal Axes)
  const angle = isUnequal ? 0.38 : 0.785; // 45 deg for equal, alpha for unequal
  const len = 52;
  ctx.beginPath();
  ctx.moveTo(cx - len * Math.cos(angle), cy + len * Math.sin(angle));
  ctx.lineTo(cx + len * Math.cos(angle), cy - len * Math.sin(angle));
  ctx.stroke();

  ctx.beginPath();
  ctx.moveTo(cx - len * Math.sin(angle), cy - len * Math.cos(angle));
  ctx.lineTo(cx + len * Math.sin(angle), cy + len * Math.cos(angle));
  ctx.stroke();
  ctx.setLineDash([]);

  // Axis Labels
  ctx.font = "bold 9px Arial";
  ctx.fillText("X", ox2 - 24, cy + 3);
  ctx.fillText("X", ox2 + db + 20, cy + 3);
  ctx.fillText("Y", cx - 3, oy2 - da - 18);
  ctx.fillText("Y", cx - 3, oy2 + 24);
  ctx.fillText("U", cx + len * Math.cos(angle) + 4, cy - len * Math.sin(angle));
  ctx.fillText("V", cx - len * Math.sin(angle) - 10, cy - len * Math.cos(angle));

  // Cx, Cy dimension markers
  ctx.fillText("Cx", ox2 + 6, cy + 12);
  ctx.fillText("Cy", cx - 14, oy2 + 8);
  if (isUnequal) {
    ctx.fillText("α", cx + 10, cy - 4);
  }
}

// 2. Flats Drawing (Matching Screenshots 9358, 9374)
function drawFlatBlueprint(ctx, section, w, h) {
  const ox = 26;
  const oy = 140;
  const fw = 118;
  const fh = 24;

  ctx.strokeStyle = "#ffffff";
  ctx.fillStyle = "#ffffff";
  ctx.lineWidth = 1.8;

  ctx.strokeRect(ox, oy, fw, fh);

  // Cross hatching
  ctx.save();
  ctx.rect(ox, oy, fw, fh);
  ctx.clip();
  ctx.strokeStyle = "rgba(255, 255, 255, 0.6)";
  ctx.lineWidth = 1.2;
  for (let x = ox - 50; x < ox + fw + 50; x += 6) {
    ctx.beginPath();
    ctx.moveTo(x, oy + fh);
    ctx.lineTo(x + 50, oy);
    ctx.stroke();
  }
  ctx.restore();

  // Width & Thickness Callouts
  ctx.font = "bold 10px Arial";
  drawDimArrow(ctx, ox, oy - 12, ox + fw, oy - 12, false);
  ctx.fillText("w", ox + fw / 2 - 4, oy - 16);

  drawDimArrow(ctx, ox - 12, oy + fh, ox - 12, oy, true);
  ctx.fillText("t", ox - 22, oy + fh / 2 + 4);
}

// 3. HR Plates Drawing (Matching Screenshot 9359)
function drawPlateBlueprint(ctx, section, w, h) {
  const ox = 70;
  const oy = 60;
  const pw = 20;
  const ph = 240;

  ctx.strokeStyle = "#ffffff";
  ctx.fillStyle = "#ffffff";
  ctx.lineWidth = 1.8;

  ctx.strokeRect(ox, oy, pw, ph);

  // Cross hatching
  ctx.save();
  ctx.rect(ox, oy, pw, ph);
  ctx.clip();
  ctx.strokeStyle = "rgba(255, 255, 255, 0.6)";
  ctx.lineWidth = 1.2;
  for (let y = oy - 50; y < oy + ph + 50; y += 8) {
    ctx.beginPath();
    ctx.moveTo(ox, y);
    ctx.lineTo(ox + pw, y - pw);
    ctx.stroke();
  }
  ctx.restore();

  // Thickness callout
  ctx.font = "bold 10px Arial";
  drawDimArrow(ctx, ox, oy - 12, ox + pw, oy - 12, false);
  ctx.fillText("t", ox + pw / 2 - 3, oy - 16);
}

// 4. Beams Blueprint (Matching Screenshot 9348, 9349)
function drawBeamBlueprint(ctx, section, w, h) {
  const cx = 85;
  const cy = 200;
  const bh = 220;
  const bw = 110;
  const tw = 12;
  const tf = 18;

  ctx.strokeStyle = "#ffffff";
  ctx.fillStyle = "#ffffff";
  ctx.lineWidth = 1.8;

  // I-Beam Profile
  ctx.beginPath();
  // Top Flange
  ctx.moveTo(cx - bw/2, cy - bh/2);
  ctx.lineTo(cx + bw/2, cy - bh/2);
  ctx.lineTo(cx + bw/2, cy - bh/2 + tf);
  ctx.lineTo(cx + tw/2 + 8, cy - bh/2 + tf);
  ctx.quadraticCurveTo(cx + tw/2, cy - bh/2 + tf, cx + tw/2, cy - bh/2 + tf + 8);
  // Web
  ctx.lineTo(cx + tw/2, cy + bh/2 - tf - 8);
  ctx.quadraticCurveTo(cx + tw/2, cy + bh/2 - tf, cx + tw/2 + 8, cy + bh/2 - tf);
  // Bottom Flange
  ctx.lineTo(cx + bw/2, cy + bh/2 - tf);
  ctx.lineTo(cx + bw/2, cy + bh/2);
  ctx.lineTo(cx - bw/2, cy + bh/2);
  ctx.lineTo(cx - bw/2, cy + bh/2 - tf);
  ctx.lineTo(cx - tw/2 - 8, cy + bh/2 - tf);
  ctx.quadraticCurveTo(cx - tw/2, cy + bh/2 - tf, cx - tw/2, cy + bh/2 - tf - 8);
  // Web left
  ctx.lineTo(cx - tw/2, cy - bh/2 + tf + 8);
  ctx.quadraticCurveTo(cx - tw/2, cy - bh/2 + tf, cx - tw/2 - 8, cy - bh/2 + tf);
  ctx.lineTo(cx - bw/2, cy - bh/2 + tf);
  ctx.closePath();
  ctx.stroke();

  // Coordinate Axes
  ctx.setLineDash([8, 3, 2, 3]);
  ctx.beginPath();
  ctx.moveTo(cx - bw/2 - 20, cy); ctx.lineTo(cx + bw/2 + 20, cy);
  ctx.moveTo(cx, cy - bh/2 - 20); ctx.lineTo(cx, cy + bh/2 + 20);
  ctx.stroke();
  ctx.setLineDash([]);

  // Dimensions
  ctx.font = "bold 9px Arial";
  // D (Depth)
  drawDimArrow(ctx, cx - bw/2 - 14, cy + bh/2, cx - bw/2 - 14, cy - bh/2, true);
  ctx.fillText("D", cx - bw/2 - 26, cy + 3);

  // B (Width)
  drawDimArrow(ctx, cx - bw/2, cy - bh/2 - 12, cx + bw/2, cy - bh/2 - 12, false);
  ctx.fillText("B", cx - 4, cy - bh/2 - 16);

  // T (Flange thickness)
  drawDimArrow(ctx, cx + bw/2 + 12, cy - bh/2, cx + bw/2 + 12, cy - bh/2 + tf, true);
  ctx.fillText("T", cx + bw/2 + 18, cy - bh/2 + tf/2 + 3);

  // t (Web thickness)
  drawDimArrow(ctx, cx - tw/2, cy + 30, cx + tw/2, cy + 30, false);
  ctx.fillText("t", cx - 2, cy + 42);

  // Leader lines for R1 & R2
  ctx.fillText("R₁", cx + tw/2 + 18, cy - bh/2 + tf + 18);
  drawLeader(ctx, cx + tw/2 + 16, cy - bh/2 + tf + 14, cx + tw/2 + 2, cy - bh/2 + tf + 4);

  ctx.fillText("X", cx + bw/2 + 24, cy + 3);
  ctx.fillText("Y", cx - 3, cy - bh/2 - 24);
}

// 5. Channels Blueprint (Matching Screenshots 9350, 9351)
function drawChannelBlueprint(ctx, section, w, h) {
  const ox = 40;
  const cy = 200;
  const ch = 220;
  const cw = 90;
  const tw = 12;
  const tf = 18;

  ctx.strokeStyle = "#ffffff";
  ctx.fillStyle = "#ffffff";
  ctx.lineWidth = 1.8;

  ctx.beginPath();
  ctx.moveTo(ox + cw, cy - ch/2);
  ctx.lineTo(ox, cy - ch/2);
  ctx.lineTo(ox, cy + ch/2);
  ctx.lineTo(ox + cw, cy + ch/2);
  ctx.lineTo(ox + cw, cy + ch/2 - tf);
  ctx.lineTo(ox + tw + 8, cy + ch/2 - tf);
  ctx.quadraticCurveTo(ox + tw, cy + ch/2 - tf, ox + tw, cy + ch/2 - tf - 8);
  ctx.lineTo(ox + tw, cy - ch/2 + tf + 8);
  ctx.quadraticCurveTo(ox + tw, cy - ch/2 + tf, ox + tw + 8, cy - ch/2 + tf);
  ctx.lineTo(ox + cw, cy - ch/2 + tf);
  ctx.closePath();
  ctx.stroke();

  // Coordinate Axes
  const centroidX = ox + 24;
  ctx.setLineDash([8, 3, 2, 3]);
  ctx.beginPath();
  ctx.moveTo(ox - 18, cy); ctx.lineTo(ox + cw + 18, cy);
  ctx.moveTo(centroidX, cy - ch/2 - 18); ctx.lineTo(centroidX, cy + ch/2 + 18);
  ctx.stroke();
  ctx.setLineDash([]);

  // Dimensions
  ctx.font = "bold 9px Arial";
  drawDimArrow(ctx, ox - 12, cy + ch/2, ox - 12, cy - ch/2, true);
  ctx.fillText("D", ox - 24, cy + 3);

  drawDimArrow(ctx, ox, cy - ch/2 - 10, ox + cw, cy - ch/2 - 10, false);
  ctx.fillText("B", ox + cw/2 - 4, cy - ch/2 - 14);

  ctx.fillText("Cy", ox + 6, cy + ch/2 + 14);
  ctx.fillText("X", ox + cw + 22, cy + 3);
  ctx.fillText("Y", centroidX - 3, cy - ch/2 - 22);
}

// 6. Pipes Blueprint (Matching Screenshots 9345, 9352, 9360)
function drawPipeBlueprint(ctx, section, w, h) {
  const cx = 85;
  const cy = 200;
  const rOuter = 65;
  const rInner = 48;

  ctx.strokeStyle = "#ffffff";
  ctx.fillStyle = "#ffffff";
  ctx.lineWidth = 1.8;

  // Outer & Inner Circles
  ctx.beginPath(); ctx.arc(cx, cy, rOuter, 0, Math.PI * 2); ctx.stroke();
  ctx.beginPath(); ctx.arc(cx, cy, rInner, 0, Math.PI * 2); ctx.stroke();

  // Hatching in annular ring
  ctx.save();
  ctx.beginPath();
  ctx.arc(cx, cy, rOuter, 0, Math.PI * 2);
  ctx.arc(cx, cy, rInner, 0, Math.PI * 2, true);
  ctx.clip();
  ctx.strokeStyle = "rgba(255, 255, 255, 0.5)";
  ctx.lineWidth = 1;
  for (let x = cx - rOuter - 20; x < cx + rOuter + 20; x += 6) {
    ctx.beginPath();
    ctx.moveTo(x, cy + rOuter);
    ctx.lineTo(x + 2 * rOuter, cy - rOuter);
    ctx.stroke();
  }
  ctx.restore();

  // X-X Axis
  ctx.setLineDash([8, 3, 2, 3]);
  ctx.beginPath();
  ctx.moveTo(cx - rOuter - 22, cy); ctx.lineTo(cx + rOuter + 22, cy);
  ctx.stroke();
  ctx.setLineDash([]);

  // Dimensions
  ctx.font = "bold 9px Arial";
  ctx.fillText("X", cx - rOuter - 30, cy + 3);
  ctx.fillText("X", cx + rOuter + 26, cy + 3);

  // OD Dimension
  drawDimArrow(ctx, cx - rOuter, cy - rOuter - 10, cx + rOuter, cy - rOuter - 10, false);
  ctx.fillText("OD", cx - 8, cy - rOuter - 14);

  // t Leader
  ctx.fillText("t", cx + rOuter - 10, cy - rOuter + 28);
  drawLeader(ctx, cx + rOuter - 12, cy - rOuter + 26, cx + (rOuter + rInner)/2 * Math.cos(0.7), cy - (rOuter + rInner)/2 * Math.sin(0.7));

  // Rx Leader
  ctx.fillText("Rx", cx + 18, cy + 22);
  drawLeader(ctx, cx + 16, cy + 20, cx, cy);
}

// 7. Rectangular Tubes (Matching Screenshot 9353)
function drawRectTubeBlueprint(ctx, section, w, h) {
  const cx = 85;
  const cy = 200;
  const tw = 120;
  const th = 70;
  const wall = 14;

  ctx.strokeStyle = "#ffffff";
  ctx.fillStyle = "#ffffff";
  ctx.lineWidth = 1.8;

  // Outer & Inner Rounded Rectangles
  drawRoundedRect(ctx, cx - tw/2, cy - th/2, tw, th, 8);
  drawRoundedRect(ctx, cx - tw/2 + wall, cy - th/2 + wall, tw - 2*wall, th - 2*wall, 5);

  // Hatching in wall
  ctx.save();
  ctx.beginPath();
  roundedRectPath(ctx, cx - tw/2, cy - th/2, tw, th, 8);
  roundedRectPath(ctx, cx - tw/2 + wall, cy - th/2 + wall, tw - 2*wall, th - 2*wall, 5, true);
  ctx.clip();
  ctx.strokeStyle = "rgba(255, 255, 255, 0.5)";
  ctx.lineWidth = 1;
  for (let x = cx - tw - 20; x < cx + tw + 20; x += 6) {
    ctx.beginPath();
    ctx.moveTo(x, cy + th);
    ctx.lineTo(x + th * 2, cy - th);
    ctx.stroke();
  }
  ctx.restore();

  // Dashed Axes
  ctx.setLineDash([8, 3, 2, 3]);
  ctx.beginPath();
  ctx.moveTo(cx - tw/2 - 18, cy); ctx.lineTo(cx + tw/2 + 18, cy);
  ctx.moveTo(cx, cy - th/2 - 18); ctx.lineTo(cx, cy + th/2 + 18);
  ctx.stroke();
  ctx.setLineDash([]);

  // Dimensions
  ctx.font = "bold 9px Arial";
  drawDimArrow(ctx, cx - tw/2, cy - th/2 - 10, cx + tw/2, cy - th/2 - 10, false);
  ctx.fillText("B", cx - 4, cy - th/2 - 14);

  drawDimArrow(ctx, cx + tw/2 + 10, cy + th/2, cx + tw/2 + 10, cy - th/2, true);
  ctx.fillText("D", cx + tw/2 + 16, cy + 3);

  ctx.fillText("t", cx - tw/2 + wall/2 - 2, cy + th/2 - wall/2 + 3);
}

// 8. Square Tubes (Matching Screenshot 9354)
function drawSquareTubeBlueprint(ctx, section, w, h) {
  const cx = 85;
  const cy = 200;
  const s = 90;
  const wall = 14;

  ctx.strokeStyle = "#ffffff";
  ctx.fillStyle = "#ffffff";
  ctx.lineWidth = 1.8;

  drawRoundedRect(ctx, cx - s/2, cy - s/2, s, s, 8);
  drawRoundedRect(ctx, cx - s/2 + wall, cy - s/2 + wall, s - 2*wall, s - 2*wall, 5);

  ctx.save();
  ctx.beginPath();
  roundedRectPath(ctx, cx - s/2, cy - s/2, s, s, 8);
  roundedRectPath(ctx, cx - s/2 + wall, cy - s/2 + wall, s - 2*wall, s - 2*wall, 5, true);
  ctx.clip();
  ctx.strokeStyle = "rgba(255, 255, 255, 0.5)";
  ctx.lineWidth = 1;
  for (let x = cx - s - 20; x < cx + s + 20; x += 6) {
    ctx.beginPath();
    ctx.moveTo(x, cy + s);
    ctx.lineTo(x + s * 2, cy - s);
    ctx.stroke();
  }
  ctx.restore();

  ctx.setLineDash([8, 3, 2, 3]);
  ctx.beginPath();
  ctx.moveTo(cx - s/2 - 18, cy); ctx.lineTo(cx + s/2 + 18, cy);
  ctx.moveTo(cx, cy - s/2 - 18); ctx.lineTo(cx, cy + s/2 + 18);
  ctx.stroke();
  ctx.setLineDash([]);

  ctx.font = "bold 9px Arial";
  drawDimArrow(ctx, cx - s/2, cy - s/2 - 10, cx + s/2, cy - s/2 - 10, false);
  ctx.fillText("D", cx - 4, cy - s/2 - 14);

  ctx.fillText("t", cx - s/2 + wall/2 - 2, cy + s/2 - wall/2 + 3);
}

// 9. Square Bars (Matching Screenshot 9355)
function drawSquareBarBlueprint(ctx, section, w, h) {
  const cx = 85;
  const cy = 200;
  const s = 90;

  ctx.strokeStyle = "#ffffff";
  ctx.fillStyle = "#ffffff";
  ctx.lineWidth = 1.8;

  ctx.strokeRect(cx - s/2, cy - s/2, s, s);

  ctx.save();
  ctx.rect(cx - s/2, cy - s/2, s, s);
  ctx.clip();
  ctx.strokeStyle = "rgba(255, 255, 255, 0.5)";
  ctx.lineWidth = 1.2;
  for (let x = cx - s - 20; x < cx + s + 20; x += 6) {
    ctx.beginPath();
    ctx.moveTo(x, cy + s);
    ctx.lineTo(x + s * 2, cy - s);
    ctx.stroke();
  }
  ctx.restore();

  ctx.font = "bold 10px Arial";
  drawDimArrow(ctx, cx - s/2, cy - s/2 - 10, cx + s/2, cy - s/2 - 10, false);
  ctx.fillText("t", cx - 3, cy - s/2 - 14);
}

// 10. Round Bars (Matching Screenshot 9357)
function drawRoundBarBlueprint(ctx, section, w, h) {
  const cx = 85;
  const cy = 200;
  const r = 50;

  ctx.strokeStyle = "#ffffff";
  ctx.fillStyle = "#ffffff";
  ctx.lineWidth = 1.8;

  ctx.beginPath(); ctx.arc(cx, cy, r, 0, Math.PI * 2); ctx.stroke();

  ctx.save();
  ctx.beginPath(); ctx.arc(cx, cy, r, 0, Math.PI * 2); ctx.clip();
  ctx.strokeStyle = "rgba(255, 255, 255, 0.5)";
  ctx.lineWidth = 1.2;
  for (let x = cx - r - 20; x < cx + r + 20; x += 6) {
    ctx.beginPath();
    ctx.moveTo(x, cy + r);
    ctx.lineTo(x + r * 2, cy - r);
    ctx.stroke();
  }
  ctx.restore();

  ctx.font = "bold 10px Arial";
  drawDimArrow(ctx, cx - r, cy - r - 10, cx + r, cy - r - 10, false);
  ctx.fillText("t", cx - 3, cy - r - 14);
}

// Helper: Rounded Rectangle
function drawRoundedRect(ctx, x, y, width, height, radius) {
  ctx.beginPath();
  roundedRectPath(ctx, x, y, width, height, radius);
  ctx.stroke();
}

function roundedRectPath(ctx, x, y, width, height, radius, clockwise = false) {
  if (clockwise) {
    ctx.moveTo(x + radius, y);
    ctx.lineTo(x + width - radius, y);
    ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
    ctx.lineTo(x + width, y + height - radius);
    ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
    ctx.lineTo(x + radius, y + height);
    ctx.quadraticCurveTo(x, y + height, x, y + height - radius);
    ctx.lineTo(x, y + radius);
    ctx.quadraticCurveTo(x, y, x + radius, y);
  } else {
    ctx.moveTo(x + radius, y);
    ctx.lineTo(x + width - radius, y);
    ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
    ctx.lineTo(x + width, y + height - radius);
    ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
    ctx.lineTo(x + radius, y + height);
    ctx.quadraticCurveTo(x, y + height, x, y + height - radius);
    ctx.lineTo(x, y + radius);
    ctx.quadraticCurveTo(x, y, x + radius, y);
  }
}

// Helper: Dimension Arrows & Leader lines
function drawDimArrow(ctx, x1, y1, x2, y2, isVert) {
  ctx.beginPath();
  ctx.moveTo(x1, y1);
  ctx.lineTo(x2, y2);
  ctx.stroke();

  const arrLen = 4;
  if (isVert) {
    ctx.beginPath();
    ctx.moveTo(x1 - 2.5, y1 - arrLen); ctx.lineTo(x1, y1); ctx.lineTo(x1 + 2.5, y1 - arrLen);
    ctx.moveTo(x2 - 2.5, y2 + arrLen); ctx.lineTo(x2, y2); ctx.lineTo(x2 + 2.5, y2 + arrLen);
    ctx.stroke();
  } else {
    ctx.beginPath();
    ctx.moveTo(x1 + arrLen, y1 - 2.5); ctx.lineTo(x1, y1); ctx.lineTo(x1 + arrLen, y1 + 2.5);
    ctx.moveTo(x2 - arrLen, y2 - 2.5); ctx.lineTo(x2, y2); ctx.lineTo(x2 - arrLen, y2 + 2.5);
    ctx.stroke();
  }
}

function drawLeader(ctx, fromX, fromY, toX, toY) {
  ctx.beginPath();
  ctx.moveTo(fromX, fromY);
  ctx.lineTo(toX, toY);
  ctx.stroke();

  const angle = Math.atan2(toY - fromY, toX - fromX);
  ctx.beginPath();
  ctx.moveTo(toX, toY);
  ctx.lineTo(toX - 5 * Math.cos(angle - Math.PI / 6), toY - 5 * Math.sin(angle - Math.PI / 6));
  ctx.moveTo(toX, toY);
  ctx.lineTo(toX - 5 * Math.cos(angle + Math.PI / 6), toY - 5 * Math.sin(angle + Math.PI / 6));
  ctx.stroke();
}

// Navigation & Actions
function setupEvents() {
  document.getElementById("calcBtn").onclick = showCalculatorScreen;
  document.getElementById("shareBtn").onclick = () => {
    navigator.clipboard.writeText(`${currentSection.designation} - Mass: ${currentSection.massPerMetre} kg/m`);
    alert(`Copied ${currentSection.designation} specs to clipboard!`);
  };

  document.getElementById("navBackBtn").onclick = () => {
    if (currentScreen === "calculator" || currentScreen === "size_picker") {
      showDetailScreen();
    } else if (currentScreen === "detail") {
      showCategoryListScreen();
    }
  };

  document.getElementById("navHomeBtn").onclick = showCategoryListScreen;
}

window.onload = init;
