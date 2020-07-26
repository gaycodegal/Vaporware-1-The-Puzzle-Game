# Language configs

The language config should be simple to use, the name of the player's language is stored in `Globals.settings.general.language`, and this is used to pick the language config from this folder.

The language configs from this folder store strings which can be accessed in code by doing things like `var title = Globals.language.get_value("main_menu", "title", "")`. It is important to provide a default or handle `null` so that the game does not crash if a language string is not available.
