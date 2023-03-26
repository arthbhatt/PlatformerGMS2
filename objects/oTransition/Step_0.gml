/// @description Transition step event

if( mode != TRANSITION_MODE.OFF )
{
	if( mode == TRANSITION_MODE.INTRO )
	{
		ScreenCoveragePercent = max( 0, ScreenCoveragePercent - max( ScreenCoveragePercent/10, 0.005 ) );
	}
	else// if( ( mode == TRANSITION_MODE.NEXT ) || ( TRANSITION_MODE.GOTO ) )
	{
		ScreenCoveragePercent = min( 1, ScreenCoveragePercent + max( ( 1 - ( ScreenCoveragePercent / 10 ) ), 0.005 ) );
	}
	
	/* Percent is 1 when we have covered the entire screen - which happens after we have done the Next or GOTO transition.
	 * It is 0 when we have finished the into and we are not covering any part of the screen. */
	if( ( ScreenCoveragePercent == 1 ) || ( ScreenCoveragePercent == 0 ) )
	{
		switch( mode )
		{
			case TRANSITION_MODE.GOTO:
			{
				/* We have covered the entire screen with closing animation. We shall go to the
				 * given room now and begin the intro animation. */
				show_debug_message("Going to specific room.")
				mode = TRANSITION_MODE.INTRO;
				room_goto(TargetRoom);
				with( oPlayer )
				{
				    oPlayer.x = other.TargetX;
					oPlayer.y = other.TargetY;
				}
				break;
			}
			
			case TRANSITION_MODE.NEXT:
			{
				/* We have covered the entire screen with closing animation. We shall go to the
				 * next room now and begin the intro animation. */
				show_debug_message("Going to next room.")
				mode = TRANSITION_MODE.INTRO;
				room_goto_next();
				break;
			}
			
			case TRANSITION_MODE.INTRO:
			{
				/* We have finished the intro and the new level is now visible.
				 * Stop transition animation. */
				mode = TRANSITION_MODE.OFF;
				break;
			}
			
			case TRANSITION_MODE.RESTART:
			{
				game_restart();
				break;
			}
        }
	}
}
else
{
	/* The mode is off. Do nothing. */
}
