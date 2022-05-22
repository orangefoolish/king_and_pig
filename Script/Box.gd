extends RigidBody2D

onready var animatedSprite=$AnimatedSprite;

var velocity=Vector2.ZERO


func _on_Box_ready():
	animatedSprite.play("Stay")


func _on_HurtBox_area_entered(area):
	animatedSprite.play("Hit")
	AudioManage.play("BoxBreak")
	PlayerStatu.emit_signal("hit")	
	queue_free()

