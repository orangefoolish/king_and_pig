extends Area2D

const PIG=preload("res://Scene/enemy/CommonPig.tscn")

func _on_HurtBox_area_exited(area):
	call_deferred("pig_appear")
func pig_appear():
	var pig=PIG.instance()
	get_tree().current_scene.add_child(pig);
	pig.set_deferred("global_position",global_position)
