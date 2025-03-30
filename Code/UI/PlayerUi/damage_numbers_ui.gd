class_name DamageNumberUi extends Control


const DMGNMBR:String = "uid://c8sgavqft6dj0"


@onready var position_checker: Marker2D = %position_checker

var dmg_nmbr:PackedScene = null
var pool:Array[DamageNumber] = []
var dmglog:Array[Array] = []
var sending:bool = false
var level:Node2D:
	get:
		if level == null: level = get_tree().get_first_node_in_group(&"level")
		return level


func _ready() -> void:
	Signals.DmgNbrTreeExit.connect(_return_to_pool)
	Signals.SpawnDamageNumber.connect(_receive_dmg_nmbr_request)


func _process(_delta: float) -> void:
	if not sending and not dmglog.is_empty():
		sending = true
		var to_send:Array = dmglog.pop_front()
		_spawn_damage_number(to_send[0], to_send[1])
		

func _receive_dmg_nmbr_request(damage:Damage, parent:Node2D) -> void:
	var to_append:Array = [damage, parent]
	dmglog.append(to_append)


func _spawn_damage_number(damage:Damage, parent:Node2D) -> void:
	if damage and parent:
		if dmg_nmbr == null:
			dmg_nmbr = load(DMGNMBR)
			
		var dn:DamageNumber = pool.pop_front()
		if dn == null: dn = dmg_nmbr.instantiate()
		level.add_child(dn)
		if not dn.is_node_ready(): await dn.ready
		dn.text = str(damage.value)
		dn.global_position = parent.global_position
		dn.position.x -= (dn.size.x / 2) + randf_range(-Data.DMG_NMBRS_OFFSET, Data.DMG_NMBRS_OFFSET)
		dn.position.y -= dn.size.y
		dn.trigger()
		await get_tree().create_timer(Data.DMG_NMBRS_WAIT).timeout
		sending = false


func _return_to_pool(dm:DamageNumber) -> void:
	level.remove_child.call_deferred(dm)
	pool.append(dm)
