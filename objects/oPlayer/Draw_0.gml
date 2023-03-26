/// @description Drawing rope

if(HookObject != noone)
{
	//draw_line(x, y, HookObject.x, HookObject.y);
	draw_line_width_colour(x, y, HookObject.x, HookObject.y, 10, c_white, c_white);
}

draw_self();