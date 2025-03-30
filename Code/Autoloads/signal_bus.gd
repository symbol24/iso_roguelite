extends Node


# Managers
signal LoadManager(id:StringName)
signal ManagerLoaded(id:StringName)
signal LoadScene(id:StringName, display_loading_screen:bool)
signal SceneLoaded(id:StringName)
signal Save()
signal SetCharacter(id:StringName)
signal SpawnCharacter(data:CharacterData)
signal SpawnChests()
signal UpdateRunState(message:StringName)
signal SpawnCamera()

# Levels
signal LevelReady(id:StringName)

# Character Actions
signal ActionTimer(action_id:StringName, current_time:float, max_time:float)
signal ActionToggled(action_id:StringName, toggle:bool)
signal ActionChargesUpdate(action_id:StringName, value:int)

# Character
signal CharacterReady(character:Node2D)
signal ToggleRotation(value:bool)
signal HpUpdated(data:CharacterData)
signal ArmorUpdated(data:CharacterData)
signal ShieldUpdated(data:CharacterData)
signal CharacterDeath(data:CharacterData)
signal AnimationSignal(character:Character, type:StringName, value)

# UI
signal SpawnDamageNumber(damage:Damage, pos:Node2D)
signal ToggleLoadingScreen(toggle:bool)
signal LoadUi(ui_name:StringName, _additional_info)
signal DmgNbrTreeExit(dmg_nbr:DamageNumber)
signal DisplayLevelIntro()
signal DisplayObjective() # needs data

# CharacterSelection
signal CharacterSelectionBtnPressed(character_data:CharacterData)

# Enemies
signal EnemyDeath(enemy_data:EnemyData)
signal EnemyReady(enemy:Enemy)

# DEBUG
signal DebugCharacterInfo(info:StringName, value:String)
