import SwiftUI

struct CountryInputView: View {
    @Binding var selectedCountry: String
    let countries = ["United States", "Canada", "Mexico", "United Kingdom", "France", "Germany", "China", "Japan", "South Korea", "Australia"]
    
    var onContinue: () -> Void
    
    var body: some View {
        ZStack {
            // Background
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Question text
                Text("Where are you from?")
                    .font(Font.custom("Merriweather", size: 34).weight(.bold))
                    .lineSpacing(44.80)
                    .foregroundColor(.black)
                    .padding(.top, 90)
                    .padding(.bottom, 40)
                
                // Picker for countries
                Picker("Select a country", selection: $selectedCountry) {
                    ForEach(countries, id: \.self) { country in
                        Text(country).tag(country)
                    }
                }
                .font(Font.custom("Merriweather", size: 18))
                .foregroundColor(.black)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 0.1137, green: 0.4, blue: 0.2), lineWidth: 2)
                )
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    print("Continue button pressed")
                    onContinue()
                }) {
                    Image(systemName: "arrow.right.circle")
                        .font(.system(size: 60))
                        .foregroundColor(Color(red: 0.1137, green: 0.4, blue: 0.2)) // Dark green color
                }
                .padding(.bottom, 30) // Adjust as needed to align
                .offset(x: 150)
                
            }
        }
    }
    
    struct CountryInputView_Previews: PreviewProvider {
        @State static var previewCountry = "United Kingdom"
        
        static var previews: some View {
            CountryInputView(selectedCountry: $previewCountry, onContinue: {
                print("onContinue action")
            })
        }
    }
}


    

