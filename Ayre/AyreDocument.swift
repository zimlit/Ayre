//
//  AyreDocument.swift
//  Ayre
//
//  Created by Devin Rockwell on 8/26/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct Note: Codable & Hashable {
    var name: String
    var octave: Int
    
    init(_ name: String, _ octave: Int) {
        self.name = name
        self.octave = octave
    }
}

enum MensuralItem: Codable & Hashable {
    case Chord([Note], Double)
    case Rest(Double)
    case Clef(String, Double)
    case Mensuration(String)
}

struct TabNote: Codable & Hashable {
    var string: Int
    var fret: Int
}

enum TabItem: Codable & Hashable {
    case Chord([TabNote], Double)
    case Rest(Double)
}

struct Bar: Codable & Hashable {
    var length: Double
    var items: [TabItem]
}

struct GridTablature: Codable & Hashable {
    var LowestCourseOnTop: Bool = false
    var tuning: [Note]
    var FretsAsNumbers: Bool
    var bars: [Bar]
}

struct GermanTablature: Codable & Hashable {
    var tuning: [Note]
    var bars: [Bar]
}

enum StaffData: Codable & Hashable {
    case Mensural([MensuralItem])
    case GridTablature(GridTablature)
    case GermanTablature(GermanTablature)
}

struct Staff: Codable & Identifiable & Hashable {
    var id = UUID()
    var name: String

    var data: StaffData
}

struct Score: Codable {
    var name: String
    var staves: [Staff]
}

struct AyreDocument: FileDocument {
    var score: Score

    init(text: String) throws {
        let decoder = JSONDecoder()
        self.score = try decoder.decode(Score.self, from: text.data(using: .utf8)!)
    }

    static var readableContentTypes: [UTType] { [UTType.json] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        let decodedScore: Score = try JSONDecoder().decode(Score.self, from: data)
        self.score = decodedScore
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let data = try encoder.encode(score)
        return .init(regularFileWithContents: data)
    }
}
