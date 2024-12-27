import SwiftUI

struct InterestsInputView: View {
    @Binding var interests: String
    var onContinue: () -> Void

    var body: some View {
        ZStack {
            // Background
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Question text
                Text("What are your interests?")
                    .font(Font.custom("Merriweather-Regular", size: 34).weight(.bold))
                    .lineSpacing(44.80)
                    .foregroundColor(.black)
                    .position(x: 215, y: 100) // Fixed position
                
                // Input field
                TextField("Interests", text: $interests)
                    .font(Font.custom("Poppins-Regular", size: 22))
                    .lineSpacing(33.60)
                    .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                    .padding(.horizontal, 20)
                    .overlay(
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color(red: 0.1137, green: 0.4, blue: 0.2)), // Coral color
                        alignment: .bottom
                    )
                    .padding(.top, 150)
                    .position(x: 215, y: 30)
            }
            
            // Continue button
            Button(action: onContinue) {
                Image(systemName: "arrow.right.circle")
                    .font(.system(size: 60))
                    .foregroundColor(Color(red: 0.1137, green: 0.4, blue: 0.2))
            }
            .position(x: 365, y: 800) // Fixed position
        }
    }
}

struct InterestsInputView_Previews: PreviewProvider {
    static var previews: some View {
        InterestsInputView(interests: .constant("Sample Interests"), onContinue: {})
    }
}



