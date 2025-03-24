class_name UI extends CanvasLayer


const PLAYUI:String = "uid://cdi3icregrobv"


var play_ui:PlayUi = null


func _ready() -> void:
	Signals.LoadUi.connect(_load_ui)


func _load_ui(ui_name:StringName, _additional_info) -> void:
	match ui_name:
		&"play_ui":
			play_ui = load(PLAYUI).instantiate()
			add_child(play_ui)
			if not play_ui.is_node_ready(): await play_ui.ready
			play_ui.set_player_ui(_additional_info)
		_:
			pass
		
