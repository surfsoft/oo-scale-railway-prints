// Platform framework
// A 3D printed version of the internals of a cardboard platform, the idea being to make it more long lived and to only use
// the outer sheets of a Metcalfe platform kit to create platforms of any length
//
// TODO on the current platform section
// - Add optional location pin and framework socket so that the platform can be accurately located on the baseboard withput gluing down
// - Add optional area where a PCB could be fixed
// - Add optional cable fixing point
// - Add optional subway stairs framing
//
// Other components to add
// - Create a platform ramp with wedge sides (bottom narrower than the top, but straight sided)
// - Create a platform ramp made up of two different halves, a half can be straight or curved, and the centreline between tehm isn't necessarily in the middle
// - Create a version of the straight platform which has a different width at each end

$fn=9;

trackBedHeight = 5;
wallHeight = 15;
overallHeight = trackBedHeight + wallHeight;
platformEndWidth = 2;
platformSideWidth = 2;
lampDiameter = 2.6;
supportAngle = 30;
accessHoleDia = overallHeight / 2;
aspectSleeveInnerWidth = 13.5;
aspectSleeveInnerLength = 21.5;
aspectSleeveOuterWidth = aspectSleeveInnerWidth + 4;
aspectSleeveOuterLength = aspectSleeveInnerLength + 4;

module cubeWithVoid(width, depth, height) {
    difference() {
        cube([width, depth, height], center = true);
        rotate([0, 90, 0]) cylinder(h = depth, d = height * 0.75, center = true);
    }
}

module platformSide(length) {
    cube([length, platformSideWidth, overallHeight], center = true);
}

module platformEnd(length) {
    cubeWithVoid(platformEndWidth, length, overallHeight);
}

module lampMount(platformInnerWidth, supportWidth = 2, supportAdjustmentLeft = 0, supportAdjustmentRight = 0) {

    mountWidth = 20;
    supporLength = (platformInnerWidth - mountWidth) / 2;

    difference() {
        cube([mountWidth, mountWidth, overallHeight], center = true);
        cylinder(h=overallHeight, d=lampDiameter, center = true);
        translate([0, 0, -overallHeight / 2]) rotate([0, 90, 0]) cylinder(h=mountWidth, d=8, center = true);
    }

    translate([0, (supporLength + mountWidth + (supportAdjustmentLeft / 2)) / 2, 0]) cubeWithVoid(supportWidth, supporLength + (supportAdjustmentLeft / 2) + 0.5, overallHeight);
    translate([0, -(supporLength + mountWidth + (supportAdjustmentRight / 2)) / 2, 0]) cubeWithVoid(supportWidth, supporLength + (supportAdjustmentRight / 2) + 0.5, overallHeight);

}

module aspectSignalMount() {
    difference() {
        cube([aspectSleeveOuterLength, aspectSleeveOuterWidth, overallHeight], center = true);
        cube([aspectSleeveInnerLength, aspectSleeveInnerWidth, overallHeight], center = true);
    }
}

module platformStraight(platformLength, platformWidth, hasLamp = false, hasLocationPin = false, hasAspectSignal = "", widthAdjustmentLeft = 0, widthAdjustmentRight = 0) {
    
    leftAngle = widthAdjustmentLeft == 0 ? 0 : atan(widthAdjustmentLeft / platformLength);
    leftLength = widthAdjustmentLeft == 0 ? platformLength : sqrt(pow(widthAdjustmentLeft, 2) + pow(platformLength, 2)) - 1;
    rightAngle = widthAdjustmentRight == 0 ? 0 : atan(widthAdjustmentRight / platformLength);
    rightLength = widthAdjustmentRight == 0 ? platformLength : sqrt(pow(widthAdjustmentRight, 2) + pow(platformLength, 2)) - 1;

    aspectAngle = hasAspectSignal == "left" ? leftAngle : rightAngle;
    aspectSignalYPosition = hasAspectSignal == "left" ? (platformWidth - aspectSleeveOuterWidth) / 2 - 1 : - (platformWidth - aspectSleeveOuterWidth) / 2 + 1;

