//
//  ContentView.swift
//  Ayre
//
//  Created by Devin Rockwell on 8/26/25.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: AyreDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(AyreDocument()))
}
