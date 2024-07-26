extends CanvasLayer

@onready var time_label: Label = %Timer
@onready var meat_label: Label = %Meat


func _process(delta):
	time_label.text = GameManager.time_elapsed_string
	meat_label.text = str(GameManager.meat_counter)
	
