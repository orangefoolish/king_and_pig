extends "res://Script/Enemy.gd"

onready var timer=$HitBox/Position2D/Timer
onready var hitBox=$HitBox
onready var hitBoxCollision=$HitBox/Position2D/CollisionShape2D
onready var wanderTimer=$WanderTimer

export var MAX_SPEED=3500
var player=null;
var distance=0;
export var is_wander=false#是否正在闲逛

func _ready():
	hitBoxCollision.set_deferred("disabled",true)
	hitBox.direction="Left"
	animatedSprite.animation="Idle"
	
func _physics_process(delta):
	if(!pause):
		if(!is_wander):
			move_and_slide(velocity*delta*MAX_SPEED,Vector2.UP)
		else:
			move_and_collide(velocity)
		if(playerDetect):
			go_to_player()
		else:
			if(!is_wander):
				wander()
	if(!is_on_floor()):
		velocity.y+=2;
	else:
		velocity.y=0
		
func idle():
	animatedSprite.play("Idle")
	velocity=Vector2.ZERO	
func _on_PlayerDetectionZone_body_entered(body):
	dialog.visible=true;
	dialogAnimateSprite.play("FindPlayer")
	playerDetect=true;
	player=body
	yield(get_node("AnimatedSprite"),"animation_finished");
	
func _on_PlayerDetectionZone_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	playerDetect=false;
	player=null
	dialog.visible=true;
	if(PlayerStatu.health!=0):
		dialogAnimateSprite.play("Confuse")
		yield(get_node("Dialog/AnimatedSprite"),"animation_finished");


func _on_Timer_timeout():
	cooling=false
	
func wander():
	is_wander=true
	velocity.x=rand_range(-1,1);
	if(velocity.x>0):
		velocity.x=0.8
		animatedSprite.flip_h=true
	else:
		velocity.x=-0.8
		animatedSprite.flip_h=false
	animatedSprite.play("Move")
	wanderTimer.start(3)
	
func go_to_player():
	distance=global_position.x-player.global_position.x;
	if(distance<-23||distance>23):
		animatedSprite.play("Move")
		if(distance>0):
			velocity=Vector2.LEFT
			animatedSprite.flip_h=false
			hitBox.direction="Left"
		else:
			velocity=Vector2.RIGHT
			animatedSprite.flip_h=true
			hitBox.direction="Right"
	else:
		if(!cooling):
			attack_animate()
			cooling=true
			timer.start(4)	
			pause=true
			hitBoxCollision.disabled=true
		else:
			idle()

func attack_animate():
	animatedSprite.play("Attack")
	velocity=Vector2.ZERO
	yield(get_tree().create_timer(0.2),"timeout")
	hitBoxCollision.disabled=false;	
	yield(get_node("AnimatedSprite"),"animation_finished")
	pause=false



func _on_AnimationPlayer_animation_finished(anim_name):
	dialog.visible=false

func _on_WanderTimer_timeout():
	is_wander=false
