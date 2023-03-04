$fa = 1;
$fs = 0.4;

position3mm = [10, 10, 3];
positon6mm = [10, 10, 6];

cube(position3mm,center=false);

translate([0,position3mm.y,0])
  cube(positon6mm,center=false);
