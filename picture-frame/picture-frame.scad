$fa = 1;
$fs = 0.4;

/* Public Variables */
PICTURE_SIZE = [125,180]; // 5"x7"
// PICTURE_SIZE = [50,50];
FRAME_WIDTH = 10;
FRAME_DEPTH = 10;
MOUNT_WIDTH = 12;
PRINT_BED_SIZE = [250, 210, 210];

/* Private Variables */
EPSILON = 0.01;
PICTURE_OVERLAP = 5;
TOLERANCE = 0.1;
PICTURE_TOLERANCE = 0.6;
INNER_FRAME_DEPTH = 1;
MOUNT_DEPTH = 2;
BACKING_DEPTH = 1.4;
V_PICTURE_SIZE = [PICTURE_SIZE[0] - 2*PICTURE_OVERLAP, PICTURE_SIZE[1] - 2*PICTURE_OVERLAP];


// https://www.printables.com/model/147875-the-photo-frame-one-file-no-supports
// https://www.printables.com/model/146825-tiny-photo-frame

// Sliding Dovetail Joint


module frame_front() {
  color("Goldenrod")
  difference() {
    cube([V_PICTURE_SIZE[0] + 2*FRAME_WIDTH + 2*MOUNT_WIDTH, V_PICTURE_SIZE[1] + 2*FRAME_WIDTH + 2*MOUNT_WIDTH, FRAME_DEPTH]);

    // visible opening
    translate([FRAME_WIDTH, FRAME_WIDTH, 0]) {
      cube([V_PICTURE_SIZE[0] + 2*MOUNT_WIDTH, V_PICTURE_SIZE[1] + 2*MOUNT_WIDTH, FRAME_DEPTH + INNER_FRAME_DEPTH]);
    }

    // backing slot
    translate([FRAME_WIDTH - PICTURE_OVERLAP - TOLERANCE, FRAME_WIDTH - PICTURE_OVERLAP - TOLERANCE, -EPSILON*2]) {
      cube([PICTURE_SIZE[0] + 2*MOUNT_WIDTH + 2*TOLERANCE, PICTURE_SIZE[1] + 2*MOUNT_WIDTH + 2*TOLERANCE, FRAME_DEPTH - INNER_FRAME_DEPTH + EPSILON]);
    }
  }

}

module frame_mount() {
  // distance = FRAME_DEPTH - INNER_FRAME_DEPTH - MOUNT_DEPTH;
  distance = -10;

  color("AntiqueWhite")
  difference() {
    translate([FRAME_WIDTH - PICTURE_OVERLAP, FRAME_WIDTH - PICTURE_OVERLAP, distance]) {
      cube([PICTURE_SIZE[0] + 2*MOUNT_WIDTH, PICTURE_SIZE[1] + 2*MOUNT_WIDTH, MOUNT_DEPTH]);
    }

    // mount inset
    translate([FRAME_WIDTH + MOUNT_WIDTH - PICTURE_OVERLAP - PICTURE_TOLERANCE, FRAME_WIDTH + MOUNT_WIDTH - PICTURE_OVERLAP - PICTURE_TOLERANCE, distance - EPSILON]) {
      cube([PICTURE_SIZE[0] + 2*PICTURE_TOLERANCE, PICTURE_SIZE[1] + 2*PICTURE_TOLERANCE, 1]);
    }

    // // visible opening
    translate([FRAME_WIDTH + MOUNT_WIDTH, FRAME_WIDTH + MOUNT_WIDTH, distance - EPSILON*2]) {
      cube([V_PICTURE_SIZE[0], V_PICTURE_SIZE[1], 4]);
    }
  }
}

module frame_back() {
  // distance = FRAME_DEPTH - INNER_FRAME_DEPTH - MOUNT_DEPTH - BACKING_DEPTH;
  distance = -15;

  handle_radius = 20;

  color("Slategrey")
  // difference() {
    translate([FRAME_WIDTH - PICTURE_OVERLAP, FRAME_WIDTH - PICTURE_OVERLAP, distance]) {
      cube([PICTURE_SIZE[0] + 2*MOUNT_WIDTH, PICTURE_SIZE[1] + 2*MOUNT_WIDTH, BACKING_DEPTH]);
    }
    // stand slots
    // for(i = [0 : 3]) {
    //   index = i % 2 == 0 ? 1 : 0;
    //   translate([V_PICTURE_SIZE[0] / 2 + FRAME_WIDTH + MOUNT_WIDTH, V_PICTURE_SIZE[1] / 2 + FRAME_WIDTH + MOUNT_WIDTH, distance - EPSILON]) {
    //     rotate([0,0,i * 90])
    //     translate([-1,handle_radius*2,0])
    //     cube([2, ((PICTURE_SIZE[index]/2) + MOUNT_WIDTH) - handle_radius*2, 2]);
    //   }
    // }
  // }

  // nail holes
  block_size = [15,15,4];
  inner_block_size = [block_size[0], block_size[1] - 5, block_size[2] - 1.6];
  hook_coords = [
    [FRAME_WIDTH/2 + TOLERANCE, V_PICTURE_SIZE[1]/2 + FRAME_WIDTH + MOUNT_WIDTH - block_size[1]/2, distance - 3],
    [V_PICTURE_SIZE[0]/2 + FRAME_WIDTH + MOUNT_WIDTH + block_size[1]/2, FRAME_WIDTH/2 + TOLERANCE, distance - 3]
  ];
  for(i = [0 : 1]) {
    translate(hook_coords[i]) {
      rotate([0,0,i*90]) {
        difference() {
          cube(block_size);
          translate([1+EPSILON,2.5, 1.6]) {
            cube(inner_block_size);
          }
          translate([block_size[0]*0.4, block_size[1]/2, 0.8]) {
          sphere(r=1.3);
          translate([5,0,0]) {
            rotate([0,90,0]) {
              cube([2,2,block_size[0]*0.7], center=true);
            }

            sphere(r=1.7);
            translate([5,0,0]) {
              rotate([0,90,0]) {
                cube([2,3,block_size[0]*0.7], center=true);
              }
            }
          }
        }
        }
      }
    }
  }

  // handle
  // height = FRAME_DEPTH - INNER_FRAME_DEPTH - BACKING_DEPTH;
  // color("Silver")
  // difference() {
  //   translate([V_PICTURE_SIZE[0] / 2 + FRAME_WIDTH + MOUNT_WIDTH, V_PICTURE_SIZE[1] / 2 + FRAME_WIDTH + MOUNT_WIDTH, distance - height + EPSILON]) {
  //     cylinder(h=height, r=handle_radius, center=false);
  //   }

  //   translate([V_PICTURE_SIZE[0] / 2 + FRAME_WIDTH + MOUNT_WIDTH, V_PICTURE_SIZE[1] / 2 + FRAME_WIDTH + MOUNT_WIDTH, distance - height/3]) {
  //     rotate_extrude($fa=10) translate([handle_radius,0,0]) circle(height/3);
  //   }
  // }
}

module main() {
  if (PICTURE_SIZE[0] + FRAME_WIDTH*2 + MOUNT_WIDTH*2 > PRINT_BED_SIZE[0] || PICTURE_SIZE[1] + FRAME_WIDTH*2 + MOUNT_WIDTH*2 > PRINT_BED_SIZE[0]) {
    assert(false, "Frame size is too large for the print bed.");
  }

  frame_front();

  frame_mount();

  frame_back();
}

main();
