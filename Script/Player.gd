extends KinematicBody2D
var velocity=Vector2.ZERO#获取2D速度
var direction="Right";
var state=MOVE;
var is_hit=false#是否被击中了
var input_vector=Vector2.ZERO;
export var REPELDISTANCE=30;#被击退距离
onready var timer=$WeaponHitBox/Position2D/Timer
export var MAX_SPEED=6000;#最大移动速度
export var is_outdoor=true
export var GRAVITY=7;
var pause=false
var JUMP_DURATION=1.8
var indoor=false
var invincible=false
enum{
	MOVE,
	JUMP,
	ATTACK,
	HIT,
	DIE,
	FALL,
	INDOOR,
	OUTDOOR
}
onready var animatedSprite=$AnimatedSprite;
onready var weaponShape=$WeaponHitBox/Position2D/CollisionShape2D
onready var weaponHitBox=$WeaponHitBox
onready var Body=preload("res://Scene/body/PlayerBody.tscn")
func _ready():
	PlayerStatu.health=3
	weaponShape.disabled=true;
	if(is_outdoor):
		state=OUTDOOR
	PlayerStatu.connect("no_health",self,"no_health")
func _physics_process(delta):
	if(!pause):
		match state:
			MOVE:
				move_state(delta);
			ATTACK:
				attack_state();
			JUMP:
				jump_state()
			HIT:
				hit_State()
			DIE:
				die_state()
			FALL:
				fall_state(delta)
			INDOOR:
				indoor_state()
			OUTDOOR:
				outdoor_state()
	
func _process(delta):
	if(!is_on_floor()):
		velocity.y+=GRAVITY;
		if(velocity.y>10&&weaponShape.disabled):
			state=FALL
	else:
		if(velocity.y!=0):
			velocity.y=0
	if(indoor):
		if(Input.is_action_just_pressed("ui_up")):
			state=INDOOR
	move_and_slide(velocity,Vector2.UP, false, 4, PI/4, false)

	

func no_health():
	state=DIE

func _on_Area2D_area_entered(area):
	indoor=true
		

#下面是各种状态的具体执行代码
func _input(event):
	if(Input.is_action_just_pressed("ui_jump")&&velocity.y<10&&velocity.y>-10):
		state=JUMP;
	elif(Input.is_action_just_pressed("ui_attack")):
		state=ATTACK;

func move_state(delta):
	input_vector.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left");
	velocity.x=input_vector.x*MAX_SPEED*delta
	if(input_vector!=Vector2.ZERO):
		animatedSprite.play("Move")
		if(input_vector.x>0):
			if(direction=="Left"):
				animatedSprite.position.x+=16;
			direction="Right"
			animatedSprite.flip_h=false;
		elif(input_vector.x<0):
			if(direction=="Right"):
				animatedSprite.position.x-=16;
			direction="Left"
			animatedSprite.flip_h=true;
	else:
		animatedSprite.play("Idle")
func attack_state():
	if(weaponShape.disabled):
		AudioManage.play("PlayerAttack")
		weaponShape.disabled=false;
		weaponHitBox.direction=direction
		if(PlayerStatu.health!=0):
			if(direction=="Right"):
				velocity.x=60
			else:
				velocity.x=-60
			if(!is_on_floor()):
				velocity.x*=2
		animatedSprite.play("Attack")
		yield(get_node("AnimatedSprite"),"animation_finished")
		weaponShape.disabled=true;
		state=MOVE

func outdoor_state():
	animatedSprite.play("OutDoor")
	yield(get_node("AnimatedSprite"),"animation_finished")
	state=MOVE
func jump_state():
	velocity.y+=-220
	AudioManage.play("PlayerJump")
	animatedSprite.play("Jump")
	move_and_slide(velocity.normalized())
	state=FALL
	
func indoor_state():
	if(is_on_floor()):
		animatedSprite.play("InDoor");
		velocity=Vector2.ZERO
		yield(get_node("AnimatedSprite"),"animation_finished");
		indoor=false;
		PlayerStatu.emit_signal("next_level")

func _on_HurtBox_area_entered(area):
	if(!invincible):
		state=HIT;
		if(global_position.x-area.global_position.x>0):
			velocity.x=REPELDISTANCE
		else:
			velocity.x=-REPELDISTANCE
		move_and_slide(velocity)
		PlayerStatu.emit_signal("hit")
		PlayerStatu.health-=area.damage
		invincible=true;
		timer.start(0.5)
	
	
func hit_State():
	animatedSprite.play("Hit")
	velocity=Vector2.ZERO
	pause=true
	AudioManage.play("PlayerHit")
	yield(get_node("AnimatedSprite"),"animation_finished");
	pause=false
	state=MOVE

func fall_state(delta):
	if(is_on_floor()):
		AudioManage.play("PlayerGround")
		velocity.y=0;
		state=MOVE
	else:
		input_vector.x=(Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"))/2;
		velocity.x=input_vector.x*MAX_SPEED*delta
	move_and_slide(velocity.normalized(),Vector2.UP)
	animatedSprite.play("Fall")
func die_state():
	pause=true
	animatedSprite.play("Die");
	AudioManage.play("PlayerHit")
	yield(get_node("AnimatedSprite"),"animation_finished");
	var main=get_tree().current_scene
	var body=Body.instance();
	main.add_child(body);
	body.global_position=global_position
	if(direction=="Left"):
		body.get_child(0).flip_h=true
	queue_free()
	

func _on_Timer_timeout():
	invincible=false


func _on_Area2D_area_exited(area):
	indoor=false
