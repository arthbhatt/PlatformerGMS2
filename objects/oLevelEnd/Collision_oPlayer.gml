/// @description Move to next room on collission with the player

with( oPlayer )
{
	SlideTransition(TRANSITION_MODE.GOTO, other.Target, other.X, other.Y);
	HookObject = noone;
}
