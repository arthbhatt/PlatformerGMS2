/// @description Update Gun Position

x = oPlayer.x;
y = oPlayer.y;

//Point the gun in the direction where the player is facing
//image_xscale = oPlayer.image_xscale;

image_angle = HoldingAngle;

//Get gamepad R analog stick value
var GamepadRHAxis = gamepad_axis_value(0, gp_axisrh);
var GamepadRVAxis = gamepad_axis_value(0, gp_axisrv);

//show_debug_message("RightHorizontalAxis = {0}", GamepadRHAxis);
//show_debug_message("RightVerticalAxis = {0}", GamepadRVAxis);

//Point the gun to the direction in which R analog stick is pointing
if(abs(GamepadRHAxis) > 0.2 || abs(GamepadRVAxis) > 0.2)
{
	//image_angle = arctan(GamepadRVAxis/GamepadRHAxis) * 180/pi;
	image_angle = point_direction(0,0,GamepadRHAxis,GamepadRVAxis);
}

