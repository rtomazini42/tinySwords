class_name GameOverUI
extends CanvasLayer


@onready var time_label = %TempoVar

@onready var monster_label = %MonstrosVar

@export var restart_delay: float = 10.00
var restart_cooldown: float

func _ready():
	
	time_label.text = GameManager.time_elapsed_string
	monster_label.text = str(GameManager.monsters_defeated_counter)
	restart_cooldown = restart_delay
	
func _process(delta):
	restart_cooldown-= delta
	if restart_cooldown <= 0.0:
		restart_game()
		
func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()
	pass

