extends KinematicBody2D

onready var animatedSprite=$AnimatedSprite
onready var hitBoxCollisionShape2D=$HitBox/CollisionShape2D
onready var hurtBoxCollisionShape=$HurtBox/CollisionShape2D

var velocity=Vector2.ZERO;
var gravity=4.9
var fire=false;
var is_boomed=false
export var XSPEED=120 setget set_xspeed
export var YSPEED=150 setget set_yspeed
func _ready():
	animatedSprite.animation="BombOff";
	animatedSprite.play("BombOff")
	hitBoxCollisionShape2D.set_deferred("disabled",true)
	
func set_xspeed(speed):
	XSPEED=speed
	
func set_yspeed(speed):
	YSPEED=speed
	is_boomed=false
func _physics_process(delta):
	if(!is_on_floor()):
		velocity.y+=gravity
	else:
		if(velocity.y>0&&fire&&!is_boomed):
			is_boomed=true
			velocity.y=0
			velocity.x=0			
			animatedSprite.animation="Boom";
			animatedSprite.play("Boom")
			AudioManage.play("Boom")
			PlayerStatu.emit_signal("hit")
			hitBoxCollisionShape2D.set_deferred("disabled",false)
			yield(get_node("AnimatedSprite"),"animation_finished")
			queue_free()
	move_and_slide(velocity,Vector2.UP, false, 4, PI/4, false)



func _on_HurtBox_area_entered(area):
	hurtBoxCollisionShape.set_deferred("disabled",true)
	animatedSprite.animation="BombOn";
	animatedSprite.play("BombOn")
	if(global_position.x-area.global_position.x>0):#炸弹在攻击区域的右边
		velocity.x=XSPEED	
	else:
		velocity.x=-XSPEED
	velocity.y=-YSPEED
	fire=true;
	move_and_slide(velocity,Vector2.UP, false, 4, PI/4, false)
