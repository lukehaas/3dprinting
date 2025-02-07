use <MCAD/boxes.scad>

$fa = 1;
$fs = 0.4;

/* Public Variables */
// PICTURE_SIZE = [125,180]; // 5"x7"
PICTURE_SIZE = [50,50];
FRAME_WIDTH = 16;
FRAME_DEPTH_FRONT = 2;
FRAME_DEPTH_BACK = 15;
PRINT_BED_SIZE = [250, 210, 210];


/* Private Variables */
EPSILON = 0.01;
FRAME_DEPTH = FRAME_DEPTH_FRONT + FRAME_DEPTH_BACK;
PICTURE_OVERLAP = 4;
VISIBLE_PICTURE_SIZE = [PICTURE_SIZE[0] - 2*PICTURE_OVERLAP, PICTURE_SIZE[1] - 2*PICTURE_OVERLAP];

module dove_tail(size) {
  ANGLE = 14;

  POSITION = [size.x*-0.325, size.y*0.85, 0];
  RADIUS = size.x*0.15;

  difference() {
    roundedCube([size.x, size.y, size.z], RADIUS, true, true);

    translate([POSITION.x,POSITION.y,0]) {
      rotate([0, 0, ANGLE]) {
        roundedCube([size.x*1.5, size.y, size.z+1], RADIUS, true, true);
      }
    }

    mirror([0,1,0]) {
      translate([POSITION.x,POSITION.y,0]) {
        rotate([0, 0, ANGLE]) {
          roundedCube([size.x*1.5, size.y, size.z+1], RADIUS, true, true);
        }
      }
    }

  }
}


// cube([10, 10, 10], true);
// translate([9, 0, 2.5]) {
//   dove_tail([9,9,5]);
// }

// translate([30, 0, 0]) {
//   difference() {
//   cube([20, 10, 10], true);
//   translate([-5.45-EPSILON, 0, 2.45+EPSILON]) {

//     dove_tail([9.1,9.1,5.1]);

//   }
//   }
// }

module corner(index = 0, sideIndex = 0) {
  DOVETAIL_SIZE = [9,9,FRAME_DEPTH*0.75];
  color("Goldenrod")
  cube([(VISIBLE_PICTURE_SIZE.x/2) + FRAME_WIDTH, FRAME_WIDTH, FRAME_DEPTH], true);

  // join
  sign = sideIndex == 0 ? 1 : -1;
  echo(sign*5*index)
  translate([((VISIBLE_PICTURE_SIZE.x+FRAME_WIDTH*2)/-4) + DOVETAIL_SIZE.x/2 - DOVETAIL_SIZE.x*index, ((FRAME_WIDTH-PICTURE_OVERLAP)/2) -(FRAME_WIDTH/2), ((DOVETAIL_SIZE.z/2) + (FRAME_DEPTH/-2)) + (sideIndex*FRAME_DEPTH*0.25) + sign*(FRAME_DEPTH*0.25)*index]) {
    rotate([0, 180*index, 0]) {
      if (index == 0) {
        color("Red")
        dove_tail([DOVETAIL_SIZE.x + 0.1, DOVETAIL_SIZE.y + 0.1, DOVETAIL_SIZE.z + 0.1]);
      } else {
        color("Blue")
        dove_tail(DOVETAIL_SIZE);
      }        
    }
  }

  translate([VISIBLE_PICTURE_SIZE.x/4,VISIBLE_PICTURE_SIZE.y/4 + FRAME_WIDTH/2, 0]) {
    cube([FRAME_WIDTH, (VISIBLE_PICTURE_SIZE.y/2), FRAME_DEPTH], true);
  }
}

module picure_inset(padding = 0) {
  color("AntiqueWhite")

  translate([-VISIBLE_PICTURE_SIZE.x/4 - FRAME_WIDTH/2 - padding/2, VISIBLE_PICTURE_SIZE.y/2 + FRAME_WIDTH/2 + padding/2, (FRAME_DEPTH_BACK/2) + (FRAME_DEPTH/2) - FRAME_DEPTH_BACK + EPSILON]) {
    cube([PICTURE_SIZE.x + padding, PICTURE_SIZE.y + padding, FRAME_DEPTH_BACK + EPSILON], true);
  }
}

module main() {
  GAP = 20;

  difference() {
    union() {
      for (i = [0:1]) {
        translate([(((VISIBLE_PICTURE_SIZE.x+FRAME_WIDTH*2)/-2) - GAP) * i, 0, 0]) {
          rotate([0, i*180, 0]) {
            corner(i, 1);
          }
        }
      }

      for (i = [0:1]) {
        translate([(((VISIBLE_PICTURE_SIZE.x+FRAME_WIDTH*2)/-2) - GAP) * i, VISIBLE_PICTURE_SIZE.y + FRAME_WIDTH + GAP, 0]) {
          rotate([180, i*180, 0]) {
            corner(i, 0);
          }
        }
      }
    }
    picure_inset(GAP);
  }
}

main();