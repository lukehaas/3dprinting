$fa = 1;
$fs = 0.4;

barSize = [35, 35, 300];
outerBarSize = [barSize.x + 5, barSize.y + 5, barSize.z];
baseSize = [30,60,50];
innerBase = [baseSize.x, baseSize.y - 20, baseSize.z - 20];
epsilon = 0.01;


module screwHole(z) {
  translate([0,0,z]) {
    rotate([0,90,0]) {
      cylinder(h=50, d=2, center=false);
      translate([0,0,(outerBarSize.x/2) + 4]) { //18
        cylinder(h=3.6, d1=2, d2=8.4, center=false);
      }
    }
  }
}

module barCylinder() {
  difference() {
    union() {
      cylinder(h=50, d=outerBarSize.x, center=false);

      linear_extrude(height = baseSize.z) {
        polygon(points=[[0,outerBarSize.y/2],[outerBarSize.x/2,0],[barSize.x/2,baseSize.y/2]], paths=[[0,1,2]]);
      }
      linear_extrude(height = baseSize.z) {
        polygon(points=[[0,-outerBarSize.y/2],[outerBarSize.x/2,0],[barSize.x/2,-baseSize.y/2]], paths=[[0,1,2]]);
      }
    }
    translate([0, 0, 5]) {
      cylinder(h=50, d=barSize.x + 0.4, center=false);
    }
  }
}

module cylinderBase() {
  translate([barSize.x/2,-30,0]) {
    difference() {
      cube(baseSize);
      translate([10+epsilon,10,10]) {
        cube(innerBase);
      }
    }
  }
}

module main() {
  difference() {
    union() {
      barCylinder();
      cylinderBase();
    }
    space = baseSize.z/3;
    screwHole(space);
    screwHole(space*2);
  }
}

main();