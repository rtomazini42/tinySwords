extends Node2D

@onready var labelTempo: Label = %Label

@onready var timer:= $Timer as Timer

var tempo_total = 0.0
var segundos = 0

func _ready():
	pass

func _process(delta):
	tempo_total = tempo_total + delta
	segundos =  int(tempo_total)
	labelTempo.text = str(segundos)
	
	

func _on_timer_timeout():
	print("tempo")
