/// @description oPlayer Related drawing

if(HookObject != noone)
{
	//Draw Rope from HookObject to oPlayer
	draw_line_width_colour(x, y, HookObject.x, HookObject.y, 10, c_white, c_white);
	
	//Debug start
	/*
	if(HookObject.Taught == 1)
	{	
		DrawLineAtAngle(HookObject, RopeAngle, c_blue);
		DrawLineAtAngle(self, RopeAngle, c_blue, AlongRopeSpeed*100);
		DrawLineAtAngle(self, BetweenPlayerDirectionAndRopeAngle, c_yellow);
		DrawLineAtAngle(self, TangentToRopeAngle);
		DrawLineAtAngle(self, PlayerDirection, c_olive);
	}
	*/
	//Debug end
}

draw_self();