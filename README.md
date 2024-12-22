# SES-library
 
A multipurpose game-managing sestem for Godot 4.3, which is planned to include:

-Save-manager that supports autosave and unlimited amount of manual save files</br>
-Settings-manager that at least supports gameplay- and audio-related settings. Possibly even key bindings and video settings</br>
-2D style dialogue system that supports branching dialogue</br>
-Menu-manager that makes the implementation of these systems quick and easy</br>


User guide (to be updated (a lot)):</br>
I haven't looked into how plugins work yet, so for now this project is just a folder to be added inside the res:// directory. This also means that the different components need to be manually set to autoload. I'll look into making this a plugin after all the components are somewhat coded.

Using the library:</br>
The whole library is controlled by ses_middleware.gd, so every command is accessible with the identifier Ses.</br>
The library can be configure at ses_config.gd
</br></br>

## SaveManager (almost done)</br>
Is used to upkeep the SaveResource-object, and can be used to save it into a .json file. I chose .json instead of .tres to avoid the security problems with .tres and it's ability to store executable code.</br>



### Functions

save_game(save_name = SesConfig.manual_save_name)</br>
Command: Ses.save_manual(n = "")</br>
Takes everything stored in the SaveResource object and saves it to user://saves/.</br>
constructs the full name from: save_name, timestamp, ".json

auto_save(name = SesConfig.auto_save, autosave = true)</br>
Command: Ses.save_auto()
Saves using the autosave name. Using autosave leaves out the timestamp and that's why there is a second argument.

load_game(save_name = SesConfig.auto_save_name)</br>
Command: Ses.save_load(n = "")</br>
Loads the selected save into SaveResource. If filename is not specified, will load autosave instead

set_res_value(key, value)</br>
Command: Ses.res_set(k, v)</br>
Edits a predetermined value in SaveResource

set_res_variable(key, value)</br>
Command: Ses.res_var(k, v)</br>
Saves a variable into a Dictionary dynamically. Creates the variable if it doesn't exist. Edits it if it does
