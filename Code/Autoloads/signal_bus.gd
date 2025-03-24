extends Node


# Managers
signal LoadManager(id:StringName)
signal ManagerLoaded(id:StringName)
signal LoadScene(id:StringName, display_loading_screen:bool)
signal SceneLoaded(id:StringName)
signal Save()

# Levels
signal LevelReady(id:StringName)

# Character Actions
signal ActionTimer(action_id:StringName, current_time:float, max_time:float)
signal ActionToggled(action_id:StringName, toggle:bool)

# Character
signal CharacterReady(character:Node2D)
signal ToggleRotation(value:bool)
signal HpUpdated(data:CharacterData)

# UI
signal DamageNumber(damage:Damage, pos:Vector2)
signal ToggleLoadingScreen(toggle:bool)
signal LoadUi(ui_name:StringName, _additional_info)

# CharacterSelection
signal CharacterSelectionBtnPressed(character_data:CharacterData)
