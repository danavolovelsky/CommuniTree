import SwiftUI
import CoreData

// View for displaying a single post
struct PostView: View {
    var post: Post // The post object to be displayed
    var user: User // The current logged-in user
    
    @Binding var selectedUser: User?
    @Binding var showProfileView: Bool // Binding to show the profile view
    @Binding var showOtherProfileView: Bool
    @Binding var selectedPostForComments: Post? // Binding to the post selected for comments
    
    @State private var showComments = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // View user profile of the post creatorferenciate between own and others post
                // Dif
                Button(action: {
                    if let postUser = post.user {
                        selectedUser = postUser
                        if postUser == user {
                            showProfileView = true
                        } else {
                            showOtherProfileView = true
                        }
                    }
                }) {
                    // Display picture and name
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
                }
                Text(post.user?.name ?? "Unknown")
                    .font(.headline)
            }
            .padding(.bottom, 5)
            
            // Display post title, content, and timestamp
            Text(post.title ?? "No Title")
                .font(.headline)
            Text(post.content ?? "No Content")
                .font(.subheadline)
            Text(post.timestamp ?? "No Date")
                .font(.caption)
            
            HStack {
                // Likes button
                LikesView(post: post)
                    .padding(.trailing, 7)
                
                // Comments button
                Button(action: {
                    selectedPostForComments = post
                    // Reference: ChatGPT OpenAI 4 (June 2024)
                    //Comments content would not show up upon first click, so added the delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showComments = true
                    }
                }) {
                    Image(systemName: "bubble.left.fill")
                        .font(.title)
                }
                .padding(.trailing, 8)
                
                Spacer()
                
                // Save post button
                Button(action: {
                    savePost(post)
                }) {
                    Image(systemName: "bookmark.fill")
                        .font(.title)
                }
                .padding(.trailing, 8)
            }
        }
        .padding()
    }

    // Save post to user's saved posts
    private func savePost(_ post: Post) {
        user.addToSavedPosts(post)
        do {
            try post.managedObjectContext?.save()
            print("Post saved successfully")
        } catch {
            print("Failed")
        }
    }
}
