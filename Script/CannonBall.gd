extends KinematicBody2D

var velocity=Vector2.ZERO
onready var animatedSprite=$AnimatedSprite
var pause=false
export var speed=26;
export var direction="null" setget set_direction
var xposition;
func _ready():
	if(direction=="Right"):
		velocity.x+=speed;
	else:
		velocity.x-=speed;
	animatedSprite.play("Idle")
func _physics_process(delta):	
	if(xposition==global_position.x):
		if(!pause):
			pause=true
			AudioManage.play("BallBoom")
			animatedSprite.play("Boom")
			yield(get_node("AnimatedSprite"),"animation_finished")
			queue_free()
	else:
		xposition=global_position.x
	move_and_collide(velocity)

func set_direction(dir):
	direction=dir
