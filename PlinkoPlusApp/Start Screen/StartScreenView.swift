import SwiftUI

struct StartScreenView: View {
    
    @EnvironmentObject var soundManager: SoundManager
    
    var body: some View {
        ZStack {
            Image("AppBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                headerView
                Image("AppLogoImage")
                Spacer().frame(height: 120)
                NavigationLink(destination: 
                    GameScreenView().environmentObject(soundManager)) {
                    playButton
                }
                .simultaneousGesture(TapGesture().onEnded {
                    soundManager.playClickSound()
                })
                Spacer().frame(height: 26)
                NavigationLink(destination: LeaderboardScreenView().environmentObject(soundManager)) {
                    leaderboardButton
                }
                .simultaneousGesture(TapGesture().onEnded {soundManager.playClickSound()})
                Spacer()
                footerView
            }
            .padding()
        }
        .onAppear {
            soundManager.playBackgroundMusic()
            soundManager.loadSettings()
        }
    }
    
    private var headerView: some View {
        HStack {
            Spacer()
            NavigationLink(destination: SettingsScreenView().environmentObject(soundManager)) {
                actionButton(icon: "gearshape")
                    .padding(.top, 60)
                    .padding(.trailing, 15)
            }
            .simultaneousGesture(TapGesture().onEnded {
                soundManager.playClickSound()
            })
        }
    }
    
    private var playButton: some View {
        buttonView(text: "PLAY", topPadding: -8, fontSize: 38, height: 90)
    }
    
    private var leaderboardButton: some View {
        buttonView(text: "LEADERBOARD", topPadding: -6, fontSize: 22, height: 70)
    }
    
    private var footerView: some View {
        HStack {
            Spacer()
            NavigationLink(destination:
                RulesScreenView().environmentObject(soundManager)) {
                actionButton(icon: "info.circle")
                    .padding(.bottom, 100)
                    .padding(.trailing, 15)
            }
            .simultaneousGesture(TapGesture().onEnded {
                soundManager.playClickSound()
            })
        }
    }
    
    private func actionButton(icon: String) -> some View {
        Image(systemName: icon)
            .resizable()
            .frame(width: 18, height: 18)
            .foregroundColor(.black)
            .padding()
            .frame(width: 32, height: 32)
            .background(Color.white)
            .clipShape(Circle())
    }

    private func buttonView(text: String, topPadding: CGFloat, fontSize: CGFloat, height: CGFloat) -> some View {
        Text(text)
            .font(.custom("Fredoka-Bold", size: fontSize))
            .foregroundColor(.white)
            .padding(.top, topPadding)
            .frame(width: 350, height: height)
            .background(
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
                        .stroke(
                            Color(red: 139/255, green: 75/255, blue: 25/255),
                            lineWidth: 6
                        )
                        .offset(y: -3)
                        .frame(width: 360, height: height)
                }
            )
            .cornerRadius(60)
    }
}

