import SwiftUI

struct NameInputView: View {
    @Binding var name: Name // Binding to a Name object to reflect changes
    var onContinue: () -> Void // Handle continue action
    
    var body: some View {
        ZStack {
            // Background
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Question text
                Text("What’s your Name?")
                    .font(Font.custom("Merriweather-Regular", size: 34).weight(.bold))
                    .lineSpacing(44.80)
                    .foregroundColor(.black)
                    .padding(.top, 90)
                    .padding(.bottom, 40)
                    .position(x: 215, y: 100) // Fixed position
                
                // Input fields
                VStack(spacing: 20) {
                    TextField("First Name", text: $name.firstName)
                        .font(Font.custom("Poppins-Regular", size: 22))
                        .lineSpacing(33.60)
                        .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                        .padding(.horizontal, 20)
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(Color(red: 0.1137, green: 0.4, blue: 0.2)),
                                alignment: .bottom // Coral color
                        )
                    
                    TextField("Last Name", text: $name.lastName)
                        .font(Font.custom("Poppins-Regular", size: 22))
                        .lineSpacing(33.60)
                        .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                        .padding(.horizontal, 20)
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(Color(red: 0.1137, green: 0.4, blue: 0.2)), alignment: .bottom // Coral color
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

struct NameInputView_Previews: PreviewProvider {
    static var previews: some View {
        NameInputView(name: .constant(Name(firstName: "First Name", lastName: "Last Name")), onContinue: {})
    }
}






