extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heartUiEmpty = $HeartUIEmpty
onready var heartUiFull = $HeartUIFull


func _ready():
    self.max_hearts = PlayerStats.max_health
    self.hearts = PlayerStats.health
    PlayerStats.connect("health_changed", self, "set_hearts")
    PlayerStats.connect("max_health_changed", self, "set_max_hearts")


func set_hearts(value):
    if hearts == value:
        return

    hearts = clamp(value, 0, max_hearts)
    heartUiFull.visible = hearts > 0
    heartUiFull.rect_size.x = heartUiFull.texture.get_width() * hearts

func set_max_hearts(value):
    if max_hearts != value and value > 0:
        max_hearts = value
    heartUiFull.rect_size.x = heartUiEmpty.texture.get_width() * max_hearts
