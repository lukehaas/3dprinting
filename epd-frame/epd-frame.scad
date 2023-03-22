$fa = 1;
$fs = 0.4;

/*
  Public variables:
*/
// 5.65inch epd
epdOutline = [125.4, 99.5];
epdDsiplay = [114.9, 85.8];

// 7.5inch epd 
// epdOutline = [170.2, 111.2];
// epdDsiplay = [163.2, 97.92];

frameWidth = 15;

/*
  Private variables:
*/
epdSpace = 0.6;
epd = [epdOutline.x + epdSpace, epdOutline.y + epdSpace, 1];
depth = 16;
exterior = [epdDsiplay.x + frameWidth * 2, epdDsiplay.y + frameWidth * 2, depth];
epsilon = 0.01;
screwRadius = 2.2;


module frameFront() {
  notch = [24, 1.9, depth - 1];
  portNotch = [35,10, 11];
  portHole = [9, 1, 4];
  difference() {
    cube([exterior.x, exterior.y, exterior.z],center=false);

    offsetX = frameWidth - (epd.x - epdDsiplay.x)/2;
    offsetY = exterior.y - offsetX - epd.y;
    translate([offsetX, offsetY, 1]) cube([epd.x, epd.y, depth],center=false);

    translate([frameWidth,frameWidth,-epsilon]) cube([epdDsiplay.x, epdDsiplay.y, 2],center=false);

    translate([(exterior.x / 2) - (notch.x/2),offsetY - notch.y,1]) cube([notch.x+epsilon, notch.y+epsilon, notch.z+epsilon],center=false);

    translate([offsetX,1,depth-portNotch.z]) cube([portNotch.x, portNotch.y+epsilon, portNotch.z+epsilon],center=false);

    translate([offsetX + 6,0-epsilon,depth-portNotch.z+1]) cube([portHole.x, portHole.y+epsilon*2, portHole.z+epsilon],center=false);

    // screw holes
    screwHolePositions = [
      [6,6],
      [6,exterior.y-6],
      [exterior.x-6,6],
      [exterior.x-6,exterior.y-6]
    ];
    for ( i = [0 : 3] ) {
      translate([screwHolePositions[i].x, screwHolePositions[i].y, depth-5.8])
        cylinder(h=5.8+epsilon,r=screwRadius,center=false); 
    }
  }
}

module frameBack() {}

module frameInner() {}

module main() {
  frameFront();
}

main();

