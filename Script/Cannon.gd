extends StaticBody2D

onready var animatedSprite=$AnimatedSprite
onready var ball=preload("res://Scene/CannonBall.tscn")

func _ready():
	animatedSprite.play("Idle")

func _on_HurtBox_area_entered(area):
	animatedSprite.play("Shoot")
	var cannonBall=ball.instance()
	var main=get_tree().current_scene;
	if(animatedSprite.flip_h):
		cannonBall.set_direction("Right")
	main.add_child(cannonBall)	
	PlayerStatu.emit_signal("hit")
	cannonBall.global_position=global_position
	cannonBall.global_position.y-=5
	AudioManage.play("Fire")
	yield(get_node("AnimatedSprite"),"animation_finished")
	animatedSprite.play("Idle")
