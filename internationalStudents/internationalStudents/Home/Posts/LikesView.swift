import SwiftUI
import CoreData

struct LikesView: View {
    @ObservedObject var post: Post // Keep track of changes to post object
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        Button(action: {
            likePost()
        }) {
            HStack {
                Image(systemName: "heart.fill")
                Text("\(post.likes)")
            }
            .contentShape(Rectangle()) // only the button is clickable
        }
    }

    private func likePost() {
        post.likes += 1
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
