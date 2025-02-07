use <MCAD/boxes.scad>

$fa = 1;
$fs = 0.4;

/* Public Variables */
PICTURE_SIZE = [125,180]; // 5"x7"
// PICTURE_SIZE = [25,25];
FRAME_WIDTH = 12;
FRAME_DEPTH_FRONT = 2;
FRAME_DEPTH_BACK = 15;
PRINT_BED_SIZE = [250, 210, 210];

/* Private Variables */
EPSILON = 0.01;
TOLERANCE = 0.1;
PICTURE_TOLERANCE = 0.4;
PICTURE_OVERLAP = 4;
PICTURE_THICKNESS = 0.8;
FRAME_DEPTH = FRAME_DEPTH_FRONT + FRAME_DEPTH_BACK;

module cross(pad = 0) {
  WIDTH = (FRAME_WIDTH*0.8) + pad;
  HEIGHT = (WIDTH / 4) + pad;
  DEPTH = 6 + pad;
  RADIUS = 0.4;

  translate([0, (DEPTH/2)-RADIUS, 0]) {
    roundedCube([HEIGHT, DEPTH, WIDTH], RADIUS, false, true);

    rotate([0, 90, 0]) {
      roundedCube([HEIGHT, DEPTH, WIDTH], RADIUS, false, true);
    }

  }
}

module half_frame(index = 0) {
  EDGE_OFFSET = ((PICTURE_SIZE.y/2) - PICTURE_OVERLAP);
  SEGMENT_OFFSET = index*EDGE_OFFSET;
  VISUAL_GAP = index * 20;
  CROSS_OFFSET = (PICTURE_SIZE.x + FRAME_WIDTH - (PICTURE_OVERLAP * 2));

  difference() {
    union() {
      translate([0,VISUAL_GAP + index * (PICTURE_SIZE.y + PICTURE_OVERLAP),0]) {
        cube([PICTURE_SIZE.x + FRAME_WIDTH*2 - PICTURE_OVERLAP*2,FRAME_WIDTH,FRAME_DEPTH]);
      }

      translate([0, VISUAL_GAP + FRAME_WIDTH + SEGMENT_OFFSET, 0]) {
        cube([FRAME_WIDTH, PICTURE_SIZE.y/2 - PICTURE_OVERLAP, FRAME_DEPTH]);
      }

      translate([PICTURE_SIZE.x + FRAME_WIDTH - PICTURE_OVERLAP * 2, VISUAL_GAP + FRAME_WIDTH + SEGMENT_OFFSET, 0]) {
        cube([FRAME_WIDTH, PICTURE_SIZE.y/2 - PICTURE_OVERLAP, FRAME_DEPTH]);
      }

      translate([(FRAME_WIDTH/2), FRAME_WIDTH + EDGE_OFFSET, (FRAME_DEPTH/2)]) {
        cross();
      }
      translate([CROSS_OFFSET + (FRAME_WIDTH/2), FRAME_WIDTH + EDGE_OFFSET, (FRAME_DEPTH/2)]) {
        cross();
      }
    }

    translate([(FRAME_WIDTH/2), 20 + FRAME_WIDTH + EDGE_OFFSET - EPSILON, (FRAME_DEPTH/2)]) {
      cross(0.1);
    }

    translate([CROSS_OFFSET + (FRAME_WIDTH/2), 20 + FRAME_WIDTH + EDGE_OFFSET - EPSILON, (FRAME_DEPTH/2)]) {
      cross(0.1);
    }

    translate([FRAME_WIDTH - PICTURE_OVERLAP, VISUAL_GAP + FRAME_WIDTH - PICTURE_OVERLAP, FRAME_DEPTH_FRONT]) {
      cube([PICTURE_SIZE.x + PICTURE_TOLERANCE, PICTURE_SIZE.y + PICTURE_TOLERANCE, PICTURE_THICKNESS]);
    }

    translate([(FRAME_WIDTH-PICTURE_OVERLAP)+(PICTURE_SIZE.x/2), FRAME_WIDTH, FRAME_DEPTH_FRONT + PICTURE_THICKNESS + 2]) {
      cylinder(h=FRAME_DEPTH_BACK - 4, r=3);
    }
  }

  // nail holes
  // block_size = [10,10,5];
  // inner_block_size = [block_size.x - 2, block_size.y - 2, block_size.z - 2];
  // translate([(FRAME_WIDTH-PICTURE_OVERLAP)+(PICTURE_SIZE.x/2), FRAME_WIDTH+block_size.y/2, FRAME_DEPTH_FRONT + PICTURE_THICKNESS + block_size.z/2]) {
  //   difference() {
  //     cube(block_size, true);

  //     translate([0,1+EPSILON,0]) {
  //       color("red")
  //       cube(inner_block_size, true);
  //     }
  //     translate([0,EPSILON,2]) {
  //       cube([3,block_size.y,2], true); 
  //     }
  //   }
    

  // }



}

module main() {
  for (i = [0:1]) {
    half_frame(i);
  }
}

main();
