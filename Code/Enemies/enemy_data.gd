class_name EnemyData extends Resource


@export var id:StringName = ""
@export var enemy_uid:String

@export_category("Basics")
@export var base_hp:float = 100.0
@export var base_lives:int = 1
@export var base_speed:float = 400.0
@export var base_acceleration:float = 1100.0
@export var base_friction:float = 100.0

@export_category("Attack")
@export var projectile_uid:String = ""
@export var attack_type:Enums.Projectile_Type
@export var damage_type:Enums.Damage_Type
@export var sub_damabe_types:Array[Enums.Damage_Sub_Type] = []
@export var count_per_attack:int = 1
@export var base_delay_between_attacks:float = 1.0
@export var base_delay_between_proj:float = 0.1
@export var base_damage:float = 1.0
@export var base_attack_speed:float = 0.1
@export var base_crit_chance:float = 0.0
@export var base_crit_damage:float = 0.0
@export var base_projectile_pierce:float = 1
@export var base_projectile_speed:float = 1.0
@export var projectile_speed_per_level:float = 1.0
@export var base_projectile_size:float = 0.0
@export var projectile_size_per_level:float = 0.0
@export var base_life_time_distance:float = 0.0
@export var base_life_time:float = 0.0

@export_category("Defences")
@export var base_armor:float = 0.0
@export var base_shield:float = 0.0

@export_category("Resistances")
@export var base_physical_resistance:float = 0.0
@export var base_energy_resistance:float = 0.0
@export var base_plasma_resistance:float = 0.0
@export var base_explosive_resistance:float = 0.0

@export_category("UI")
@export var small_icon_uid:String
@export var large_icon_uid:String
@export var loc_display_name:String
@export var debug_display_name:String
@export var loc_description:String
@export var debug_description:String

var current_level:int = 2

# Getters
# HP
var current_hp:float
var max_hp:float:
	get: return _get_value_for_level(base_hp, current_level)
var current_lives:int
var max_lives:int:
	get: return base_lives

var speed:float:
	get: return _get_value_for_level(base_speed, current_level)

# Attack
var damage:float:
	get: return _get_value_for_level(base_damage, current_level)
var delay_between_attacks:float:
	get: return base_delay_between_attacks - (base_delay_between_attacks * attack_speed)
var delay_between_proj:float:
	get: return base_delay_between_proj - (base_delay_between_proj * attack_speed)
var attack_speed:float:
	get: return clampf(_get_value_for_level(base_attack_speed, current_level), 0.0, Data.MAX_ATTACK_SPEED)
var projectile_speed:float:
	get: return base_projectile_speed + (projectile_speed_per_level * (current_level-1))
var projectile_size:float:
	get: return base_projectile_size + (projectile_size_per_level * (current_level-1))
var crit_chance:float:
	get: return _get_value_for_level(base_crit_chance, current_level)
var crit_damage:float:
	get: return _get_value_for_level(base_crit_damage, current_level)
var projectile_peirce_count:float:
	get: return base_projectile_pierce
var life_time:float:
	get: return _get_value_for_level(base_life_time, current_level)

# Defenses
var current_armor:float
var max_armor:float:
	get: return _get_value_for_level(base_armor, current_level)
var current_shield:float
var max_shield:float:
	get: return _get_value_for_level(base_shield, current_level)

# Resistances
var physical_resist:float:
	get: return _get_value_for_level(base_physical_resistance, current_level)
var energy_resist:float:
	get: return _get_value_for_level(base_energy_resistance, current_level)
var plasma_resist:float:
	get: return _get_value_for_level(base_plasma_resistance, current_level)
var explosive_resist:float:
	get: return _get_value_for_level(base_explosive_resistance, current_level)


func setup_data() -> void:
	current_hp = max_hp
	current_lives = max_lives
	current_armor = max_armor
	current_shield = max_shield


func update_level(add_level:int = 0) -> void:
	var previous_level:int = current_level
	current_level += add_level
	
	var diff_hp: float = _get_value_for_level(base_hp, current_level) - _get_value_for_level(base_hp, previous_level)
	var diff_armor: float = _get_value_for_level(base_hp, current_level) - _get_value_for_level(base_hp, previous_level)
	var diff_shield: float = _get_value_for_level(base_hp, current_level) - _get_value_for_level(base_hp, previous_level)
	
	current_hp += diff_hp
	if current_armor > 0 and current_armor + diff_armor > 0: current_armor += diff_armor
	if current_shield > 0 and current_shield + diff_shield > 0: current_shield += diff_shield


func get_projectile_data() -> ProjectileShootData:
	var result:ProjectileShootData = ProjectileShootData.new()
	result.id = id
	result.projectile_uid = projectile_uid
	result.type = attack_type
	result.damage_type = damage_type
	result.sub_damage_types = sub_damabe_types.duplicate(true)
	result.damage = damage
	result.attack_speed = attack_speed
	result.count_per_attack = count_per_attack
	result.delay_between_proj = delay_between_attacks
	result.projectile_size = projectile_size
	result.life_time_distance = base_life_time_distance
	result.crit_chance = crit_chance
	result.crit_damage = crit_damage
	result.pierce_count = base_projectile_pierce
	result.speed = speed
	result.life_timer = life_time
	
	return result


func _get_value_for_level(value:float, level:int) -> float:
	return value + (value * ((level-1) * Data.ENEMY_UPGRADE_PER_LEVEL)) if level > 1 else 0.0
