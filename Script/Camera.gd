extends Camera2D

var time=0;
var length=0;
var time_add=0;
var shake_range=0
var freq=0
onready var cameraPos=position
onready var animate=$AnimationPlayer
func _ready():
	PlayerStatu.connect("hit",self,"shake")
	animate.play("Animate")
func shake():
	set_value()
	while time<length:
		time+=time_add
		var offset=Vector2()
		offset.x=rand_range(-shake_range,shake_range)
		offset.y=rand_range(-shake_range,shake_range)
		var newPos=cameraPos+offset;
		position=newPos
		yield(get_tree().create_timer(freq),"timeout")
	position=cameraPos
	
func set_value():
	time=0;
	length=1;
	time_add=0.25;
	shake_range=2
	freq=0.05
