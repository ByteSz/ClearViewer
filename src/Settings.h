#pragma once

namespace ClearViewer
{
	//Configuration for the main application window
	struct WindowSettings
	{
		const char* title = "ClearViewer";
		int width = 1280;
		int height = 720;
		bool resizable = true;
		bool maximized = false;
	};

	//All user configurable application settings
	struct AppSettings
	{
		WindowSettings window = WindowSettings();
	};

	namespace Settings
	{
		//Loads the application settings
		AppSettings Load();
	}
}
