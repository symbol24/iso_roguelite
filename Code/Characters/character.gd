class_name Character extends CharacterBody2D


@export var debug_data:CharacterData
@export var debug_spawn:bool = false

@onready var animator: AnimationPlayer = %animator
@onready var anim_tree: AnimationTree = %anim_tree
@onready var damage_nmbr_point: Marker2D = %damage_nmbr_point

var data:CharacterData = null
var direction:Vector2 = Vector2.ZERO
var last_direction:Vector2 = Vector2.ZERO
var actions:Array[CharacterAction] = []
var is_alive:bool = true
var hit_active:bool = false


func _ready() -> void:
	if debug_spawn:
		if data == null: character_setup()
	Signals.CharacterReady.emit(self)


func _physics_process(_delta: float) -> void:
	if is_alive: move_and_slide()


func character_setup(new_data:CharacterData = null) -> void:
	if new_data == null:
		data = debug_data.duplicate()
		data.setup_data()
		# TODO: Fix for selected actions
		for action in data.all_actions:
			if action.unlocked_be_default:
				data.active_actions.append(action)
		Signals.LoadUi.emit(&"play_ui", data)
	else:
		data = new_data


func set_new_vel(new_vel:Vector2 = Vector2.ZERO) -> void:
	if is_alive:
		velocity = new_vel
		


func set_direction(new_direction:Vector2 = Vector2.ZERO) -> void:
	if new_direction != Vector2.ZERO: last_direction = direction
	direction = new_direction
	_set_animation_params()


func receive_damage(damage:Damage) -> void:
	if is_alive:
		var shield_hit:bool = false
		var armor_hit:bool = false
		var hp_hit:bool = false
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
		
		# Shield
		if final_value > 0 and data.current_shield > 0:
			if data.current_shield > final_value:
				data.current_shield -= final_value
				final_value = 0
			else:
				final_value -= data.current_shield
				data.current_shield -= data.current_shield
			shield_hit = true
		
		# Armor
		if final_value > 0 and data.current_armor > 0:
			if data.current_armor > final_value:
				data.current_armor -= final_value
				final_value = 0
			else:
				final_value -= data.current_armor
				data.current_armor -= data.current_armor
			armor_hit = true
		
		# HP
		if final_value > 0:
			if data.current_hp > final_value:
				data.current_hp -= final_value
			else:
				data.current_hp = 0
			hp_hit = true
		
		_hit_effect(shield_hit, armor_hit, hp_hit)
		Signals.SpawnDamageNumber.emit(damage, damage_nmbr_point)
		Signals.ShieldUpdated.emit(data)
		Signals.HpUpdated.emit(data)
		Signals.ArmorUpdated.emit(data)
		
		_check_death()


func _check_death() -> void:
	if data.current_hp <= 0:
		data.current_lives -= 1
		is_alive = false
		Signals.CharacterDeath.emit(data)
		_death()
		if data.current_lives > 0: _respawn()
		

func _respawn() -> void:
	data.setup_data()
	is_alive = true


func _death() -> void:
	anim_tree.set("parameters/conditions/running", false)
	anim_tree.set("parameters/conditions/idle", false)
	anim_tree.set("parameters/conditions/dead", true)


func _set_animation_params() -> void:
	var running:bool = false
	var idle:bool = true
	if velocity != Vector2.ZERO:
		running = true
		idle = false
	
	if running != anim_tree.get("parameters/conditions/running"): anim_tree.set("parameters/conditions/running", running)
	if idle != anim_tree.get("parameters/conditions/idle"): anim_tree.set("parameters/conditions/idle", idle)
	if last_direction.x != anim_tree.get("parameters/idle_blend/blend_position"): anim_tree.set("parameters/idle_blend/blend_position", last_direction.x)
	if last_direction != anim_tree.get("parameters/running_blend/blend_position"): anim_tree.set("parameters/running_blend/blend_position",direction)


func _hit_effect(shield_hit:bool, armor_hit:bool, hp_hit:bool) -> void:
	if not hit_active:
		hit_active = true
		if shield_hit:
			modulate = Data.SHIELDHITCOLOR
		elif armor_hit:
			modulate = Data.ARMORHITCOLOR
		elif hp_hit:
			modulate = Data.HPHITCOLOR
		
		get_tree().create_timer(Data.HITTIMER).timeout.connect(_end_hit)


func _end_hit() -> void:
	modulate = Color.WHITE
	hit_active = false
