extends Control

onready var next_sence=preload("res://Scene/Level/1-1.tscn")

func _input(event):
	if(Input.is_action_just_pressed("ui_select")):
		get_tree().change_scene_to(next_sence)
