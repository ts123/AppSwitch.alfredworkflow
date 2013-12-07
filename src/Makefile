subdirs := activate_by_pid list_running_apps

.PHONY: all clean $(subdirs)

all: $(subdirs)

clean: $(subdirs)
	find . -depth 1 -type f -name '*.pyc' -delete

install: all

activate_by_pid:
	@$(MAKE) -C activate_by_pid $(MAKECMDGOALS)

list_running_apps:
	@$(MAKE) -C list_running_apps $(MAKECMDGOALS)

