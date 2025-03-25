class_name DamageNumber extends Label


var signal_sent:bool = false

func trigger() -> void:
	signal_sent = false
	var tween:Tween = create_tween()
	tween.finished.connect(_exit_tree)
	tween.tween_property(self, "position", Vector2(position.x, position.y - Data.DMG_NMBRS_HEIGHT), Data.DMG_NMBRS_TIME)


func _exit_tree() -> void:
	if not signal_sent:
		signal_sent = true
		Signals.DmgNbrTreeExit.emit(self)
