/// @description Core Player Logic

//Get Player Input
KeyLeft = keyboard_check(vk_left);
KeyRight = keyboard_check(vk_right);
KeyJump = keyboard_check_pressed(vk_up) || gamepad_button_check_pressed(0, gp_shoulderl);

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
	x = 50;
	y = 50;
}


//Calculate movement

//Directional Control Movement
var _Move = KeyRight - KeyLeft;

// Inertia calculation.
if( _Move != 0 )
{
	HoriSpeed = HoriSpeed + (Inertia * _Move);
}
else
{
	if( abs(HoriSpeed) != 0 )
	{
		HoriSpeed = HoriSpeed - (Inertia * sign(HoriSpeed));
	}
}

//Magnetic Wall (when oPlayer is in air)
if(!place_meeting(x, y+1, oWall) && (place_meeting(x+1, y, oWall) || place_meeting(x-1, y, oWall)) && HoldCount < BreakAwayVal)
{
	HoriSpeed = 0;
	HoldCount++;
}
else // Increment break-away build-up
{
	HoldCount = 0;
}

//Applying Gravity
VertSpeed += Grv;

//show_debug_message("LeftHorizontalAxis = {0}", GamepadLHAxis);
//show_debug_message("LeftVerticalAxis = {0}", GamepadLVAxis);

//Jump
if(KeyJump)
{
	//Ground Jump
	if(place_meeting(x, y+1, oWall))
	{
		VertSpeed -= JumpSpeed;
	}
	
	//Wall(on Right) Jump
	else if(place_meeting(x+1, y, oWall))
	{
		VertSpeed -= JumpSpeed;
		HoriSpeed -= JumpSpeed;
	}
	
	//Wall(on Left) Jump
	else if(place_meeting(x-1, y, oWall))
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
