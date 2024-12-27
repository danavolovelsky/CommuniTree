import CoreData

/* Reference:
 https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack
 Class for Core Data Stack setup & Usage in Preview
 https://stackoverflow.com/questions/52240107/correct-way-to-deal-with-persistentcontainer-instance-on-appdelegate
 SaveContext function
 */
class CoreDataStack {
    // Instance to access the CoreDataStack
    static let shared = CoreDataStack()

    // Persistent container to manage Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        // Initialize the container with the name of the data model
        let container = NSPersistentContainer(name: "UserDataModel")
        // Load the persistent stores and handle errors
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error")
            }
        }
        return container
    }()
    
    // Private initializer to prevent creating multiple instances
    private init() {}
    
    // Preview instance
    static var preview: CoreDataStack = {
        let instance = CoreDataStack()
        let viewContext = instance.persistentContainer.viewContext
        
        return instance
    }()
    
    // Adds a new community to the Core Data context
    func addCommunity(name: String) {
        let context = persistentContainer.viewContext
        // Create new Community entity
        let community = Community(context: context)
        community.name = name
        // Save changes to the context
        saveContext()
    }

    // Saves any changes in the context to the persistent store
    func saveContext() {
        let context = persistentContainer.viewContext
        // Check if there are any changes in the context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error")
            }
        }
    }
}

// Initialize Core Data with all community names
func initializeCommunities() {
    let allCommunities = [
        "First Year", "Second Year", "Third Year", "Computer Science", "Fashion",
        "UAL", "KCL", "UCL", "Imperial", "Marketing", "Finance", "Football",
        "Restaurants", "Pilates", "Yoga", "Visa", "Main", "Advice", "Housing"
    ]

    /* Reference:
     https://medium.com/@abhinay.mca09/core-data-in-swiftui-05be36411383
     https://stackoverflow.com/questions/38387125/how-do-i-make-a-fetch-request-using-nsmanagedobjects-new-fetchrequest-function
     */
    let context = CoreDataStack.shared.persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<Community> = Community.fetchRequest()
    
    do {
        // Fetch existing communities from persistent store
        let existingCommunities = try context.fetch(fetchRequest)
        
        // Extracts names and converts them into a set
        // Prevents adding duplicate communities, if the initialization function is called multiple times
        // Reference: Line snippet from ChatGPT OpenAI 4.0 (June 2024)
        let existingNames = Set(existingCommunities.compactMap { $0.name })
        
        // Iterate through all community names
        for name in allCommunities where !existingNames.contains(name) {
            // Add communities that do not already exist
            CoreDataStack.shared.addCommunity(name: name)
        }
    } catch {
        print("Failed")
    }
}

// ObservableObject to manage chat data
class ChatDataModel: ObservableObject {
    //Reference: https://stackoverflow.com/questions/44609216/dictionaries-string-string-in-swift
    // Dictionary to store messages for each chat identified by chatID
    // The key is the chatID (String) and the value is an array of messages (String)
    @Published var messages: [String: [String]] = [:]
        
    // Function takes parameter message, chatID
    func addMessage(_ message: String, to chatID: String) {
        // Default value of empty array
        messages[chatID, default: []].append(message)
    }
    
    // Returns: An array of messages (String) for the specified chatID
    // If there are no messages for the chatID, an empty array is returned
    func getMessages(for chatID: String) -> [String] {
        messages[chatID, default: []]
    }
}


