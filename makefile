ANT := ant -lib lib

build:
	$(ANT) build

spk: update
	$(ANT) spk
	$(ANT) syno-repo

qpkg: update
	$(ANT) qpkg

update:
	$(ANT) resolve
	$(ANT) update-ant
	$(ANT) build
	$(ANT) fetch
