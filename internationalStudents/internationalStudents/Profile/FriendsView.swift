import SwiftUI

struct FriendsView: View {
    // View should be refreshed whenever the observed object changes
    @ObservedObject var user: User // User whose friends will be displayed
    @State private var selectedFriend: User?
    @Environment(\.managedObjectContext) private var viewContext
    

    var body: some View {
        VStack {
            Text("Friends")
                .font(.largeTitle)
                .padding()

            // List of friends
            List {
                // Loop through each friend in users friends array
                ForEach(user.friendsArray) { friend in
                    // Select friend and show OtherProfile
                    Button(action: {
                        selectedFriend = friend
                    }) {
                        HStack {
                            // Display friend account (picture and name)
                            if let imageData = friend.profilePicture, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            } else {
                                // Display a placeholder image if no profile picture is available
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                            Text(friend.name ?? "None")
                                .font(.headline)
                            Spacer()
                            
                            // Friend/Unfriend Button
                            Button(action: {
                                toggleFriendStatus(for: friend)
                            }) {
                                VStack {
                                    Image(systemName: user.friendsArray.contains(friend) ? "person.fill.checkmark" : "person.fill.badge.plus")
                                        .font(.title)
                                        .foregroundColor(.black)
                                    Text(user.friendsArray.contains(friend) ? "Friend" : "Befriend")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 100, height: 60)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                            }
                        }
                        .padding()
                        .onTapGesture {
                            selectedFriend = friend
                            print("Selected friend: \(friend.name ?? "No Name")")}
                    }
                }
            }
        }
        .padding()
    // Reference: https://stackoverflow.com/questions/65779160/swiftui-sheet-is-blank-on-first-tap-but-works-correctly-afterwards
    // changing isPresented to item
    // Display OtherProfileView as a sheet
        .sheet(item: $selectedFriend) { friend in
                    OtherProfileView(user: friend, loggedInUser: user)
                }
}
    
    private func toggleFriendStatus(for friend: User) {
            if user.friendsArray.contains(friend) {
                removeFriend(friend)
            } else {
                addFriend(friend)
            }
        }

        private func addFriend(_ friend: User) {
            user.addToFriends(friend)
            saveContext()
        }

        private func removeFriend(_ friend: User) {
            user.removeFromFriends(friend)
            saveContext()
        }

        private func saveContext() {
            do {
                try viewContext.save()
            } catch {
                print("Failed")
            }
        }
    }
