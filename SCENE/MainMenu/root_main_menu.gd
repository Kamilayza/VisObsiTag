extends Control



@onready var file_tree = $Fon/MainSpace/Menu/FileExplorer/FileTree
@onready var open_folder_button = $Fon/MainSpace/Menu/FileExplorer/Btn_OpneFolder
@onready var file_dialog_scene = $FileDialogOpenFolder



func _ready():
	# Подключаем сигнал от кнопки для открытия диалога
	open_folder_button.pressed.connect(_on_open_folder_dialog)
	# Подключаем сигнал от FileDialog для обновления Tree
	file_dialog_scene.folder_selected.connect(_on_folder_selected)


# Открытие диалога выбора папки
func _on_open_folder_dialog():
	file_dialog_scene.open()


# Обновление Tree после выбора папки
func _on_folder_selected(path: String):
	print("Selected folder:", path)
	file_tree.populate_tree(path)
