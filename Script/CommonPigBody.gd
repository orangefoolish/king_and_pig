extends KinematicBody2D

var velocity=Vector2.ZERO

func _physics_process(delta):
	if(!is_on_floor()):
		velocity.y+=5;
		move_and_slide(velocity,Vector2.UP)
	else:
		velocity=0
		
