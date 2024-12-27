import SwiftUI

struct StartChatView: View {
    var user: User?
    @Binding var activeChats: [User] // Binding to list of active chats
    @Environment(\.presentationMode) var presentationMode

    @State private var searchText: String = "" // State to hold search text

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    
                    // Title
                    Text("Start a New Chat")
                        .font(.largeTitle)
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Closes the view
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding()
                }
                .padding(.top)

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
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                
                // Navigation link to create a new group chat
                NavigationLink(destination: NewGroupView(user: user, activeChats: $activeChats)) {
                    HStack {
                        Image(systemName: "person.3.fill")
                            .font(.title)
                            .foregroundColor(.black)
                        Text("New Group")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal, 10)
                }
                .padding(.top, 10)
                
                
                /* Reference:
                 https://stackoverflow.com/questions/61294515/how-to-filter-array-of-objects-using-search-bar-in-swiftui
                 */
                // List of friends to start a chat with
                if let user = user {
                    List {
                        // Filter friends based on the search text
                        ForEach(user.friendsArray.filter { searchText.isEmpty ? true : $0.name?.contains(searchText) ?? false }) { friend in
                            //When clicked on friend navigate to chatview
                            NavigationLink(destination: ChatView(user: user, friend: friend)) {
                                HStack {
                                    // Display profile picture or default icon
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
                                    Text(friend.name ?? "Unknown")
                                        .font(.headline)
                                }
                                .padding()
                            }
                            .onTapGesture {
                                activeChats.append(friend) // Add friend to active chats
                                presentationMode.wrappedValue.dismiss() // Remove the view
                            }
                        }
                    }
                }

                Spacer()
            }
            
        }
        .navigationBarHidden(true)
    }
}

struct StartChatView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.persistentContainer.viewContext
        
        return StartChatView(user: User(context: context), activeChats: .constant([]))
            .environment(\.managedObjectContext, context)
    }
}


