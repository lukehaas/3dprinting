$fa = 1;
$fs = 0.4;

pencilRadius = 4;
weight = [10.2, 10.2, 10.2];
weightContainer = [weight.x + 1, weight.y + 1, weight.z * 0.6];
height = 18;
roundedRadius = 3;

difference() {
  translate([0,0,height])
  rotate([180,0,0])
  union() {
    rotate_extrude()
    translate([pencilRadius + 1, 0, height])
    difference() {
      square([roundedRadius, roundedRadius]);

      translate([roundedRadius, roundedRadius]) {
        circle(r = roundedRadius);
      }
    }
  }
  translate([weightContainer.x*0.5,-weightContainer.y*0.5,0]) {
    cube([weightContainer.x, weightContainer.y, height], center=false);
  }
  translate([-weightContainer.x*1.5,-weightContainer.y*0.5,0]) {
    cube([weightContainer.x, weightContainer.y, height], center=false);
  }
  translate([-weightContainer.x*0.5,-weightContainer.y*1.5,0]) {
    cube([weightContainer.x, weightContainer.y, height], center=false);
  }
  translate([-weightContainer.x*0.5,weightContainer.y*0.5,0]) {
    cube([weightContainer.x, weightContainer.y, height], center=false);
  }
}

difference() {
  union() {
    cylinder(h=height, r=pencilRadius+1, center=false);

    translate([-weightContainer.x/2, -weightContainer.y/2, height]) {
      cube(weightContainer, center=false);
    }
  }
  cylinder(h=height - 1, r=pencilRadius, center=false);

  translate([-weight.x/2, -weight.y/2, height + 2]) {
    cube(weight, center=false);
  }
}

