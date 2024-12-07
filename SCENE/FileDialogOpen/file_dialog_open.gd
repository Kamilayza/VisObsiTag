extends FileDialog


# Сигнал для передачи выбранного пути к папке
signal folder_selected(path: String)


@onready var file_dialog: FileDialog = $"."


func _ready():
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.dir_selected.connect(_on_folder_selected)
	_set_default_drive()


# Устанавливаем первый доступный диск как начальный путь
func _set_default_drive():
	var default_path = "res://"
	if OS.get_name() == "Windows":
		default_path = "C:/"
	file_dialog.current_dir = default_path


func open():
	file_dialog.popup_centered()


func _on_folder_selected(path: String):
	emit_signal("folder_selected", path)