    difference() {
        union() {
    
            translate([0, ((platformWidth - platformSideWidth) / 2) + (widthAdjustmentLeft / 2), 0]) rotate([0, 0, leftAngle]) platformSide(leftLength);
            translate([0, -((platformWidth - platformSideWidth) / 2) - (widthAdjustmentRight / 2), 0]) rotate([0, 0, -rightAngle]) platformSide(rightLength);
            translate([-(platformLength - platformEndWidth) / 2, 0, 0]) platformEnd(platformWidth);
            translate([(platformLength - platformEndWidth) / 2, (widthAdjustmentLeft - widthAdjustmentRight) / 2, 0]) platformEnd(platformWidth + widthAdjustmentLeft + widthAdjustmentRight);    
    
            platformInnerWidth = platformWidth - 3;
            supportSpacing = floor(tan(supportAngle) * platformInnerWidth);
            supportCount = (platformLength / 2) / supportSpacing;

            if (supportCount > 1) for(index = [0 : supportCount - 1]) {

                percent1 = (index * supportSpacing) / platformLength;
                x1 = - (platformLength / 2) + (index * supportSpacing);
                y1 = index % 2 == 0 ? (- platformInnerWidth / 2) - (widthAdjustmentRight * percent1) : (platformInnerWidth / 2) + (widthAdjustmentLeft * percent1);
                percent2 = ((index + 1) * supportSpacing) / platformLength;
                x2 = - (platformLength / 2) + (index + 1) * supportSpacing;
                y2 = index % 2 == 0 ? (platformInnerWidth / 2) + (widthAdjustmentLeft * percent2) : (-platformInnerWidth / 2) - (widthAdjustmentRight * percent2);
                percent3 = (percent1 + percent2) / 2;
                x3 = (x1 + x2) / 2;
                y3 = (y1 + y2) / 2;        
                length1 = sqrt(pow((abs(y1) + abs(y2)), 2) + pow(supportSpacing, 2));
                supportAngle1 = 90 + atan((y2 - y1) / (x2 - x1));
                translate ([x3 + 2, y3, 0]) rotate([0, 0, supportAngle1]) cubeWithVoid(2, length1, overallHeight);

                percent4 = 1 - ((index * supportSpacing) / platformLength);
                x4 = (platformLength / 2) - (index * supportSpacing);
                y4 = index % 2 == 0 ? (- platformInnerWidth / 2) - (widthAdjustmentRight * percent4) : (platformInnerWidth / 2) + (widthAdjustmentLeft * percent4);
                percent5 = 1 - (((index + 1) * supportSpacing) / platformLength);
                x5 = (platformLength / 2) - ((index + 1) * supportSpacing);
                y5 = index % 2 == 0 ? (platformInnerWidth / 2) + (widthAdjustmentLeft * percent5) : (-platformInnerWidth / 2) - (widthAdjustmentRight * percent5);
                percent6 = (percent4 + percent5) / 2;
                x6 = (x4 + x5) / 2;
                y6 = (y4 + y5) / 2;        
                length2 = sqrt(pow((abs(y4) + abs(y5)), 2) + pow(supportSpacing, 2));
                supportAngle2 = 90 + atan((y5 - y4) / (x5 - x4));
                translate ([x6 - 2, y6, 0]) rotate([0, 0, supportAngle2]) cubeWithVoid(2, length2, overallHeight);
        
            }


            if (hasLamp) lampMount(platformWidth - 4, supportAdjustmentLeft = widthAdjustmentLeft, supportAdjustmentRight = widthAdjustmentRight);
        
            if (hasAspectSignal == "left" || hasAspectSignal == "right") {
                translate([-(platformLength - aspectSleeveOuterLength) / 2 + 1, aspectSignalYPosition, 0]) rotate([0, 0, aspectAngle]) aspectSignalMount();
            }
        }
        translate([-(platformLength - aspectSleeveOuterLength) / 2 + 1, aspectSignalYPosition, 0]) rotate([0, 0, aspectAngle]) cube([aspectSleeveInnerLength, aspectSleeveInnerWidth, overallHeight], center = true);
    }

}

module platformRamp(length, width, rampEndHeight = 2, rampEndThickness = 5) {
    
    rampPoints = [[-length / 2, 0], [length / 2, 0], [length / 2, overallHeight], [-length / 2, rampEndHeight]];
    centreVoidPoints = [[0, -accessHoleDia / 2], [length - rampEndThickness, -(width / 2) + 2], [length - rampEndThickness, (width / 2) - 2], [0, accessHoleDia / 2]];
    outerVoidPoints = [[0, (width / 2) - platformSideWidth], [length - rampEndThickness - 4, (width / 2) - platformSideWidth], [0, (accessHoleDia / 2) + 2]];
    
    difference() {
        translate([0, 0, -overallHeight / 2]) rotate([90, 0, 0]) linear_extrude(width, center = true) {
            polygon(points = rampPoints);
        }
        translate([length / 2, 0, 0]) rotate([0, 0, 180]) linear_extrude(width, center = true) {
            polygon(points = centreVoidPoints);
        } 
        translate([length / 2, 0, 0]) rotate([0, 0, 180]) linear_extrude(width, center = true) {
            polygon(points = outerVoidPoints);
        } 
        translate([length / 2, 0, 0]) rotate([180, 0, 180]) linear_extrude(width, center = true) {
            polygon(points = outerVoidPoints);
        } 
        
    }
    
}

platformStraight(300, 75, hasLamp = true, hasAspectSignal = "left");

// Modules required for platform 1

// Modules required for platform 2/3

// Modules required for platform 4
platform4Width = 76;
// x1
//platformRamp(75, platform4Width);
// x1
//platformStraight(300, platform4Width, hasLamp = true, hasAspectSignal = "right");
// x
//platformStraight(300, platform4Width, hasLamp = true);




//