import SwiftUI

struct ChatView: View {
    var user: User? // The logged-in user
    var friend: User? // The friend user (not used in this view)
    var group: User? // The group user (not used in this view)

    @State private var searchText: String = "" // State to hold the search text
    @State private var groupName: String = "" // State to hold the group name
    @State private var showStartChat = false // State to control the display of the start chat view
    @State private var activeChats: [User] = [] // State to hold the list of active chats

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    // Search bar
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

                    Spacer()

                    // Navigation link to the StartChatView
                    NavigationLink(destination: StartChatView(user: user, activeChats: $activeChats)) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .padding()

                HStack {
                    Text("Messages")
                        .font(.body)
                        .padding()
                    Spacer()
                }

                // List of active chats
                List {
                    ForEach(activeChats) { chat in
                        // Navigation link to InsideChatView
                        NavigationLink(destination: InsideChatView(user: user, friend: chat.name != groupName ? chat : nil, group: chat.name == groupName ? chat : nil)) {
                            HStack {
                                // Profile picture or default icon
                                if let imageData = chat.profilePicture, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                } else {
                                    Image(systemName: chat.name == groupName ? "person.3.fill" : "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                }
                                Text(chat.name ?? "Non")
                                    .font(.headline)
                                    .padding()
                            }
                            .padding()
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.persistentContainer.viewContext
        
        return NavigationStack {
            ChatView()
                .environment(\.managedObjectContext, context)
        }
    }
}


