extends KinematicBody2D

onready var animatedSprite=$AnimatedSprite
onready var Bomb=preload("res://Scene/Bomb.tscn")
onready var Pig=preload("res://Scene/enemy/CommonPig.tscn")
onready var PlayerDetect=$PlayerDetection
onready var playerDetectCollision=$PlayerDetection/PlayerDetectionZone/CollisionShape2D
func _ready():
	if(animatedSprite.flip_h):
		PlayerDetect.direction="Left"
	animatedSprite.play("Idle")

func _on_PlayerDetectionZone_body_entered(body):
	if(body):		
		var xdistance=body.global_position.x-global_position.x;#玩家相对于炸弹猪的位置
		var ydistance=global_position.y-body.global_position.y+150
		if(xdistance<0):#玩家在炸弹猪左边
			animatedSprite.flip_h=false
		else:
			animatedSprite.flip_h=true
		animatedSprite.play("ThrowBomb") 
		yield(get_node("AnimatedSprite"),"animation_finished")
		var bomb=Bomb.instance()
		var pig=Pig.instance()
		var main=get_tree().current_scene
		main.add_child(bomb);
		bomb.global_position=global_position
		if(xdistance<0):#玩家在炸弹猪左边
			bomb.global_position.x-=10
		else:
			bomb.global_position.x+=10
		bomb.XSPEED=abs(xdistance);
		bomb.YSPEED=ydistance
		main.add_child(pig)
		pig.global_position=global_position
		


func _on_HitBox_area_entered(area):
	queue_free()



