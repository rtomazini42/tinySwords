class_name MobSpawner

extends Node2D
@export var Creatures: Array[PackedScene]
var mobs_per_minute: float=  60.0

@onready var path_folow_2d: PathFollow2D = %PathFollow2D

var cooldown: float = 0.0





func _ready():
	pass 
	
func _process(delta):
	#temporizador cooldown
	if GameManager.is_game_over: return
	
	cooldown -= delta
	if cooldown > 0: return
	
	#frequencia por minuto
	var interval = 60.0 / mobs_per_minute
	cooldown = interval

	#checar se ponto é valido
	var point = get_pont()
	var world_state = get_world_2d().direct_space_state
	
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	
	var result: Array = world_state.intersect_point(parameters,1)
	
	if not result.is_empty(): return
	
	#instanciar criatura aleatoria
	var index = randi_range(0,Creatures.size() - 1)
	var creature_scene = Creatures[index]
	var creature = creature_scene.instantiate()
	creature.global_position = point
	get_parent().add_child(creature)
	pass

func get_pont() -> Vector2:
	path_folow_2d.progress_ratio = randf()
	return path_folow_2d.global_position
	

