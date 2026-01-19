$fn = 90;

module spacer(slotAngle = 1.5) {
    
    deckDistance = 96;
    
    
    difference() {
        union() {
            translate([0, -3.75, 0]) cube([5, 5, deckDistance], center = true);

           translate([0, 0, -deckDistance / 2]) lug(slotAngle);
           translate([0, 5 / 2, (deckDistance / 2) - ((11.5 + 7.5) / 2) ]) rotate([-90, 0, 0]) blend(height = 7.5);
           translate([- 7.5 / 2, 0, (deckDistance / 2) - ((11.5 + 2.5) / 2) ]) rotate([-90, 0, 90]) blend(width = 12.5, height = 2.5);
           translate([7.5 / 2, 0, (deckDistance / 2) - ((11.5 + 2.5) / 2) ]) rotate([180, 0, 90]) blend(width = 12.5, height = 2.5);

            translate([0, 0, deckDistance / 2]) lug(slotAngle);
            translate([0, 5 / 2, - (deckDistance / 2) + ((11.5 + 7.5) / 2) ]) rotate([0, 0, 0]) blend(height = 7.5);
            translate([- 7.5 / 2, 0, - (deckDistance / 2) + ((11.5 + 2.5) / 2) ]) rotate([0, 0, 90]) blend(width = 12.5, height = 2.5);
            translate([7.5 / 2, 0, - (deckDistance / 2) + ((11.5 + 2.5) / 2) ]) rotate([90, 0, 90]) blend(width = 12.5, height = 2.5);
        }
        translate([0, 12.5 / 2, (deckDistance / 2) - ((11.5 + 15) / 2)]) rotate([0, 90, 0]) cylinder(h=12.5 + 2, r=7.5, center = true);
        translate([0, 12.5 / 2, - (deckDistance / 2) + ((11.5 + 15) / 2)]) rotate([0, 90, 0]) cylinder(h=12.5 + 2, r=7.5, center = true);
    }
    
}
    

module lug(slotAngle = 1.5) {
    
    slotHeight = 6.4;
    slotDepth = 7.5;
    lugHeight = slotHeight + 5;
    lugDepth = slotDepth + 5;
    lugWidth = 10;
    blendHeight = 1.5;

    difference() {
        cube([lugWidth, lugDepth, lugHeight], center = true);
        translate([0, (lugDepth - slotDepth) / 2, 0]) rotate([0, slotAngle, 0]) cube([lugWidth + 2, slotDepth, slotHeight], center = true);
    }
    
}

module blend(height = 5, width = 5) {
    difference() {
        cube([width, height, height], center = true);
        translate([0, height / 2, height / 2]) rotate([0, 90, 0]) cylinder(h=width*2, r=height, center = true);
    }
}

spacer(slotAngle = -1.5);

    
