import Foundation

struct StringsGenerator {
	let projectName: String
	let sources: [StringsSource]

	init(projectName: String, sources: [StringsSource]) {
		self.projectName = projectName
		self.sources = sources
	}

	func generate(
		baseLang: LanguageKey,
		os: OS,
		path: String,
		codeGen: Bool,
		codePath: String? = nil
	) {
		sources.forEach { source in
			switch os {
			case .android:
				source.generateXMLFile(at: path, baseLang: baseLang)
			case .iOS:
				source.generateStringsFile(at: path)
				if codeGen {
					let _path: String
					if let p = codePath, !p.isEmpty {
						_path = p
					} else {
						_path = path
					}
					source.generateSwiftCode(at: _path)
				}
			}
		}
	}
}
