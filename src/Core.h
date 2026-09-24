#pragma once

namespace ClearViewer
{
	//Initializes the application window and subsystems
	int Initialize();

	//Runs the main loop until the application is closed
	void Run();

	//Sets the application up to close and shut down
	void Quit();

	//Releases the application window and subsystems
	void Shutdown();
}
