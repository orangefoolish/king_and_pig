extends StaticBody2D

onready var animateSprite=$AnimatedSprite;
export var next_scence:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	animateSprite.animation="Idle";
	PlayerStatu.connect("next_level",self,"change_scene")

func _on_Area2D_area_entered(area):
	animateSprite.play("Opening")


func _on_Area2D_area_exited(area):
	animateSprite.play("Closing")
	
func _input(event):
	if(Input.is_action_just_pressed("ui_restart")):
		get_tree().reload_current_scene()

func change_scene():
	get_tree().change_scene_to(next_scence)
