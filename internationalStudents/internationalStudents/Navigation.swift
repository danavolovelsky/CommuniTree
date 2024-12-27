// Manage the selected tab (navigation) and the logged-in user

import SwiftUI
import CoreData

/*Reference:
 https://www.youtube.com/watch?v=DLj9yM-zLyc
*/

struct Navigation: View {
    @State private var selection = 0
    @State private var loggedInUser: User?
    @State private var selectedChat: User?

    var body: some View {
        // Tab-based navigation
        TabView(selection: $selection) {
            // Home tab
            NavigationStack {
                if let loggedInUser = loggedInUser {
                    HomeView(user: loggedInUser) // Display HomeView if user is logged in
                }
            }
            .tabItem {
                Image(systemName: "house")
            }
            .tag(0) // Tag to identify the Home tab

                        // Chat tab
                        NavigationStack {
                            if let loggedInUser = loggedInUser {
                                ChatView(user: selectedChat ?? loggedInUser)
                            }
                        }
                        .tabItem {
                            Image(systemName: "message")
                        }
                        .tag(1)

            // Profile tab
            NavigationStack {
                if let loggedInUser = loggedInUser {
                    ProfileView(user: loggedInUser)                 }
            }
            .tabItem {
                Image(systemName: "person")
            }
            .tag(2)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Fetch the loggedin user when the view appears
            loggedInUser = fetchLoggedInUser()
        }
    }
    /* Reference:
     https://stackoverflow.com/questions/46209946/how-to-user-userdefaults-to-save-logged-in-state
     https://www.hackingwithswift.com/quick-start/swiftui/how-to-filter-core-data-fetch-requests-using-a-predicate
     https://www.hackingwithswift.com/books/ios-swiftui/filtering-fetchrequest-using-nspredicate
     */
    // Fetch loggedin user from Coredata (Same logic as in LogInView)
    private func fetchLoggedInUser() -> User? {
        // Get the email of the logged-in user from UserDefaults (set in LogInView)
        let email = UserDefaults.standard.string(forKey: "loggedInUserEmail")
        if let email = email {
            // Create a fetch request for the User entity, based on email
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "email == %@", email)
            
            do {
                // Execute the fetch request and return the first user found
                let users = try CoreDataStack.shared.persistentContainer.viewContext.fetch(fetchRequest)
                return users.first
            } catch {
                // Error message if fetch fails
                print("Failed fetching logged in user")
                return nil
            }
        }
        return nil // If no email is found in UserDefaults
    }
}

struct Navigation_Previews: PreviewProvider {
    static var previews: some View {
        Navigation()
            .environment(\.managedObjectContext, CoreDataStack.preview.persistentContainer.viewContext)
    }
}


