/// @desc DrawLineAtAngle(InstanceId, Length, Direction) Draws line from an instance in a particular direction
/// @note
/// @arg InstanceId references instance from which the line should be drawn
/// @arg Direction (in degree) at which the line should be drawn
/// @arg Color defines the line's color
/// @arg Length of the line to be drawn
/// @arg Width of the line to be drawn
function DrawLineAtAngle(InstanceId, Direction, Color = c_red, Length = 100, Width = 5){
	
	if(InstanceId != noone)
	{
		with(InstanceId)	
		{
			var _TempX = lengthdir_x(Length, Direction);
			var _TempY = lengthdir_y(Length, Direction);
		
			draw_line_width_colour(x, y, x+_TempX, y+_TempY, Width, Color, Color);
		}
	}
}
