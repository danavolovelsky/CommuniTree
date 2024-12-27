import SwiftUI

struct NewGroupView: View {
    var user: User?
    @State private var searchText: String = ""
    @Binding var activeChats: [User]
    @State private var groupName: String = ""
    @State private var selectedFriends: Set<User> = []
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Header with back button and title
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left.circle")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding()
                
                Text("New Group")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .padding(.top)

            // Search bar for friends
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
                .padding(.top, 10)
            
            // Group name input
            HStack {
                Spacer()
                Text("Group Name:")
                TextField("...", text: $groupName)
                    .font(.headline)
                    .padding(.horizontal, 10)
            }
            .padding(.top, 10)

            // List of friends to select from
            if let user = user {
                List {// Checks searchbarSort friends alphabetically: .sorted(by: { $0.name ?? "" < $1.name ?? "" }) -> how each friend should be displayed
                    ForEach(user.friendsArray.filter { searchText.isEmpty ? true : $0.name?.contains(searchText) ?? false }.sorted(by: { $0.name ?? "" < $1.name ?? "" }), id: \.self) { friend in
                        HStack {
                            // Select or remove friends
                            Button(action: {
                                if selectedFriends.contains(friend) {
                                    selectedFriends.remove(friend)
                                } else {
                                    selectedFriends.insert(friend)
                                }
                            }) {
                                // Fill circle if selected otheerwise empty circle
                                Image(systemName: selectedFriends.contains(friend) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedFriends.contains(friend) ? .blue : .gray)
                            }
                            .buttonStyle(PlainButtonStyle())

                            // Display friends data (picture and name)
                            if let imageData = friend.profilePicture, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                            Text(friend.name ?? "None")
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                    }
                }
            }

            // Button to create a new group
            Button(action: {
                if let context = user?.managedObjectContext {
                    let newGroup = User(context: context)
                    newGroup.name = groupName
                    newGroup.profilePicture = UIImage(systemName: "person.3.fill")?.pngData()
                    activeChats.append(newGroup)
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Create Group")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}





