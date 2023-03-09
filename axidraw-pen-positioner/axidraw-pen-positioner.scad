$fa = 1;
$fs = 0.4;

layers = 3;
x = 20;
y = 20;
startingZ = 3;

for ( i = [0 : layers] ) {
  z = startingZ + i;
  translate([0, i * y, 0])
    cube([x, y, z], center=false);
}
