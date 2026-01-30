//
//  AyreApp.swift
//  Ayre
//
//  Created by Devin Rockwell on 8/26/25.
//

import SwiftUI

let defaultDoc = """
{
    "name": "Title",
    "staves": []
}
"""

@main
struct AyreApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: try! AyreDocument(text: defaultDoc)) { file in
            ContentView(document: file.$document)
        }
    }
}
