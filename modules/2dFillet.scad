module 2dFillet(length, thickness) {
    diameter = length * 2;
    translate([-diameter / 4, diameter / 4, 0])
    difference() {
        cube([diameter, diameter, thickness], center = true);
        cylinder(d = diameter, h = thickness, center = true);
        translate([0, diameter / 4, 0]) cube([diameter, diameter / 2, thickness], center = true);
        translate([- diameter / 4, - diameter / 4, 0]) cube([diameter / 2, diameter / 2, thickness], center = true);
    }
}