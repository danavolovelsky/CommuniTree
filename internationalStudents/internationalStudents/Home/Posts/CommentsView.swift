import SwiftUI
import CoreData

struct CommentsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var post: Post
    @State private var commentText: String = "" // Holds comment text content
    var loggedInUser: User
    @State private var selectedUser: User?
    @State private var showProfileView = false

    var body: some View {
        VStack {
            List {
                // Iterate through the comments of the post
                ForEach(post.commentsArray) { comment in
                    Button(action: {
                        // Visit user profiles
                        if let user = comment.user {
                            if user == loggedInUser {
                                showProfileView = true
                            } else {
                                selectedUser = user
                            }
                        }
                    }) {
                        // Display user picture and name
                        VStack(alignment: .leading) {
                            HStack {
                                if let imageData = comment.user?.profilePicture, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                }
                                Text(comment.user?.name ?? "Unknown")
                                    .font(.headline)
                            }
                            // Display comment text
                            Text(comment.text ?? "")
                                .font(.subheadline)
                            // Display timestamp
                            Text(comment.timeStamp?.formatted() ?? "")
                                .font(.caption)
                        }
                    }
                }
            }
            // TextField for adding a new comment
            TextField("Add a comment...", text: $commentText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

            // Button to add comment
            Button(action: {
                addComment()
            }) {
                Text("Add Comment")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            print("CommentsView is shown")
        }
        // Open other/profile view
        .sheet(isPresented: $showProfileView) {
            ProfileView(user: loggedInUser)
        }
        .sheet(item: $selectedUser) { user in
            OtherProfileView(user: user, loggedInUser: loggedInUser)
        }
    }

    // Function to add comments
    private func addComment() {
        let newComment = Comment(context: viewContext) // Create a newComment object in the context
        newComment.text = commentText
        newComment.timeStamp = Date()
        newComment.user = loggedInUser // Comment is written by the loggedin user
        newComment.post = post // Comment is under the specific post

        post.addToComments(newComment) // Add the new comment to the post's comments
        saveContext()
        commentText = "" // Clear Textfield
    }

    // Save context
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed")
        }
    }
}
