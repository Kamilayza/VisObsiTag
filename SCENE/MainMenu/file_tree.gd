extends Tree

# --- Переменнные ---

# --- --- Ноды --- ---
@onready var lb_no_matches = $"../Lb_NoMatches"


# --- --- Иконки --- ---
var icon_folder_close = load("res://ASSET/Icons/FileExplorer/FolderClose.svg")
var icon_folder_open = load("res://ASSET/Icons/FileExplorer/FolderOpen.svg")
var icon_folder_obsidian = load("res://ASSET/Icons/FileExplorer/Obsidian.svg")
var icon_file_img = load("res://ASSET/Icons/FileExplorer/FileImageFilled.svg")
var icon_file_txt = load("res://ASSET/Icons/FileExplorer/FileTextFilled.svg")
var icon_file_md = load("res://ASSET/Icons/FileExplorer/FileMarkdownFilled.svg")
var icon_file = load("res://ASSET/Icons/FileExplorer/File.svg")

# --- --- Состояния --- ---
var no_matches_found = false


# --- Методы ---

# --- --- Создание FileTree --- ---

# Метод для заполнения дерева папками и файлами внутри выбранной папки
func populate_tree(folder_path: String):
	clear()  # Очистка текущего содержимого дерева
	var root = create_item()
	var folder_name = folder_path.get_file()  # Получаем только название папки
	root.set_text(0, folder_name)  # Устанавливаем корневой элемент с названием папки
	root.set_icon(0, icon_folder_open)  # Устанавливаем иконку открытой папки для корня
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


# --- --- Фильтрация элементов FileTree --- ---

# Метод для фильтрации элементов дерева
func filter_tree(search_text: String):
	no_matches_found = true  # Изначально считаем, что совпадений нет
	
	if search_text.is_empty():
		_reset_visibility(get_root())
		no_matches_found = false
	else:
		var root = get_root()
		
		# Для каждой папки мы проверяем наличие совпадений и раскрываем все папки на пути
		for child in root.get_children():
			if _filter_folders(child, search_text, []):
				no_matches_found = false
		
		# Затем проверяем файлы на совпадение
		for child in root.get_children():
			if _filter_files(child, search_text, []):
				no_matches_found = false
				
	lb_no_matches.visible = no_matches_found


# Рекурсивный метод для фильтрации папок
func _filter_folders(item: TreeItem, search_text: String, path_to_item: Array) -> bool:
	var item_name = item.get_text(0).to_lower()
	var is_folder = item.get_icon(0) == icon_folder_close or item.get_icon(0) == icon_folder_obsidian
	
	# Добавляем текущий элемент в путь
	path_to_item.append(item)
	
	# Проверка на совпадение с папкой
	var matches = item_name == search_text or item_name.find(search_text) != -1
	if matches:
		_reveal_path(path_to_item)  # Раскрываем путь к элементу
		_show_item_and_children(item)  # Показываем папку и её содержимое
		
		# Если папка совпала, оставляем её скрытой (если нет вложений, проходящих фильтрацию)
		item.collapsed = true  # Не раскрывать совпавшую папку
		return true
		
	# Если папка не совпала с запросом, проверяем её дочерние элементы
	var has_visible_child = false
	for child in item.get_children():
		# Важно: проверяем как папки, так и файлы
		if _filter_folders(child, search_text, path_to_item.duplicate()) or _filter_files(child, search_text, path_to_item.duplicate()):
			has_visible_child = true
			
	# Устанавливаем видимость папки, если она или её дочерние элементы видимы
	item.visible = matches or has_visible_child
	if matches:
		_reveal_path(path_to_item)  # Раскрываем путь к элементу
		
	return item.visible


# Рекурсивный метод для фильтрации файлов
func _filter_files(item: TreeItem, search_text: String, path_to_item: Array) -> bool:
	var item_name = item.get_text(0).to_lower()
	var is_folder = item.get_icon(0) == icon_folder_close or item.get_icon(0) == icon_folder_obsidian
	
	# Проверка на совпадение с файлом
	if !is_folder:
		var matches = item_name == search_text or item_name.find(search_text) != -1
		if matches:
			_reveal_path(path_to_item)  # Раскрываем путь к элементу
			_show_item_and_children(item)  # Показываем файл
		return matches
	return false  # Если это папка, пропускаем этот метод


# Метод для раскрытия всех папок на пути к элементу
func _reveal_path(path_to_item: Array):
	for node in path_to_item:
		node.collapsed = false  # Раскрываем папку


# Метод для показа папки и всех её дочерних элементов
func _show_item_and_children(item: TreeItem):
	item.visible = true
	for child in item.get_children():
		_show_item_and_children(child)


# Метод для сброса видимости (отображает все элементы)
func _reset_visibility(item: TreeItem):
	item.visible = true
	for child in item.get_children():
		_reset_visibility(child)
