/// @description Insert description here

//Player speed vars
HoriSpeed = 0;
VertSpeed = 0;

JumpSpeed = 20; //9

//Acceleration(intertia) vars
//TODO: Get this value from the oWall object that oPlayer is standing on.
//This will help us make different oWall objects (Or their children) have different types of surfaces.
//Some more slippery than the other
GroundAccel = 2;
GroundFriction = 1;

//In-air acceleration vars
AirAccel = 1;
AirFriction = 0.5;

Grv = 0.3;
WallFriction = 0.2; //This applies in the veritcal direction

//Magnetic wall vars
HoldCount = 0;
BreakAwayVal = 0; //5

HoriSpeedMax = 15;
VertSpeedMax = 10;

//Disabling animation for oPlayer
image_speed = 0;

//TODO: Add different in-air HoriAccel and Friction