import SwiftUI
import CoreData

struct SavedPostsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var savedPosts: [Post] = [] // Store list of saved posts
    var user: User

    var body: some View {
        VStack(alignment: .leading) {
            Text("Saved Posts")
                .font(.largeTitle)
                .padding()

            // List of saved posts
            List {
                ForEach(savedPosts) { post in // Loop through each saved post
                    VStack(alignment: .leading) {
                        HStack {
                            // Display user info
                            if let imageData = post.user?.profilePicture, let uiImage = UIImage(data: imageData) {
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
                            Text(post.user?.name ?? "None")
                                .font(.headline)
                        }
                        .padding(.bottom, 5)
                        
                        // Display post info
                        Text(post.title ?? "None")
                            .font(.headline)
                        Text(post.content ?? "None")
                            .font(.subheadline)
                        Text(post.timestamp ?? "None")
                            .font(.caption)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                removePost(post: post)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
        .onAppear {
            fetchSavedPosts() // Fetch saved posts when the view appears
        }
    }

    private func fetchSavedPosts() {
        // Fetches saved posts for current user by accessing the savedPostsArray extension,which uses Core Data to retrieve and sort the saved posts
        savedPosts = user.savedPostsArray
    }

    // Remove a post from the saved posts
    private func removePost(post: Post) {
        user.removeFromSavedPosts(post)
        do {
            try viewContext.save() 
            fetchSavedPosts() // Refresh saved posts list
        } catch {
            print("Failed")
        }
    }
}

struct SavedPostsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.persistentContainer.viewContext
        
        return NavigationStack {
            SavedPostsView(user: User(context: context)) // Pass user object with context to preview
                .environment(\.managedObjectContext, context)
        }
    }
}


