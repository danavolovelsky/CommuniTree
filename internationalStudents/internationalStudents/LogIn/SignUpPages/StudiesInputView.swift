import SwiftUI

struct StudiesInputView: View {
    @Binding var studies: Studies
    let years = ["2024", "2025", "2026", "2027", "2028", "2029", "2030"]
    
    var onContinue: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 60) {
                Spacer()
                
                // Question
                Text("Add your study details!")
                    .font(Font.custom("Merriweather-Regular", size: 34).weight(.bold))
                    .lineSpacing(44.80)
                    .foregroundColor(.black)
                    .offset(y: 50)
                
                Spacer()
                
                // Input field for Field of Studies
                TextField("Field of Studies", text: $studies.studyField)
                    .font(Font.custom("Poppins-Regular", size: 22))
                    .lineSpacing(33.60)
                    .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                    .offset(x: 70, y: -10)
                    .overlay(
                        Rectangle()
                            .frame(width: 300, height: 2)
                            .foregroundColor(Color(red: 0.1137, green: 0.4, blue: 0.2)), alignment: .bottom
                    )
                
                // Picker for graduation year
                Picker("Select graduation year", selection: $studies.studyYear) {
                    Text("Select graduation year").tag("")
                    ForEach(years, id: \.self) { year in
                        Text(year).tag(year)
                    }
                }
                .font(Font.custom("Merriweather-Regular", size: 18))
                .foregroundColor(.black)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 0.1137, green: 0.4, blue: 0.2), lineWidth: 2)
                )
                Spacer()
            }
            .frame(width: 430, height: 932)
            .background(Color(red: 255, green:255, blue: 255))
            // Continue button
            Button(action: onContinue) {
                Image(systemName: "arrow.right.circle")
                    .font(.system(size: 60))
                    .foregroundColor(Color(red: 0.1137, green: 0.4, blue: 0.2))
            }
            .position(x: 365, y: 800) 
        }
    }
}

struct StudiesInputView_Previews: PreviewProvider {
    @State static var previewStudies = Studies(studyField: "", studyYear: "")

    static var previews: some View {
        StudiesInputView(studies: $previewStudies, onContinue: {})
    }
}

