extends Label

@onready var slider = $%Slider

func _ready() -> void:
	
	slider.value_changed.connect(_on_slider_value_changed)
	_on_slider_value_changed(slider.value)
	text = str(slider.value)

#func _process(delta: float) -> void:
#	pass


func _on_slider_value_changed(value):
	text = str(value)

