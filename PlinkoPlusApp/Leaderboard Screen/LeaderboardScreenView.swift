import SwiftUI

struct LeaderboardScreenView: View {
    
    @EnvironmentObject var soundManager: SoundManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var leaders: [Leader] = []

    var body: some View {
        ZStack {
            Image("AppBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                headerView
                titleView
                leaderboardList
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadLeaders()
            NotificationCenter.default.addObserver(forName: .leadersUpdated, object: nil, queue: .main) { _ in
                loadLeaders()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .leadersUpdated, object: nil)
        }
    }
    
    private var headerView: some View {
        HStack {
            backButton
            Spacer()
        }
        .padding(.top, 60)
    }
    
    private var backButton: some View {
        Button(action: {
            soundManager.playClickSound()
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .resizable()
                .frame(width: 6, height: 10)
                .foregroundColor(.black)
                .padding()
        }
        .frame(width: 32, height: 32)
        .background(Color.white)
        .clipShape(Circle())
    }
    
    private var titleView: some View {
        Text("LEADERBOARD")
            .font(.custom("Fredoka-Bold", size: 26))
            .foregroundColor(.white)
            .padding(.top, -20)
    }
    
    private var leaderboardList: some View {
        List {
            ForEach(Array(leaders.prefix(10).enumerated()), id: \.element.id) { index, leader in
                LeaderRowView(leader: leader, rank: index + 1)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(PlainListStyle())
    }
    
    private func loadLeaders() {
        let userDefaults = UserDefaults.standard
        
        if let savedLeaders = userDefaults.array(forKey: "leaders") as? [[String: Any]] {
            leaders = savedLeaders.compactMap { dict in
                if let nickname = dict["nickname"] as? String, let score = dict["score"] as? Int {
                    return Leader(nickname: nickname, score: score)
                }
                return nil
            }
        }

        leaders += defaultLeaders
        
        leaders.sort { $0.score > $1.score }
    }
}

extension Notification.Name {
    static let leadersUpdated = Notification.Name("leadersUpdated")
}
