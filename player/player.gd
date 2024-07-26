class_name Player

extends CharacterBody2D

@export_category("Life")
@export var health: int = 100
@export var max_health: int = 200
@export var death_prefab: PackedScene

@export_category("Movement")
@export	var speed: float = 3

@export_category("Sword")
@export var sword_damage: int = 2
@export var hitbox_cooldown = 3

@export_category("Ritual")
@export var ritual_damage: int = 5
@export var ritual_interval: float = 20
@export var ritual_scene: PackedScene
#dano
#intervalo
#cena

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword_area: Area2D = $swordArea
@onready var hitbox_area: Area2D = $HitboxArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var health_progress_bar: ProgressBar = $HealthProgressBar

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_ataccking: bool = false
var ataccking_cooldown: float = 0.0

var ritual_cooldown: float = 30

signal meat_collected(value:int)

func _ready():
	GameManager.player = self
	meat_collected.connect(func(value: int): GameManager.meat_counter += 1)

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
		
	#processar dano
	update_hitbox_detection(delta)		
	
	#ritual
	update_ritual(delta)
	
	#atualizar health bar
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health
			
			
func update_ritual(delta: float)-> void:
	ritual_cooldown-=delta
	if ritual_cooldown>0: return
	
	ritual_cooldown = ritual_interval
	
	#criar ritual e colocar posição no player
	var ritual = ritual_scene.instantiate()
	ritual.demage_amnt = ritual_damage
	add_child(ritual)
	
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
			if dot_product >= 0.0:
				enemy.demage(sword_damage)
	
#	var enemies = get_tree().get_nodes_in_group("enemies")
#	for enemy in enemies:
#		enemy.demage(sword_damage)
#	#print("Enemies: ", enemies.size())
#	pass

func update_hitbox_detection(delta: float) -> void:
	# temporizador
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	
	#frêquencia
	hitbox_cooldown = 0.5
	
	#detectar inimigos
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var demage_amount = 3
			demage(demage_amount)
	

func demage(amount: int) -> void:
	if health <= 0: return
	health -= amount
	#print("Player atingido por dano: ",amount ," saúde atual: ",health)
	
	#piscar inimigo
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE, 0.3) #animar entre coisas a->b
#
	if health <= 0:
		die()
		
	
func die() -> void:
	GameManager.end_game()
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	queue_free()

func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
		
	#print("player recebeu cura ", health)
	return health
