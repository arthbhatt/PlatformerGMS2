/// @description Transition logic setup.

//window_set_size(2560, 1600);
window_set_fullscreen(true);

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