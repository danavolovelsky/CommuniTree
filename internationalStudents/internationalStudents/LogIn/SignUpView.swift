// Controls which signupview page should be visible based on the currentStep and their order
// Saves User data to Coredata
// Saves loggedin user email to Userdefaults

import SwiftUI
import CoreData

// Combine name details
struct Name {
    var firstName: String
    var lastName: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

// Combine study details
struct Studies {
    var studyField: String
    var studyYear: String
    
    var studyInfo: String {
        return "\(studyField) \(studyYear)"
    }
}

struct SignUpView: View {
    
    @State private var currentStep = 1
    @State private var name = Name(firstName: "", lastName: "")
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var country: String = ""
    @State private var studies = Studies(studyField: "", studyYear: "")
    @State private var interests: String = ""
    @State private var bio: String = ""
    @State private var profilePicture: UIImage? = nil
    @State private var navigateToHome = false
    
    // Access Core Data context
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var user: User?
    
    /*Reference:
     https://stackoverflow.com/questions/73108237/swiftui-switch-statement
     */
    var body: some View {
        VStack {
            // Handle different steps of the sign-up process
            switch currentStep {
            case 1:
                NameInputView(name: $name, onContinue: { currentStep = 2 })
            case 2:
                EmailInputView(email: $email, onContinue: { currentStep = 3 })
            case 3:
                PasswordInputView(password: $password, onContinue: { currentStep = 4 })
            case 4:
                CountryInputView(selectedCountry: $country, onContinue: { currentStep = 5 })
            case 5:
                StudiesInputView(studies: $studies, onContinue: { currentStep = 6 })
            case 6:
                InterestsInputView(interests: $interests, onContinue: { currentStep = 7 })
            case 7:
                BioInputView(bio: $bio, onContinue: { currentStep = 8 })
            case 8:
                ProfilePictureInputView(profilePicture: $profilePicture, onContinue: {
                    saveUserData()
                    currentStep = 9
                })
            default:
                Text("Problem/Done")
            }
            
            // Navigation link to home screen after signup
            NavigationLink(destination: Navigation(), isActive: $navigateToHome) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Initialize user when view appears
            initializeUser()
        }
    }
    
    // Initializes new User entity
    private func initializeUser() {
        print("Initializing user")
        user = User(context: managedObjectContext)
    }
    
    // Saves user data to Core Data
    private func saveUserData() {
        guard let user = user else {
            return
        }
        user.name = name.fullName
        user.email = email
        user.password = password
        user.country = country
        user.studies = studies.studyInfo
        user.interests = interests
        user.bio = bio
        if let profilePicture = profilePicture {
            user.profilePicture = profilePicture.pngData()
        }
        
        do {
            try managedObjectContext.save()
            print("User data saved")
            saveLoggedInUser(user: user) // Automatically log in new user
            navigateToHome = true
        } catch {
            print("Didnt save user")
        }
    }
    
    /* Reference:
     https://stackoverflow.com/questions/46209946/how-to-user-userdefaults-to-save-logged-in-state
     */
    // Save logged-in user data using UserDefaults
    private func saveLoggedInUser(user: User) {
        UserDefaults.standard.set(user.email, forKey: "loggedInUserEmail")
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environment(\.managedObjectContext, CoreDataStack.preview.persistentContainer.viewContext)
    }
}
