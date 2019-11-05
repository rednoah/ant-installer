ANT := ant -lib lib


build: update
	$(ANT) spk syno-repo qpkg

update:
	$(ANT) clean resolve
	$(ANT) update-ant
	$(ANT) build fetch

clean:
	$(ANT) clean
