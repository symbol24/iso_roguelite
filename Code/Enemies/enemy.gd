class_name Enemy extends CharacterBody2D


@export var debug_data:EnemyData
@export var debug_spawn:bool = false

@onready var damage_nmbr_point: Marker2D = %damage_nmbr_point
@onready var hp_bar: TextureProgressBar = %hp_bar

var data:EnemyData = null
var direction:Vector2 = Vector2.ZERO
var last_direction:Vector2 = Vector2.ZERO
var is_alive:bool = false
var dmglog:Array[Damage] = []
var processing_damage:bool = false


func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_layer_value(4, true)
	set_collision_mask_value(4, true)
	if debug_spawn: setup_enemy()
	Signals.EnemyReady.emit(self)


func _physics_process(_delta: float) -> void:
	if is_alive: move_and_slide()


func setup_enemy(new_data:EnemyData = null) -> void:
	if new_data == null:
		if debug_data == null: push_error(name, " does not have debug_data and will break.")
		data = debug_data.duplicate(true)
	else:
		data = new_data
	
	data.setup_data()
	if hp_bar: hp_bar.value = data.current_hp / data.max_hp
	is_alive = true


func set_direction_and_veliocty(new_velocity:Vector2 = Vector2.ZERO, new_direction:Vector2 = Vector2.ZERO) ->  void:
	if new_direction != Vector2.ZERO: last_direction = direction
	direction = new_direction
	velocity = new_velocity
	_set_animation_params()
	

func receive_damage(damage:Damage) -> void:
	if is_alive and damage != null:
		var final_value:float = damage.value
		match damage.type:
			Enums.Damage_Type.PHYSICAL:
				final_value -= final_value * data.physical_resist
			Enums.Damage_Type.ENERGY:
				final_value -= final_value * data.energy_resist
			Enums.Damage_Type.PLASMA:
				final_value -= final_value * data.plasma_resist
			Enums.Damage_Type.EXPLOSIVE:
				final_value -= final_value * data.explosive_resist
			_:
				pass
		if final_value < 0: final_value = 0
		
		if data.current_shield > 0:
			if final_value > 0 and data.current_shield > final_value:
				data.current_shield -= final_value
				final_value = 0
		else:
			final_value -= data.current_shield
			data.current_shield -= data.current_shield
		
		if data.current_armor > 0:
			if final_value > 0 and data.current_armor > final_value:
				data.current_armor -= final_value
				final_value = 0
			else:
				final_value -= data.current_armor
				data.current_armor -= data.current_armor
		
		if data.current_hp >= final_value:
			if  final_value > 0  and data.current_hp > final_value:
				data.current_hp -= final_value
			else:
				data.current_hp = 0
		
		_hit_effect()
		Signals.SpawnDamageNumber.emit(damage, damage_nmbr_point)
		if hp_bar: hp_bar.value = data.current_hp / data.max_hp
		
		_check_death()
		await get_tree().create_timer(Data.DMG_NMBRS_WAIT).timeout
		processing_damage = false


func _check_death() -> void:
	if data.current_hp <= 0:
		data.current_lives -= 1
		is_alive = false
		Signals.EnemyDeath.emit(data)
		if data.current_lives > 0: _respawn()
		else: _death()
		

func _respawn() -> void:
	data.setup_data()
	is_alive = true


func _death() -> void:
	pass


func _set_animation_params() -> void:
	pass


func _hit_effect() -> void:
	pass
