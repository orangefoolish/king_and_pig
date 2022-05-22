extends KinematicBody2D
onready var body=preload("res://Scene/body/CommonPigBody.tscn")
onready var enemyStat=$EnemyStat
onready var animatedSprite=$AnimatedSprite
onready var dialog=$Dialog
onready var timer=$HitBox/Position2D/Timer
var velocity=Vector2.ZERO
onready var PlayerDetect=$PlayerDetection
onready var playerDetectCollision=$PlayerDetection/PlayerDetectionZone/CollisionShape2D
onready var dialogAnimateSprite=$Dialog/AnimatedSprite
var pause=false#是否被击中了或者死亡了
var playerDetect=false;#是否发现了玩家
var cooling=false;#攻击冷却

func _ready():
	dialog.visible=false;
	PlayerStatu.connect("no_health",self,"vectory")
	
func _on_HurtBox_area_entered(area):
	cooling=true;
	timer.start(0.75);
	enemyStat.health-=area.damage
	PlayerStatu.emit_signal("hit")
	AudioManage.play("EnemyHit")
	if(enemyStat.health>0):
		pause=true;
		animatedSprite.play("Hit")
		yield(get_node("AnimatedSprite"),"animation_finished")
		pause=false
		
func _on_EnemyStat_no_health():
	pause=true
	dialog.visible=true;
	dialogAnimateSprite.play("Dead")
	animatedSprite.play("Die")
	yield(get_node("AnimatedSprite"),"animation_finished")
	velocity=Vector2.ZERO
	#playerDetectCollision.disabled=true
	var deadbody=body.instance();
	get_parent().add_child(deadbody)
	deadbody.get_child(0).flip_h=animatedSprite.flip_h
	deadbody.global_position=global_position;
	queue_free()

func vectory():
	dialogAnimateSprite.play("Vectory")
	
