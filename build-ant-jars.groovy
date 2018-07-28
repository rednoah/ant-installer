project.references.'jars'.each { r ->
	ant.jar(destfile: ant.project.properties.'dir.dist' + '/ant/' + r.name, index: 'yes', indexMetaInf: 'yes', compress: 'no') {
		zipfileset(src: r) {
			exclude(name: 'META-INF/MANIFEST.MF')
			exclude(name: 'META-INF/INDEX.LIST')
			exclude(name: 'META-INF/*.RSA')
			exclude(name: 'META-INF/*.DSA')
			exclude(name: 'META-INF/*.SF')
			exclude(name: 'META-INF/*.EC')
		}
	}
}
