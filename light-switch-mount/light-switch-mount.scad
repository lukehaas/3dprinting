use <MCAD/boxes.scad>

$fa = 1;
$fs = 0.4;

lightSwitchBaseSize = [
  85,
  86,
  10
];
lightSwitchBasePosition = [
  2,
  2,
  -0.1
];

outerRadius = 2;

mainSize = [
  lightSwitchBaseSize.x + 4,
  lightSwitchBaseSize.y + 4,
  lightSwitchBaseSize.z + 10
];

hueIndentSize = [
  34.6,
  92,
  11.5
];

hueIndentPosition = [
  (mainSize.x / 2) - hueIndentSize.x / 2,
  2,
  mainSize.z - hueIndentSize.z / 2,
];


switchIndentSize = [
  18,
  25,
  7
];

switchIndentPosition = [
  (mainSize.x / 2) - switchIndentSize.x / 2,
  (mainSize.y / 2) - switchIndentSize.y / 2,
  lightSwitchBaseSize.z - 0.2
];

module hueNotch() {
  translate(hueIndentPosition)
    roundedCube(hueIndentSize, 4, false, false);

  hueNotchSize = [
    25.2,
    2.2,
    1
  ];
  hueNotchPosition = [
    (mainSize.x / 2) - hueNotchSize.x / 2,
    mainSize.y - hueNotchSize.y + 0.1,
    hueIndentPosition.z - hueNotchSize.z + 0.1
  ];

  translate(hueNotchPosition)
    cube(hueNotchSize,center=false);
}

module magnetSocket() {
  socketRadius = 3.05;
  socketHeight = 5.8;
  position = [
    (mainSize.x / 2),
    switchIndentPosition.y + switchIndentSize.y + socketRadius + 1,
    lightSwitchBaseSize.z - 0.2
  ];


  translate(position)
    cylinder(h=socketHeight,r=socketRadius,center=true);
}

module sideIndents() {
  width = mainSize.x * 0.5;
  offsetX = 2;
  
  positions = [
    [hueIndentPosition.x - width - offsetX,-4,11],
    [hueIndentPosition.x + hueIndentSize.x + offsetX,-4,11]
  ];
  

  for ( i = [0 : 1] ) {
    translate(positions[i])
      roundedCube([width,mainSize.y + 8,15], 4, false, false);
  }
}

module switchIndentHole() {
  translate(switchIndentPosition)
    cube(switchIndentSize,center=false);
}


difference() {
  roundedCube(mainSize, outerRadius, true, false);

  translate(lightSwitchBasePosition)
    roundedCube(lightSwitchBaseSize, outerRadius, true, false);

  hueNotch();
  magnetSocket();
  sideIndents();
  switchIndentHole();
}
