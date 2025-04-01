extends Node


# Manager Manager
signal LoadManager(id:StringName)
signal ManagerLoaded(id:StringName)

# Scene Manager
signal LoadScene(id:StringName, display_loading_screen:bool)
signal SceneLoaded(id:StringName)

# Run Manager
signal ResetRun()
signal SetCharacter(data:CharacterData)
signal SetDifficulty(difficulty:int)
signal UpdateRunState(message:StringName)
signal ToggleCanPause(value:bool)

# Spawn Manager
signal SpawnCharacter(data:CharacterData)
signal SpawnChests()
signal SpawnObjectiveElements(objective:LevelObjectiveData)
signal SpawnCamera()
signal SpawnLevelBoss()

# Save Load Manager
signal RunCurrencyUpdate(value:int)
signal Save()

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
signal AddRunUpgrade(data:RunUpgradeData)

# UI
signal SpawnDamageNumber(damage:Damage, pos:Node2D)
signal ToggleLoadingScreen(toggle:bool)
signal LoadUi(ui_name:StringName, _additional_info)
signal DmgNbrTreeExit(dmg_nbr:DamageNumber)
signal DisplayLevelIntro(data:LevelData)
signal DisplayObjective(data:LevelObjectiveData) # needs data
signal ToggleUi(ui_name:StringName, display:bool)
signal ObjectiveCountUpdated(data:LevelObjectiveData)
signal RunCurrencyUpdated(value:int)

# CharacterSelection
signal CharacterSelectionBtnPressed(character_data:CharacterData)

# Enemies
signal EnemyDeath(enemy_data:EnemyData)
signal EnemyReady(enemy:Enemy)

# DEBUG
signal DebugCharacterInfo(info:StringName, value:String)
signal DebugObjectiveSelect(objective:StringName)
