import SwiftUI

@main
struct PlinkoPlusApp: App {
    
    @StateObject private var soundManager = SoundManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                StartScreenView()
                    .environmentObject(soundManager)
            }
        }
    }
}
