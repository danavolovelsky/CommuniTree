import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // FetchRequest for Community entities sorted by name
    @FetchRequest(
        entity: Community.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Community.name, ascending: true)]
    ) private var communities: FetchedResults<Community>
    
    var user: User
    @State private var searchText: String = ""
    @State private var showBurgerMenu = false
    @State private var showSortingOptions = false
    @State private var showAddPost = false
    @State private var selectedCommunity: Community? = nil
    @State private var mainList: [String] = ["Main", "Advice", "Housing"]
    @State private var selectedPostForComments: Post?
    @State private var showProfileView = false
    @State private var showOtherProfileView = false
    @State private var selectedUser: User?
    @State private var selectedSortOption: SortOption = .date
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        VStack {
            // Link to open burger menu, search bar, Sorting
            HeaderView(showBurgerMenu: $showBurgerMenu, searchText: $searchText, showSorting: $showSortingOptions)
            
            // Main list display
            CommunityListView(mainList: $mainList, selectedCommunity: $selectedCommunity, communities: Array(communities))
            
            // Display selected community or prompt to select one
            if let selectedCommunity = selectedCommunity {
                List {
                    // Loop through filtered posts in the selected community
                    ForEach(sortedPosts(filteredPosts(selectedCommunity.postsArray))) { post in
                                            // Custom view to display post details
                                            PostView(post: post, user: user, selectedUser: $selectedUser, showProfileView: $showProfileView, showOtherProfileView: $showOtherProfileView, selectedPostForComments: $selectedPostForComments)
                                        }
                                        .buttonStyle(PlainButtonStyle()) // Ensure only the buttons handle taps
                                    }
            }
            Spacer()
            
            HStack {
                Spacer()
                
                // Add Post Button
                Button(action: {
                    showAddPost.toggle()
                }) {
                    Image(systemName: "plus.square.fill.on.square.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .padding()
                // Logic to upload posts
                .sheet(isPresented: $showAddPost) {
                    AddPostView(selectedCommunity: $selectedCommunity, user: .constant(user))
                        .environment(\.managedObjectContext, viewContext)
                }
                
                // Sheet for Burger Menu
                .sheet(isPresented: $showBurgerMenu) {
                    BurgerMenuView(mainList: $mainList)
                        .environment(\.managedObjectContext, viewContext)
                }
                // Sheet for Sorting Options
                .sheet(isPresented: $showSortingOptions) {
                    SortingView(selectedSortOption: $selectedSortOption)
                }
                // Sheet for Comments View
                .sheet(item: $selectedPostForComments, onDismiss: {
                    // Reset the selected post for comments when the sheet is dismissed
                    selectedPostForComments = nil
                    print("CommentsView dismissed")
                }) { post in
                    CommentsView(post: post, loggedInUser: user)
                        .environment(\.managedObjectContext, viewContext)
                }
                // Sheet for Profile View and Other Profile View (when clicked on user)
                .sheet(item: $selectedUser) { user in
                    if user == self.user {
                        ProfileView(user: user)
                    } else {
                        OtherProfileView(user: user, loggedInUser: self.user)
                    }
                }
                .onAppear {
                    // Set the initial selected community to the first item in mainList
                    if selectedCommunity == nil, let firstCommunityName = mainList.first, let community = communities.first(where: { $0.name == firstCommunityName }) {
                        selectedCommunity = community
                        print("Initial community: \(selectedCommunity?.name ?? "fail")")
                    }
                }
                // Reference: https://www.hackingwithswift.com/books/ios-swiftui/responding-to-state-changes-using-onchange
                .onChange(of:selectedCommunity) { newCommunity in
                    if let community = newCommunity {
                    }
                }
            }
        }
    }
    // Filter posts based on search text
        private func filteredPosts(_ posts: [Post]) -> [Post] {
            if searchText.isEmpty {
                return posts
            } else {
                return posts.filter { post in
                    post.title?.contains(searchText) == true || post.content?.contains(searchText) == true
                }
            }
        }
    
    // Sort posts based on selected sort option
    private func sortedPosts(_ posts: [Post]) -> [Post] {
        switch selectedSortOption {
        case .date:
            return posts.sorted { ($0.timestamp ?? "") > ($1.timestamp ?? "") }
        case .likes:
            return posts.sorted { $0.likes > $1.likes }
        }
    }

    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            let context = CoreDataStack.preview.persistentContainer.viewContext
            
            return NavigationStack {
                HomeView(user: User(context: context))
                    .environment(\.managedObjectContext, context)
            }
        }
    }
}

// Reference: https://sarunw.com/posts/swiftui-picker-enum/#:~:text=askToJoin%2C%20.automatic%5D-,Identifiable,the%20members%20must%20be%20Identifiable%20.&text=We%20can%20make%20an%20enum,uniquely%20identifies%20each%20enum%20case.

 // ChatGPT OpenAI 4 (2024): Told me to look into enum and explained logic a little about it and sorting

enum SortOption: String, CaseIterable, Identifiable {
    case date = "Date"
    case likes = "Likes"
    
    var id: String { self.rawValue }
}


