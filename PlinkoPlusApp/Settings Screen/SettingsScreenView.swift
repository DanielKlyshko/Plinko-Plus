import SwiftUI

struct SettingsScreenView: View {
    
    @EnvironmentObject var soundManager: SoundManager
    
    @Environment(\.dismiss) private var dismiss
    @State private var soundEnabled: Bool = true
    
    var body: some View {
        ZStack {
            Image("AppBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                headerView
                
                Text("SETTINGS")
                    .font(.custom("Fredoka-Bold", size: 26))
                    .foregroundColor(.white)
                    .padding(.top, -20)

                buttonWithSlider(icon: "volumeIcon", value: $soundManager.backgroundVolume)
                buttonWithSlider(icon: "musicNotesIcon", value: $soundManager.soundVolume)
                
                buttonWithToggle(icon: "phoneVibroIcon", text: "Vibro", isOn: $soundEnabled)

                textButton(text: "Reset Leaderboard")
                    .onTapGesture {
                        soundManager.playClickSound()
                        resetLeaderboard() // Вызов метода сброса настроек
                        NotificationCenter.default.post(name: NSNotification.Name("resetScore"), object: nil)
                    }
                
                Spacer()
                
                textButton(text: "SAVE CHANGES")
                    .padding(.bottom, 100)
                    .onTapGesture {
                        soundManager.playClickSound()
                        saveSettings()
                    }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            backButton
            Spacer()
        }
        .padding(.top, 60)
        .padding(.leading, 15)
    }
    
    private var backButton: some View {
        Button(action: {
            soundManager.playClickSound()
            dismiss() }) {
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
    
    private func buttonWithSlider(icon: String, value: Binding<Float>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 60)
                .stroke(Color(red: 139/255, green: 75/255, blue: 25/255), lineWidth: 6)
                .frame(width: 340, height: 70)
                .offset(y: 3)
            
            RoundedRectangle(cornerRadius: 60)
                .frame(width: 350, height: 70)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1, green: 191/255, blue: 0),
                            Color(red: 1, green: 114/255, blue: 7/255)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            HStack {
                Image(icon)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                
                Spacer()
                
                Slider(value: value, in: 0...1) // Громкость от 0 до 1
                    .tint(Color.white)
                    .padding(.trailing, 20)
            }
            .frame(width: 340, height: 70)
        }
        .padding(.top, 10)
    }

    private func buttonWithToggle(icon: String, text: String, isOn: Binding<Bool>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 60)
                .stroke(Color(red: 139/255, green: 75/255, blue: 25/255), lineWidth: 6)
                .frame(width: 340, height: 70)
                .offset(y: 3)
            
            RoundedRectangle(cornerRadius: 60)
                .frame(width: 350, height: 70)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1, green: 191/255, blue: 0),
                            Color(red: 1, green: 114/255, blue: 7/255)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            HStack {
                Image(icon)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                
                Text(text)
                    .font(.custom("Fredoka-Bold", size: 24))
                    .foregroundColor(.white)
                    .padding(.leading, 10)
                
                Spacer()
                
                Toggle("", isOn: isOn)
                    .labelsHidden()
                    .tint(.white)
                    .padding(.trailing, 20)
                    .onChange(of: isOn.wrappedValue) { _ in
                        soundManager.playClickSound()
                    }
            }
            .frame(width: 340, height: 70)
        }
        .padding(.top, 10)
    }
    
    private func textButton(text: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 60)
                .stroke(Color(red: 139/255, green: 75/255, blue: 25/255), lineWidth: 6)
                .frame(width: 340, height: 70)
                .offset(y: 3)
            
            RoundedRectangle(cornerRadius: 60)
                .frame(width: 350, height: 70)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1, green: 191/255, blue: 0),
                            Color(red: 1, green: 114/255, blue: 7/255)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Text(text)
                .font(.custom("Fredoka-Bold", size: 24))
                .foregroundColor(.white)
            
        }
        .padding(.top, 10)
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(soundManager.soundVolume, forKey: "soundVolume")
        UserDefaults.standard.set(soundManager.backgroundVolume, forKey: "backgroundVolume")
        UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
    }

    private func resetLeaderboard() {
        UserDefaults.standard.removeObject(forKey: "leaders")
        UserDefaults.standard.set(0.5, forKey: "soundVolume")
        UserDefaults.standard.set(0.5, forKey: "backgroundVolume")
        UserDefaults.standard.set(true, forKey: "soundEnabled")
        soundManager.soundVolume = 0.5
        soundManager.backgroundVolume = 0.5
        soundEnabled = true
    }
}

#Preview {
    SettingsScreenView()
}
