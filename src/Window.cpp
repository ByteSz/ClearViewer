//App headers
#include "Core.h"
#include "Window.h"

//External headers
#include <SDL3/SDL.h>
#include <SDL3/SDL_video.h>

namespace ClearViewer::Window
{
	bool Create(WindowData& window, const WindowSettings& settings)
	{
		//Set up the SDL window flags based on settings
		SDL_WindowFlags flags = 0;
		if (settings.resizable) flags |= SDL_WINDOW_RESIZABLE;
		if (settings.maximized) flags |= SDL_WINDOW_MAXIMIZED;

		//Create the window handle for use by the application
		window.handle = SDL_CreateWindow(settings.title, settings.width, settings.height, flags);
		if (!window.handle)
		{
			SDL_Log("Failed to create window: %s", SDL_GetError());
			return false;
		}

		//Make sure to clear the window close flag
		window.closeRequested = false;
		return true;
	}

	void HandleEvent(WindowData& window, const SDL_Event& event)
	{
		switch (event.type)
		{
			//User closed the window or requested to quit
			case SDL_EVENT_QUIT:
				//Mark the app to quit
				Quit();
				break;
			case SDL_EVENT_WINDOW_CLOSE_REQUESTED:
				//Mark that a close event has been requested
				if (event.window.windowID == SDL_GetWindowID(window.handle)) window.closeRequested = true;
				break;
			case SDL_EVENT_KEY_DOWN:
				if (event.key.key == SDLK_F)
				{
					SDL_Log("F!");
				}
				break;

			default:
				break;
		}
	}

	void Destroy(WindowData& window)
	{
		//Deletes the main window for shutdown
		if (window.handle)
		{
			SDL_DestroyWindow(window.handle);
			window.handle = nullptr;
		}
	}
}
