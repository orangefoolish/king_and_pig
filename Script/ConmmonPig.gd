extends "res://Script/Enemy.gd"

onready var hitBox=$HitBox
onready var hitBoxCollision=$HitBox/Position2D/CollisionShape2D
onready var wanderTimer=$WanderTimer
var player=null;
var distance=0;
var MAXSPEED=4000
export var is_wander=false#是否正在闲逛
enum{
	WANDER,MOVE,ATTACK,IDLE,FALL
}
var state=IDLE
func _ready():
	hitBoxCollision.set_deferred("disabled",true)
	hitBox.direction="Left"
	randomize()#每次随机的时候选取不同的种子 
	
func _physics_process(delta):
	if(!is_on_floor()):
		velocity.y+=5;
		if(velocity.y>5):
			state=FALL	
	else:
		velocity.y=0
	move_and_slide(velocity,Vector2.UP, false, 4, PI/4, false)
	if(!pause):
		match state:
			IDLE:
				idle()
			WANDER:
				wander(delta)
			ATTACK:
				attack()
			MOVE:
				go_to_player(delta)
			FALL:
				fall()
	else:
		velocity.x=0
func fall():
	if(velocity.y==0):
		state=IDLE
		return
	animatedSprite.play("Fall")
func idle():
	find_player()
	animatedSprite.play("Idle")
	velocity=Vector2.ZERO	
	yield(get_node("AnimatedSprite"),"animation_finished")
	state=pick_random_state([IDLE,WANDER]);
	
func wander(delta):
	find_player()
	if(!is_wander):
		is_wander=true
		velocity.x=rand_range(-1,1);
		if(velocity.x>0):
			velocity.x=0.8*MAXSPEED*delta
			animatedSprite.flip_h=true
			PlayerDetect.direction="Left"
		else:
			velocity.x=-0.8*MAXSPEED*delta
			animatedSprite.flip_h=false
			PlayerDetect.direction="Right"
		animatedSprite.play("Move")
		wanderTimer.start(rand_range(1,3))
func go_to_player(delta):
	if(player):
		distance=global_position.x-player.global_position.x;
		if(distance<-28||distance>28):
			animatedSprite.play("Move")
			if(distance>0):
				velocity.x=-MAXSPEED*delta
				animatedSprite.flip_h=false
				hitBox.direction="Left"
				PlayerDetect.direction="Right"
			else:
				velocity.x=MAXSPEED*delta
				animatedSprite.flip_h=true
				hitBox.direction="Right"
				PlayerDetect.direction="Left"
		else:
			if(!cooling):
				state=ATTACK	
			

func find_player():
	if(player):
		state=MOVE
		return
func attack():
	if(!cooling&&!pause):
		cooling=true
		timer.start(4)		
		animatedSprite.play("Attack")
		velocity=Vector2.ZERO
		yield(get_tree().create_timer(0.2),"timeout")
		hitBoxCollision.disabled=false;	
		AudioManage.play("EnemyAttack")
		yield(get_node("AnimatedSprite"),"animation_finished")
		hitBoxCollision.disabled=true;	
		state=IDLE

func _on_AnimationPlayer_animation_finished(anim_name):
	dialog.visible=false

func _on_WanderTimer_timeout():
	is_wander=false
	state=pick_random_state([IDLE,WANDER]);
	


func _on_Timer_timeout():
	cooling=false


func _on_AnimatedSprite_animation_finished():
	dialog.visible=false

func pick_random_state(state_list):
	state_list.shuffle();
	return state_list.pop_front();


func _on_WallDectctionZone_body_entered(body):
	velocity.x=-velocity.x
	animatedSprite.flip_h=!animatedSprite.flip_h


func _on_PlayerDetectionZone_body_entered(body):
	dialog.visible=true;
	dialogAnimateSprite.play("FindPlayer")
	player=body
	yield(get_node("AnimatedSprite"),"animation_finished");


func _on_PlayerDetectionZone_body_exited(body):
	dialog.visible=true;
	dialogAnimateSprite.play("Confuse")
	player=null
	state=pick_random_state([IDLE,WANDER]);
