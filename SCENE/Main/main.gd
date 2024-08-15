extends Control



@onready var text_edit : TextEdit = $CenterContainer/MarginContainer/VBoxContainer/TextEdit
@onready var fd_open_file : FileDialog = $Dialogs/FD_open_file
@onready var fd_save_file : FileDialog = $Dialogs/FD_save_file



# Переменная для хранения пути к открытому или сохраненному файлу
var current_file_path: String = ""



func _ready():
	pass


# Обработка нажатия на кнопку "Открыть файл"
func _on_btn_open_file_pressed():
	fd_open_file.popup()  # Открытие диалога выбора файла


# Обработка выбора файла в диалоге открытия
func _on_fd_open_file_file_selected(path):
	current_file_path = path  # Сохранение пути к открытому файлу
	var file := FileAccess.open(path, FileAccess.READ)
	if file:  # Проверка, удалось ли открыть файл
		text_edit.text = file.get_as_text()  # Чтение содержимого файла и вывод его в TextEdit
		file.close()


# Обработка нажатия на кнопку "Сохранить файл"
func _on_btn_save_file_pressed():
	if current_file_path != "":  # Проверка, задан ли путь к файлу
		var file := FileAccess.open(current_file_path, FileAccess.WRITE)
		if file:  # Проверка, удалось ли открыть файл для записи
			file.store_string(text_edit.text)  # Запись содержимого TextEdit в файл
			file.close()
		else:
			print("Ошибка: Не удалось открыть файл для записи.")
	else:
		print("Ошибка: Путь к файлу не задан. Используйте 'Сохранить как'.")


# Обработка нажатия на кнопку "Сохранить как"
func _on_btn_save_how_file_pressed():
	fd_save_file.popup()  # Открытие диалога сохранения файла


# Обработка выбора файла в диалоге сохранения
func _on_fd_save_file_file_selected(path):
	current_file_path = path  # Сохранение нового пути к файлу
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file:  # Проверка, удалось ли открыть файл для записи
		file.store_string(text_edit.text)  # Запись содержимого TextEdit в файл
		file.close()
	else:
		print("Ошибка: Не удалось открыть файл для записи.")


# Обработка нажатия на кнопку "Очистить текст"
func _on_btn_clear_text_pressed():
	text_edit.clear()  # Очистка текстового поля
