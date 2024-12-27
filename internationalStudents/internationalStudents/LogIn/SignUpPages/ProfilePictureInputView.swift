import SwiftUI
import UIKit

struct ProfilePictureInputView: View {
    @Binding var profilePicture: UIImage?
    @State private var isShowingImagePicker = false
    @State private var isSignedUp: Bool = false
    var onContinue: () -> Void

    var body: some View {
        VStack(spacing: 60) {
            Spacer()
            Text("Add a Profile picture!")
                .font(Font.custom("Merriweather-Regular", size: 34).weight(.bold))
                .lineSpacing(44.80)
                .foregroundColor(.black)
                .padding(.top, 90)
                .padding(.bottom, 40)
            Spacer()
            
            Button(action: {
                isShowingImagePicker = true
                }) {
                if let profilePicture = profilePicture {
                    Image(uiImage: profilePicture)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 300)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(red: 29 / 255, green: 102 / 255, blue: 51 / 255), lineWidth: 1))
                } else {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 100))
                        .foregroundColor(.gray)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            }
                        }
                        .frame(width: 300, height: 300)
                        .offset(y: -10)
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePicker(image: $profilePicture)
                        }

                        Spacer()
                        Spacer()
                    }
                    .frame(width: 430, height: 932)
                    .background(Color.white)
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    
                                    self.isSignedUp = true
                                    onContinue()
                                }) {
                                    Image(systemName: "arrow.right.circle")
                                        .font(.system(size: 60))
                                        .foregroundColor(Color(red: 0.1137, green: 0.4, blue: 0.2))
                                }
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 50))
                                .background(NavigationLink(destination: Navigation(), isActive: $isSignedUp) {
                                                EmptyView()
                                }
                                )
                            }
                        }
                    )
                }
            }

/* Reference:
 https://developer.apple.com/documentation/uikit/uiimagepickercontrollerdelegate/1619126-imagepickercontroller
 https://designcode.io/swiftui-advanced-handbook-imagepicker
 https://developer.apple.com/forums/thread/677454
 */
// Image picker to select profile picture
struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        // Delegate method to handle image selection
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }

    // Binding to the selected image
    @Binding var image: UIImage?

    // Create the coordinator to handle UIImagePickerControllerDelegate methods
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // Create the UIImagePickerController
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


struct ProfilePictureInputView_Previews: PreviewProvider {
    static var previews: some View {
    ProfilePictureInputView(profilePicture: .constant(nil), onContinue: {})
    }
}
