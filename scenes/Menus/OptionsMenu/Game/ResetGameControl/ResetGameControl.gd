extends HBoxContainer

signal reset_confirmed


func _on_ResetButton_pressed() -> void:
	$ConfirmResetDialog.popup_centered()
	$ResetButton.disabled = true

func _on_ConfirmResetDialog_confirmed() -> void:
	emit_signal("reset_confirmed")

func _on_confirm_reset_dialog_canceled() -> void:
	$ResetButton.disabled = false
