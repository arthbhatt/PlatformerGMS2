/// @description Core Player Logic

//Get Player Input
KeyLeft = keyboard_check(vk_left);
KeyRight = keyboard_check(vk_right);
KeyJump = keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_shoulderl);

keyShoot = keyboard_check_pressed(ord("E")) || gamepad_button_check_pressed(0, gp_shoulderr);
keyRopeRelease = keyboard_check_released(ord("E")) || gamepad_button_check_released(0, gp_shoulderr);

KeyReset = keyboard_check_pressed(vk_escape) || gamepad_button_check_pressed(0, gp_start);

var GamepadLHAxis = gamepad_axis_value(0, gp_axislh);
var GamepadLVAxis = gamepad_axis_value(0, gp_axislv);
if(abs(GamepadLHAxis) > 0.2)
{
	//show_debug_message("LeftHorizontalAxis = {0}", GamepadLHAxis);
	if(GamepadLHAxis > 0)
	{
		KeyRight = 1;
	} 
	else
	{
		KeyLeft = 1;
	}
	
}

//Reset Game State
if(KeyReset)
{
	x = 240;
	y = 1500;
	
	HandObject.image_index = 0;
}

//Shooting
if(keyShoot && (HandObject != noone)) //TODO: make a check to see if HandObject is oShooter
{
	HookObject = instance_create_layer(x, y, "Shooter", oHook);
	with(HookObject)
	{
		speed = HookSpeed;
		direction = other.HandObject.image_angle;
		
		image_angle = direction;
		
		other.HandObject.image_index = 1;
	}
}

//Check for rope holding
if(HookObject != noone)
{
	if(keyRopeRelease)
	{
		HookObject = noone;
		HandObject.image_index = 0;
	}
}

//Detect if oPlayer is standing on oWall or not
var _OnGround = place_meeting(x, y+1, oWall);

//Detect if oPlayer is touching oWall on his left or right
var _TouchingRightWall = place_meeting(x+1, y, oWall);
var _TouchingLeftWall = place_meeting(x-1, y, oWall);

//Calculate movement

//Directional Control Movement
var _Move = KeyRight - KeyLeft;

//Change holding angle of in-hand object based on the direction in which oPlayer is facing
if(_Move > 0)
{
	HandObject.HoldingAngle = 45; //0
}
else if(_Move < 0)
{
	HandObject.HoldingAngle = 180 - 45; //180
}

//Setting horizontal acceleration and horizontal friction values based on where oPlayer is
var _HAccel = 0;
var _HFriction = 0;

if(_OnGround)
{
	_HAccel = GroundAccel;
	_HFriction = GroundFriction;
}
else
{
	_HAccel = AirAccel;
	_HFriction = AirFriction;
}

// Inertia calculation.
if( _Move != 0 )
{
	HoriSpeed = HoriSpeed + (_HAccel * _Move);
}

//Appling horizontal friction
if( abs(HoriSpeed) != 0 )
{
	//HoriSpeed = HoriSpeed - (_HFriction * sign(HoriSpeed));
	
	if(abs(HoriSpeed) > _HFriction)
	{
		HoriSpeed -= _HFriction * sign(HoriSpeed);
	}
	else
	{
		HoriSpeed = 0;
	}
}


//Magnetic Wall (when oPlayer is in air)
//TODO: Also try snapping oPlayer to the Wall if it is within a certain distance of it and moving in its direction.
if(!_OnGround && (_TouchingRightWall || _TouchingLeftWall) && HoldCount < BreakAwayVal)
{
	HoriSpeed = 0;
	HoldCount++;
}
else // Increment break-away build-up
{
	HoldCount = 0;
}

//Applying Vertical Acceleration
var _VAccel = Grv;
if((_TouchingLeftWall || _TouchingRightWall) && (VertSpeed > 0))
{
	_VAccel -= WallFriction;
}
VertSpeed += _VAccel;

//show_debug_message("LeftHorizontalAxis = {0}", GamepadLHAxis);
//show_debug_message("LeftVerticalAxis = {0}", GamepadLVAxis);

