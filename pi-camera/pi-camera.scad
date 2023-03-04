use <MCAD/boxes.scad>

$fa = 1;
$fs = 0.4;

wall = 3;
outerSpace = 2;

piWidth = 85;
piLength = 56;
piHeight = 18; // 20

screwMountHeight = 3;

caseWidth = piWidth + (wall*2) + (outerSpace*2);
caseLength = piLength + (wall*2) + (outerSpace*2);
caseHeight = piHeight + screwMountHeight + wall;
caseRadius = 3;
edge = wall + outerSpace;


lidScrewHoleInsetHeight = 2;
lidScrewHolepositions = [
    [65,lidScrewHoleInsetHeight-0.1,20.6],
    [8,lidScrewHoleInsetHeight-0.1,20.6],
    [65,caseLength+0.1,20.6],
    [8,caseLength+0.1,20.6]
];

module screwHole(position) {
    translate(position)
        cylinder(h=3.1,r=2.1);
}

module baseScrewMount(position, height, radius) {
    color("Red")
    difference() {
        translate(position)
            cylinder(h=height,r=radius);
            screwHole(position);
    }
}

module baseScrewMounts() {
    screwMountHeight = 3;
    radius = 3.5;

    positions = [
        [edge + radius, edge + radius, wall],
        [edge + radius, edge + radius + 49, wall],
        [edge + 58 + radius, edge + radius, wall],
        [edge + 58 + radius, edge + radius + 49, wall]
    ];

    for ( i = [0 : 3] ) {
        baseScrewMount(positions[i], screwMountHeight, radius);
    }
}

module lidScrewHoles() {
    insetHeight = 2;
    radius = 2.9;
    screwHoleHeight = wall+0.1;
    positions = lidScrewHolepositions;

    for ( i = [0 : 3] ) {
        translate(positions[i])
            rotate([90,0,0])
            cylinder(h=insetHeight,r=radius,center=false);

        holeY = positions[i][1] < caseLength ? positions[i][1] : caseLength-screwHoleHeight;
        translate([positions[i][0], holeY, positions[i][2]])
            rotate([90,0,0])
            cylinder(h=screwHoleHeight,r=1.4,center=true);
    }
}

module caseBase() {
    difference() {
        color("Yellow")
        roundedCube([caseWidth,caseLength,caseHeight], caseRadius,true,false);

        translate([wall,wall,wall])
            roundedCube([piWidth + (outerSpace*2),piLength + (outerSpace*2),caseHeight], caseRadius,true,false);

        // memory card slot
        translate([-0.1,(caseLength/2) - 8,-2])
            cube([wall+5, 16, 10],center=false);

        // rear ports
        translate([caseWidth-wall-0.1,wall+outerSpace,wall+outerSpace])
            cube([wall+0.2, piLength, piHeight+screwMountHeight],center=false);

        // side ports
        translate([wall+4,-0.1,edge])
            cube([60, wall+0.2, 10],center=false);

        lidScrewHoles();
    }

    baseScrewMounts();
}

