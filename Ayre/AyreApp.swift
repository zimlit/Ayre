//
//  AyreApp.swift
//  Ayre
//
//  Created by Devin Rockwell on 8/26/25.
//

import SwiftUI

@main
struct AyreApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: AyreDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
