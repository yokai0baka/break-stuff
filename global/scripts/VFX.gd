extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.crt_displayed == false:
		$CRTFilter.visible = false
	else:
		$CRTFilter.visible = true

	if Global.gameboy_displayed == false:
		$GreenBoy.visible = false
	else:
		$GreenBoy.visible = true

	if Global.neutral_displayed == false:
		$NeutralCozy.visible = false
	else:
		$NeutralCozy.visible = true
