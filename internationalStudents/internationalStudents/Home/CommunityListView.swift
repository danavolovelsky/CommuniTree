import SwiftUI
import CoreData

struct CommunityListView: View {
    @Binding var mainList: [String] // Communities to display on homeview
    @Binding var selectedCommunity: Community? // Currently selected community
    var communities: [Community] // List of community objects

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) { // Horizontal scroll view
            HStack(spacing: 10) {
                
                ForEach(mainList, id: \.self) { item in // Loop through mainList
                    if let community = communities.first(where: { $0.name == item }) { // Check if the community exists
                        VStack {
                            Text(community.name ?? "None") // Display community name
                                .font(.headline)
                                .padding()
                        }
                        .frame(width: 120, height: 60)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                        .onTapGesture {
                            withAnimation {
                                selectedCommunity = community // Update selected community on tap
                            }
                        }
                    } else {
                        VStack {
                            Text(item) // Display item name if community not found
                                .font(.headline)
                                .padding()
                        }
                        .frame(width: 120, height: 60)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }
}

struct CommunityListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.persistentContainer.viewContext
        
        //Reference: OpenAI ChatGPT 4 Logic (June 2024)
        // Fetch communities from the context
        let fetchRequest: NSFetchRequest<Community> = Community.fetchRequest()
        let communities = (try? context.fetch(fetchRequest)) ?? []
        
        return CommunityListView(
            mainList: .constant(["Main", "Advice", "Housing"]),
            selectedCommunity: .constant(nil),
            communities: communities // Use fetched communities for preview
        )
        .environment(\.managedObjectContext, context)
    }
}

