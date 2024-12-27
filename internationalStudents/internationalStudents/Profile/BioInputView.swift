import SwiftUI

struct BioInputView: View {
    @Binding var bio: String
    var onContinue: () -> Void

    var body: some View {
        VStack(spacing: 60) {
            Spacer()
            Text("Write a short Bio!")
                .font(Font.custom("Merriweather-Regular", size: 34).weight(.bold))
                .lineSpacing(44.80)
                .foregroundColor(.black)
                .padding(.top, 90)
                .padding(.bottom, 40)
            Spacer()
            ZStack(alignment: .topLeading) {
                if bio.isEmpty {
                    Text("Hey everyone, I just moved to London and am looking to...")
                        .font(Font.custom("Poppins", size: 22))
                        .lineSpacing(33.60)
                        .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
                TextEditor(text: $bio)
                    .font(Font.custom("Poppins", size: 22))
                    .lineSpacing(33.60)
                    .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .frame(width: 300, height: 500)
                        .offset(y: -10)
                        Spacer()
                        
                        Spacer()
                    }
                    .frame(width: 430, height: 932)
                    .background(Color.white)
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: onContinue) {
                                    Image(systemName: "arrow.right.circle")
                                        .font(.system(size: 60))
                                        .foregroundColor(Color(red: 0.1137, green: 0.4, blue: 0.2)) // Coral color
                                }
                                .position(x: 365, y: 850) // Fixed position
                            }
                        }
                    )
                }
            }


struct BioInputView_Previews: PreviewProvider {
    static var previews: some View {
        BioInputView(bio: .constant("Hey, I just moved to London and am looking to..."), onContinue: {})
           
    }
}
