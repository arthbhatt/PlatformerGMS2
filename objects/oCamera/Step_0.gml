/// @description Update camera

//Update destination
if(instance_exists(Follow))
{
	xTo = Follow.x;
	yTo = Follow.y;
}

//Update object position
x += (xTo - x)/25;
y += (yTo - y)/25;

x = clamp(x, ViewWHalf, room_width-ViewWHalf);
y = clamp(y, ViewHHalf, room_height-ViewHHalf);

//Update camera view
camera_set_view_pos(Cam, x - ViewWHalf, y - ViewHHalf);