class_name MeleeActionData extends ActionData


@export var attacks:Array[Dictionary] = []
var active_attack:Dictionary = {}
@export var crit_chance:float = 0.0
@export var crit_damage:float = 0.0
@export var damage_type:Enums.Damage_Type
@export var sub_damage_types:Array[Enums.Damage_Sub_Type] = []
@export var anim_speed_scale:float = 0.7
@export var attack_speed:float = 0.0
@export var signal_name:StringName
