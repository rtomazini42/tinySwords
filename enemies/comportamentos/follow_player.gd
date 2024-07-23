extends Node

@export var speed = 1.0

#@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var enemy: Enemy
var sprite: AnimatedSprite2D

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")
	


func _physics_process(delta):
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector= difference.normalized()
	
	#movimentação
	enemy.velocity = input_vector * speed * 100.0
	enemy.move_and_slide()
	
	#girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
