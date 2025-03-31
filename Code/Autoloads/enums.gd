extends Node


enum Damage_Type {
					PHYSICAL = 0,
					ENERGY = 1,
					PLASMA = 2,
					EXPLOSIVE = 3,
				}

enum Damage_Sub_Type {
						CORROSIVE = 0,
						ION = 1,
						GRAVITY = 2,
						NANITE = 3,
					}

enum Projectile_Type {
						MOVING = 0,
						FLOATING = 1,
						FIXED = 2,
					}

enum Positive_Effect {
						HEAL = 0,
						ARMOR = 1,
						SHIELD = 2,
					}

enum LevelState {
					SPAWNINGCHESTS = 0,
					LEVELINTRO = 1,
					SPAWNINGPLAYERS = 2,
					NORMALGAMEPLAY = 3,
					OBJECTIVECOMPLETE = 4,
					BOSSDEFEATED = 5,
					UNLOAD = 6,
				}


enum Objective_Type {
						NOTHING = 0,
						ENEMYKILLS = 1,
						DESTROYOBJECTS = 2,
						TOGGLEOBJECTS = 3,
						DEFEATELITES = 4,
						HUNT = 5,
						DEFEATBOSS = 6,
						KEYHUNT = 7,
						SPECIAL = 8,
					}

enum Enemy_Type {
					NORMAL = 0,
					ELITE = 1,
					BOSS = 2,
					HUNTED = 3,
					DESTRUCTIBLE = 4,
				}
