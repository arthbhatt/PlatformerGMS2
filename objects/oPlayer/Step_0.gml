/// @description Core Player Logic

//TODO: Define keyboard bindings
var _KBindLeft = vk_left;

//Get Player Input
KeyLeft = keyboard_check(_KBindLeft);
KeyRight = keyboard_check(vk_right);
KeyJump = keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_shoulderl) || gamepad_button_check_pressed(0, gp_face1); //gp_shoulderl

keyShoot = keyboard_check_pressed(ord("E")) || gamepad_button_check_pressed(0, gp_shoulderrb) || gamepad_button_check_pressed(0, gp_shoulderr) || gamepad_button_check_pressed(0, gp_face3);
keyRopeRelease = keyboard_check_released(ord("E")) || gamepad_button_check_released(0, gp_shoulderrb)  || gamepad_button_check_released(0, gp_shoulderr) || gamepad_button_check_released(0, gp_face3);

KeyReset = keyboard_check_pressed(vk_escape) || gamepad_button_check_pressed(0, gp_start);

KeyDive = gamepad_button_check_pressed(0, gp_shoulderlb);

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
	x = 300;
	y = 4600;
	
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
		instance_destroy(HookObject);
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

//
// Physics Calculation 
// There are three main phases to it-
// 1) Updating acceleration
// 2) Updating speeds
// 3) Updating coords
//

//
// 1) Updating Acceleration
//

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

//
// 2) Updating Speeds
//

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
//TODO: Try removing magnetic wall and disabling horizontal direction control after doing a wall jump for a few frames
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

//Dive
if(KeyDive)
{
	VertSpeed += DiveSpeed;
}

//Jump
if(KeyJump)
{
	var _IsNormalJumpPossible = 0;
	
	//Rope Tug Jump
	if(HookObject != noone)
	{
		if(HookObject.Hooked == 1) && (HookObject.Taught == 1)
		{	
			show_debug_message("RopeTugJump");
			
			_IsNormalJumpPossible = 0;
			AlongRopeSpeed = -1 * RopeTugJumpSpeed;
			
			HoriSpeed += AlongRopeSpeed * dcos(RopeAngle);
			VertSpeed -= AlongRopeSpeed * dsin(RopeAngle);
		}
		else
		{
			_IsNormalJumpPossible = 1;
		}
	}
	else
	{
		_IsNormalJumpPossible = 1;
	}
	
	if(_IsNormalJumpPossible == 1)
	{
		show_debug_message("NormalJump attempted");
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
}

//Rope Swinging Physics
if(HookObject != noone)
{
	if(HookObject.Hooked == 1)
	{	
		if(HookObject.HookedObject.object_index == oWall)
		{
			show_debug_message("Wall Object Hooked!");
		}
		else
		{
			show_debug_message("Box Object Hooked!");
		}
		
		var _PlayerDistanceFromHook = point_distance(HookObject.x, HookObject.y, x, y);
		
		//Check to see if the rope is taught
		if(_PlayerDistanceFromHook >= HookObject.RopeLength)
		{
			HookObject.Taught = 1;
		
			RopeAngle = point_direction(HookObject.x, HookObject.y, x, y);// * pi/180;
			
			PlayerDirection = arctan2(-1*VertSpeed, HoriSpeed) * 180/pi;
			PlayerSpeed = sqrt(power(VertSpeed, 2) + power(HoriSpeed, 2));
		
			BetweenPlayerDirectionAndRopeAngle = PlayerDirection - RopeAngle;
			
			//Keep the speed tangent to rope's direction as it is
			TangentToRopeSpeed = PlayerSpeed * dsin(BetweenPlayerDirectionAndRopeAngle);
			TangentToRopeAngle = RopeAngle + 90;
		
			HoriSpeed = TangentToRopeSpeed * dcos(TangentToRopeAngle);
			VertSpeed = -1* TangentToRopeSpeed * dsin(TangentToRopeAngle);
			
			// Allow the rope to go slack, if moving along its direction
			AlongRopeSpeed = PlayerSpeed * dcos(BetweenPlayerDirectionAndRopeAngle);
			 //Moving opposite to the direction of rope, so apply momentum conservation
			 //TODO: Consider HookedObject's speed. So, if oPlayer fires hook at a heavy moving object, it should pull oPlayer along
			if(AlongRopeSpeed > 0)
			{
				if(HookObject.HookedObject.object_index == oBox)
				{
					var _HookedObjectMass = HookObject.HookedObject.Mass;
					var _CombinedMass = _HookedObjectMass + Mass;
					
					var _HookedObjectTugSpeed = AlongRopeSpeed * Mass/_CombinedMass;
					AlongRopeSpeed = AlongRopeSpeed * _HookedObjectMass/_CombinedMass;
					
					//Apply tug speed to HookedObject
					HookObject.HookedObject.HoriSpeed += _HookedObjectTugSpeed * dcos(RopeAngle);
					HookObject.HookedObject.VertSpeed -= _HookedObjectTugSpeed * dsin(RopeAngle);
				}
				else
				{
					AlongRopeSpeed = 0;
				}
			}
			
			HoriSpeed += AlongRopeSpeed * dcos(RopeAngle);
			VertSpeed -= AlongRopeSpeed * dsin(RopeAngle);
			
		}	
		else
		{
			HookObject.Taught = 0;
		}
	}
}

//
// 3) Updating coords (and some other stuff)
//

// Inherit parent(oCollidable) event 
// (for applying speed bounds, collison checks, and update coords)
event_inherited();

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
