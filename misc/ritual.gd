extends Node2D

@export var demage_amnt: int = 5

@onready var area2d: Area2D = $Area2D

func deal_demage():
	var bodies = area2d.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			enemy.demage(demage_amnt)
	
