/// @description Core Player Logic

//Get Player Input
KeyLeft = keyboard_check(vk_left);
KeyRight = keyboard_check(vk_right);
KeyJump = keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_shoulderl);

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
}

//Detect if oPlayer is standing on oWall or not
var _OnGround = place_meeting(x, y+1, oWall);

//Detect if oPlayer is touching oWall on his left or right
var _TouchingRightWall = place_meeting(x+1, y, oWall);
var _TouchingLeftWall = place_meeting(x-1, y, oWall);

//Calculate movement

//Directional Control Movement
var _Move = KeyRight - KeyLeft;

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


//Update Player Coords
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
	game_end();
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
