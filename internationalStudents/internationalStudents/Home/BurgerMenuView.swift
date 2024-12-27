import SwiftUI
import CoreData

struct BurgerMenuView: View {
    @Binding var mainList: [String]     
    @State private var searchText: String = ""
    @State private var secondaryList: [String] = [] // List of communities not in the main list

    // Reference: https://forums.developer.apple.com/forums/thread/659042
    // FetchRequest for Community entities sorted by name
    @FetchRequest(
        entity: Community.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Community.name, ascending: true)]
    ) private var communities: FetchedResults<Community>
    
    // Initializer to bind the main list
    // Two way data flow between child and parent
    init(mainList: Binding<[String]>) {
        self._mainList = mainList
    }

    // Load communities into the secondary list that aren't in the main list
    private func loadSecondaryList() {
        let allCommunities = communities.map { $0.name ?? "" } // Get all community names
        secondaryList = allCommunities.filter { !mainList.contains($0) }.removingDuplicates() // Filter out main list communities and remove duplicates
    }

    // Reference: https://stackoverflow.com/questions/69485653/case-insensitive-search-swiftui-ios15
    // Filter secondary text based on search bar
    var filteredList: [String] {
        searchText.isEmpty ? secondaryList : secondaryList.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack {
            Text("Communities")
                .font(.largeTitle)
                .padding()

            // List of main communities
            List(mainList, id: \.self) { item in
                HStack {
                    Text(item)
                    Spacer()
                    //Remove item -> Moves to secondary list
                    Button(action: { removeItem(item) }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }

            // Search bar to filter secondary list
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

            // List of secondary communities
            List(filteredList, id: \.self) { item in
                HStack {
                    Text(item)
                    Spacer()
                    // Move item to main list
                    Button(action: { addItem(item) }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .onAppear(perform: loadSecondaryList) // Load secondary list when the view appears
    }

    // Removes an item from the main list and adds it to the secondary list
    private func removeItem(_ item: String) {
        if let index = mainList.firstIndex(of: item) {
            mainList.remove(at: index) // Remove item from main list
            if !secondaryList.contains(item) {
                secondaryList.append(item) // Add item to secondary list if not already present
            }
        }
    }

    // Finds item index in secondary list and removes
    private func addItem(_ item: String) {
        // Reference: https://developer.apple.com/documentation/swift/array/firstindex(of:)
        if let index = secondaryList.firstIndex(of: item) {
            secondaryList.remove(at: index) // Remove item from secondary list
            mainList.append(item) // Add item to main list
        }
    }
}

// Reference: https://gist.github.com/danilovdev/9dcc4b01a229fa29e975c3a2d5e36423
// Extension to remove duplicates from an array
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted } // Filter out duplicates
    }
}

struct BurgerMenuView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample main list for the preview
        BurgerMenuView(mainList: .constant(["Main", "Recommendations", "Housing"]))
            .environment(\.managedObjectContext, CoreDataStack.shared.persistentContainer.viewContext)
    }
}





