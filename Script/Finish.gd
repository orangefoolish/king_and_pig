extends Control
onready var tensNumber=$TensNumber
onready var oneNumber=$OneNumber
var score=0;
func _ready():
	score=PlayerStatu.score
	if(score>=10):
		tensNumber.frame=int(score/10);
		tensNumber.visible=true;
	if(oneNumber.global_position.x==tensNumber.global_position.x):
		oneNumber.global_position.x=tensNumber.global_position.x+5
	oneNumber.frame=score%10
