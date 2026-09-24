//App headers
#include "Core.h"
#include "Settings.h"
#include "Window.h"

//External headers
#include <SDL3/SDL.h>
#include <SDL3/SDL_log.h>

namespace ClearViewer
{
	//All top level application state
	struct AppData
	{
		AppSettings settings;
		WindowData mainWindow;
		bool running = false;
	};

	//Storage for the app itself
	AppData app;

	int Initialize()
	{
		//Tries to initialize SDL
		if (!SDL_Init(SDL_INIT_VIDEO))
		{
			SDL_Log("Failed to initialize SDL: %s", SDL_GetError());
			return 1;
		}

		//Load the app settings
		app.settings = Settings::Load();

		//Create the main application window
		if (!Window::Create(app.mainWindow, app.settings.window)) return false;

		//Success!
		app.running = true;
		return 0;
	}

	void Run()
	{
		//Main application loop
		while (app.running)
		{
			//TODO: Convert to window API agnostic event loop
			SDL_Event event;
			while (SDL_PollEvent(&event))
			{
				//Pass into the window to handle the event
				Window::HandleEvent(app.mainWindow, event);
			}

			//If a close has been requested, then make sure to mark the app to quit
			if (app.mainWindow.closeRequested)
			{
				//Trigger popup to confirm close

				//Mark the app to quit
				Quit();
			}

			//Nothing to draw yet, so avoid spinning the CPU
			SDL_Delay(16);
		}
	}

	void Quit()
	{
		app.running = false;
	}

	void Shutdown()
	{
		Window::Destroy(app.mainWindow);
		SDL_Quit();
	}
}
