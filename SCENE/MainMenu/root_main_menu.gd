extends Control

# --- Переменные ---
@onready var file_tree = %FileTree
@onready var btn_open_folder = $Fon/MainSpace/Menu/FileExplorer/Btn_ActionsTree/Btn_OpenFolder
@onready var btn_find_element = $Fon/MainSpace/Menu/FileExplorer/HBC_FindElement/Btn_FindElement
@onready var btn_clean_data_tree = $Fon/MainSpace/Menu/FileExplorer/Btn_ActionsTree/Btn_CleanDataTree
@onready var file_dialog_scene = $FileDialogOpenFolder
@onready var le_find_element = %LE_FindElement
@onready var lb_no_matches = $Fon/MainSpace/Menu/FileExplorer/SpaceFT/Lb_NoMatches
@onready var lb_no_tree_data = $Fon/MainSpace/Menu/FileExplorer/SpaceFT/Lb_NoTreeData
@onready var timer = $Timer

# --- Методы ---
func _ready():
	# Изначально кнопка очистки древа и элементы поиска должны быть заблокированы
	_block_elements()
	
	# Подключаем сигнал от кнопки для открытия диалога
	btn_open_folder.pressed.connect(_on_open_folder_dialog)
	
	# Подключаем сигнал от FileDialog для обновления Tree
	file_dialog_scene.folder_selected.connect(_on_folder_selected)
	
	# Подключаем сигнал для фильтрации по кнопке
	btn_find_element.pressed.connect(_on_filter_button_pressed)
	
	# Подключаем сигнал от таймера для скрытия ярлыка
	timer.timeout.connect(self._on_timer_timeout)

# Открытие диалога выбора папки
func _on_open_folder_dialog():
	file_dialog_scene.open()

# Обновление Tree после выбора папки
func _on_folder_selected(path: String):
	print("Selected folder:", path)
	file_tree.populate_tree(path)
	
	# После выбора папки, разблокируем элементы поиска и кнопку очистки древа
	_unblock_elements()

# Фильтрация по кнопке
func _on_filter_button_pressed():
	var search_text = le_find_element.text.strip_edges().to_lower()
	file_tree.filter_tree(search_text)
	
	# Отображаем или скрываем ярлык "Совпадений не найдено"
	lb_no_matches.visible = file_tree.no_matches_found

# Обработчик нажатия на кнопку очистки древа
func _on_clean_data_tree_pressed():
	# Очищаем древо файлов
	file_tree.clear()  # Здесь используем clear() для очистки дерева
	
	# Показываем ярлык "Древо пусто"
	lb_no_tree_data.visible = true
	
	# Блокируем кнопки и строку поиска после очистки
	_block_elements()
	
	# Запускаем таймер для скрытия ярлыка через 3 секунды
	timer.start(3.0)

# Сигнал от таймера для скрытия ярлыка
func _on_timer_timeout():
	# Скрываем ярлык "Древо пусто" после 3 секунд
	lb_no_tree_data.visible = false

# --- Методы для блокировки и разблокировки элементов ---
func _block_elements():
	# Блокируем кнопки и строку поиска
	btn_clean_data_tree.disabled = true
	le_find_element.editable = false  # Для LineEdit снова делаем неактивной
	btn_find_element.disabled = true

func _unblock_elements():
	# Разблокируем кнопки и строку поиска
	le_find_element.editable = true  # Для LineEdit используем 'editable'
	btn_find_element.disabled = false
	btn_clean_data_tree.disabled = false
