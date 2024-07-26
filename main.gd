extends Node2D

@export var game_ui: CanvasLayer
@export var gameOver_ui_template: PackedScene

func _ready():
	GameManager.game_over.connect(trigger_game_over)

func trigger_game_over():
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	
	var game_over_ui: GameOverUI = gameOver_ui_template.instantiate()
	add_child(game_over_ui)

	
