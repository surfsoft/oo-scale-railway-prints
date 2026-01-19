// Platform framework
// A 3D printed version of the internals of a cardboard platform, the idea being to make it more long lived and to only use
// the outer sheets of a Metcalfe platform kit to create platforms of any length
//
// TODO on the current platform section
// - Add optional area where a PCB could be fixed, include a cable strain relief
//
// Other components to add
// - Create a platform ramp with wedge sides (bottom narrower than the top, but straight sided)
// - Create a platform ramp where one or both sides can be curved, by specifying by a radius

$fn=90;

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
locationScrewDiameter = 4;

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

module subwayMount(subwayLength, subwayWidth, platformInnerWidth, supportWidth = 2, hasLamp = false) {
    
    cube([subwayLength, subwayWidth, overallHeight], center = true);
    if (!hasLamp) {
        supporLength = (platformInnerWidth - subwayWidth) / 2;
        echo(supportWidth);
        translate([0, (supporLength + subwayWidth) / 2, 0]) cubeWithVoid(supportWidth, supporLength + 0.5, overallHeight);
        translate([0, -(supporLength + subwayWidth) / 2, 0]) cubeWithVoid(supportWidth, supporLength + 0.5, overallHeight);
    }
    
}


module aspectSignalMount() {
    difference() {
        cube([aspectSleeveOuterLength, aspectSleeveOuterWidth, overallHeight], center = true);
        cube([aspectSleeveInnerLength, aspectSleeveInnerWidth, overallHeight], center = true);
    }
}

module platformStraight(
    platformLength, 
    platformWidth, 
    hasLamp = false, 
    hasAspectSignal = "", 
    hasLocationPin = false, 
    hasPcbMount = false, // TODO
    hasSubway = false,
    widthAdjustmentLeft = 0, 
    widthAdjustmentRight = 0) {
    
    leftAngle = widthAdjustmentLeft == 0 ? 0 : atan(widthAdjustmentLeft / platformLength);
    leftLength = widthAdjustmentLeft == 0 ? platformLength : sqrt(pow(widthAdjustmentLeft, 2) + pow(platformLength, 2)) - 1;
    rightAngle = widthAdjustmentRight == 0 ? 0 : atan(widthAdjustmentRight / platformLength);
    rightLength = widthAdjustmentRight == 0 ? platformLength : sqrt(pow(widthAdjustmentRight, 2) + pow(platformLength, 2)) - 1;
    platformInnerWidth = platformWidth - 3;
    supportSpacing = floor(tan(supportAngle) * platformInnerWidth);
    supportCount = (platformLength / 2) / supportSpacing;

    locationPinLength = 20;
    locationPinWidth = 20;
    locationPinHeight = overallHeight / 2;
    locationPinX = platformLength / 4;
    locationPinY = ((platformWidth - locationPinWidth) / 2) - platformSideWidth - (widthAdjustmentLeft * 0.75) ;
    locationPinZ = -(overallHeight - locationPinHeight) / 2;
        
    subwayInnerLength = 51;
    subwayLength = subwayInnerLength + 4;
    subwayInnerWidth = 27.5;
    subwayWidth = subwayInnerWidth + 4;
    subwayPositionX = hasLamp ? subwayLength / 2 + 5 : 0;
    subwayPositionY = 0;

    aspectAngle = hasAspectSignal == "left" ? leftAngle : rightAngle;
    aspectSignalYPosition = hasAspectSignal == "left" ? (platformWidth - aspectSleeveOuterWidth) / 2 - 1 : - (platformWidth - aspectSleeveOuterWidth) / 2 + 1;

    difference() {
        union() {
    
            translate([0, ((platformWidth - platformSideWidth) / 2) + (widthAdjustmentLeft / 2), 0]) rotate([0, 0, leftAngle]) platformSide(leftLength);
            translate([0, -((platformWidth - platformSideWidth) / 2) - (widthAdjustmentRight / 2), 0]) rotate([0, 0, -rightAngle]) platformSide(rightLength);
            translate([-(platformLength - platformEndWidth) / 2, 0, 0]) platformEnd(platformWidth);
            translate([(platformLength - platformEndWidth) / 2, (widthAdjustmentLeft - widthAdjustmentRight) / 2, 0]) platformEnd(platformWidth + widthAdjustmentLeft + widthAdjustmentRight);    
    

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


            if (hasLamp) {
                 lampMount(platformWidth - 4, supportAdjustmentLeft = widthAdjustmentLeft, supportAdjustmentRight = widthAdjustmentRight);
            }
        
            if (hasAspectSignal == "left" || hasAspectSignal == "right") {
                translate([-(platformLength - aspectSleeveOuterLength) / 2 + 1, aspectSignalYPosition, 0]) rotate([0, 0, aspectAngle]) aspectSignalMount();
            }
            
            if (hasLocationPin) {
                translate ([locationPinX, locationPinY, locationPinZ]) cube([locationPinLength + 4, locationPinWidth + 4, locationPinHeight], center = true);
            }

            if (hasSubway) {
                translate ([subwayPositionX, subwayPositionY, 0]) subwayMount(subwayLength, subwayWidth, platformInnerWidth, hasLamp = hasLamp);
            }

        }
        
        if (hasAspectSignal != "") {
            translate([-(platformLength - aspectSleeveOuterLength) / 2 + 1, aspectSignalYPosition, 0]) rotate([0, 0, aspectAngle]) cube([aspectSleeveInnerLength, aspectSleeveInnerWidth, overallHeight], center = true);
        }
            
        if (hasLocationPin) {
            translate ([locationPinX, locationPinY, locationPinZ]) cube([locationPinLength, locationPinWidth, locationPinHeight], center = true);
        }

        if (hasSubway) {
            translate ([subwayPositionX, subwayPositionY, 0]) cube([subwayInnerLength, subwayInnerWidth, overallHeight], center = true);
        }
    }
    
    if (hasLocationPin) {
        translate ([locationPinX, locationPinY, locationPinZ]) difference() {
            cube([locationPinLength - 1, locationPinWidth - 1, locationPinHeight], center = true);
            translate([0, 0, 1]) cube([locationPinLength - 5, locationPinWidth - 5, locationPinHeight - 2], center = true);
            cylinder(h=locationPinHeight, d = locationScrewDiameter, center = true);
        }
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

platformStraight(300, 75, hasLamp = true, hasAspectSignal = "", hasLocationPin = false, hasSubway = true);
