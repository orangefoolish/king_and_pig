extends Area2D
var diamond=null;
onready var boxPiece=preload("res://Scene/body/BoxPiece.tscn")
onready var Heart=preload("res://Scene/HeartAndDiamond/Heart.tscn")
onready var BigHeart=preload("res://Scene/HeartAndDiamond/BigHeart.tscn")
onready var Diamon=preload("res://Scene/HeartAndDiamond/Diamond.tscn")

func _ready():
	randomize()#每次随机的时候选取不同的种子 

func _on_HurtBox_area_entered(area):
	call_deferred("box_break",area.global_position.x>global_position.x)

func box_break(direction):
	
	var body=boxPiece.instance();
	var main=get_tree().current_scene
	if(rand_range(0,5)>4):
		var heart=Heart.instance();
		main.add_child(heart)
		heart.set_deferred("global_position",global_position)
	if(rand_range(0,5)>9):
		var bigHeart=BigHeart.instance()
		main.add_child(bigHeart)
		bigHeart.set_deferred("global_position",global_position)
	for i in range(int(rand_range(0,3))):
		diamond=Diamon.instance()
		main.add_child(diamond)
		diamond.set_deferred("global_position",global_position)
	main.add_child(body);
	body.set_deferred("global_position",global_position)
	


