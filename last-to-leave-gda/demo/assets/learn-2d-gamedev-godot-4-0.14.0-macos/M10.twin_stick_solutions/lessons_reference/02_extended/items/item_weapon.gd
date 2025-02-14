class_name ItemWeapon extends Item

@export var weapon: PackedScene = null
@export var hand_texture: Texture2D = null


func use(player: Player) -> void:
	player.equip_weapon(self)