//TODO: Try removing magnetic wall and disabling horizontal direction control after doing a wall jump for a few frames
//Jump
if(KeyJump)
{
	//Ground Jump
	if(_OnGround)
	{
		VertSpeed -= JumpSpeed;
	}
	
	//Wall(on Right) Jump
	else if(_TouchingRightWall)
	{
		VertSpeed -= JumpSpeed;
		HoriSpeed -= JumpSpeed;
	}
	
	//Wall(on Left) Jump
	else if(_TouchingLeftWall)
	{
		VertSpeed -= JumpSpeed;
		HoriSpeed += JumpSpeed;
	}
}


//Apply speed bounds
if(abs(HoriSpeed) > HoriSpeedMax)
{
	HoriSpeed = sign(HoriSpeed) * HoriSpeedMax;
}

if(abs(VertSpeed) > VertSpeedMax)
{
	VertSpeed = sign(VertSpeed) * VertSpeedMax;
}


//Rope Physics
if(HookObject != noone)
{
	if(HookObject.Hooked == 1)
	{	
		var _PlayerDistanceFromHook = point_distance(HookObject.x, HookObject.y, x, y);
		
		if(_PlayerDistanceFromHook >= HookObject.RopeLength)
		{
			HookObject.Taught = 1;
		
			RopeAngle = point_direction(HookObject.x, HookObject.y, x, y);// * pi/180;
			
			PlayerDirection = arctan2(-1*VertSpeed, HoriSpeed) * 180/pi;
			PlayerSpeed = sqrt(power(VertSpeed, 2) + power(HoriSpeed, 2));
		
			BetweenPlayerDirectionAndRopeAngle = PlayerDirection - RopeAngle;
			
			TangentToRopeSpeed = PlayerSpeed * dsin(BetweenPlayerDirectionAndRopeAngle);
			TangentToRopeAngle = RopeAngle + 90;
		
			HoriSpeed = TangentToRopeSpeed * dcos(TangentToRopeAngle);
			VertSpeed = -1* TangentToRopeSpeed * dsin(TangentToRopeAngle);
			
			AlongRopeSpeed = PlayerSpeed * dcos(BetweenPlayerDirectionAndRopeAngle);
			if(AlongRopeSpeed < 0) //Moving in the direction of rope, so allow movement in this direction
			{
				HoriSpeed += AlongRopeSpeed * dcos(RopeAngle);
				VertSpeed -= AlongRopeSpeed * dsin(RopeAngle);
			}
			else
			{
				AlongRopeSpeed = 0;
			}
			
		}	
	}
}


//Update Player Coords
//The collision detection would fail if the object speeds are way high(More than 128 pixels/frame). Do a check based on "if a point lies on a line"
//Horizontal Collision
if(place_meeting(x+HoriSpeed, y, oWall))
{
	//Note: Not a fan of implementing loops for changing object coords inside an already made game loop
	while(!place_meeting(x+sign(HoriSpeed), y, oWall))
	{
		x += sign(HoriSpeed);
	}
	HoriSpeed = 0;
}
x += HoriSpeed;
	
//Vertical Collision
if(place_meeting(x, y+VertSpeed, oWall))
{
	//Note: Not a fan of implementing loops for changing object coords inside an already made game loop
	while(!place_meeting(x, y+sign(VertSpeed), oWall))
	{
		y += sign(VertSpeed);
	}
	VertSpeed = 0;
}
y += VertSpeed;



//Detect wall clipping
if(place_meeting(x, y, oWall)) 
{
	show_debug_message("Wall Clipping detected!!!"); 
	//game_end();
}


//Animation
/*
if(!place_meeting(x, y+1, oWall))
{
	sprite_index = sPlayerA;
	image_speed = 0;
	if(VertSpeed > 0) // Falling
	{
		image_index = 1;
	}
	else // Rising
	{
		image_index = 0;
	}
}
else
{
	sprite_index = sPlayer;
	image_speed = 30;
}

if(HoriSpeed != 0)
{
	image_xscale = sign(HoriSpeed);
}*/
