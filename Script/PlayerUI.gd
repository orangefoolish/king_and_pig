extends Control

onready var heart1=$Heart1
onready var heart2=$Heart2
onready var heart3=$Heart3
onready var playerStatu=PlayerStatu
onready var tensNumber=$TensNumber
onready var oneNumber=$OneNumber
var stop=false
var heart=null setget set_heart
var score=null
var start=true
func _ready():
	set_number()
	score=playerStatu.score
	heart1.play("Idle")
	heart2.play("Idle")
	heart3.play("Idle")
	heart=playerStatu.health
	playerStatu.connect("health_change",self,"set_heart")
	playerStatu.connect("get_score",self,"set_number")
	playerStatu.connect("no_health",self,"stop")
	
func stop():
	stop=true
	
func set_number():
	if(!stop):
		score=playerStatu.score
		if(!start):
			AudioManage.play("Diamond")
		else:
			start=false
		if(score>=10):
			tensNumber.frame=int(score/10);
			tensNumber.visible=true;
		if(oneNumber.global_position.x==tensNumber.global_position.x):
			oneNumber.global_position.x=tensNumber.global_position.x+5
		oneNumber.frame=score%10

	
func set_heart(value):
	if(!stop):
		if(value<heart):
			match value:
				0:
					if(heart2.animation!="Hit"):
						heart2.play("Hit")
					if(heart3.animation!="Hit"):
						heart3.play("Hit")
					heart1.play("Hit")
				1:
					if(heart3.animation!="Hit"):
						heart3.play("Hit")
					heart2.play("Hit")
				2:		
					heart3.play("Hit")	
		else:
			match value:
				2:
					heart2.play("Idle")
				3:
					if(heart1.animation!="Idle"):
						heart2.play("Idle")
					if(heart2.animation!="Idle"):
						heart2.play("Idle")
					heart3.play("Idle")
		heart=value
