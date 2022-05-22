extends "res://Script/Enemy.gd"

onready var fireCannonBox=$HitBox/Position2D/CollisionShape2D
onready var hitBox=$HitBox
onready var aim=$HitBox

var find_player=false
func _ready():
	animatedSprite.play("MatchOn")
	fireCannonBox.disabled=true;
	if(animatedSprite.flip_h):
		PlayerDetect.direction="Left"
		hitBox.direction="Left"
func _physics_process(delta):
	if(find_player):
		fire()
		
func fire():
	if(!cooling):
		timer.start(2.5)
		cooling=true
		animatedSprite.play("FireCannon")
		fireCannonBox.set_deferred("disabled",false)
		yield(get_node("AnimatedSprite"),"animation_finished")
		fireCannonBox.set_deferred("disabled",true)
		animatedSprite.play("LightMatch")
		yield(get_node("AnimatedSprite"),"animation_finished")
		animatedSprite.play("MatchOn")
			

func _on_Timer_timeout():
	cooling=false


func _on_PlayerDetectionZone_body_entered(body):
	find_player=true;
	


func _on_PlayerDetectionZone_body_exited(body):
	find_player=false
