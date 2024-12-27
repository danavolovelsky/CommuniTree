import SwiftUI
import CoreData

struct AddPostView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    // Pass selected community and user from parent view
    @Binding var selectedCommunity: Community?
    @Binding var user: User?
    
    @State private var postTitle: String = ""
    @State private var postContent: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Post Title", text: $postTitle)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                TextEditor(text: $postContent)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                Spacer()
                
                // Add post button
                Button(action: {
                    savePost()
                    presentationMode.wrappedValue.dismiss() // Remove the view
                }) {
                    Text("Add Post")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }
            }
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss() // Remove view when close button is clicked
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
            })
        }
    }
    
    private func savePost() {
        // Ensure the selected community and user are not nil
        guard let selectedCommunity = selectedCommunity, let user = user else { return }
        
        // Create a new Post object and set properties
        let newPost = Post(context: viewContext)
        newPost.title = postTitle
        newPost.content = postContent
        newPost.timestamp = StringDate() // Current date
        newPost.community = selectedCommunity
        newPost.user = user

        // Save context, refresh selected community to update it
        do {
            try viewContext.save()
            viewContext.refresh(selectedCommunity, mergeChanges: true)
        } catch {
            print("Failed")
        }
    }
    
    // Format current date as a string
    private func StringDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
}

struct AddPostView_Previews: PreviewProvider {
    @State static var selectedCommunity: Community? = nil
    @State static var user: User? = nil
    static var previews: some View {
        AddPostView(selectedCommunity: $selectedCommunity, user: $user)
            .environment(\.managedObjectContext, CoreDataStack.preview.persistentContainer.viewContext)
    }
}

