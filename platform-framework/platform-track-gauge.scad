thickness = 2.5;
topWidth = 25;
topDepth = 25;
platformEdgeWidth = 20;
platformWallWidth = 23;
platformToTrackDepth = 12;
trackKeyWidth = 8.25;
trackKeyDepth = 1.5;

module platformSurfaceSide() {
    cube([topWidth, thickness, topDepth]);
    translate([0, 0, -platformToTrackDepth]) cube([platformEdgeWidth, thickness, platformToTrackDepth]);
    translate([0, 0, -platformToTrackDepth - trackKeyDepth]) cube([trackKeyWidth, thickness, trackKeyDepth]);
}

module platformWallSide() {
    cube([platformWallWidth, thickness, topDepth]);
    translate([0, 0, -platformToTrackDepth]) cube([platformWallWidth, thickness, platformToTrackDepth]);
    translate([0, 0, -platformToTrackDepth - trackKeyDepth]) cube([trackKeyWidth, thickness, trackKeyDepth]);
}

platformSurfaceSide();
rotate([0, 0, 180]) translate([0, -thickness, 0]) platformWallSide();