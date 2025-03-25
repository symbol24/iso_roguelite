class_name CharacterData extends Resource


@export var id:StringName = ""
@export var character_uid:String
@export var unlocked_by_default:bool = false
@export var anim_for_direction:bool = true

# Basics
@export_category("Stats")
@export var base_hp:float = 100.0
@export var base_lives:int = 1
@export var base_speed:float = 400.0
@export var base_acceleration:float = 1100.0
@export var base_friction:float = 100.0
@export var base_armor:float = 0.0
@export var base_shield:float = 0.0
@export var base_crit_chance:float = 0.0
@export var base_crit_damage:float = 0.0

# Resistances
@export var base_physical_resistance:float = 0.0
@export var base_energy_resistance:float = 0.0
@export var base_plasma_resistance:float = 0.0
@export var base_explosive_resistance:float = 0.0

# Actions
@export var all_actions:Array[ActionData] = []
var active_actions:Array[ActionData] = []

# Character upgrades
@export_category("Upgrades")
@export var all_character_upgrades:Array[Resource]

@export_category("UI")
@export var small_icon_uid:String
@export var large_icon_uid:String
@export var loc_display_name:String
@export var debug_display_name:String
@export var loc_description:String
@export var debug_description:String


# Getters
# HP
var current_hp:float
var max_hp:float:
	get: return base_hp + _get_value_from_meta_upgrades(&"hp") + _get_value_from_run_upgrades(&"hp")
var current_lives:int
var max_lives:int:
	get: return base_lives + int(_get_value_from_meta_upgrades(&"lives")) + int(_get_value_from_run_upgrades(&"lives"))

# Movement
var speed:float:
	get: return base_speed + _get_value_from_meta_upgrades(&"speed") + _get_value_from_run_upgrades(&"speed")

# Attack
var damage:float:
	get: return _get_value_from_meta_upgrades(&"damage") + _get_value_from_run_upgrades(&"damage")
var attack_speed:float:
	get: return _get_value_from_meta_upgrades(&"attack_speed") + _get_value_from_run_upgrades(&"attack_speed")
var projectile_speed:float:
	get: return _get_value_from_meta_upgrades(&"projectile_speed") + _get_value_from_run_upgrades(&"projectile_speed")
var projectile_size:float:
	get: return _get_value_from_meta_upgrades(&"projectile_size") + _get_value_from_run_upgrades(&"projectile_size")
var projectile_life_time_distance:float:
	get: return _get_value_from_meta_upgrades(&"projectile_life_time_distance") + _get_value_from_run_upgrades(&"projectile_life_time_distance")
var crit_chance:float:
	get: return base_crit_chance + _get_value_from_meta_upgrades(&"crit_chance") + _get_value_from_run_upgrades(&"crit_chance")
var crit_damage:float:
	get: return base_crit_damage + _get_value_from_meta_upgrades(&"crit_damage") + _get_value_from_run_upgrades(&"crit_damage")
var projectile_peirce_count:float:
	get: return _get_value_from_meta_upgrades(&"projectile_peirce_count") + _get_value_from_run_upgrades(&"projectile_peirce_count")
var charges:int:
	get: return _get_value_from_meta_upgrades(&"charges") + _get_value_from_run_upgrades(&"charges")

# Defenses
var current_armor:float
var max_armor:float:
	get: return base_armor + _get_value_from_meta_upgrades(&"armor") + _get_value_from_run_upgrades(&"armor")
var current_shield:float
var max_shield:float:
	get: return base_shield + _get_value_from_meta_upgrades(&"shield") + _get_value_from_run_upgrades(&"shield")

# Resistances
var physical_resist:float:
	get: return base_physical_resistance + _get_value_from_meta_upgrades(&"physical_resist") + _get_value_from_run_upgrades(&"physical_resist")
var energy_resist:float:
	get: return base_energy_resistance + _get_value_from_meta_upgrades(&"energy_resist") + _get_value_from_run_upgrades(&"energy_resist")
var plasma_resist:float:
	get: return base_plasma_resistance + _get_value_from_meta_upgrades(&"plasma_resist") + _get_value_from_run_upgrades(&"plasma_resist")
var explosive_resist:float:
	get: return base_explosive_resistance + _get_value_from_meta_upgrades(&"explosive_resist") + _get_value_from_run_upgrades(&"explosive_resist")

# Upgrades
var active_meta_upgrades:Array = []
var active_run_upgrades:Array = []


func setup_data(meta_upgrades:Array = []) -> void:
	active_meta_upgrades = meta_upgrades
	current_hp = max_hp
	current_lives = max_lives
	current_armor = max_armor
	current_shield = max_shield


func _get_value_from_meta_upgrades(_variable_name:StringName = "") -> float:
	# TODO: make this search all active META upgrades for all instances of the variable and send them all back as one
	return 0.0


func _get_value_from_run_upgrades(_variable_name:StringName = "") -> float:
	# TODO: make this search all active RUN upgrades for all instances of the variable and send them all back as one
	return 0.0
