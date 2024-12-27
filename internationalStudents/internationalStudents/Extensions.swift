import Foundation
import CoreData

// Reference: ChatGPT OpenAI 4.0 (2024)
//On managing collections in Core Data
// Converting the NSSet to a Set<Comment> / Set<User> / Set<Post> or an empty set if nil

// Extension for Post: Array of comments sorted by timestamp
extension Post {
    var commentsArray: [Comment] {
        let set = comments as? Set<Comment> ?? []
        return set.sorted { (comment1: Comment, comment2: Comment) -> Bool in
            (comment2.timeStamp ?? Date()) < (comment1.timeStamp ?? Date()) // Sort comments by their timestamp in descending order
        }
    }
}

// Extension for User: Array of friends
extension User {
    var friendsArray: [User] {
        let set = friends as? Set<User> ?? []
        return Array(set) // Convert the set to an array
    }
}

// Extension for User: to provide an array of saved posts sorted by timestamp
extension User {
    var savedPostsArray: [Post] {
        let set = savedPosts as? Set<Post> ?? []
        return set.sorted {
            ($0.timestamp ?? "") > ($1.timestamp ?? "") // Sort posts by their timestamp in descending order
        }
    }
}

// Extension for Community: Array of posts sorted by timestamp
extension Community {
    var postsArray: [Post] {
        let set = posts as? Set<Post> ?? [] // Convert the NSSet to a Set<Post> or an empty set if nil
        return set.sorted {
            // Sort posts by their timestamp in descending order
            ($0.timestamp ?? "") > ($1.timestamp ?? "")
        }
    }
}


