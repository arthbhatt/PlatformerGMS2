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
AirFriction = 0.2;

Grv = 0.9;
WallFriction = 0.2; //This applies in the veritcal direction

//Magnetic wall vars
HoldCount = 0;
BreakAwayVal = 0; //5

//Maximum oPlayer speed (It cannot be greater that oPlayer_width+oWall_width. i.e. 128 for now)
HoriSpeedMax = 20;
VertSpeedMax = 20;

//Disabling animation for oPlayer
image_speed = 0;

//Shooter vars
HandObject = oShooter;
HookObject = noone;

//Rope Physics vars
PlayerSpeed = 0;
PlayerDirection = 0;

RopeTugJumpSpeed = 20;

AlongRopeSpeed = 0;
RopeAngle = 0;
BetweenPlayerDirectionAndRopeAngle = 0;
TangentToRopeSpeed = 0;
TangentToRopeAngle = 0;