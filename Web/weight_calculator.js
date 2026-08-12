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
                category: "IS Medium Channels (ISMC)",
                items: [
                    { name: "ISMC 75", h: 75, b: 40, tw: 4.4, tf: 7.3, mass: 7.14 },
                    { name: "ISMC 100", h: 100, b: 50, tw: 4.7, tf: 7.5, mass: 9.56 },
                    { name: "ISMC 125", h: 125, b: 65, tw: 5.3, tf: 8.1, mass: 13.1 },
                    { name: "ISMC 150", h: 150, b: 75, tw: 5.7, tf: 7.8, mass: 16.8 },
                    { name: "ISMC 175", h: 175, b: 75, tw: 6.0, tf: 10.2, mass: 19.6 },
                    { name: "ISMC 200", h: 200, b: 75, tw: 6.2, tf: 11.4, mass: 22.3 },
                    { name: "ISMC 225", h: 225, b: 80, tw: 6.4, tf: 12.4, mass: 26.1 },
                    { name: "ISMC 250", h: 250, b: 80, tw: 7.2, tf: 14.1, mass: 30.7 },
                    { name: "ISMC 300", h: 300, b: 90, tw: 7.8, tf: 13.6, mass: 36.3 },
                    { name: "ISMC 350", h: 350, b: 100, tw: 8.1, tf: 14.1, mass: 42.7 },
                    { name: "ISMC 400", h: 400, b: 100, tw: 8.6, tf: 15.3, mass: 50.1 }
                ]
            },
            {
                category: "IS Light Channels (ISLC)",
                items: [
                    { name: "ISLC 75", h: 75, b: 40, tw: 3.7, tf: 6.0, mass: 5.7 },
                    { name: "ISLC 100", h: 100, b: 50, tw: 4.0, tf: 6.4, mass: 7.9 },
                    { name: "ISLC 125", h: 125, b: 65, tw: 4.4, tf: 6.6, mass: 10.7 },
                    { name: "ISLC 150", h: 150, b: 75, tw: 4.8, tf: 7.8, mass: 14.4 },
                    { name: "ISLC 175", h: 175, b: 75, tw: 5.1, tf: 8.0, mass: 16.7 },
                    { name: "ISLC 200", h: 200, b: 90, tw: 5.3, tf: 8.6, mass: 20.6 },
                    { name: "ISLC 225", h: 225, b: 90, tw: 5.8, tf: 9.6, mass: 24.0 },
                    { name: "ISLC 250", h: 250, b: 100, tw: 6.1, tf: 10.7, mass: 28.0 },
                    { name: "ISLC 300", h: 300, b: 100, tw: 6.7, tf: 11.6, mass: 34.4 }
                ]
            },
            {
                category: "IS Junior Channels (ISJC)",
                items: [
                    { name: "ISJC 100", h: 100, b: 45, tw: 3.0, tf: 4.7, mass: 5.8 },
                    { name: "ISJC 125", h: 125, b: 50, tw: 3.0, tf: 5.0, mass: 7.9 },
                    { name: "ISJC 150", h: 150, b: 55, tw: 3.6, tf: 5.4, mass: 9.9 },
                    { name: "ISJC 175", h: 175, b: 60, tw: 3.6, tf: 5.7, mass: 11.4 },
                    { name: "ISJC 200", h: 200, b: 70, tw: 4.1, tf: 6.2, mass: 13.9 }
                ]
            }
        ],
        'ANSI/AISC': [
            {
                category: "American Standard Channels (C & MC)",
                items: [
                    { name: "C 3x4.1", h: 76.2, b: 35.8, tw: 4.3, tf: 6.9, mass: 6.1 },
                    { name: "C 4x5.4", h: 101.6, b: 40.2, tw: 4.7, tf: 7.5, mass: 8.0 },
                    { name: "C 5x6.7", h: 127.0, b: 44.5, tw: 4.8, tf: 8.1, mass: 10.0 },
                    { name: "C 6x8.2", h: 152.4, b: 48.8, tw: 5.1, tf: 8.7, mass: 12.2 },
                    { name: "MC 6x12", h: 152.4, b: 63.4, tw: 8.0, tf: 9.8, mass: 17.9 },
                    { name: "C 8x11.5", h: 203.2, b: 57.4, tw: 5.6, tf: 9.9, mass: 17.1 },
                    { name: "C 10x15.3", h: 254.0, b: 66.0, tw: 6.1, tf: 11.1, mass: 22.8 },
                    { name: "C 12x20.7", h: 304.8, b: 74.7, tw: 7.2, tf: 12.7, mass: 30.8 },
                    { name: "C 15x33.9", h: 381.0, b: 86.4, tw: 10.2, tf: 16.5, mass: 50.4 }
                ]
            }
        ],
        'BS 4 : Part 1': [
            {
                category: "Parallel Flange Channels (PFC)",
                items: [
                    { name: "PFC 125x65", h: 125, b: 65, tw: 5.5, tf: 9.5, mass: 13.4 },
                    { name: "PFC 150x75", h: 150, b: 75, tw: 5.5, tf: 10.0, mass: 17.9 },
                    { name: "PFC 180x75", h: 180, b: 75, tw: 6.0, tf: 10.5, mass: 20.3 },
                    { name: "PFC 200x75", h: 200, b: 75, tw: 6.0, tf: 11.0, mass: 23.4 },
                    { name: "PFC 230x75", h: 230, b: 75, tw: 6.5, tf: 11.5, mass: 25.7 },
                    { name: "PFC 260x75", h: 260, b: 75, tw: 7.0, tf: 12.0, mass: 27.6 },
                    { name: "PFC 300x90", h: 300, b: 90, tw: 9.0, tf: 15.5, mass: 41.4 },
                    { name: "PFC 380x100", h: 380, b: 100, tw: 9.5, tf: 17.5, mass: 54.0 },
                    { name: "PFC 400x100", h: 400, b: 100, tw: 10.0, tf: 18.0, mass: 58.4 }
                ]
            }
        ],
        'AS 3679': [
            {
                category: "Australian Channels (PFC)",
                items: [
                    { name: "75PFC", h: 75, b: 40, tw: 4.5, tf: 6.0, mass: 5.9 },
                    { name: "100PFC", h: 100, b: 50, tw: 5.0, tf: 6.7, mass: 8.6 },
                    { name: "125PFC", h: 125, b: 65, tw: 5.5, tf: 7.5, mass: 11.9 },
                    { name: "150PFC", h: 150, b: 75, tw: 6.0, tf: 9.5, mass: 17.7 },
                    { name: "180PFC", h: 180, b: 75, tw: 6.0, tf: 10.5, mass: 20.9 },
                    { name: "200PFC", h: 200, b: 75, tw: 6.0, tf: 11.0, mass: 22.9 },
                    { name: "230PFC", h: 230, b: 75, tw: 6.5, tf: 12.0, mass: 25.1 },
                    { name: "250PFC", h: 250, b: 90, tw: 8.0, tf: 13.0, mass: 35.5 },
                    { name: "300PFC", h: 300, b: 90, tw: 8.0, tf: 14.0, mass: 40.1 }
                ]
            }
        ],
        'ISO 657': [
            {
                category: "ISO Standard Channels (UPN)",
                items: [
                    { name: "UPN 80", h: 80, b: 45, tw: 6.0, tf: 8.0, mass: 8.64 },
                    { name: "UPN 100", h: 100, b: 50, tw: 6.0, tf: 8.5, mass: 10.6 },
                    { name: "UPN 120", h: 120, b: 55, tw: 7.0, tf: 9.0, mass: 13.4 },
                    { name: "UPN 140", h: 140, b: 60, tw: 7.0, tf: 10.0, mass: 16.0 },
                    { name: "UPN 160", h: 160, b: 65, tw: 7.5, tf: 10.5, mass: 18.8 },
                    { name: "UPN 180", h: 180, b: 70, tw: 8.0, tf: 11.0, mass: 22.0 },
                    { name: "UPN 200", h: 200, b: 75, tw: 8.5, tf: 11.5, mass: 25.3 },
                    { name: "UPN 240", h: 240, b: 85, tw: 9.5, tf: 13.0, mass: 33.2 },
                    { name: "UPN 300", h: 300, b: 100, tw: 10.0, tf: 16.0, mass: 46.2 }
                ]
            }
        ]
    },
    beam: {
        'IS 808': [
            {
                category: "IS Medium Beams (ISMB)",
                items: [
                    { name: "ISMB 100", h: 100, b: 50, tw: 4.7, tf: 7.0, mass: 8.9 },
                    { name: "ISMB 125", h: 125, b: 75, tw: 4.4, tf: 7.6, mass: 13.0 },
                    { name: "ISMB 150", h: 150, b: 75, tw: 5.0, tf: 8.0, mass: 15.0 },
                    { name: "ISMB 175", h: 175, b: 85, tw: 5.8, tf: 9.0, mass: 19.3 },
                    { name: "ISMB 200", h: 200, b: 100, tw: 5.7, tf: 10.8, mass: 25.4 },
                    { name: "ISMB 225", h: 225, b: 110, tw: 6.5, tf: 11.8, mass: 31.2 },
                    { name: "ISMB 250", h: 250, b: 125, tw: 6.9, tf: 12.5, mass: 37.3 },
                    { name: "ISMB 300", h: 300, b: 140, tw: 7.5, tf: 13.1, mass: 44.2 },
                    { name: "ISMB 350", h: 350, b: 140, tw: 8.1, tf: 14.2, mass: 52.4 },
                    { name: "ISMB 400", h: 400, b: 140, tw: 8.9, tf: 16.0, mass: 61.6 },
                    { name: "ISMB 450", h: 450, b: 150, tw: 9.4, tf: 17.4, mass: 72.4 },
                    { name: "ISMB 500", h: 500, b: 180, tw: 10.2, tf: 17.2, mass: 86.9 },
                    { name: "ISMB 550", h: 550, b: 190, tw: 11.2, tf: 19.3, mass: 103.7 },
                    { name: "ISMB 600", h: 600, b: 210, tw: 12.0, tf: 20.8, mass: 122.6 }
                ]
            },
            {
                category: "IS Light Beams (ISLB)",
                items: [
                    { name: "ISLB 75", h: 75, b: 50, tw: 3.7, tf: 5.0, mass: 6.1 },
                    { name: "ISLB 100", h: 100, b: 50, tw: 4.0, tf: 6.4, mass: 8.0 },
                    { name: "ISLB 125", h: 125, b: 75, tw: 4.4, tf: 6.5, mass: 11.9 },
                    { name: "ISLB 150", h: 150, b: 80, tw: 4.8, tf: 6.8, mass: 14.2 },
                    { name: "ISLB 175", h: 175, b: 90, tw: 5.1, tf: 7.3, mass: 16.7 },
                    { name: "ISLB 200", h: 200, b: 100, tw: 5.4, tf: 7.3, mass: 19.8 },
                    { name: "ISLB 225", h: 225, b: 100, tw: 5.6, tf: 8.6, mass: 22.2 },
                    { name: "ISLB 250", h: 250, b: 125, tw: 6.1, tf: 8.2, mass: 27.9 },
                    { name: "ISLB 300", h: 300, b: 150, tw: 6.7, tf: 9.4, mass: 36.9 },
                    { name: "ISLB 350", h: 350, b: 165, tw: 7.4, tf: 11.4, mass: 49.5 },
                    { name: "ISLB 400", h: 400, b: 165, tw: 8.0, tf: 12.5, mass: 56.9 },
                    { name: "ISLB 450", h: 450, b: 170, tw: 8.6, tf: 13.4, mass: 65.3 },
                    { name: "ISLB 500", h: 500, b: 180, tw: 9.2, tf: 14.1, mass: 75.0 },
                    { name: "ISLB 600", h: 600, b: 210, tw: 10.5, tf: 15.5, mass: 99.5 }
                ]
            },
            {
                category: "IS Wide Flange Beams (ISWB)",
                items: [
                    { name: "ISWB 150", h: 150, b: 100, tw: 5.4, tf: 7.0, mass: 17.0 },
                    { name: "ISWB 175", h: 175, b: 125, tw: 5.8, tf: 7.4, mass: 22.1 },
                    { name: "ISWB 200", h: 200, b: 140, tw: 6.1, tf: 9.0, mass: 28.8 },
                    { name: "ISWB 225", h: 225, b: 150, tw: 6.4, tf: 9.9, mass: 33.9 },
                    { name: "ISWB 250", h: 250, b: 200, tw: 6.7, tf: 9.0, mass: 40.9 },
                    { name: "ISWB 300", h: 300, b: 200, tw: 7.4, tf: 10.0, mass: 48.1 },
                    { name: "ISWB 350", h: 350, b: 250, tw: 8.0, tf: 11.4, mass: 56.9 },
                    { name: "ISWB 400", h: 400, b: 250, tw: 8.6, tf: 12.7, mass: 66.7 },
                    { name: "ISWB 450", h: 450, b: 250, tw: 9.2, tf: 13.7, mass: 79.3 },
                    { name: "ISWB 500", h: 500, b: 250, tw: 9.9, tf: 14.7, mass: 95.2 },
                    { name: "ISWB 600", h: 600, b: 250, tw: 11.2, tf: 18.0, mass: 133.7 }
                ]
            },
            {
                category: "IS Heavy Beams / Columns (ISHB)",
                items: [
                    { name: "ISHB 150", h: 150, b: 150, tw: 5.4, tf: 8.4, mass: 27.1 },
                    { name: "ISHB 200", h: 200, b: 200, tw: 6.1, tf: 9.0, mass: 37.3 },
                    { name: "ISHB 225", h: 225, b: 225, tw: 6.5, tf: 9.1, mass: 43.1 },
                    { name: "ISHB 250", h: 250, b: 250, tw: 6.7, tf: 9.0, mass: 51.0 },
                    { name: "ISHB 300", h: 300, b: 300, tw: 7.6, tf: 10.6, mass: 63.0 },
                    { name: "ISHB 350", h: 350, b: 250, tw: 8.3, tf: 11.6, mass: 67.4 },
                    { name: "ISHB 400", h: 400, b: 250, tw: 9.1, tf: 12.7, mass: 77.4 },
                    { name: "ISHB 450", h: 450, b: 250, tw: 9.8, tf: 13.7, mass: 87.2 }
                ]
            }
        ],
        'ANSI/AISC': [
            {
                category: "AISC Wide Flange Beams (W Shapes)",
                items: [
                    { name: "W 4x13", h: 106, b: 103, tw: 7.1, tf: 8.8, mass: 19.3 },
                    { name: "W 6x9", h: 150, b: 100, tw: 4.3, tf: 5.5, mass: 13.4 },
                    { name: "W 6x15", h: 152, b: 152, tw: 5.8, tf: 6.6, mass: 22.5 },
                    { name: "W 8x10", h: 200, b: 100, tw: 4.3, tf: 5.2, mass: 14.9 },
                    { name: "W 8x18", h: 207, b: 133, tw: 5.8, tf: 8.4, mass: 26.8 },
                    { name: "W 8x24", h: 203, b: 165, tw: 6.2, tf: 10.2, mass: 35.7 },
                    { name: "W 10x12", h: 251, b: 101, tw: 4.8, tf: 5.3, mass: 17.9 },
                    { name: "W 10x19", h: 260, b: 102, tw: 6.4, tf: 10.0, mass: 28.3 },
                    { name: "W 10x30", h: 266, b: 148, tw: 7.6, tf: 13.0, mass: 44.6 },
                    { name: "W 12x16", h: 305, b: 101, tw: 5.6, tf: 6.7, mass: 23.8 },
                    { name: "W 12x26", h: 310, b: 165, tw: 5.8, tf: 9.7, mass: 38.7 },
                    { name: "W 12x40", h: 303, b: 203, tw: 7.5, tf: 13.1, mass: 59.5 },
                    { name: "W 14x22", h: 349, b: 127, tw: 5.8, tf: 8.5, mass: 32.7 },
                    { name: "W 14x34", h: 356, b: 171, tw: 7.2, tf: 11.6, mass: 50.6 },
                    { name: "W 16x26", h: 399, b: 140, tw: 6.4, tf: 8.8, mass: 38.7 },
                    { name: "W 18x35", h: 450, b: 152, tw: 7.6, tf: 10.8, mass: 52.1 },
                    { name: "W 21x44", h: 526, b: 165, tw: 8.9, tf: 11.4, mass: 65.5 },
                    { name: "W 24x55", h: 599, b: 178, tw: 10.0, tf: 12.8, mass: 81.8 }
                ]
            },
            {
                category: "American Standard Beams (S Shapes)",
                items: [
                    { name: "S 3x5.7", h: 76.2, b: 59.2, tw: 4.3, tf: 6.6, mass: 8.5 },
                    { name: "S 4x7.7", h: 101.6, b: 67.6, tw: 4.9, tf: 7.4, mass: 11.5 },
                    { name: "S 6x12.5", h: 152.4, b: 84.6, tw: 5.9, tf: 9.1, mass: 18.6 },
                    { name: "S 8x18.4", h: 203.2, b: 101.6, tw: 6.9, tf: 10.8, mass: 27.4 },
                    { name: "S 10x25.4", h: 254.0, b: 118.4, tw: 7.9, tf: 12.5, mass: 37.8 },
                    { name: "S 12x31.8", h: 304.8, b: 127.0, tw: 8.9, tf: 14.2, mass: 47.3 }
                ]
            }
        ],
        'BS 4 : Part 1': [
            {
                category: "Universal Beams (UB)",
                items: [
                    { name: "127x76x13UB", h: 127, b: 76, tw: 4.0, tf: 7.6, mass: 13.0 },
                    { name: "152x89x16UB", h: 152, b: 89, tw: 4.5, tf: 7.7, mass: 16.0 },
                    { name: "178x102x19UB", h: 178, b: 102, tw: 4.8, tf: 7.9, mass: 19.0 },
                    { name: "203x102x23UB", h: 203, b: 102, tw: 5.4, tf: 9.3, mass: 23.1 },
                    { name: "203x133x25UB", h: 203, b: 133, tw: 5.7, tf: 7.8, mass: 25.1 },
                    { name: "254x102x22UB", h: 254, b: 102, tw: 5.7, tf: 6.8, mass: 22.0 },
                    { name: "254x146x31UB", h: 251, b: 146, tw: 6.0, tf: 8.6, mass: 31.1 },
                    { name: "305x102x25UB", h: 305, b: 102, tw: 5.8, tf: 6.8, mass: 24.8 },
                    { name: "305x165x40UB", h: 303, b: 165, tw: 6.0, tf: 10.2, mass: 40.3 },
                    { name: "356x127x33UB", h: 349, b: 127, tw: 6.0, tf: 8.5, mass: 33.1 },
                    { name: "406x140x39UB", h: 398, b: 142, tw: 6.4, tf: 8.6, mass: 39.0 },
                    { name: "457x152x52UB", h: 450, b: 153, tw: 7.6, tf: 10.9, mass: 52.3 },
                    { name: "533x210x82UB", h: 528, b: 209, tw: 9.6, tf: 13.2, mass: 82.2 },
                    { name: "610x229x101UB", h: 603, b: 228, tw: 10.5, tf: 14.8, mass: 101.2 }
                ]
            },
            {
                category: "Universal Columns (UC)",
                items: [
                    { name: "152x152x23UC", h: 152, b: 152, tw: 5.8, tf: 6.8, mass: 23.0 },
                    { name: "203x203x46UC", h: 203, b: 203, tw: 7.2, tf: 11.0, mass: 46.1 },
                    { name: "254x254x73UC", h: 254, b: 254, tw: 8.6, tf: 14.2, mass: 73.1 },
                    { name: "305x305x97UC", h: 308, b: 305, tw: 9.9, tf: 15.4, mass: 96.9 }
                ]
            }
        ],
        'AS 3679': [
            {
                category: "Australian Universal Beams (UB)",
                items: [
                    { name: "150UB14", h: 150, b: 75, tw: 5.0, tf: 7.0, mass: 14.0 },
                    { name: "150UB18", h: 155, b: 100, tw: 6.0, tf: 8.0, mass: 18.0 },
                    { name: "180UB16", h: 173, b: 90, tw: 4.5, tf: 7.0, mass: 16.1 },
                    { name: "200UB18", h: 198, b: 99, tw: 4.5, tf: 7.0, mass: 18.2 },
                    { name: "200UB25", h: 203, b: 133, tw: 5.8, tf: 7.8, mass: 25.4 },
                    { name: "250UB25", h: 248, b: 124, tw: 5.0, tf: 8.0, mass: 25.7 },
                    { name: "250UB31", h: 252, b: 146, tw: 6.1, tf: 8.6, mass: 31.4 },
                    { name: "310UB32", h: 305, b: 99, tw: 5.5, tf: 6.7, mass: 32.0 },
                    { name: "310UB40", h: 304, b: 165, tw: 6.1, tf: 10.2, mass: 40.4 },
                    { name: "360UB45", h: 352, b: 171, tw: 6.9, tf: 9.7, mass: 44.7 },
                    { name: "410UB54", h: 403, b: 178, tw: 7.6, tf: 10.9, mass: 53.7 },
                    { name: "460UB67", h: 454, b: 190, tw: 8.5, tf: 12.7, mass: 67.1 },
                    { name: "530UB82", h: 528, b: 209, tw: 9.6, tf: 13.2, mass: 82.0 },
                    { name: "610UB101", h: 603, b: 228, tw: 10.6, tf: 14.8, mass: 101.0 }
                ]
            },
            {
                category: "Australian Universal Columns (UC)",
                items: [
                    { name: "100UC15", h: 97, b: 99, tw: 5.0, tf: 7.0, mass: 14.8 },
                    { name: "150UC23", h: 152, b: 152, tw: 6.0, tf: 6.8, mass: 23.4 },
                    { name: "150UC30", h: 158, b: 153, tw: 6.5, tf: 9.4, mass: 30.0 },
                    { name: "200UC46", h: 203, b: 203, tw: 7.3, tf: 11.0, mass: 46.2 },
                    { name: "250UC73", h: 254, b: 254, tw: 8.6, tf: 14.2, mass: 72.9 },
                    { name: "310UC97", h: 308, b: 305, tw: 9.9, tf: 15.4, mass: 96.8 }
                ]
            }
        ],
        'ISO 657': [
            {
                category: "ISO Parallel Flange Beams (IPE)",
                items: [
                    { name: "IPE 80", h: 80, b: 46, tw: 3.8, tf: 5.2, mass: 6.0 },
                    { name: "IPE 100", h: 100, b: 55, tw: 4.1, tf: 5.7, mass: 8.1 },
                    { name: "IPE 120", h: 120, b: 64, tw: 4.4, tf: 6.3, mass: 10.4 },
                    { name: "IPE 140", h: 140, b: 73, tw: 4.7, tf: 6.9, mass: 12.9 },
                    { name: "IPE 160", h: 160, b: 82, tw: 5.0, tf: 7.4, mass: 15.8 },
                    { name: "IPE 180", h: 180, b: 91, tw: 5.3, tf: 8.0, mass: 18.8 },
                    { name: "IPE 200", h: 200, b: 100, tw: 5.6, tf: 8.5, mass: 22.4 },
                    { name: "IPE 220", h: 220, b: 110, tw: 5.9, tf: 9.2, mass: 26.2 },
                    { name: "IPE 240", h: 240, b: 120, tw: 6.2, tf: 9.8, mass: 30.7 },
                    { name: "IPE 270", h: 270, b: 135, tw: 6.6, tf: 10.2, mass: 36.1 },
                    { name: "IPE 300", h: 300, b: 150, tw: 7.1, tf: 10.7, mass: 42.2 },
                    { name: "IPE 330", h: 330, b: 160, tw: 7.5, tf: 11.5, mass: 49.1 },
                    { name: "IPE 360", h: 360, b: 170, tw: 8.0, tf: 12.7, mass: 57.1 },
                    { name: "IPE 400", h: 400, b: 180, tw: 8.6, tf: 13.5, mass: 66.3 },
                    { name: "IPE 450", h: 450, b: 190, tw: 9.4, tf: 14.6, mass: 77.6 },
                    { name: "IPE 500", h: 500, b: 200, tw: 10.2, tf: 16.0, mass: 90.7 }
                ]
            }
        ]
    },
    angle: {
        'IS 808': [
            {
                category: "IS Equal Angles (ISA)",
                items: [
                    { name: "20x20x3", a: 20, b: 20, t: 3, mass: 0.9 },
                    { name: "25x25x3", a: 25, b: 25, t: 3, mass: 1.1 },
                    { name: "25x25x4", a: 25, b: 25, t: 4, mass: 1.4 },
                    { name: "30x30x3", a: 30, b: 30, t: 3, mass: 1.4 },
                    { name: "30x30x4", a: 30, b: 30, t: 4, mass: 1.8 },
                    { name: "35x35x3", a: 35, b: 35, t: 3, mass: 1.6 },
                    { name: "35x35x4", a: 35, b: 35, t: 4, mass: 2.1 },
                    { name: "40x40x3", a: 40, b: 40, t: 3, mass: 1.8 },
                    { name: "40x40x4", a: 40, b: 40, t: 4, mass: 2.4 },
                    { name: "40x40x5", a: 40, b: 40, t: 5, mass: 3.0 },
                    { name: "45x45x3", a: 45, b: 45, t: 3, mass: 2.1 },
                    { name: "45x45x5", a: 45, b: 45, t: 5, mass: 3.4 },
                    { name: "50x50x3", a: 50, b: 50, t: 3, mass: 2.3 },
                    { name: "50x50x4", a: 50, b: 50, t: 4, mass: 3.0 },
                    { name: "50x50x5", a: 50, b: 50, t: 5, mass: 3.8 },
                    { name: "50x50x6", a: 50, b: 50, t: 6, mass: 4.5 },
                    { name: "60x60x5", a: 60, b: 60, t: 5, mass: 4.5 },
                    { name: "60x60x6", a: 60, b: 60, t: 6, mass: 5.4 },
                    { name: "65x65x5", a: 65, b: 65, t: 5, mass: 4.9 },
                    { name: "65x65x6", a: 65, b: 65, t: 6, mass: 5.8 },
                    { name: "65x65x8", a: 65, b: 65, t: 8, mass: 7.7 },
                    { name: "75x75x6", a: 75, b: 75, t: 6, mass: 6.8 },
                    { name: "75x75x8", a: 75, b: 75, t: 8, mass: 8.9 },
                    { name: "75x75x10", a: 75, b: 75, t: 10, mass: 11.0 },
                    { name: "80x80x6", a: 80, b: 80, t: 6, mass: 7.3 },
                    { name: "80x80x8", a: 80, b: 80, t: 8, mass: 9.6 },
                    { name: "80x80x10", a: 80, b: 80, t: 10, mass: 11.9 },
                    { name: "90x90x6", a: 90, b: 90, t: 6, mass: 8.2 },
                    { name: "90x90x8", a: 90, b: 90, t: 8, mass: 10.8 },
                    { name: "90x90x10", a: 90, b: 90, t: 10, mass: 13.4 },
                    { name: "100x100x6", a: 100, b: 100, t: 6, mass: 9.2 },
                    { name: "100x100x8", a: 100, b: 100, t: 8, mass: 12.1 },
                    { name: "100x100x10", a: 100, b: 100, t: 10, mass: 14.9 },
                    { name: "100x100x12", a: 100, b: 100, t: 12, mass: 17.7 },
                    { name: "130x130x10", a: 130, b: 130, t: 10, mass: 19.7 },
                    { name: "150x150x12", a: 150, b: 150, t: 12, mass: 27.2 },
                    { name: "200x200x15", a: 200, b: 200, t: 15, mass: 45.3 }
                ]
            },
            {
                category: "IS Unequal Angles (ISA)",
                items: [
                    { name: "30x20x3", a: 30, b: 20, t: 3, mass: 1.1 },
                    { name: "40x25x4", a: 40, b: 25, t: 4, mass: 1.9 },
                    { name: "45x30x4", a: 45, b: 30, t: 4, mass: 2.2 },
                    { name: "50x30x4", a: 50, b: 30, t: 4, mass: 2.4 },
                    { name: "50x30x5", a: 50, b: 30, t: 5, mass: 3.0 },
                    { name: "60x40x5", a: 60, b: 40, t: 5, mass: 3.7 },
                    { name: "65x45x5", a: 65, b: 45, t: 5, mass: 4.1 },
                    { name: "75x50x6", a: 75, b: 50, t: 6, mass: 5.6 },
                    { name: "75x50x8", a: 75, b: 50, t: 8, mass: 7.3 },
                    { name: "80x50x6", a: 80, b: 50, t: 6, mass: 5.8 },
                    { name: "90x60x6", a: 90, b: 60, t: 6, mass: 6.8 },
                    { name: "90x60x8", a: 90, b: 60, t: 8, mass: 8.9 },
                    { name: "100x65x6", a: 100, b: 65, t: 6, mass: 7.5 },
                    { name: "100x65x8", a: 100, b: 65, t: 8, mass: 9.9 },
                    { name: "100x75x8", a: 100, b: 75, t: 8, mass: 10.5 },
                    { name: "125x75x8", a: 125, b: 75, t: 8, mass: 12.1 },
                    { name: "150x90x10", a: 150, b: 90, t: 10, mass: 18.2 },
                    { name: "200x100x12", a: 200, b: 100, t: 12, mass: 27.3 }
                ]
            }
        ],
        'ANSI/AISC': [
            {
                category: "AISC Equal Angles (L Shapes)",
                items: [
                    { name: "L 2x2x1/8", a: 50.8, b: 50.8, t: 3.2, mass: 2.45 },
                    { name: "L 2x2x3/16", a: 50.8, b: 50.8, t: 4.8, mass: 3.63 },
                    { name: "L 2x2x1/4", a: 50.8, b: 50.8, t: 6.4, mass: 4.75 },
                    { name: "L 2.5x2.5x1/4", a: 63.5, b: 63.5, t: 6.4, mass: 6.1 },
                    { name: "L 3x3x3/16", a: 76.2, b: 76.2, t: 4.8, mass: 5.5 },
                    { name: "L 3x3x1/4", a: 76.2, b: 76.2, t: 6.4, mass: 7.3 },
                    { name: "L 3x3x3/8", a: 76.2, b: 76.2, t: 9.5, mass: 10.7 },
                    { name: "L 4x4x1/4", a: 101.6, b: 101.6, t: 6.4, mass: 9.8 },
                    { name: "L 4x4x3/8", a: 101.6, b: 101.6, t: 9.5, mass: 14.6 },
                    { name: "L 4x4x1/2", a: 101.6, b: 101.6, t: 12.7, mass: 19.0 },
                    { name: "L 5x5x3/8", a: 127.0, b: 127.0, t: 9.5, mass: 18.3 },
                    { name: "L 6x6x3/8", a: 152.4, b: 152.4, t: 9.5, mass: 22.2 },
                    { name: "L 6x6x1/2", a: 152.4, b: 152.4, t: 12.7, mass: 29.2 },
                    { name: "L 8x8x1/2", a: 203.2, b: 203.2, t: 12.7, mass: 39.3 }
                ]
            },
            {
                category: "AISC Unequal Angles (L Shapes)",
                items: [
                    { name: "L 3x2x3/16", a: 76.2, b: 50.8, t: 4.8, mass: 4.6 },
                    { name: "L 4x3x1/4", a: 101.6, b: 76.2, t: 6.4, mass: 8.6 },
                    { name: "L 5x3.5x5/16", a: 127.0, b: 88.9, t: 7.9, mass: 13.0 },
                    { name: "L 6x4x3/8", a: 152.4, b: 101.6, t: 9.5, mass: 18.3 },
                    { name: "L 8x6x1/2", a: 203.2, b: 152.4, t: 12.7, mass: 34.2 }
                ]
            }
        ],
        'BS 4 : Part 1': [
            {
                category: "British Equal Angles",
                items: [
                    { name: "L 40x40x4", a: 40, b: 40, t: 4, mass: 2.42 },
                    { name: "L 50x50x5", a: 50, b: 50, t: 5, mass: 3.77 },
                    { name: "L 60x60x6", a: 60, b: 60, t: 6, mass: 5.42 },
                    { name: "L 75x75x6", a: 75, b: 75, t: 6, mass: 6.85 },
                    { name: "L 75x75x8", a: 75, b: 75, t: 8, mass: 8.99 },
                    { name: "L 90x90x8", a: 90, b: 90, t: 8, mass: 10.9 },
                    { name: "L 100x100x10", a: 100, b: 100, t: 10, mass: 15.0 },
                    { name: "L 120x120x10", a: 120, b: 120, t: 10, mass: 18.2 },
                    { name: "L 150x150x12", a: 150, b: 150, t: 12, mass: 27.3 },
                    { name: "L 200x200x16", a: 200, b: 200, t: 16, mass: 48.5 }
                ]
            },
            {
                category: "British Unequal Angles",
                items: [
                    { name: "L 65x50x6", a: 65, b: 50, t: 6, mass: 5.16 },
                    { name: "L 75x50x6", a: 75, b: 50, t: 6, mass: 5.65 },
                    { name: "L 100x65x8", a: 100, b: 65, t: 8, mass: 9.94 },
                    { name: "L 125x75x8", a: 125, b: 75, t: 8, mass: 12.2 },
                    { name: "L 150x90x10", a: 150, b: 90, t: 10, mass: 18.2 },
                    { name: "L 200x100x12", a: 200, b: 100, t: 12, mass: 27.3 }
                ]
            }
        ],
        'AS 3679': [
            {
                category: "Australian Equal Angles (EA)",
                items: [
                    { name: "25x25x3EA", a: 25, b: 25, t: 3, mass: 1.12 },
                    { name: "30x30x3EA", a: 30, b: 30, t: 3, mass: 1.35 },
                    { name: "40x40x3EA", a: 40, b: 40, t: 3, mass: 1.83 },
                    { name: "50x50x3EA", a: 50, b: 50, t: 3, mass: 2.31 },
                    { name: "65x65x5EA", a: 65, b: 65, t: 5, mass: 4.87 },
                    { name: "75x75x6EA", a: 75, b: 75, t: 6, mass: 6.81 },
                    { name: "90x90x6EA", a: 90, b: 90, t: 6, mass: 8.22 },
                    { name: "100x100x6EA", a: 100, b: 100, t: 6, mass: 9.16 },
                    { name: "125x125x8EA", a: 125, b: 125, t: 8, mass: 14.9 },
                    { name: "150x150x10EA", a: 150, b: 150, t: 10, mass: 22.8 },
                    { name: "200x200x13EA", a: 200, b: 200, t: 13, mass: 39.8 }
                ]
            },
            {
                category: "Australian Unequal Angles (UA)",
                items: [
                    { name: "65x50x5UA", a: 65, b: 50, t: 5, mass: 4.28 },
                    { name: "75x50x6UA", a: 75, b: 50, t: 6, mass: 5.56 },
                    { name: "100x75x6UA", a: 100, b: 75, t: 6, mass: 7.98 },
                    { name: "125x75x6UA", a: 125, b: 75, t: 6, mass: 9.16 },
                    { name: "150x100x10UA", a: 150, b: 100, t: 10, mass: 18.9 }
                ]
            }
        ],
        'ISO 657': [
            {
                category: "ISO Equal Angles (ISO 657/1)",
                items: [
                    { name: "20x20x3", a: 20, b: 20, t: 3, mass: 0.88 },
                    { name: "25x25x3", a: 25, b: 25, t: 3, mass: 1.12 },
                    { name: "30x30x3", a: 30, b: 30, t: 3, mass: 1.36 },
                    { name: "40x40x4", a: 40, b: 40, t: 4, mass: 2.42 },
                    { name: "50x50x5", a: 50, b: 50, t: 5, mass: 3.77 },
                    { name: "60x60x6", a: 60, b: 60, t: 6, mass: 5.42 },
                    { name: "70x70x7", a: 70, b: 70, t: 7, mass: 7.38 },
                    { name: "80x80x8", a: 80, b: 80, t: 8, mass: 9.66 },
                    { name: "90x90x9", a: 90, b: 90, t: 9, mass: 12.2 },
                    { name: "100x100x10", a: 100, b: 100, t: 10, mass: 15.1 },
                    { name: "120x120x11", a: 120, b: 120, t: 11, mass: 19.9 },
                    { name: "150x150x12", a: 150, b: 150, t: 12, mass: 27.3 },
                    { name: "200x200x16", a: 200, b: 200, t: 16, mass: 48.5 }
                ]
            },
            {
                category: "ISO Unequal Angles (ISO 657/2)",
                items: [
                    { name: "30x20x3", a: 30, b: 20, t: 3, mass: 1.12 },
                    { name: "40x25x4", a: 40, b: 25, t: 4, mass: 1.93 },
                    { name: "50x30x5", a: 50, b: 30, t: 5, mass: 2.96 },
                    { name: "60x40x6", a: 60, b: 40, t: 6, mass: 4.46 },
                    { name: "75x50x7", a: 75, b: 50, t: 7, mass: 6.47 },
                    { name: "90x60x8", a: 90, b: 60, t: 8, mass: 8.96 },
                    { name: "100x65x9", a: 100, b: 65, t: 9, mass: 11.1 },
                    { name: "125x75x10", a: 125, b: 75, t: 10, mass: 15.0 },
                    { name: "150x90x11", a: 150, b: 90, t: 11, mass: 20.0 },
                    { name: "200x100x14", a: 200, b: 100, t: 14, mass: 31.4 }
                ]
            }
        ]
    },
    tee: {
        'IS 808': [
            {
                category: "IS Normal Tee Bars (ISNT)",
                items: [
                    { name: "ISNT 20", h: 20, b: 20, tw: 3.0, tf: 3.0, mass: 0.9 },
                    { name: "ISNT 25", h: 25, b: 25, tw: 3.5, tf: 3.5, mass: 1.3 },
                    { name: "ISNT 30", h: 30, b: 30, tw: 4.0, tf: 4.0, mass: 1.8 },
                    { name: "ISNT 40", h: 40, b: 40, tw: 5.0, tf: 5.0, mass: 2.9 },
                    { name: "ISNT 50", h: 50, b: 50, tw: 6.0, tf: 6.0, mass: 4.5 },
                    { name: "ISNT 60", h: 60, b: 60, tw: 6.0, tf: 6.0, mass: 5.4 },
                    { name: "ISNT 75", h: 75, b: 75, tw: 8.0, tf: 8.0, mass: 8.9 },
                    { name: "ISNT 80", h: 80, b: 80, tw: 8.0, tf: 8.0, mass: 9.6 },
                    { name: "ISNT 100", h: 100, b: 100, tw: 10.0, tf: 10.0, mass: 15.0 },
                    { name: "ISNT 150", h: 150, b: 150, tw: 12.0, tf: 12.0, mass: 27.2 }
                ]
            },
            {
                category: "IS Heavy Tee Bars (ISHT)",
                items: [
                    { name: "ISHT 75", h: 75, b: 75, tw: 5.4, tf: 8.4, mass: 13.5 },
                    { name: "ISHT 100", h: 100, b: 100, tw: 6.1, tf: 9.0, mass: 18.6 },
                    { name: "ISHT 125", h: 125, b: 125, tw: 6.5, tf: 9.1, mass: 21.5 },
                    { name: "ISHT 150", h: 150, b: 150, tw: 6.7, tf: 9.0, mass: 25.5 }
                ]
            },
            {
                category: "IS Slit Medium Weight Tee Bars (ISST)",
                items: [
                    { name: "ISST 100", h: 50, b: 100, tw: 4.7, tf: 7.0, mass: 4.5 },
                    { name: "ISST 150", h: 75, b: 150, tw: 5.0, tf: 8.0, mass: 7.5 },
                    { name: "ISST 200", h: 100, b: 200, tw: 5.7, tf: 10.8, mass: 12.7 },
                    { name: "ISST 250", h: 125, b: 250, tw: 6.9, tf: 12.5, mass: 18.6 },
                    { name: "ISST 300", h: 150, b: 300, tw: 7.5, tf: 13.1, mass: 22.1 }
                ]
            }
        ],
        'ANSI/AISC': [
            {
                category: "AISC Structural Tees (WT Shapes)",
                items: [
                    { name: "WT 3x6", h: 76.2, b: 101.6, tw: 5.6, tf: 6.7, mass: 8.9 },
                    { name: "WT 4x9", h: 101.6, b: 133.4, tw: 5.8, tf: 8.4, mass: 13.4 },
                    { name: "WT 5x15", h: 127.0, b: 148.0, tw: 7.6, tf: 13.0, mass: 22.3 },
                    { name: "WT 6x20", h: 152.4, b: 203.2, tw: 7.5, tf: 13.1, mass: 29.8 },
                    { name: "WT 7x30", h: 177.8, b: 171.5, tw: 9.8, tf: 15.6, mass: 44.6 },
                    { name: "WT 9x40", h: 228.6, b: 190.5, tw: 10.0, tf: 16.3, mass: 59.5 }
                ]
            }
        ],
        'BS 4 : Part 1': [
            {
                category: "BS Structural Tees",
                items: [
                    { name: "T 50x100", h: 50, b: 100, tw: 5.0, tf: 8.0, mass: 7.5 },
                    { name: "T 75x150", h: 75, b: 150, tw: 6.0, tf: 9.0, mass: 12.0 },
                    { name: "T 100x200", h: 100, b: 200, tw: 7.0, tf: 10.0, mass: 18.0 },
                    { name: "T 125x250", h: 125, b: 250, tw: 8.0, tf: 11.0, mass: 24.5 }
                ]
            }
        ],
        'AS 3679': [
            {
                category: "Australian Structural Tees",
                items: [
                    { name: "50x50T", h: 50, b: 50, tw: 5.0, tf: 5.0, mass: 3.7 },
                    { name: "75x75T", h: 75, b: 75, tw: 6.0, tf: 6.0, mass: 6.8 },
                    { name: "100x100T", h: 100, b: 100, tw: 8.0, tf: 8.0, mass: 12.1 },
                    { name: "125x125T", h: 125, b: 125, tw: 9.0, tf: 9.0, mass: 17.2 },
                    { name: "150x150T", h: 150, b: 150, tw: 10.0, tf: 10.0, mass: 22.8 }
                ]
            }
        ],
        'ISO 657': [
            {
                category: "ISO Standard Tees (T)",
                items: [
                    { name: "ISO T20", h: 20, b: 20, tw: 3.0, tf: 3.0, mass: 0.88 },
                    { name: "ISO T25", h: 25, b: 25, tw: 3.5, tf: 3.5, mass: 1.25 },
                    { name: "ISO T30", h: 30, b: 30, tw: 4.0, tf: 4.0, mass: 1.77 },
                    { name: "ISO T40", h: 40, b: 40, tw: 5.0, tf: 5.0, mass: 2.96 },
                    { name: "ISO T50", h: 50, b: 50, tw: 6.0, tf: 6.0, mass: 4.44 },
                    { name: "ISO T60", h: 60, b: 60, tw: 7.0, tf: 7.0, mass: 6.23 },
                    { name: "ISO T80", h: 80, b: 80, tw: 9.0, tf: 9.0, mass: 10.7 },
                    { name: "ISO T100", h: 100, b: 100, tw: 11.0, tf: 11.0, mass: 16.4 }
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
        case 'box':
            html = `
                <div class="wb-input-group">
                    <label>Height H (mm)</label>
                    <input type="number" id="inp_h" value="100" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Width B (mm)</label>
                    <input type="number" id="inp_w" value="50" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Wall Thickness t (mm)</label>
                    <input type="number" id="inp_t" value="3.2" oninput="calculateCurrentMass()">
                </div>
                <div class="wb-input-group">
                    <label>Length (mm)</label>
                    <input type="number" id="inp_l" value="6000" oninput="calculateCurrentMass()">
                </div>
                ${commonTail}
            `;
            break;

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

        case 'box':
            const box_h = parseFloat(document.getElementById('inp_h')?.value || 100);
            const box_w = parseFloat(document.getElementById('inp_w')?.value || 50);
            const box_t = parseFloat(document.getElementById('inp_t')?.value || 3.2);
            area_mm2 = (box_h * box_w) - Math.max(0, (box_h - 2 * box_t) * (box_w - 2 * box_t));
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
