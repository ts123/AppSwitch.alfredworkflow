SHELL=/bin/bash
TARGET=AppSwitch.alfredworkflow

subdirs := src

.PHONY: all clean install $(subdirs)

all: $(subdirs)
	mkdir -p bin
	zip -j9 bin/$(TARGET) src/*.{plist,png,py} \
		src/list_running_apps/build/Release/list_running_apps

clean: $(subdirs)
	rm -rf bin

install: all
	open bin/$(TARGET)

src:
	@$(MAKE) -C src $(MAKECMDGOALS)

