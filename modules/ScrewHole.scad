module countersunkHole(headDia, threadDia, headHeight, plateThickness) {

    headOffset = headHeight > (plateThickness / 2) ? (plateThickness - headHeight) / 2: (plateThickness - headHeight) / 2;
    threadHeight = plateThickness - headHeight;
    threadOffset = threadHeight > (plateThickness / 2) ?  -(plateThickness - threadHeight) / 2: - (plateThickness - threadHeight) / 2;
    
    translate([0, 0, headOffset]) cylinder(d1 = threadDia, d2 = headDia, h = headHeight, center = true);
    translate([0, 0, threadOffset]) cylinder(d = threadDia, h = threadHeight, center = true);
    
}

module roundheadHole(headDia, threadDia, headHeight, plateThickness) {

    headOffset = headHeight > (plateThickness / 2) ? (plateThickness - headHeight) / 2: (plateThickness - headHeight) / 2;
    threadHeight = plateThickness - headHeight;
    threadOffset = threadHeight > (plateThickness / 2) ?  -(plateThickness - threadHeight) / 2: - (plateThickness - threadHeight) / 2;

    translate([0, 0, headOffset]) cylinder(d = headDia, h = headHeight, center = true);
    translate([0, 0, threadOffset]) cylinder(d = threadDia, h = threadHeight, center = true);

}