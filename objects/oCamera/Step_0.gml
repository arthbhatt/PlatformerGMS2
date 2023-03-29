/// @description Update camera

//Update destination
if(instance_exists(Follow))
{
	xTo = Follow.x;
	yTo = Follow.y;
}

//Update object position
var _xShift = (xTo - x)/10; //25
var _yShift = (yTo - y)/10; //25

if(_xShift > MaxHPanSpeed)
{
	_xShift = MaxHPanSpeed;
}

if(_yShift > MaxVPanSpeed)
{
	_yShift = MaxVPanSpeed;
}

x += _xShift;
y += _yShift;

x = clamp(x, ViewWHalf, room_width-ViewWHalf);
y = clamp(y, ViewHHalf, room_height-ViewHHalf);

//Update camera view
camera_set_view_pos(Cam, x - ViewWHalf, y - ViewHHalf);