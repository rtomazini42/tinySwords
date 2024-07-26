extends Node

@export var mob_spawner: MobSpawner
@export var initial_spawn_rate: float = 10.0
@export var spawn_rate_minute: float = 5.0
@export var wave_duration: float = 30
@export var break_intensity: float = 0.7

var time: float = 0.0

func _process(delta) -> void:
	#ignorar se fim de jogo:
	if GameManager.is_game_over: return
	
	time += delta
	#linear
	var spawn_rate = initial_spawn_rate + spawn_rate_minute * (time / 60)
	#onda senodial
	var sin_wave = sin((time * TAU)/wave_duration)
	var wave_factor = remap(sin_wave,-1.0,1.0, break_intensity,1)
	
	spawn_rate += wave_factor
	
	
	mob_spawner.mobs_per_minute = spawn_rate
	#print(spawn_rate)
