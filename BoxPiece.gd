extends KinematicBody2D

onready var sprite1=$Sprite1
onready var sprite2=$Sprite2
onready var sprite3=$Sprite3
onready var sprite4=$Sprite4
var velocity=Vector2.ZERO

func _ready():
	sprite1.position.x+=rand_range(-8,8)
	sprite1.position.y=rand_range(2,3)
	sprite2.position.x+=rand_range(-8,8)
	sprite2.position.y=rand_range(2,3)
	sprite3.position.x+=rand_range(-8,8)
	sprite3.position.y=rand_range(2,3)
	sprite4.position.x+=rand_range(-8,8)
	sprite4.position.y=rand_range(2,3)
	
func _physics_process(delta):
	if(!is_on_floor()):
		velocity.y+=5;
	else:
		queue_free()
	move_and_slide(velocity,Vector2.UP)


