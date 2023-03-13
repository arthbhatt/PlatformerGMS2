/// @description Update Gun Position

x = oPlayer.x;
y = oPlayer.y-10;

//Point the gun in the direction where the player is facing
//image_xscale = oPlayer.image_xscale;

image_angle = 0;

//Get gamepad R analog stick value
var GamepadRHAxis = gamepad_axis_value(0, gp_axisrh);
var GamepadRVAxis = gamepad_axis_value(0, gp_axisrv);

//Point the gun to the direction in which R analog stick is pointing
if(abs(GamepadRHAxis) > 0.2 || abs(GamepadRVAxis) > 0.2)
{
	//image_angle = arctan(GamepadRVAxis/GamepadRHAxis) * 180/pi;
	image_angle = point_direction(0,0,GamepadRHAxis,GamepadRVAxis);
}