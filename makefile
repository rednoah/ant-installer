ANT := ant -lib lib


build: update
	$(ANT) spk syno-repo qpkg

update:
	$(ANT) clean resolve
	$(ANT) update-ant
	$(ANT) build fetch

clean:
	-rm -rv dist cache
	git reset --hard
	git pull
	git --no-pager log -1
