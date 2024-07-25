extends CanvasLayer

@onready var time_label: Label = %Timer
@onready var gold_label: Label = %Gold
@onready var meat_label: Label = %Meat

var time_elapsed: float = 0.0
var meat_counter: int = 0

func _ready():
	GameManager.player.meat_collected.connect(on_meat_collected)
	meat_label.text = str(meat_counter)
	
func _process(delta):
	time_elapsed += delta
	var time_elapsed_seconds: int = floori(time_elapsed)
	var seconds: int = time_elapsed_seconds % 60
	var minutes: int = time_elapsed_seconds / 60
	
	time_label.text = "%02d:%02d" % [minutes, seconds]
	
func on_meat_collected(regeneration_value:int) -> void:
	meat_counter += 1
	meat_label.text = str(meat_counter)
