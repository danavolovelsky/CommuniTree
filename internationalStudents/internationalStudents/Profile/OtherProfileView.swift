import CoreData
import SwiftUI

struct OtherProfileView: View {
    var user: User?
    var loggedInUser: User
    @State private var isFriend = false // Checks if displayed user is a friend
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        VStack(alignment: .leading) {
            if let user = user {
                HStack {
                    // Display profile picture
                    if let imageData = user.profilePicture, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            .padding(.bottom, 10)
                    } else { // Placeholder image if no profile picture
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                    // Display user name
                    Text(user.name ?? "fail")
                        .font(.title)
                        .padding(.leading, 10)
                    Spacer()
                }
                .padding()

                HStack {
                    Spacer()
                    VStack {
                        // Toggle friend status
                        Button(action: {
                            toggleFriendStatus(for: user)
                        }) {
                            VStack {
                                // Change icon depending on friend status
                                Image(systemName: isFriend ? "person.fill.checkmark" : "person.fill.badge.plus")
                                    .font(.title)
                                    .foregroundColor(.black)
                                Text(isFriend ? "Friend" : "Befriend")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            .frame(width: 340, height: 60)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                        }
                    }
                    Spacer()
                }
                .padding(.bottom, 20)

                // Display user information (like in ProfileView)
                Group {
                    Text(user.country ?? "fail")
                        .font(.headline)
                        .padding(.bottom, 5)

                    Text(user.bio ?? "fail")
                        .font(.subheadline)
                        .padding(.bottom, 5)

                    HStack {
                        Text("Studies:")
                            .font(.headline)
                        Text(user.studies ?? "fail")
                            .font(.subheadline)
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        Text("Interests:")
                            .font(.headline)
                        Text(user.interests ?? "fail")
                            .font(.subheadline)
                    }
                }
                .padding(.bottom, 10)
            }
        }
        .padding()
        .onAppear {
            /* Reference:
             https://stackoverflow.com/questions/73480387/how-to-use-contains-with-array-of-struct-in-swiftui
            */
            // Check if displayed user is already a friend
            isFriend = loggedInUser.friendsArray.contains { $0.objectID == user?.objectID }
        }
        Spacer()
    }

    // Toggle friend status of the displayed user
    private func toggleFriendStatus(for user: User) {
        // Use view context directly
        if isFriend {
            // Removes user from friends if already a friend
            loggedInUser.removeFromFriends(user)
        } else {
            // Adds user to friends if not a friend
            loggedInUser.addToFriends(user)
        }
        isFriend.toggle() // Updates friend status
        
        /* Reference:
           https://www.hackingwithswift.com/quick-start/swiftui/how-to-configure-core-data-to-work-with-swiftui
        */        
        do {
            try viewContext.save() // Save changes to the context
        } catch {
            print("Error")
        }
    }
}

#Preview {
    NavigationStack {
        OtherProfileView(user: User(), loggedInUser: User())
    }
}



