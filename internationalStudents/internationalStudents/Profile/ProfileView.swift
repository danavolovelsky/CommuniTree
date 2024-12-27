import CoreData
import SwiftUI

struct ProfileView: View {
    var user: User?
    @State private var showSavedPosts = false
    @State private var showFriends = false
    @State private var navigateToLogin = false // State for navigation

    var body: some View {
        VStack(alignment: .leading) {
            // Top right buttons for notifications, settings, and logout
            HStack {
                Spacer()
                Button(action: {
                    // Notification button action
                }) {
                    Image(systemName: "bell.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding(.trailing, 20)
                
                Button(action: {
                    // Settings button action
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding(.trailing, 20)
                
                Button(action: {
                    navigateToLogin = true // Set navigation state to true
                }) {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
            }
            .padding([.top, .horizontal])
            
            Spacer()
            
            // Profile information display (Picture and name)
            if let user = user {
                HStack {
                    if let imageData = user.profilePicture, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            .padding(.bottom, 10)
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                    Text(user.name ?? "fail")
                        .font(.title)
                        .padding(.leading, 10)
                    Spacer()
                }
                .padding()
                
                // Buttons for Friends and Saved Posts
                HStack {
                    Spacer()
                    VStack {
                        Button(action: {
                            showFriends.toggle() // Toggle friends view
                        }) {
                            VStack {
                                Image(systemName: "person.2.fill")
                                    .font(.title)
                                    .foregroundColor(.black)
                                Text("Friends")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            .frame(width: 150, height: 60)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                        }
                    }
                    Spacer()
                
                    VStack {
                        Button(action: {
                            showSavedPosts.toggle() // Toggle saved posts view
                        }) {
                            VStack {
                                Image(systemName: "bookmark.fill")
                                    .font(.title)
                                    .foregroundColor(.black)
                                Text("Saved")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            .frame(width: 150, height: 60)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                        }
                        
                    }
                    Spacer()
                }
                .padding(.bottom, 20)

                Group {
                    Text(user.country ?? "fail")
                        .font(.headline)
                        .padding(.bottom, 5)

                    Text(user.bio ?? "fail")
                        .font(.subheadline)
                        .padding(.bottom, 5)

                    HStack {
                        Text("Studies:")
                            .font(.headline)
                        Text(user.studies ?? "fail")
                            .font(.subheadline)
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        Text("Interests:")
                            .font(.headline)
                        Text(user.interests ?? "fail")
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
            }
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showSavedPosts) {
            if let user = user {
                SavedPostsView(user: user) // Show SavedPostsView if user is available
            }
        }
        .sheet(isPresented: $showFriends) {
            if let user = user {
                FriendsView(user: user) // Show FriendsView if user is available
            }
        }
        .fullScreenCover(isPresented: $navigateToLogin) {
            LogInView() // Present the login view
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView(user: User())
        }
    }
}

