include <../../modules/2dFillet.scad>

$fn=180;

plugOuterDiameter = 8;
plugInnerDiameter = 3;
plugLength = 20;

module plug(length, outerDiameter, innerDiameter) {
    difference() {
        cylinder(d=outerDiameter, h=length, center = true);
        cylinder(d=innerDiameter, h=length, center = true);
    }
}

module groundSignalTop(mountingHoleDiameter) {
    depth = 4;
    difference() {
        cube([10, 10, depth], center = true);
        translate([4.6, 4.2, 0]) rotate([0, 0, 30]) cube([2.5, 6, depth], center = true);
        translate([-4.6, 4.2, 0]) rotate([0, 0, -30]) cube([2.5, 6, depth], center = true);
        cylinder(d=mountingHoleDiameter, h=depth, center = true);
    }
}

module groundSignalMount() {
    
    translate([0, 0, 2]) groundSignalTop(plugInnerDiameter);
    translate([0, 0, -plugLength/2]) plug(plugLength, plugOuterDiameter, plugInnerDiameter);
    
}

module signalCableClip(height) {
    difference() {
        union() {
            cube([8, 20, 2], center = true);
            translate([0, -10, height / 2]) cylinder(d=8, h=2 + height, center = true);
        }
        translate([0, -10, height / 2]) cylinder(d=4, h=2 + height, center = true);
    }
    translate([0, 8.5, 1 + (height / 2)]) cube([8, 3, height], center = true);
}

groundSignalMount();
