import SwiftUI

struct Leader: Identifiable {
    let id = UUID()
    let nickname: String
    var score: Int
}

let defaultLeaders = [
    Leader(nickname: "Player1", score: 500),
    Leader(nickname: "Player2", score: 450),
    Leader(nickname: "Player3", score: 400),
    Leader(nickname: "Player4", score: 390),
    Leader(nickname: "Player5", score: 370),
    Leader(nickname: "Player6", score: 350),
    Leader(nickname: "Player7", score: 340),
    Leader(nickname: "Player8", score: 330),
    Leader(nickname: "Player9", score: 320),
    Leader(nickname: "Player10", score: 310),
    Leader(nickname: "Player11", score: 300),
    Leader(nickname: "Player12", score: 290),
    Leader(nickname: "Player13", score: 280),
    Leader(nickname: "Player14", score: 270),
    Leader(nickname: "Player15", score: 260),
    Leader(nickname: "Player16", score: 250),
    Leader(nickname: "Player17", score: 240),
    Leader(nickname: "Player18", score: 230),
    Leader(nickname: "Player19", score: 220),
    Leader(nickname: "Player20", score: 210)
]
