extends Node2D

export var health=3 setget set_health;
export var max_health=3

signal no_health;

func set_health(value):
	health=min(value,max_health)
	health=max(0,health);
	if(health<=0):
		emit_signal("no_health")
