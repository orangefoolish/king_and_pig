extends Node2D
onready var sprite=$Sprite

var on_area=false

func ready():
	sprite.scale.x=0

func _physics_process(delta):
	if(!on_area):
		if(sprite.scale.x>0):
			sprite.scale.x-=0.008
		else:
			sprite.visible=false
	else:
		if(sprite.scale.x<0.1):
			sprite.scale.x+=0.01
func _on_PlayerDetectionZone_body_entered(body):
	sprite.visible=true
	on_area=true;



func _on_PlayerDetectionZone_body_exited(body):
	on_area=false;
