extends KinematicBody2D
var velocity=Vector2.ZERO#获取2D速度
var direction="IdleDown";
var state=MOVE;
export var MAX_SPEED=100;#最大移动速度
export var ACCELERATION=500;#加速度
export var FRICTION=2000;#摩擦力
var KnockBack=Vector2.ZERO;
enum{
	MOVE,
	JUMP,
	ATTACK
}
onready var animateSprite=$AnimatedSprite;
onready var animationPlayer=$AnimationPlayer

func _physics_process(delta):
	KnockBack=KnockBack.move_toward(Vector2.ZERO,FRICTION*delta);
	move_and_slide(KnockBack)
	match state:
		MOVE:
			move_state(delta);
		ATTACK:
			attack_state();
		JUMP:
			jump_state()
func move_state(delta):
	var input_vector=Vector2.ZERO;
	input_vector.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left");
	input_vector.y=Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up");
	input_vector=input_vector.normalized();
	animateSprite.animation="Move"
	animationPlayer.play("Move")
	if(input_vector!=Vector2.ZERO):
		if(input_vector.x>0):
			direction="Right"
		elif(input_vector.x<0):
			direction="Left"
		velocity=velocity.move_toward(input_vector*MAX_SPEED,ACCELERATION*delta);
	else:
		animationPlayer.play("Idle")	
		velocity=velocity.move_toward(Vector2.ZERO,FRICTION*delta);
	move_and_slide(velocity)#角色坐标移动函数,并且这个函数可以处理碰撞时的移动，并且在碰撞的时候会返回一个速度向量
	
	if(Input.is_action_just_released("ui_jump")):
		state=JUMP;
	elif(Input.is_action_just_pressed("ui_attack")):
		state=ATTACK;
	
func attack_state():
	velocity=Vector2.ZERO
	match direction:
		"IdleUp":
			animationPlayer.play("AttackUp");
		"IdleDown":
			animationPlayer.play("AttackDown");
		"IdleLeft":
			animationPlayer.play("AttackLeft");
		"IdleRight":
			animationPlayer.play("AttackRight");
	
func _on_PlayerHurtBox_area_entered(area):
	pass
	
func jump_state():
	pass
	
func _on_PlayerHurtBox_invincible_end():
	pass # Replace with function body.


func _on_PlayerHurtBox_invincible_start():
	pass
