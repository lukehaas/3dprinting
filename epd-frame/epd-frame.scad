$fa = 1;
$fs = 0.4;

/*
  Public variables:
*/
// 5.65inch epd
// epdOutline = [125.4, 99.5];
// epdDsiplay = [114.9, 85.8];

// 7.5inch epd 
epdOutline = [170.2, 111.2];
epdDsiplay = [163.2, 97.92];

frameWidth = 15;
batterySize = [40, 60];
/*
  End
*/

/*
  Private variables:
*/
epdSpace = 0.6;
epd = [epdOutline.x + epdSpace, epdOutline.y + epdSpace, 1];
depth = 16;
exterior = [epdDsiplay.x + frameWidth * 2, epdDsiplay.y + frameWidth * 2, depth];
innerOffsetX = frameWidth - (epd.x - epdDsiplay.x)/2;
innerOffset = [innerOffsetX, exterior.y - innerOffsetX - epd.y];
epsilon = 0.01;
screwRadius = 2.2;
screwHolePositions = [
  [6,6],
  [6,exterior.y-6],
  [exterior.x-6,6],
  [exterior.x-6,exterior.y-6]
];
/*
  End
*/

/*
  Util
*/
function addEpsilon(arr) = [arr.x + epsilon, arr.y + epsilon, arr.z + epsilon];

module measure(position, size, center) {
  color("Red")
  translate(position) cube(size, center=center);
}
/*
  End
*/

module frameFront() {
  notch = [24, 1.9, depth - 1];
  portNotch = [35,10, 11];
  portHole = [9, 1, 4];
  difference() {
    cube([exterior.x, exterior.y, exterior.z],center=false);

    translate([innerOffset.x, innerOffset.y, 1]) cube([epd.x, epd.y, depth],center=false);

    translate([frameWidth,frameWidth,-epsilon]) cube([epdDsiplay.x, epdDsiplay.y, 2],center=false);

    translate([(exterior.x / 2) - (notch.x/2),innerOffset.y - notch.y,1]) cube(addEpsilon(notch),center=false);

    translate([innerOffset.x,1,depth-portNotch.z]) cube([portNotch.x, portNotch.y+epsilon, portNotch.z+epsilon],center=false);

    translate([innerOffset.x + 6,0-epsilon,depth-portNotch.z+1]) cube([portHole.x, portHole.y+epsilon*2, portHole.z+epsilon],center=false);
    
    
    // screw holes
    screwHoleHeight = 5.8;
    for ( i = [0 : 3] ) {
      translate([screwHolePositions[i].x, screwHolePositions[i].y, depth-(screwHoleHeight/2)])
        cylinder(h=screwHoleHeight+epsilon,r=screwRadius,center=true); 
    }
  }
}

module frameInner() {
  origin = [innerOffset.x, innerOffset.y, 50];
  inner = [epdOutline.x, epdOutline.y, 3];
  boardIndent = [70, 50, 2.4];
  batteryBoardIndent = [18, 12, 2.4];
  batterySupports = [
    [2, batterySize.x - 7, 10.7],
    [batterySize.y - 5, 2, 10.7]
  ];
  centralSupport = [5, 5, 10.7];
  boardSupport = [2, 40, 4];
  difference() {
    translate([origin.x, origin.y, origin.z]) cube(inner,center=false);

    translate([origin.x+(exterior.x / 2) - 35.6, origin.y - epsilon, origin.z + (inner.z - boardIndent.z)]) cube(addEpsilon(boardIndent), center=false);

    translate([origin.x + 7.6, origin.y+20, origin.z + (inner.z - batteryBoardIndent.z)]) cube(addEpsilon(batteryBoardIndent), center=false);

    translate([origin.x + 0.5 + screwRadius, origin.y+23.8 + screwRadius, origin.z-epsilon]) cylinder(h=inner.z+0.1,r=screwRadius,center=false);
    translate([origin.x + 28.5 + screwRadius, origin.y+23.8 + screwRadius, origin.z-epsilon]) cylinder(h=inner.z+0.1,r=screwRadius,center=false);
  }

  // battery supports
  translate([origin.x + batterySize.y, origin.y + inner.y - batterySupports[0].y - 1, origin.z]) cube(batterySupports[0],center=false);
  translate([origin.x + 1, origin.y + inner.y - batterySize.x, origin.z]) cube(batterySupports[1],center=false);

  // central support
  translate([origin.x + (inner.x / 2) - (centralSupport.x / 2), origin.y + (inner.y / 2) + (centralSupport.y / 2), origin.z]) cube(centralSupport,center=false);

  // board support
  translate([origin.x+(exterior.x / 2) - 35.6 - boardSupport.x, origin.y + 1, origin.z + inner.z]) cube(boardSupport,center=false);
  // measure(origin, [61, 10, 10]);
}

module frameBack() {
  origin = [0, 0, 120];
  back = [exterior.x, exterior.y, 2.6];
  magnetRadius = 12.55;
  magnetHeight = 5.1;
  magnetHoleRadius = 1.95;

  magnetShellRadius = 13.05;
  magnetShellHeight = 3.5;

  screwHoleRadius = 1.85;

  module magnetSockets() {
    translate([origin.x + (back.x/2) - magnetShellRadius - 3.5, origin.y + (back.y/2), origin.z+(magnetHeight/2)-epsilon])
      cylinder(h=magnetHeight,r=magnetRadius,center=true);

    translate([origin.x + (back.x/2) + magnetShellRadius + 3.5, origin.y + (back.y/2), origin.z+(magnetHeight/2)-epsilon])
      cylinder(h=magnetHeight,r=magnetRadius,center=true);
  }

  difference() {
    translate([origin.x, origin.y, origin.z]) cube(back,center=false);

    // screw holes
    for ( i = [0 : 3] ) {
      translate([screwHolePositions[i].x, screwHolePositions[i].y, origin.z-0.1])
        cylinder(h=back.z+0.2,r=screwHoleRadius,center=false);

      translate([screwHolePositions[i].x, screwHolePositions[i].y, origin.z+back.z-1+epsilon])
        cylinder(h=1,r1=screwHoleRadius,r2=3.65,center=false);
    }
    magnetSockets();
  }
  difference() {
    union() {
      translate([origin.x + (back.x/2) - magnetShellRadius - 3.5, origin.y + (back.y/2), origin.z+back.z+magnetShellHeight/2])
        cylinder(h=magnetShellHeight,r=magnetShellRadius,center=true);

      translate([origin.x + (back.x/2) + magnetShellRadius + 3.5, origin.y + (back.y/2), origin.z+back.z+magnetShellHeight/2])
        cylinder(h=magnetShellHeight,r=magnetShellRadius,center=true);


    }
    magnetSockets();
  }
  translate([origin.x + (back.x/2) - magnetShellRadius - 3.5, origin.y + (back.y/2), origin.z+back.z])
    cylinder(h=magnetHeight,r=magnetHoleRadius,center=true);

  translate([origin.x + (back.x/2) + magnetShellRadius + 3.5, origin.y + (back.y/2), origin.z+back.z])
    cylinder(h=magnetHeight,r=magnetHoleRadius,center=true);

  // measure([origin.x + (back.x/2) - magnetShellRadius - 3.5, origin.y + (back.y/2), origin.z+back.z+(magnetShellHeight)-0.5], [1, 1, 1], true);
}

module main() {
  frameFront();
  frameInner();
  frameBack();
}

main();