module caseLid() {
    lidZ = caseHeight+10;
    difference() {
        color("Yellow")
        translate([0,0,lidZ])
            roundedCube([caseWidth,caseLength,wall], caseRadius,true,false);
        
        // cable hole
        translate([6,caseLength/2 - 10,lidZ-0.1])
            cube([55, 20, wall+0.2],center=false);
        
        // vents
        for ( i = [0 : 7] ) {
            translate([15 + (i * 5),caseLength - 13 - wall -1,lidZ-0.1])
                cube([2, 13, wall+0.2],center=false); 
        }
        for ( i = [0 : 7] ) {
            translate([15 + (i * 5),wall+1,lidZ-0.1])
                cube([2, 13, wall+0.2],center=false); 
        }
        for ( i = [0 : 2] ) {
            translate([caseWidth - 23 + (i * 5),wall+1,lidZ-0.1])
                cube([2, caseLength - (wall*2) - 2, wall+0.2],center=false); 
        }

        // screw holes 
        translate([9,16.2,lidZ+wall/2])
            cylinder(h=wall+0.1,r=2.1,center=true);
    
        translate([9,caseLength-16.2,lidZ+wall/2])
            cylinder(h=wall+0.1,r=2.1,center=true);

        translate([60,16.2,lidZ+wall/2])
            cylinder(h=wall+0.1,r=2.1,center=true);
    
        translate([60,caseLength-16.2,lidZ+wall/2])
            cylinder(h=wall+0.1,r=2.1,center=true);
        // screw holes end
    }

    
    mountSize = 6.8;
    for ( i = [0 : 3] ) {
        
        mountX = lidScrewHolepositions[i][0]-mountSize/2;
        mountY = lidScrewHolepositions[i][1] < caseLength ? wall+0.2 : caseLength - 6.5 - wall-0.2;
        mountZ = lidZ-mountSize;
        
        difference() {
            translate([mountX,mountY,mountZ]) {
                color("Red")
                cube([mountSize,6.5, mountSize],center=false);
            }
            holeY = lidScrewHolepositions[i][1] < caseLength ? mountY + wall-0.1 : mountY + wall + 0.6;
            translate([mountX + mountSize/2,holeY,mountZ + mountSize/2])
                color("Pink")
                rotate([90,0,0])
                cylinder(h=6,r=2.1,center=true);
        }
    }

}

module camera() {
    cameraZ = caseHeight+10+10;
    
    cableSlotPosition = [
      6,
      caseLength/2 - 10,
      cameraZ-0.1
    ];
    cableSlotSize = [
      55,
      20,
      wall+0.2
    ];
    
    cameraExtenderSize = [
      9,
      25,
      140
    ];
    
    extenderBaseSize = [
        66,
        44,
        1.4
    ];

    module cameraScrewHoles() {
        translate([wall+1.6,caseLength/2,cameraZ + cameraExtenderSize.z])
            rotate([90,0,0])
            cylinder(h=cameraExtenderSize.y + 2,r=1.4,center=true);
    }
    
    difference() {
        color("Orange")
        translate([0,caseLength/2 - extenderBaseSize.y/2,cameraZ])
            cube([extenderBaseSize.x, extenderBaseSize.y, extenderBaseSize.z],center=false);
    
        translate([cableSlotPosition.x,cableSlotPosition.y,cableSlotPosition.z])
            cube([cableSlotSize.x, cableSlotSize.y, cableSlotSize.z],center=false);
        
        // screw holes
       translate([9,16.2,cameraZ])
            cylinder(h=wall+0.1,r=1.4,center=true);
    
        translate([9,caseLength-16.2,cameraZ])
            cylinder(h=wall+0.1,r=1.4,center=true);

        translate([60,16.2,cameraZ])
            cylinder(h=wall+0.1,r=1.4,center=true);
    
        translate([60,caseLength-16.2,cameraZ])
            cylinder(h=wall+0.1,r=1.4,center=true);
    }
    
    difference() {
        color("Orange")
        translate([wall+1,caseLength/2 - cameraExtenderSize.y/2,cameraZ])
            cube([cameraExtenderSize.x, cameraExtenderSize.y, cameraExtenderSize.z],center=false);
        
        translate([cableSlotPosition.x,cableSlotPosition.y,cableSlotPosition.z])
            cube([cableSlotSize.x, cableSlotSize.y, 40],center=false);
        
        translate([cableSlotPosition.x,cableSlotPosition.y,cableSlotPosition.z + 40 - 0.1])
            cube([5, cableSlotSize.y, cameraExtenderSize.z - 30],center=false);
        
        translate([wall+1.6,(caseLength/2 + cameraExtenderSize.y/2)-2.5,cameraZ + cameraExtenderSize.z])
            rotate([90,0,0])
            cylinder(h=cameraExtenderSize.y-5,r=3.1,center=false);
        
        cameraScrewHoles();
    }
    
