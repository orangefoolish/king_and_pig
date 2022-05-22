extends RigidBody2D

onready var animatedSprite=$AnimatedSprite
func _ready():
	animatedSprite.play("Idle")
	
func _on_PlayerDetectionZone_body_entered(body):
	if(PlayerStatu.health<PlayerStatu.max_health):
		animatedSprite.play("Hit")
		PlayerStatu.set_health(PlayerStatu.health+1)
		yield(get_node("AnimatedSprite"),"animation_finished")
		queue_free()
