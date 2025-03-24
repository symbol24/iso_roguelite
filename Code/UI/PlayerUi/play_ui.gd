class_name PlayUi extends Control


const BOXSIZE:Vector2 = Vector2(20, 20)
const TEMPICON:String = "uid://cn5q8epuuj0g7"
const TEMPFILL:String = "uid://wlgi0bk4igll"


@onready var hp_bar: TextureProgressBar = %hp_bar
@onready var abilities_hbox: HBoxContainer = %abilities_hbox

var boxes:Array[ActionBox] = []
var character_id:StringName = &""


func _ready() -> void:
	Signals.HpUpdated.connect(_update_hp)


func set_player_ui(data:CharacterData) -> void:
	character_id = data.id
	for each in data.active_actions:
		var action_box:ActionBox = ActionBox.new()
		action_box.set_custom_minimum_size(BOXSIZE)
		abilities_hbox.add_child(action_box)
		if not action_box.is_node_ready(): await action_box.ready
		action_box.size = BOXSIZE
		action_box.id = each.id
		if each.icon_uid != "": 
			action_box.texture_under = load(each.icon_uid) as CompressedTexture2D
		else: 
			action_box.texture_under = load(TEMPICON) as CompressedTexture2D
		action_box.texture_progress = load(TEMPFILL) as CompressedTexture2D
		action_box.name = &"action_" + each.id


func _update_hp(data:CharacterData) -> void:
	if data.id == character_id:
		hp_bar.value = data.current_hp / data.max_hp
