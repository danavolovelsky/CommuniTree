import SwiftUI

struct HeaderView: View {
    @Binding var showBurgerMenu: Bool
    @Binding var searchText: String
    @Binding var showSorting: Bool

    var body: some View {
        HStack {
            // Burger Menu Button
            Button(action: {
                showBurgerMenu.toggle()
            }) {
                Image(systemName: "line.horizontal.3")
                    .font(.title)
                    .foregroundColor(.black)
            }

            // Search Bar
            TextField("Search...", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
                .padding(.horizontal, 10)

            Spacer()

            // Sorting Button
            Button(action: {
                showSorting.toggle()
            }) {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.title)
                    .foregroundColor(.black)
            }
        }
        .padding()
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(showBurgerMenu: .constant(false), searchText: .constant(""), showSorting: .constant(false))
    }
}
