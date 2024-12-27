import SwiftUI

struct SortingView: View {
    @Binding var selectedSortOption: SortOption

    var body: some View {
        VStack {
            Text("Sorting Options")
                .font(.title)
                .padding()
            // Reference: https://codewithchris.com/swiftui-picker-2023/
            Picker("Sort by:", selection: $selectedSortOption) {
                ForEach(SortOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Spacer()
        }
        .padding()
    }
}

struct SortingView_Previews: PreviewProvider {
    static var previews: some View {
        SortingView(selectedSortOption: .constant(.date))
    }
}


