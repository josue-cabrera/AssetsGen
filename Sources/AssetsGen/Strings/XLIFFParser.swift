import Foundation
import XMLCoder

struct XLIFFParser {
	let sources: [StringsSource]

	init(sources: [StringsSource]) {
		self.sources = sources
	}

	func parse(inputPath: String, files: [String], outputPath: String) {
		files
			.map { inputPath / $0 }
			.compactMap { FileUtils.data(atPath: $0) }
			.forEach { data in
				do {
					let xliff = try XMLDecoder().decode(XLIFF.self, from: data)
					let sources = parse(xliff: xliff)
					sources.forEach { source in
						FileUtils.saveJSON(source, inPath: outputPath / "\(source.fileName).json")
					}
				} catch {
					print(error)
				}
			}
	}

	func parse(xliff: XLIFF) -> [StringsSource] {
		var sources = self.sources
		xliff.files.forEach { file in
			if let idx = sources.firstIndex(where: { file.original.contains($0.fileName) }) {
				let source = sources[idx]
				file.body.transUnits.forEach { unit in
					if let idx = source.strings.firstIndex(where: { $0.key == unit.id }),
						let value = unit.target {
						let string = source.strings[idx]
						let sourceValue = string.value(for: file.sourceLanguage, with: Configs.os)?.localizableValue
						if unit.source == sourceValue {
							string.set(value, for: file.targetLanguage)
						} else {
							ParseXLIFFFile.shared.write(key: string.key, base: sourceValue ?? "", translated: unit.source)
						}
					}
				}
				sources[idx] = source
			}
		}
		return sources
	}
}
