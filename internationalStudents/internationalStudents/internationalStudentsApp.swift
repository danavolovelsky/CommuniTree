import SwiftUI

// Main page
@main
struct internationalStudentsApp: App {
    // Shared instance of CoreDataStack 
    let coreDataStack = CoreDataStack.shared
    // Instance of ChatDataModel (can be found in CoreDataStack file too)
    let chatData = ChatDataModel()

    init() {
        initializeCommunities() // Initialize community data (can be found in CoreDataStack file too)
    }

    var body: some Scene {
        WindowGroup {
            // Wrap NavigationView
            NavigationView {
                LogInView()
                // Add Core Data managed object context to the environment
                    .environment(\.managedObjectContext, coreDataStack.persistentContainer.viewContext)
                // Add Chat data model to the environment
                    .environmentObject(chatData)
            }        }
    }
}
