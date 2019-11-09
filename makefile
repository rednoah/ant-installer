ANT := ant -lib lib


build: update
	$(ANT) spk syno-repo qpkg

update:
	$(ANT) clean resolve
	$(ANT) update-ant
	$(ANT) build fetch

clean:
	rm -rv dist
	git reset --hard
	git pull
	git log -1
