class_name Mine extends Projectile


const READYTIME:float = 0.5


@onready var sprite: Sprite2D = %sprite
@onready var damage_collder: CollisionShape2D = %damage_collder
@onready var detector: Area2D = %detector
@onready var detector_collider: CollisionShape2D = %detector_collider
@onready var animator: AnimationPlayer = %animator


func _ready() -> void:
	detector.body_entered.connect(_detector_body_entered)
	animator.animation_finished.connect(_anim_end)


func setup_attack(_data:ActionData, _owner:Node2D, pos:Vector2 = Vector2.ZERO, _rot:float = 0.0) -> void:
	data = _data
	attack_owner = _owner
	if pos != Vector2.ZERO:
		global_position = pos
		origin = pos
	life_timer = data.life_timer
	pierce_count = data.pierce_count + attack_owner.data.projectile_peirce_count if attack_owner is Character else data.pierce_count
	
	damage_collder.shape.radius *= 1 + data.projectile_size + attack_owner.data.projectile_size if attack_owner is Character else 1
	detector_collider.shape.radius *= 1 + data.projectile_size + attack_owner.data.projectile_size if attack_owner is Character else 1


func get_damage() -> Damage:
	var damage:Damage = Damage.new()
	var cc_check:float = randf()
	var cc:float = data.crit_chance + attack_owner.data.crit_chance
	if cc_check <= cc:
		damage.is_critical = true
	var cd:float = 1.0 + data.crit_damage + attack_owner.data.crit_damage if damage.is_critical else 1.0
	damage.value = (data.damage + attack_owner.data.damage) * cd
	damage.type = data.damage_type
	damage.sub_types = data.sub_damage_types.duplicate(true)
	get_tree().create_timer(DESTROYTIME).timeout.connect(destroy_self)
	return damage


func trigger() -> void:
	get_tree().create_timer(READYTIME).timeout.connect(_activate_mine)


func destroy_self() -> void:
	damage_collder.set_disabled.call_deferred(true)
	animator.play("explode")


func _detector_body_entered(_body) -> void:
	if active:
		damage_collder.set_disabled.call_deferred(false)
		detector_collider.set_disabled.call_deferred(true)


func _activate_mine() -> void:
	animator.play("active")
	active = true
	detector_collider.set_disabled(false)


func _anim_end(anim_name:String) -> void:
	if anim_name == "explode":
		queue_free()
