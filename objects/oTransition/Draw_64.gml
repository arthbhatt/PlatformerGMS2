/// @description Draw intro and exit animation on the screen

if( mode != TRANSITION_MODE.OFF )
{
	/* The draw GUI functions draw over the screen without taking the camera into
	 * consideration. It is not aware of the room etc. It will draw over the screen. */
	draw_set_color( c_black );
	draw_rectangle( 0, 0, GUIWidth, ScreenCoveragePercent * GUIHalfHeight, false );
    draw_rectangle( 0, GUIHeight, GUIWidth, ( GUIHeight - ( ScreenCoveragePercent * GUIHalfHeight ) ), false );
}
else
{
	/* Mode is off, no animation necessary. */
}
