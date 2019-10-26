APP_MAKEFILES := $(shell find ./applications -name 'Makefile' -printf '%h\n')
SOC_MAKEFILES := $(shell find ./soc -name 'Makefile' -printf '%h\n')

build:
	$(foreach makefile,$(APP_MAKEFILES), $(MAKE) -C $(makefile) $@;)

compile:
	$(foreach makefile,$(SOC_MAKEFILES), $(MAKE) -C $(makefile) $@;)

simulate:
	$(foreach makefile,$(SOC_MAKEFILES), $(MAKE) -C $(makefile) $@;)

synthesize:
	$(foreach makefile,$(SOC_MAKEFILES), $(MAKE) -C $(makefile) $@;)

clean:
	$(foreach makefile,$(APP_MAKEFILES), $(MAKE) -C $(makefile) $@;)
	$(foreach makefile,$(SOC_MAKEFILES), $(MAKE) -C $(makefile) $@;)