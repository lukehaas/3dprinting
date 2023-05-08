spacer = [54,53,10];
epsilon = 0.01;

difference() {
  cube(spacer,center=false);
    mirror([1,0,0]) {
      translate([-spacer.x/2,37, -epsilon]) {
        linear_extrude(0.5) {
          text("AxiDraw", font = "Liberation Sans:style=Bold", size = 7, halign = "center");
        }
      }
      translate([-spacer.x/2, 26, -epsilon]) {
        linear_extrude(0.5) {
          text("Canvas", font = "Liberation Sans:style=Bold", size = 7, halign = "center");
        }
      }

      translate([-spacer.x/2, 15, -epsilon]) {
        linear_extrude(0.5) {
          text("Spacer", font = "Liberation Sans:style=Bold", size = 7, halign = "center");
        }
      }

      translate([-spacer.x/2, 2, -epsilon]) {
        linear_extrude(0.5) {
          text("54mm", font = "Liberation Sans:style=Bold", size = 4, halign = "center");
        }
      }
     translate([-2, spacer.y/2, -epsilon]) {
      rotate([0,0,90]) {
          linear_extrude(0.5) {
            text("53mm", font = "Liberation Sans:style=Bold", size = 4, halign = "center");
          }
        }
    }
  }
}
