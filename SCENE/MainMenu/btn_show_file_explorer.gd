extends Button


# Сигнал для открытия диалога выбора папки
signal open_folder_dialog


func _ready():
	# Подключаем сигнал 'pressed' к функции обработчику
	pressed.connect(_on_btn_show_file_tree_pressed)


func _on_btn_show_file_tree_pressed():
	# Испускаем сигнал для открытия диалогового окна
	emit_signal("open_folder_dialog")
