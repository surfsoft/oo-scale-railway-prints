$fn = 180;

include <../modules/ScrewHole.scad>
include <../modules/2dFillet.scad>

module bottomMount() {

    baseThickness = 50;
    baseWidth = 25;
    baseDepth = 6;
    catchThickness = 65;
    catchDepth = 10;
    catchWidth = 5;
    filletSize = 5;
    headDia = 7.5;
    screwDia = 4;
    headHeight = 2.5;
    screwXOffset = ((baseWidth - catchWidth - filletSize) / 2) - (baseWidth / 2  - catchWidth - filletSize);
    
    difference() {
        cube([baseWidth, baseThickness, baseDepth], center = true);
        translate([-screwXOffset, baseThickness / 3, 0]) countersunkHole(headDia, screwDia, headHeight, baseDepth);
        translate([-screwXOffset, -baseThickness / 3, 0]) countersunkHole(headDia, screwDia, headHeight, baseDepth);
    }

    translate([(baseWidth - catchWidth) / 2, (baseThickness - catchThickness) / 2 , (baseDepth + catchDepth) / 2]) cube([catchWidth, catchThickness, catchDepth], center = true);
    translate([(baseWidth / 2) - catchWidth - (filletSize / 2), 0, (baseDepth + filletSize) / 2]) rotate([90, 0, 0]) 2dFillet(filletSize, baseThickness);

}

module topMount() {
    
    ceilingLength = 75;
    ceilingAngle = 40;
    mountLength = cos(ceilingAngle) * ceilingLength;
    mountDrop = sin(ceilingAngle) * ceilingLength;
    mountWidth = 20;
    baseDepth = 5;
    headDia = 7.5;
    screwDia = 4;
    headHeight = 2.5;
    holeHeight = 60;
    magnetDiameter = 6;
    magnetHeight = 2.1;
    
    difference() {
        translate([- ceilingLength / 2, - mountWidth / 2, 0])
        rotate([-90,-40, 0])
        difference() {
            linear_extrude(height = mountWidth) {
                polygon(points = [[0, 0], [mountLength, 0], [mountLength, mountDrop]]);
            }
            translate([mountLength - (magnetHeight / 2), magnetDiameter * 0.9, mountWidth / 2]) rotate([90, 0, 90]) cylinder(d = magnetDiameter, h = magnetHeight, center = true);
            translate([mountLength - (magnetHeight / 2), magnetDiameter * 2.1, mountWidth / 2]) rotate([90, 0, 90]) cylinder(d = magnetDiameter, h = magnetHeight, center = true);        }
        translate([25, 0, (holeHeight / 2) + baseDepth]) cylinder(d=headDia + 1, h=holeHeight, center = true);
        translate([25, 0, baseDepth / 2]) countersunkHole(headDia, screwDia, headHeight, baseDepth);
        translate([-25, 0, (holeHeight / 2) + baseDepth]) cylinder(d=headDia + 1, h=holeHeight, center = true);
        translate([-25, 0, baseDepth / 2]) countersunkHole(headDia, screwDia, headHeight, baseDepth);
        
    }
    
}

module topSlot() {
    
    mountWidth = 20.1;
    mountHeight = 3;
    ceilingLength = 75;
    ceilingAngle = 40;
    mountLength = sin(ceilingAngle) * ceilingLength - 5;
    fenceWidth = 1;
    fenceHeight = 4;

    magnetDiameter = 6;
    magnetHeight = 2.1;
    
    difference() {
        cube([mountWidth, mountLength, mountHeight], center = true);
        translate([0, (mountLength / 2) - magnetDiameter * 0.9, (mountHeight - magnetHeight) / 2]) cylinder(d = magnetDiameter, h = magnetHeight, center = true);
                translate([0, (mountLength / 2) - magnetDiameter * 2.1, (mountHeight - magnetHeight) / 2]) cylinder(d = magnetDiameter, h = magnetHeight, center = true);
    }
    translate([0, (mountLength + fenceWidth) / 2, (fenceHeight - mountHeight) / 2]) cube([mountWidth + (fenceWidth * 2), fenceWidth, fenceHeight], center = true);
    translate([-(mountWidth + fenceWidth) / 2, 2.5, (fenceHeight - mountHeight) / 2]) cube([fenceWidth, mountLength - 5, fenceHeight], center = true);
    translate([(mountWidth + fenceWidth) / 2, 2.5, (fenceHeight - mountHeight) / 2]) cube([fenceWidth, mountLength - 5, fenceHeight], center = true);
}
