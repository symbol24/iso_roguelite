class_name LoadingScene extends Control


func _ready() -> void:
	Signals.ToggleLoadingScreen.connect(_toggle_loading_screen)


func _toggle_loading_screen(display:bool = false) -> void:
	if display:
		if get_index() < get_parent().get_child_count()-1:
			get_parent().move_child(self, get_parent().get_child_count()-1)
		show()
	else:
		hide()
