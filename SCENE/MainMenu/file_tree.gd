extends Tree



# Загружаем иконки для файлов и папок
var icon_folder_close = load("res://ASSET/Icons/FileExplorer/FolderClose.svg")
var icon_folder_obsidian = load("res://ASSET/Icons/FileExplorer/Obsidian.svg")
var icon_file_img = load("res://ASSET/Icons/FileExplorer/FileImageFilled.svg")
var icon_file_txt = load("res://ASSET/Icons/FileExplorer/FileTextFilled.svg")
var icon_file_md = load("res://ASSET/Icons/FileExplorer/FileMarkdownFilled.svg")
var icon_file = load("res://ASSET/Icons/FileExplorer/File.svg")



# Метод для заполнения дерева папками и файлами внутри выбранной папки
func populate_tree(folder_path: String):
	clear()  # Очистка текущего содержимого дерева
	var root = create_item()
	var folder_name = folder_path.get_file()  # Получаем только название папки
	root.set_text(0, folder_name)  # Устанавливаем корневой элемент с названием папки
	_populate_tree_recursive(root, folder_path)


# Рекурсивное заполнение содержимого дерева
func _populate_tree_recursive(parent_item: TreeItem, folder_path: String):
	var dir = DirAccess.open(folder_path)
	if dir:
		var subdirectories = dir.get_directories()
		var files = dir.get_files()

		# Добавляем папки
		for subfolder in subdirectories:
			var subfolder_path = folder_path.path_join(subfolder)
			var folder_item = create_item(parent_item)
			folder_item.set_text(0, subfolder)

			# Устанавливаем уникальную иконку для папки ".obsidian"
			if subfolder == ".obsidian":
				folder_item.set_icon(0, icon_folder_obsidian)
			else:
				# Устанавливаем стандартную иконку для закрытой папки
				folder_item.set_icon(0, icon_folder_close)

			folder_item.collapsed = true  # Сворачиваем папку по умолчанию

			# Рекурсивно добавляем вложенные папки
			_populate_tree_recursive(folder_item, subfolder_path)

		# Добавляем файлы
		for file in files:
			var file_path = folder_path.path_join(file)
			var file_item = create_item(parent_item)
			file_item.set_text(0, file)
			file_item.set_icon(0, _get_file_icon(file))


# Функция для получения иконки в зависимости от типа файла
func _get_file_icon(file_name: String) -> Texture2D:
	var extension = file_name.get_extension().to_lower()
	match extension:
		"png", "jpg", "jpeg", "svg":
			return icon_file_img
		"txt":
			return icon_file_txt
		"md":
			return icon_file_md
		_:
			return icon_file
