//
//  ScoreView.swift
//  Ayre
//
//  Created by Devin Rockwell on 1/31/26.
//

import SwiftUI

struct ScoreView: View {
    @Binding var score: Score
    var staffSpace = 7.5
    
    func getDuration(_ length: Double) -> String {
        switch length {
        case 1: return "\u{EBAA}"
        case 2: return "\u{EBA9}"
        case 4: return "\u{EBA8}"
        case 8: return "\u{EBA7}"
        default: return ""
        }
    }

    var body: some View {
        ForEach($score.staves) { $staff in
            Canvas(
                opaque: true,
                colorMode: .nonLinear,
                rendersAsynchronously: false
            ) { context, size in
                switch staff.data {
                case .Mensural(_):
                    // draw staff lines
                    var path = Path()
                    path.addLine(to: CGPoint(x: 0.0, y: 30.0))
                    path.addLine(to: CGPoint(x: size.width, y: 30.0))
                    context.stroke(
                        path,
                        with: .color(.black),
                        lineWidth: 5
                    )
                case .GermanTablature(_): break
                case .GridTablature(var data):
                    if data.tuning.count >= 6 {
                        var line = 0
                        while line < 6 {
                            var path = Path()
                            path.move(
                                to: CGPoint(
                                    x: 10.0,
                                    y: 30.0 + Double(line) * staffSpace
                                )
                            )
                            path.addLine(
                                to: CGPoint(
                                    x: size.width - 10.0,
                                    y: 30.0 + Double(line) * staffSpace
                                )
                            )
                            context.stroke(
                                path,
                                with: .color(.black),
                                lineWidth: 1
                            )
                            line += 1
                        }
                    } else {
                        var line = 0
                        while line < data.tuning.count {
                            var path = Path()
                            path.move(
                                to: CGPoint(
                                    x: 10.0,
                                    y: 30.0 + Double(line) * staffSpace
                                )
                            )
                            path.addLine(
                                to: CGPoint(
                                    x: size.width - 10.0,
                                    y: 30.0 + Double(line) * staffSpace
                                )
                            )
                            context.stroke(
                                path,
                                with: .color(.black),
                                lineWidth: 1
                            )
                            line += 1
                        }
                    }
                    var xPosition = 15.0
                    for bar in data.bars {
                        for item in bar.items {
                            switch item {
                            case .Chord(let notes, let length):
                                for note in notes {
                                    let position = CGPoint(
                                        x: xPosition,
                                        y: 29.05 + (Double(note.string) - 1)
                                            * staffSpace
                                    )
                                    context.draw(
                                        Text("\(UnicodeScalar(note.fret+0xEBC0)!)")
                                            .font(.custom("Bravura", size: 23))
                                            .foregroundStyle(
                                            .black
                                        ),
                                        at: position
                                    )
                                    let durationSign = getDuration(length)
                                    context.draw(
                                        Text(durationSign)
                                            .font(.custom("Bravura", size: 23))
                                            .foregroundStyle(
                                            .black
                                        ),
                                        at: CGPoint(x: xPosition, y: 20.0)
                                    )
                                }
                            case .Rest(let dur): break
                            }
                            xPosition += 10.0
                        }
                        var barline = Path()
                        barline.move(to: CGPoint(x: xPosition, y: 30.0))
                        barline.addLine(to: CGPoint(x: xPosition, y: 30.0+staffSpace*5))
                        context.stroke(barline, with: .color(.black), lineWidth: 1)
                    }
                }
            }
            .background(.white)
        }
    }
}

#Preview {
    @Previewable @State var s = Score(
        name: "Preview",
        staves: [
            Staff(
                name: "Lute",
                data: .GridTablature(
                    GridTablature(
                        tuning: [
                            Note("G", 2),
                            Note("C", 3),
                            Note("F", 3),
                            Note("A", 3),
                            Note("D", 4),
                            Note(
                                "G",
                                4
                            ),
                        ],
                        FretsAsNumbers: true,
                        bars: [
                            Bar(
                                length: 16.0,
                                items: [
                                    .Chord(
                                        [
                                            .init(string: 6, fret: 0),
                                            .init(string: 3, fret: 1),
                                            .init(string: 2, fret: 0),
                                            .init(string: 1, fret: 0),
                                        ],
                                        8.0
                                    ),
                                    .Chord([.init(string: 4, fret: 2)], 4),
                                    .Chord(
                                        [
                                            .init(string: 2, fret: 3),
                                            .init(string: 3, fret: 0),
                                        ],
                                        2.0
                                    ),
                                    .Chord([.init(string: 2, fret: 1)], 2.0),
                                ]
                            )
                        ]
                    )
                )
            )
        ]
    )

    ScoreView(
        score: $s
    )
}
