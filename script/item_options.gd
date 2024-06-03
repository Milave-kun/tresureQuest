extends ColorRect

@onready var lblName = $Button/lbl_name
@onready var lblDescription = $Button/lbl_description
@onready var lblLevel = $Button/lbl_level
@onready var itemIcon = $Button/ColorRect/ItemIcon

var item = null
@onready var player = get_tree().get_first_node_in_group("player")
@onready var button: TextureButton = %Button

signal selected_upgrade(upgrade)

func _ready() -> void:
	assert(selected_upgrade.connect(player.upgrade_character) == OK)
	assert(button.pressed.connect(click) == OK)
	if item == null:
		item = "food"
	lblName.text = UpgradeDb.UPGRADES[item]["displayname"]
	lblDescription.text = UpgradeDb.UPGRADES[item]["details"]
	lblLevel.text = UpgradeDb.UPGRADES[item]["level"]
	itemIcon.texture = load(UpgradeDb.UPGRADES[item]["icon"])

func click() -> void:
	selected_upgrade.emit(item)
	pass
