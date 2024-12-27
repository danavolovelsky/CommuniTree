import SwiftUI
import Combine

struct InsideChatView: View {
    var user: User?
    var friend: User?
    var group: User?

    @State private var newMessage: String = ""
    @EnvironmentObject var chatData: ChatDataModel

    // ChatID based on friend or group
    var chatID: String {
        friend?.email ?? group?.email ?? "None"
    }

    var body: some View {
        VStack {
            // Display user or group info
            if let displayUser = friend ?? group {
                HStack {
                    Image(systemName: displayUser is User ? "person.crop.circle.fill" : "person.3.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text(displayUser.name ?? "Unknown")
                        .font(.headline)
                        .padding()
                }
                .padding()
            }
            // Shows List of messages
            List(chatData.getMessages(for: chatID), id: \.self) { message in
                HStack {
                    Spacer()
                    Text(message)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.trailing, 10)
                }
            }

            // Chat field below
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Button("Send") {
                    sendMessage()
                }
                .foregroundColor(.white)
                .padding(10)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .padding()
        }
        .navigationBarTitle(Text(friend?.name ?? group?.name ?? ""), displayMode: .inline)
    }
    
    //Adds message to chat
    // Emptys input field
    private func sendMessage() {
        if !newMessage.isEmpty {
            chatData.addMessage(newMessage, to: chatID)
            newMessage = ""
        }
    }
}

// Preview provider for the InsideChatView
struct InsideChatView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataStack.preview.persistentContainer.viewContext
        let chatData = ChatDataModel()
        
        return InsideChatView(user: User(context: context), friend: User(context: context))
            .environmentObject(chatData)
            .environment(\.managedObjectContext, context)
    }
}


