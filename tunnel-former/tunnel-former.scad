include <../../modules/2dFillet.scad>

module tunnelRoof(radius, thickness, length) {
    translate([-radius / 2, 0, radius / 2])
        rotate([90, 0, 0])
            intersection() {
                cube([radius, radius, length], center = true);
                translate([radius / 2, -radius / 2, 0]) difference() {
                    cylinder(r=radius, h=length, center = true);
                    cylinder(r=radius - thickness, h=length, center = true);
                }
            }
}

module tunnelFormer() {
    overallWidth = 138;
    overallDepth = 20;
    thickness = 3;
    wallHeight = 55;
    filletSize = 10;
    radius = 30;
    translate([-(overallWidth - thickness) / 2 , 0, 0]) cube([thickness, overallDepth, wallHeight], center = true);
    translate([-(overallWidth -  filletSize) / 2 + thickness, 0, -(wallHeight - filletSize) / 2]) rotate([90, 0, 180]) 2dFillet(10, overallDepth);
    translate([-((overallWidth - thickness) / 2) + radius - (thickness / 2), 0, wallHeight / 2]) tunnelRoof(radius, thickness, overallDepth);
    translate([0, 0, (wallHeight / 2) + radius - (thickness / 2)]) cube([overallWidth - (radius * 2), overallDepth, thickness], center = true);
    translate([((overallWidth - thickness) / 2) - radius + (thickness / 2), 0, wallHeight / 2]) rotate([0, 90, 0]) tunnelRoof(radius, thickness, overallDepth);
    translate([(overallWidth - thickness) / 2, 0, 0]) cube([thickness, overallDepth, wallHeight], center = true);
    translate([(overallWidth -  filletSize) / 2 - thickness, 0, -(wallHeight - filletSize) / 2]) rotate([90, 0, 0]) 2dFillet(10, overallDepth);

}

tunnelFormer();