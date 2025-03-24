class_name ProjectileShootData extends ActionData


@export var projectile_uid:String = ""
@export var type:Enums.Projectile_Type = Enums.Projectile_Type.MOVING
@export var damage:float = 0.0
@export var count_per_attack:int = 1
## Time between each projectile in a burst (when count_per_attack > 1).
@export var delay_between_proj:float = 0.1
## Attack speed modifier. (action_delay / (attack_speed + character_attack_speed))
@export var attack_speed:float = 1.0
## Bonus multiplyer Projectile size, should always be 0 on projectile data.
@export var projectile_size:float = 0.0
@export var crit_chance:float = 0.0
@export var crit_damage:float = 0.0
@export var damage_type:Enums.Damage_Type
@export var sub_damage_types:Array[Enums.Damage_Sub_Type]
@export var pierce_count:float = 1.0
@export var speed:float = 1000.0
## Distance should be a squared value as the comparison is done to "distance_to_squared"
@export var life_time_distance:float = 2500.0
@export var life_timer:float = 0.0
## Distance at which the reticle is placed whe using gamepad.
@export var reticle_distance:float = 60.0

#@export_group("Laser")
#@export var attacks_per_second:int = 1
#@export var max_charge:float = 10.0
#@export var charge_time:float = 3.0
#@export var minimum_shoot_time:float = 0.5
#@export var rotation_speed:float = 10.0
#@export var rotation_multiplier:float = 0.1
#
#@export_group("Fixed")
#@export var dampening:float = 0.0
#@export var area_size:float = 1.0
#@export var projectile_life_time:float = 0.0
