import SwiftUI

struct PasswordInputView: View {
    @Binding var password: String
    var onContinue: () -> Void

    var body: some View {
        ZStack {
            // Background
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Question text
                Text("Create a Password!")
                    .font(Font.custom("Merriweather-Regular", size: 34).weight(.bold))
                    .lineSpacing(44.80)
                    .foregroundColor(.black)
                    .padding(.top, 90)
                    .padding(.bottom, 40)
                    .position(x: 215, y: 100) // Fixed position
                
                // Input field
                VStack(spacing: 20) {
                    SecureField("Password", text: $password)
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
                }
                .padding(.top, 150) // Adjusted padding to align vertically
                .position(x: 215, y: 30)
            }
            
            // Continue button at the bottom
            Button(action: onContinue) {
                Image(systemName: "arrow.right.circle")
                    .font(.system(size: 60))
                    .foregroundColor(Color(red: 0.1137, green: 0.4, blue: 0.2)) // Dark green color
            }
            .position(x: 365, y: 800) // Fixed position
        }
    }
}

struct PasswordInputView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordInputView(password: .constant("SamplePassword"), onContinue: {})
    }
}

