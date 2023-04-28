spacer = [54,53,10];
epsilon = 0.01;

difference() {
  cube(spacer,center=false);
    mirror([1,0,0]) {
      translate([-spacer.x/2,36, -epsilon]) {
        linear_extrude(0.5) {
          text("AxiDraw", font = "Liberation Sans:style=Bold", size = 8, halign = "center");
        }
      }
      translate([-spacer.x/2, 24, -epsilon]) {
        linear_extrude(0.5) {
          text("Canvas", font = "Liberation Sans:style=Bold", size = 8, halign = "center");
        }
      }

      translate([-spacer.x/2, 12, -epsilon]) {
        linear_extrude(0.5) {
          text("Spacer", font = "Liberation Sans:style=Bold", size = 8, halign = "center");
        }
      }
  }
}
