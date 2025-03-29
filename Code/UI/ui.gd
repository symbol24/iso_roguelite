class_name UI extends CanvasLayer


const PLAYUI:String = "uid://cdi3icregrobv"
const DMGNMBRSUI:String = "uid://bkc2tqjwdbaa3"
const DEBUGUI:String = "uid://b1k4t6jw8tt8x"


var play_ui:PlayUi = null
var dmg_nbrs:DamageNumberUi = null
var debug_ui:DebugUi = null


func _ready() -> void:
	Signals.LoadUi.connect(_load_ui)


func _load_ui(ui_name:StringName, _additional_info) -> void:
	match ui_name:
		&"play_ui":
			play_ui = load(PLAYUI).instantiate()
			add_child(play_ui)
			if not play_ui.is_node_ready(): await play_ui.ready
			play_ui.set_player_ui(_additional_info)
			
			dmg_nbrs = load(DMGNMBRSUI).instantiate()
			add_child(dmg_nbrs)
			if not dmg_nbrs.is_node_ready(): await dmg_nbrs.ready
			
			debug_ui = load(DEBUGUI).instantiate()
			add_child(debug_ui)
			if not debug_ui.is_node_ready(): await debug_ui.ready
		_:
			pass
		
