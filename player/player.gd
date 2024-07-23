extends CharacterBody2D

@export	var speed: float = 3

@export var sword_damage: int = 2

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var sword_area: Area2D = $swordArea

@onready var sprite: Sprite2D = $Sprite2D

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_ataccking: bool = false
var ataccking_cooldown: float = 0.0

func _process(delta: float) -> void:
	#mandar para o GameManager a posição do jogador
	GameManager.player_position = position
	
	#obter entrada
	read_input()
	if is_ataccking:
		ataccking_cooldown -= delta
		if ataccking_cooldown <= 0:
			is_ataccking = false
			is_running = false
			animation_player.play("idle")
			
		#animação
	if not is_ataccking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")
				
		#girar sprite
		
		if input_vector.x > 0:
			sprite.flip_h = false
		elif input_vector.x < 0:
			sprite.flip_h = true


	#ataque
	if Input.is_action_just_released("attack"):
		attack()
			
			
func read_input():
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down", 0.15)
		#atualizar is runnin
	was_running = is_running
	is_running = not input_vector.is_zero_approx()	
	
func _physics_process(delta: float) -> void:
	#modificar velocidade
	var target_velocity = input_vector * speed * 100.0
	if is_ataccking:
		target_velocity = target_velocity * 0.1
	velocity = lerp(velocity,target_velocity,0.25)
	move_and_slide()
		
func attack() -> void:
	if is_ataccking:
		return
	animation_player.play("attack_side_1")
	ataccking_cooldown = 0.6
	is_ataccking = true
	#chamada de deal demage lá na animationPlayer

 
func deal_damage_to_enemies() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
				
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.1:
				enemy.demage(sword_damage)
	
#	var enemies = get_tree().get_nodes_in_group("enemies")
#	for enemy in enemies:
#		enemy.demage(sword_damage)
#	#print("Enemies: ", enemies.size())
#	pass
