extends Position2D

var direction=null setget set_direction;

func set_direction(direction):
	if(direction=="Right"):
		rotation_degrees=0;
	else:	
		rotation_degrees=180;



