import SwiftUI
import SpriteKit

struct GameScreenView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var soundManager: SoundManager
    @Environment(\.dismiss) private var dismiss

    @State private var score: Int = 500
    @State private var multiplier: Double = 1.0
    @State private var currentMultiplier: Double = 1.0
   
    @State private var dropPositionX: CGFloat = UIScreen.main.bounds.width / 2
    
    @State private var showingBetSheet: Bool = false
    @State private var selectedBet: Double = 10
    
    @State private var isBallDropped: Bool = false
    @State private var hasBallLanded: Bool = false
    @State private var isBonusActive: Bool = false
    @State private var isMultiplierUsed: Bool = false

    // MARK: - Views Setups
    
    var scene: SKScene {
        let scene = GameScene(score: $score, multiplier: $multiplier)
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        ZStack {
            backgroundView
            gameContentView
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadScore()
            setupObservers()
        }
        .onDisappear(perform: removeObservers)
    }

    private var backgroundView: some View {
        Image("AppBackground")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
    
    private var gameContentView: some View {
        VStack {
            headerView
            scoreView
            Spacer()
            gameAreaView
            
            actionButtons
            winTextView
            dropOrRestartButton
            Spacer()
        }
    }

    private var scoreView: some View {
        Text("\(score)")
            .font(.custom("Fredoka-Bold", size: 38))
            .foregroundColor(.white)
            .padding(.top, -8)
            .frame(width: 200, height: 90)
            .background(scoreBackground)
            .cornerRadius(60)
            .padding(.top, -20)
    }

    private var gameAreaView: some View {
        SpriteView(scene: scene)
            .frame(width: 380, height: 432)
            .cornerRadius(20)
            .shadow(radius: 10)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    dropPositionX = min(max(value.location.x, 0), UIScreen.main.bounds.width)
                    NotificationCenter.default.post(name: NSNotification.Name("moveBallToPosition"), object: dropPositionX)
                })
    }
    
    private var actionButtons: some View {
        HStack {
            bonusButton
            Spacer()
            multiplierButton
        }
        .padding(.top, -422)
        .padding(.horizontal, 30)
    }
    
    private var winTextView: some View {
        VStack {
            Text("You win!")
                .font(.custom("Fredoka-Bold", size: 30))
                .foregroundColor(.white)
            Text("X\(currentMultiplier, specifier: "%.1f")")
                .font(.custom("Fredoka-Bold", size: 50))
                .foregroundColor(.white)
        }
        .opacity(hasBallLanded ? 1 : 0)
        .padding(.bottom, -10)
        .padding(.top, -20)
    }

    private var dropOrRestartButton: some View {
        Button(action: dropOrRestartBall) {
            Text(isBallDropped ? "Restart" : "Drop Ball")
                .font(.custom("Fredoka-Bold", size: 38))
                .foregroundColor(.white)
                .padding(.top, -8)
                .frame(width: 200, height: 90)
                .background(scoreBackground)
                .cornerRadius(60)
        }
    }
    
    private var scoreBackground: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1, green: 191/255, blue: 0),
                    Color(red: 1, green: 114/255, blue: 7/255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            RoundedRectangle(cornerRadius: 60)
                .stroke(Color(red: 139/255, green: 75/255, blue: 25/255), lineWidth: 6)
                .offset(y: -3)
                .frame(width: 210, height: 90)
        }
    }
    
    private var headerView: some View {
        HStack {
            backButton
            Spacer()
        }
        .padding(.top, 50)
        .padding(.leading, 15)
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
    
    // MARK: - Bonuses Settings
    
    private var bonusButton: some View {
        VStack {
            Button(action: {
                if score >= 300 {
                    score -= 300
                    isBonusActive = true
                    NotificationCenter.default.post(name: NSNotification.Name("bonusButtonPressed"), object: nil)
                }
            }) {
                Image("bonusCirclesIcon")
                    .resizable()
                    .frame(width: 30, height: 20)
                    .padding()
            }
            .frame(width: 60, height: 40)
            .background(bonusButtonBackground)
            .cornerRadius(20)
            .opacity(score >= 300 ? 1 : 0.7)
            .disabled(score < 300 || isBonusActive || isBallDropped)

            Text("300")
                .font(.custom("Fredoka-Bold", size: 16))
                .foregroundColor(.white)
        }
    }

    private var bonusButtonBackground: some View {
        if isBonusActive {
            return AnyView(Color.red)
        } else if score >= 300 {
            return AnyView(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 1, green: 191/255, blue: 0),
                        Color(red: 1, green: 114/255, blue: 7/255)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        } else {
            return AnyView(Color.gray)
        }
    }

    private var multiplierButton: some View {
        VStack {
            Button(action: {
                if score >= 500 {
                    score -= 500
                    isMultiplierUsed = true
                    NotificationCenter.default.post(name: NSNotification.Name("multiplierButtonPressed"), object: nil)
                }
            }) {
                Text("x2")
                    .font(.custom("Fredoka-Bold", size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 60, height: 40)
                    .background(buttonBackground)
                    .cornerRadius(20)
                    .opacity(score >= 500 ? 1 : 0.7)
            }
            .disabled(score < 500 || isMultiplierUsed || isBallDropped)

            Text("500")
                .font(.custom("Fredoka-Bold", size: 16))
                .foregroundColor(.white)
        }
    }
    private var buttonBackground: some View {
        if isMultiplierUsed {
            return AnyView(Color.green)
        } else if score >= 500 {
            return AnyView(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 1, green: 191/255, blue: 0),
                        Color(red: 1, green: 114/255, blue: 7/255)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        } else {
            return AnyView(Color.gray)
        }
    }

    // MARK: - Ball Actions
    
    private func dropOrRestartBall() {
        isBallDropped ? restartGame() : dropBall()
    }
    
    private func dropBall() {
        isBonusActive ? notifyDropBall() : notifyDropBall()
        isBallDropped = true
    }
    
    private func notifyDropBall() {
        NotificationCenter.default.post(name: NSNotification.Name("dropBallAtPosition"), object: dropPositionX)
    }
    
    // MARK: - Restart

    private func restartGame() {
        dropPositionX = UIScreen.main.bounds.width / 2
        NotificationCenter.default.post(name: NSNotification.Name("restartGame"), object: nil)
        isBallDropped = false
        
        NotificationCenter.default.post(name: NSNotification.Name("resetButtonPressed"), object: nil)
        
    }

    // MARK: - Score Settings
    
    private func saveScore() {
        UserDefaults.standard.set(score, forKey: "userScore")
    }
    
    private func loadScore() {
        if let savedScore = UserDefaults.standard.value(forKey: "userScore") as? Int {
            score = savedScore
        }
    }
    
    private func resetScore() {
        score = 500
        saveScore()
    }

    private func updateOrCreatePlayer(nickname: String, score: Int) {
        let userDefaults = UserDefaults.standard
        var players = userDefaults.array(forKey: "leaders") as? [[String: Any]] ?? []

        if let index = players.firstIndex(where: { ($0["nickname"] as? String) == nickname }) {
            players[index]["score"] = score
        } else {
            let newPlayer: [String: Any] = ["nickname": nickname, "score": score]
            players.append(newPlayer)
        }

        userDefaults.set(players, forKey: "leaders")
    }
    
    // MARK: - Notification Observers
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("updateMultiplier"), object: nil, queue: .main) { notification in
            if let multiplier = notification.object as? Double {
                currentMultiplier = multiplier
            }
            saveScore()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ballLanded"), object: nil, queue: .main) { _ in
            hasBallLanded = true
            score = Int(Double(score) * currentMultiplier)
            saveScore()
            updateOrCreatePlayer(nickname: "YourNickname", score: score)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("restartGame"), object: nil, queue: .main) { _ in
            hasBallLanded = false
            currentMultiplier = 1.0
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("resetScore"), object: nil, queue: .main) { _ in
            resetScore()
            }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ballLanded"), object: nil, queue: .main) { _ in
            hasBallLanded = true
            isMultiplierUsed = false
            isBonusActive = false
            }
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}
