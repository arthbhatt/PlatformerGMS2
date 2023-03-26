/// @desc SlideTransition(Mode, TargetRoom, TargetX, TargetY)
/// @arg Mode sets the transition mode between next, restart and goto
/// @arg TargetRoom Set the target room when transitioning
/// @arg TargetX [NOT USED] the X coordinate of the location where the player should start in the target room
/// @arg TargetY [NOT USED] the Y coordinate of the location where the player should start in the target room
function SlideTransition( Mode, Room, x, y )
{
	show_debug_message("Called transition script.")
	/* Verify that the object exists. */
	with( oTransition )
	{
		TargetRoom = Room
		mode = Mode;
		TargetX = x;
		TargetY = y;
	}
}