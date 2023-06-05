$fa = 1;
$fs = 0.4;

barSize = [35, 35, 300];
outerBarSize = [barSize.x + 5, barSize.y + 5, barSize.z];
baseSize = [30,60,50];
innerBase = [baseSize.x - 5, baseSize.y - 20, baseSize.z - 20];
epsilon = 0.01;


module main() {
  difference() {
    union() {
      cylinder(h=50, d=outerBarSize.x, center=false);

      linear_extrude(height = 50) {
        polygon(points=[[0,outerBarSize.y/2],[outerBarSize.x/2,0],[barSize.x/2,baseSize.y/2]], paths=[[0,1,2]]);
        polygon(points=[[0,-outerBarSize.y/2],[outerBarSize.x/2,0],[barSize.x/2,-baseSize.y/2]], paths=[[0,1,2]]);
      }
    }
    translate([0, 0, 5]) {
      cylinder(h=50, d=barSize.x + 0.2, center=false);
    }
  }
  
    translate([barSize.x/2,-30,0]) {
      difference() {
      cube(baseSize);
      
      translate([5+epsilon,10,10]) {
        cube(innerBase);
      }
    }

  }

}

main();