    // angle cylender
    difference() {
        color("Green")
        translate([wall+1.6,caseLength/2 + cameraExtenderSize.y/2,cameraZ + cameraExtenderSize.z])
            rotate([90,0,0])
            cylinder(h=cameraExtenderSize.y,r=3,center=false);
    
        translate([wall+1.6,(caseLength/2 + cameraExtenderSize.y/2)-2.5,cameraZ + cameraExtenderSize.z])
            rotate([90,0,0])
            cylinder(h=cameraExtenderSize.y-5,r=3.1,center=false);

        cameraScrewHoles();
    }

    lensHole = [
        2.4,
        12,
        18
    ];
    cameraMountPosition = [
        41.2,
        caseLength/2 - cameraExtenderSize.y/2,
        cameraZ + cameraExtenderSize.z - 5.8 - wall
    ];
    // camera mount
    difference() {
        color("Blue")
        translate([cameraMountPosition.x,cameraMountPosition.y,cameraMountPosition.z])
            cube([2, cameraExtenderSize.y, 25], center=false);
        
        translate([cameraMountPosition.x-0.2,cameraMountPosition.y + (cameraExtenderSize.y/2)-(lensHole.y/2),cameraMountPosition.z +4])
            cube([lensHole.x, lensHole.y, lensHole.z], center=false);
    }
    difference() {
        color("Orange")
        translate([cameraMountPosition.x + 1,cameraMountPosition.y+cameraExtenderSize.y-2.6,cameraZ + cameraExtenderSize.z -11.6])
            rotate([90,0,0])
            cylinder(h=cameraExtenderSize.y-5.2,r=3,center=false);

        translate([cameraMountPosition.x + 1,cameraMountPosition.y+cameraExtenderSize.y-4.9,cameraZ + cameraExtenderSize.z -11.6])
            rotate([90,0,0])
            cylinder(h=cameraExtenderSize.y-10,r=3.1,center=false);
        
        // screw hole
        translate([cameraMountPosition.x + 1,cameraMountPosition.y+cameraExtenderSize.y/2,cameraZ + cameraExtenderSize.z -11.6])
            rotate([90,0,0])
            cylinder(h=cameraExtenderSize.y,r=1.4,center=true);
    }
    // screw
    translate([caseLength,cameraMountPosition.y+cameraExtenderSize.y/2,cameraZ + cameraExtenderSize.z -11.6]) {
        cylinder(h=8,r=1.3,center=false); // ready
        cylinder(h=2,r=3,center=false);
    }

    translate([cameraMountPosition.x-2,cameraMountPosition.y+2.2,cameraMountPosition.z+22.8])
    rotate([0,90,0])
        cylinder(h=2, r=1, center=false);

    translate([cameraMountPosition.x-2,cameraExtenderSize.y+18.3,cameraMountPosition.z+22.8])
    rotate([0,90,0])
        cylinder(h=2, r=1, center=false);
    
    sideTriangleX = cableSlotPosition.x+cameraExtenderSize.x-wall+1;
    color("Orange")
    rotate([90,0,0])
    translate([0,0,-23])
    linear_extrude(2.5)
        polygon(points=[[sideTriangleX,cameraZ],[sideTriangleX + 51,cameraZ],[sideTriangleX,cameraZ+40]]);
    
    color("Orange")
    rotate([90,0,0])
    translate([0,0,-23-cameraExtenderSize.y+2.5])
    linear_extrude(2.5)
        polygon(points=[[sideTriangleX,cameraZ],[sideTriangleX + 51,cameraZ],[sideTriangleX,cameraZ+40]]);

    for ( i = [0 : 6] ) {
        color("Orange")
        rotate([0,38,0])
        translate([cableSlotPosition.x - 42 + (i * 8),cableSlotPosition.y - 2.5,cableSlotPosition.z + 28.3])
            cube([5, cableSlotSize.y + 5, 2], center=false);
    }
}

caseBase();
caseLid();
camera();





