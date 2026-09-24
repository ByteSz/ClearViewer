CC  := gcc
CXX := g++
CXXFLAGS := -std=c++20 -Wall -Wextra -Ilib/SDL3/include
LDFLAGS  := -Llib
LDLIBS   := -lSDL3

TARGET  := bin/ClearViewer.exe
SOURCES := $(wildcard src/*.cpp)
OBJECTS := $(patsubst src/%.cpp, objects/%.o, $(SOURCES))

# SDL3 is built from the lib/SDL3 submodule without CMake, using the source list from its Visual Studio project
SDL_DIR     := lib/SDL3
SDL_DLL     := lib/SDL3.dll
SDL_IMPLIB  := lib/libSDL3.dll.a
SDL_VCXPROJ := $(shell sed -n 's/.*ClCompile Include="\([^"]*\)".*/\1/p' $(SDL_DIR)/VisualC/SDL/SDL.vcxproj)
SDL_SOURCES := $(filter-out %/pch.c %/pch_cpp.cpp src/notification/windows/%, $(subst \,/,$(subst ..\..\,,$(SDL_VCXPROJ))))
SDL_SOURCES += src/notification/dummy/SDL_dummynotification.c
SDL_OBJECTS := $(patsubst %, objects/SDL3/%.o, $(SDL_SOURCES))
SDL_FLAGS   := -O2 -DNDEBUG -DDLL_EXPORT -DSDL_USE_BUILTIN_OPENGL_DEFINITIONS -DSDL_DISABLE_SVE2 \
               -Ilib/SDL3_config -I$(SDL_DIR)/include -I$(SDL_DIR)/src
SDL_LIBS    := -lkernel32 -luser32 -lgdi32 -lwinmm -limm32 -lole32 -loleaut32 -lversion -luuid \
               -ladvapi32 -lsetupapi -lshell32 -lhid

.PHONY: all sdl run clean clean-sdl

all: $(TARGET)

sdl: $(SDL_DLL)

$(TARGET): $(OBJECTS) $(SDL_DLL)
	@mkdir -p $(@D)
	$(CXX) $(OBJECTS) -o $@ $(LDFLAGS) $(LDLIBS)
	cp $(SDL_DLL) $(@D)/

objects/%.o: src/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -MMD -MP -c $< -o $@

# The SDL object list is too long for the Windows command line, so link through a response file
$(SDL_DLL): $(SDL_OBJECTS)
	$(file >objects/SDL3/objects.rsp,$(SDL_OBJECTS))
	$(CXX) -shared -o $@ @objects/SDL3/objects.rsp -Wl,--out-implib,$(SDL_IMPLIB) \
		-static-libgcc -static-libstdc++ $(SDL_LIBS)
	@rm -f objects/SDL3/objects.rsp

objects/SDL3/%.c.o: $(SDL_DIR)/%.c
	@mkdir -p $(@D)
	@echo "SDL3 $*.c"
	@$(CC) $(SDL_FLAGS) -c $< -o $@

objects/SDL3/%.cpp.o: $(SDL_DIR)/%.cpp
	@mkdir -p $(@D)
	@echo "SDL3 $*.cpp"
	@$(CXX) $(SDL_FLAGS) -c $< -o $@

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f objects/*.o objects/*.d $(TARGET)

clean-sdl:
	rm -rf objects/SDL3 $(SDL_DLL) $(SDL_IMPLIB) $(dir $(TARGET))SDL3.dll

-include $(OBJECTS:.o=.d)
