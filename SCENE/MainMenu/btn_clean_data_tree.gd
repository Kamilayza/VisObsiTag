extends Button

# --- Переменные ---
@onready var file_tree = %FileTree 
@onready var lb_no_tree_data = $"../../SpaceFT/Lb_NoTreeData"  
@onready var timer = $"../../../../../../Timer"
@onready var btn_clean_data_tree = $"."
@onready var le_find_element = %LE_FindElement
@onready var btn_find_element = $"../../HBC_FindElement/Btn_FindElement"

# --- Методы ---
func _ready():
	# Подключаем сигнал на нажатие кнопки очистки древа
	pressed.connect(_on_clean_data_tree_pressed)
	
	# Подключаем сигнал таймера для скрытия ярлыка
	timer.timeout.connect(self._on_timer_timeout)

# Обработчик нажатия на кнопку очистки древа
func _on_clean_data_tree_pressed():
	# Очищаем древо файлов
	file_tree.clear()  # Здесь используем clear() для очистки дерева
	
	# Показываем ярлык "Древо пусто"
	lb_no_tree_data.visible = true
	
	# Блокируем кнопку очистки древа после ее нажатия
	btn_clean_data_tree.disabled = true
	
	# Блокируем строку поиска и кнопку фильтра, так как нет данных для поиска
	le_find_element.editable = false
	btn_find_element.disabled = true
	
	# Запускаем таймер для скрытия ярлыка через 3 секунды
	timer.start(3.0)

# Сигнал от таймера для скрытия ярлыка
func _on_timer_timeout():
	# Скрываем ярлык "Древо пусто" после 3 секунд
	lb_no_tree_data.visible = false
