/// @description Insert description here
// You can write your code in this editor

if(Hooked == 0)
{	
	speed = 0;
	Hooked = 1;
	HookedObject = other.id;

	RopeLength = point_distance(PlayerObject.x, PlayerObject.y, x, y);
}