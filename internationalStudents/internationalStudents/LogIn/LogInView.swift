// Login page
// Authenticating user by email and password
import SwiftUI
import CoreData

struct LogInView: View {
    // Access CoreData context from the environment
    @Environment(\.managedObjectContext) private var managedObjectContext
    // Fetch request to get User entities from CoreData
    @FetchRequest(sortDescriptors: []) private var users: FetchedResults<User>
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 50) {
                    Spacer()
                    Spacer()
                    
                    // Logo image
                    Image("mainLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                    
                    Spacer()
                    
                    // VStack for email and password fields with adjusted padding
                    VStack {
                        VStack {
                            // Email TextField
                            HStack {
                                TextField("Email", text: $email)
                                    .font(Font.custom("Poppins", size: 14))
                                    .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                                    .padding(.leading, 10)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(red: 0.1137, green: 0.4, blue: 0.2), lineWidth: 1)
                            )
                            
                            // Password SecureField
                            HStack {
                                SecureField("Password", text: $password)
                                    .font(Font.custom("Poppins", size: 14))
                                    .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
                                    .padding(.leading, 10)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(red: 0.1137, green: 0.4, blue: 0.2), lineWidth: 1)
                            )
                        }
                        .padding(.top, -30) // Adjust this value to move the fields higher
                        
                        VStack(alignment: .leading, spacing: 16) {
                            // Log In button
                            Button(action: {
                                // Validate login when the button is pressed
                                validateLogin(email: email, password: password) { success, user in
                                    if success, let user = user {
                                        self.isLoggedIn = true
                                        saveLoggedInUser(user: user)
                                    }
                                }
                            }) {
                                Text("Log In")
                                    .font(Font.custom("Poppins", size: 14))
                                    .lineSpacing(19.60)
                                    .foregroundColor(Color.white)
                            }
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                            .background(Color(red: 0.1137, green: 0.4, blue: 0.2))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .inset(by: 1)
                                    .stroke(Color(red: 0.1137, green: 0.4, blue: 0.2), lineWidth: 1)
                            )
                            
                            // Navigation link to Navigation->Homepage if loggedin
                            .background(NavigationLink(destination: Navigation(), isActive: $isLoggedIn) {
                            })
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 100, trailing: 24))
                
                // Navigation link to the SignUpView
                HStack {
                    Spacer()
                    NavigationLink(destination: SignUpView()) {
                        Text("Don’t have an account? Sign up")
                            .font(Font.custom("Poppins", size: 14))
                            .lineSpacing(19.60)
                            .foregroundColor(.black)
                            .padding([.bottom, .trailing], 40)
                            .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
    }
    
    /* Reference: https://stackoverflow.com/questions/53912575/completion-handler-and-if-statement-within
     */
    // Check login data
    func validateLogin(email: String, password: String, completion: @escaping (Bool, User?) -> Void) {
        let user = fetchUserByEmail(email: email)
        if let user = user, user.password == password {
            completion(true, user)
        } else {
            completion(false, nil)
        }
    }

    // Save the logged-in user's data
    func saveLoggedInUser(user: User) {
        UserDefaults.standard.set(user.email, forKey: "loggedInUserEmail")
    }

    /* Reference: https://www.hackingwithswift.com/quick-start/swiftui/how-to-filter-core-data-fetch-requests-using-a-predicate
        https://www.hackingwithswift.com/books/ios-swiftui/filtering-fetchrequest-using-nspredicate
     */

    // Function to fetch a user by email from CoreData
    func fetchUserByEmail(email: String) -> User? {
        // Create a fetch request for the User entity, based on email
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let users = try managedObjectContext.fetch(fetchRequest)
            return users.first
        } catch {
            return nil
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
            .environment(\.managedObjectContext, CoreDataStack.preview.persistentContainer.viewContext)
    }
}
