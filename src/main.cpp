//App headers
#include "Core.h"

//External headers
#include <SDL3/SDL_main.h>

int main(int, char*[])
{
	//Initialize and capture error
	int error = ClearViewer::Initialize();

	//Check for error, shutdown if occurs
	if (error != 0)
	{
		ClearViewer::Shutdown();
		return 1;
	}

	//Run the application main loop
	ClearViewer::Run();

	//Free all application resources for shutdown
	ClearViewer::Shutdown();
	return 0;
}
