import AVFoundation
import SwiftUI

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    private var backgroundPlayer: AVAudioPlayer?
    private var clickPlayer: AVAudioPlayer?
    private var pagKickPlayer: AVAudioPlayer?
    
    @Published var isSoundEnabled: Bool = true {
        didSet {
            if isSoundEnabled {
                backgroundPlayer?.play()
            } else {
                backgroundPlayer?.stop()
            }
        }
    }
    
    @Published var isVibrationEnabled: Bool = true
    
    @Published var backgroundVolume: Float = 0.5 { // Громкость фоновой музыки
        didSet {
            backgroundPlayer?.volume = backgroundVolume
        }
    }
    
    @Published var soundVolume: Float = 0.5 { // Громкость звуков
        didSet {
            clickPlayer?.volume = soundVolume
            pagKickPlayer?.volume = soundVolume
        }
    }
    
    private init() {
        setupAudioPlayers()
        loadSettings()
    }
    
    private func setupAudioPlayers() {
        // Настройка фоновой музыки
        if let url = Bundle.main.url(forResource: "backgroundMusic", withExtension: "wav") {
            backgroundPlayer = try? AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = -1 // Бесконечное воспроизведение
            backgroundPlayer?.prepareToPlay()
            backgroundPlayer?.volume = backgroundVolume // Установка начальной громкости
        }
        
        // Настройка звука клика
        if let url = Bundle.main.url(forResource: "clickSound", withExtension: "wav") {
            clickPlayer = try? AVAudioPlayer(contentsOf: url)
            clickPlayer?.prepareToPlay()
            clickPlayer?.volume = soundVolume // Установка начальной громкости
        }
        
        if let url = Bundle.main.url(forResource: "pinKickedSound", withExtension: "wav") {
            pagKickPlayer = try? AVAudioPlayer(contentsOf: url)
            pagKickPlayer?.prepareToPlay()
            pagKickPlayer?.volume = soundVolume // Установка начальной громкости
        }
    }
    
    func playClickSound() {
        guard isSoundEnabled else { return }
        clickPlayer?.play()
    }
    
    func playpinKickedSound() {
        guard isSoundEnabled else { return }
        pagKickPlayer?.play()
    }
    
    func playBackgroundMusic() {
        guard isSoundEnabled else { return }
        if backgroundPlayer?.isPlaying == false {
            backgroundPlayer?.play()
        }
    }
    
    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
    }
    
    func vibrate() {
        guard isVibrationEnabled else { return }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func loadSettings() {
           // Загрузка громкости звука
           if let soundVolume = UserDefaults.standard.value(forKey: "soundVolume") as? Float {
               self.soundVolume = soundVolume
           }
           if let backgroundVolume = UserDefaults.standard.value(forKey: "backgroundVolume") as? Float {
               self.backgroundVolume = backgroundVolume
           }
    }
    
}
