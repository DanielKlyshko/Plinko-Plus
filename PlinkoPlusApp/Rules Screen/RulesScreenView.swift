import SwiftUI

struct RulesScreenView: View {
    
    @EnvironmentObject var soundManager: SoundManager
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            backgroundImage
            
            VStack {
                headerView
                titleView
                rulesContent
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var backgroundImage: some View {
        Image("AppBackground")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
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
    
    private var titleView: some View {
        Text("RULES")
            .font(.custom("Fredoka-Bold", size: 26))
            .foregroundColor(.white)
            .padding(.top, -20)
    }
    
    private var rulesContent: some View {
        VStack(spacing: 10) {
            rulesSection(title: "What is Plinko Plus?", content: "Launch the ball onto the game board, and it will fall through obstacles into one of the slots — either a bonus or penalty slot. Depending on where the ball lands, you will either win or lose points.", height: 180)
            
            rulesSection(title: "How to start Game?", content: "Press PLAY button on the main screen and then START GAME button to launch the ball.", height: 120)
            
            slotTypesSection
        }
    }
    
    private func rulesSection(title: String, content: String, height: CGFloat) -> some View {
        ZStack {
            backgroundRoundedRectangle(height: height)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.custom("Fredoka-Bold", size: 26))
                    .foregroundColor(.white)
                
                Text(content)
                    .font(.custom("Roboto-Bold", size: 16))
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
    
    private var slotTypesSection: some View {
        ZStack {
            backgroundRoundedRectangle(height: 160)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Slot Types")
                    .font(.custom("Fredoka-Bold", size: 26))
                    .foregroundColor(.white)
                    .padding(.leading, 5)
                
                VStack(alignment: .leading, spacing: 10) {
                    slotTypeItem(symbol: "•", description: "Penalty Slots: Have a multiplier less than one, causing you to lose points.")
                    slotTypeItem(symbol: "•", description: "Bonus Slots: Have a multiplier greater than one, resulting in a win.")
                }
                .padding(.leading, 5)
            }
            .padding()
        }
    }
    
    private func slotTypeItem(symbol: String, description: String) -> some View {
        HStack {
            Text(symbol)
                .font(.custom("Roboto-Bold", size: 16))
                .foregroundColor(.white)
            Text(description)
                .font(.custom("Roboto-Bold", size: 16))
                .foregroundColor(.white)
        }
    }
    
    private func backgroundRoundedRectangle(height: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color(red: 139/255, green: 75/255, blue: 25/255), lineWidth: 6)
                .frame(width: 350, height: height)
                .offset(y: 3)
            
            RoundedRectangle(cornerRadius: 40)
                .frame(width: 360, height: height)
                .foregroundStyle(gradientBackground)
        }
    }
    
    private var gradientBackground: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 1, green: 191/255, blue: 0),
                Color(red: 1, green: 114/255, blue: 7/255)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#Preview {
    RulesScreenView()
}
