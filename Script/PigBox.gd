extends KinematicBody2D

onready var animatedSprite=$AnimatedSprite
onready var animationPlayer=$AnimationPlayer
onready var timer=$Aim/Position2D/Timer
onready var hitBox=$Aim/Position2D/CollisionShape2D
onready var boxPiece=preload("res://Scene/body/BoxPiece.tscn")

const PIG=preload("res://Scene/enemy/CommonPig.tscn")
var XSPEED=1.5
var YSPEED=4
var SPEED=50
var ACCERATION=40
var FRICTION=5
var player=null

var cooling=false;
var direction=null;
var velocity=Vector2.ZERO
export var GRAVITY=10

func _ready():
	hitBox.disabled=true
	animatedSprite.animation="Stay";
	animationPlayer.play("Stay")
func _physics_process(delta):
	if(!is_on_floor()):
		velocity.y+=GRAVITY*delta
		if(direction=="Left"):
			velocity.x-=FRICTION*delta
		else:
			velocity.x+=FRICTION*delta
	elif(velocity.y>0):
		velocity.y=0
		velocity.x=0
		animatedSprite.animation="Stay";
		animationPlayer.play("Stay")
		hitBox.set_deferred("disabled",true)
	velocity=velocity.move_toward(velocity,ACCERATION*delta)
	move_and_slide(velocity*SPEED,Vector2.UP, false, 4, PI/4, false)
	
func _on_AttackArea2D_body_entered(body):
	if(!cooling):
		animatedSprite.animation="Attack";
		animationPlayer.play("Attack")
		attack()
func attack():
	if(player):
		hitBox.set_deferred("disabled",false)
		velocity.y-=YSPEED;
		if((player.global_position-global_position).x<0):
			direction="Left"
		else:
			direction="Right"

		if(direction=="Left"):
			velocity.x-=XSPEED;
		else:
			velocity.x+=XSPEED;
		cooling=true;
		timer.start(2)
func _on_Timer_timeout():
	cooling=false;

func _on_HurtBox_area_exited(area):
	call_deferred("box_break",area.global_position.x>global_position.x)
	

func _on_HurtBox_area_entered(area):
	PlayerStatu.emit_signal("hit")	

func box_break(direction):
	var body=boxPiece.instance();
	var main=get_tree().current_scene
	main.add_child(body);
	body.set_deferred("global_position",global_position)
	queue_free()
	


func _on_Position2D_area_entered(area):
	hitBox.set_deferred("disabled",true)
	


func _on_PlayerDetectionZone_body_entered(body):
	player=body
	animatedSprite.animation="Look";
	animationPlayer.play("Look")


func _on_PlayerDetectionZone_body_exited(body):
	animatedSprite.animation="Hide";
	animationPlayer.play("Hide")
	player=null


