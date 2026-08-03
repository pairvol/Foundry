PREFIX ?= $(HOME)/.local
BINDIR := $(PREFIX)/bin
APPDIR := $(PREFIX)/share/applications
APPID := dev.pairvol.Foundry

.PHONY: all run install uninstall

all:
	@echo "Foundry is a GJS script; nothing to compile. Run 'make run' or 'make install'."

run:
	./bin/foundry

install:
	install -d $(BINDIR) $(APPDIR)
	install -m 0755 bin/foundry $(BINDIR)/foundry
	install -m 0644 data/$(APPID).desktop $(APPDIR)/$(APPID).desktop
	update-desktop-database $(APPDIR) >/dev/null 2>&1 || true

uninstall:
	rm -f $(BINDIR)/foundry $(APPDIR)/$(APPID).desktop
	update-desktop-database $(APPDIR) >/dev/null 2>&1 || true
