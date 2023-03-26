/// @description Transition logic setup.

GUIWidth = display_get_gui_width();
GUIHeight = display_get_gui_height();
GUIHalfHeight = GUIHeight * 0.5;

enum TRANSITION_MODE
{
	OFF,
	INTRO,
	NEXT,
	GOTO,
	RESTART
}

mode = TRANSITION_MODE.INTRO

ScreenCoveragePercent = 1;
TargetRoom = room
TargetX = 0
TargetY = 0