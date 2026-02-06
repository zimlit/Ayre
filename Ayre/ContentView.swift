//
//  ContentView.swift
//  Ayre
//
//  Created by Devin Rockwell on 8/26/25.
//

import SwiftUI

struct TuningPicker: View {
    @Binding var tuning: [Note]
    
    var body: some View {
        
    }
}

struct ContentView: View {
    @Binding var document: AyreDocument
    @State private var multiSelection = Set<UUID>()
    @State private var newItemModalShown = false
    @State private var staffType: StaffData = StaffData.Mensural([])
    @State private var staffName: String = ""
    
    var body: some View {
        HStack {
            VStack {
                Button(action: {
                    newItemModalShown.toggle()
                }) {
                    Text("New Staff")
                }.sheet(isPresented: $newItemModalShown) {
                    Form {
                        TextField("Staff Name", text: $staffName)
                        Picker("Type:", selection: $staffType) {
                            Text("Mensural Staff").tag(StaffData.Mensural([]))
                            Text("Tablature Staff")
                                .tag(StaffData.GridTablature(GridTablature(tuning: [
                                    Note("G", 2), Note("C", 3), Note("F", 3), Note("A", 3), Note("D", 4), Note("G", 4)
                                ], FretsAsNumbers: false, bars: [])))
                            Text("German Tablature Staff")
                                .tag(
                                    StaffData
                                        .GermanTablature(
                                            GermanTablature(
                                                tuning: [
                                                    Note("G", 2), Note("C", 3), Note("F", 3), Note("A", 3), Note("D", 4), Note("G", 4)
                                                ],
                                                bars: []
                                            )
                                        )
                                )
                        }
                        switch staffType {
                        case .Mensural(_):
                            Text("mensural")
                        case let .GridTablature(tablature):
                            Text("Tuning: \(tablature.tuning)")
                        case let .GermanTablature(tablature):
                            Text("Tuning: \(tablature.tuning)")
                        }
                        HStack{
                            Button(role: .cancel, action: {
                                newItemModalShown.toggle()
                            }) {
                                Text("Cancel")
                            }
                            Button(
                                action: {
                                    document.score.staves
                                        .append(
                                            Staff(name: staffName, data: staffType)
                                        )
                                    newItemModalShown.toggle()
                                }) {
                                    Text("Create")
                                }
                                .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding(16)
                }
                List($document.score.staves, editActions: [.delete, .move], selection: $multiSelection) { $staff in Text(
                    staff.name
                )
                    
                }
            }
            ScoreView(score: $document.score)
        }
        

    }
}

#Preview {
    ContentView(document: .constant(try! AyreDocument(text: """
        {
            "name": "Title",
            "staves": []
        }
""")))
}
