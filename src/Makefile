subdirs := list_running_apps

.PHONY: all clean $(subdirs)

all: $(subdirs)

clean: $(subdirs)
	find . -depth 1 -type f -name '*.pyc' -delete

install: all

list_running_apps:
	@$(MAKE) -C list_running_apps $(MAKECMDGOALS)

