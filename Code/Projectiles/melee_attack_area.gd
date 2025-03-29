class_name MeleeAttackArea extends AttackArea


@export var attack_id:StringName = ""


func setup_attack(_data:ActionData, _owner:Node2D, _pos:Vector2 = Vector2.ZERO, _rot:float = 0.0) -> void:
	data = _data
	attack_owner = _owner


func destroy_self() -> void:
	pass


func get_damage() -> Damage:
	var damage:Damage = Damage.new()
	var cc_check:float = randf()
	var damage_value:float = data.active_attack[attack_id] if data.active_attack.has(attack_id) else 0.0
	var cc:float = data.crit_chance + attack_owner.data.crit_chance
	if cc_check <= cc:
		damage.is_critical = true
	var cd:float = 1.0 + data.crit_damage + attack_owner.data.crit_damage if damage.is_critical else 1.0
	damage.value = (damage_value + attack_owner.data.damage) * cd
	damage.type = data.damage_type
	damage.sub_types = data.sub_damage_types.duplicate(true)
	get_tree().create_timer(Data.PROJECTILEDESTROYTIME).timeout.connect(destroy_self)
	return damage
