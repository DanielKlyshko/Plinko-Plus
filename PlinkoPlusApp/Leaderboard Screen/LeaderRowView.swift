import SwiftUI

struct LeaderRowView: View {
    let leader: Leader
    let rank: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 60)
                .stroke(Color(red: 139/255, green: 75/255, blue: 25/255), lineWidth: 6)
                .frame(height: 70)
                .offset(y: 3)

            RoundedRectangle(cornerRadius: 60)
                .frame(height: 70)
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
                Text("#\(rank)")
                    .font(.custom("Fredoka-Bold", size: 20))
                    .foregroundColor(.white)
                    .padding(.leading, 20)

                Text(leader.nickname)
                    .font(.custom("Fredoka-Bold", size: 20))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(leader.score)")
                    .font(.custom("Fredoka-Bold", size: 30))
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
            }
            .frame(maxWidth: .infinity, minHeight: 80)
        }
        .padding(.bottom, 5)
    }
}

