ANT := ant -lib lib


package: update
	$(ANT) spk package-source

update:
	$(ANT) resolve
	$(ANT) update-ant
