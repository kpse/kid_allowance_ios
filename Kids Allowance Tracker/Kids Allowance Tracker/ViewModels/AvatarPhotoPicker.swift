import SwiftUI
import PhotosUI
import Combine

/// Photo picker for avatar selection
struct AvatarPhotoPicker: View {
    @Binding var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    
    let size: CGFloat
    
    init(selectedImage: Binding<UIImage?>, size: CGFloat = 80) {
        self._selectedImage = selectedImage
        self.size = size
    }
    
    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            ZStack(alignment: .bottomTrailing) {
                // Avatar display
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                        )
                } else {
                    // Default cat icon
                    Image(systemName: "cat.fill")
                        .font(.system(size: size * 0.5))
                        .foregroundStyle(.white)
                        .frame(width: size, height: size)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.OceanBlue, Color.Mint],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                        )
                }
                
                // Edit indicator with paw
                ZStack {
                    Circle()
                        .fill(Color.Mint)
                        .frame(width: size * 0.35, height: size * 0.35)
                    
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: size * 0.18))
                        .foregroundStyle(.white)
                }
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                .offset(x: size * 0.05, y: size * 0.05)
            }
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let newValue,
                   let data = try? await newValue.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                }
            }
        }
    }
}

/// Avatar manager to save/load avatar image
class AvatarManager: ObservableObject {
    @Published var avatarImage: UIImage?
    
    private let imageKey = "savedAvatarImage"
    private let defaults = UserDefaults.standard
    
    init() {
        loadAvatar()
    }
    
    func saveAvatar(_ image: UIImage?) {
        if let image = image,
           let data = image.jpegData(compressionQuality: 0.8) {
            defaults.set(data, forKey: imageKey)
        } else {
            defaults.removeObject(forKey: imageKey)
        }
        avatarImage = image
    }
    
    func loadAvatar() {
        if let data = defaults.data(forKey: imageKey),
           let image = UIImage(data: data) {
            avatarImage = image
        }
    }
    
    func clearAvatar() {
        defaults.removeObject(forKey: imageKey)
        avatarImage = nil
    }
}

/// Complete avatar view with editing capability
struct EditableAvatarView: View {
    @StateObject private var avatarManager = AvatarManager()
    @State private var showingActionSheet = false
    @State private var showPhotoPicker = false
    @State private var selectedItem: PhotosPickerItem?
    
    let size: CGFloat
    let showEditButton: Bool
    
    init(size: CGFloat = 80, showEditButton: Bool = true) {
        self.size = size
        self.showEditButton = showEditButton
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                // Avatar display
                if let avatarImage = avatarManager.avatarImage {
                    Image(uiImage: avatarImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 3)
                        )
                } else {
                    // Default cat icon
                    Image(systemName: "cat.fill")
                        .font(.system(size: size * 0.5))
                        .foregroundStyle(.white)
                        .frame(width: size, height: size)
                        .background(
                            Circle()
                                .fill(.white.opacity(0.2))
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        )
                }
                
                if showEditButton {
                    // Edit button with paw
                    Button {
                        showingActionSheet = true
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.Mint)
                                .frame(width: size * 0.35, height: size * 0.35)
                            
                            Image(systemName: "pawprint.fill")
                                .font(.system(size: size * 0.18))
                                .foregroundStyle(.white)
                        }
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .offset(x: size * 0.05, y: size * 0.05)
                }
            }
        }
        .confirmationDialog("Choose Avatar", isPresented: $showingActionSheet) {
            Button("Choose from Photos") {
                showPhotoPicker = true
            }
            
            if avatarManager.avatarImage != nil {
                Button("Remove Photo", role: .destructive) {
                    avatarManager.clearAvatar()
                }
            }
            
            Button("Cancel", role: .cancel) {}
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let newValue,
                   let data = try? await newValue.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    avatarManager.saveAvatar(image)
                }
            }
        }
    }
}

/// Simple avatar display (non-editable) for use in various places
struct AvatarDisplay: View {
    @StateObject private var avatarManager = AvatarManager()
    let size: CGFloat
    
    init(size: CGFloat = 60) {
        self.size = size
    }
    
    var body: some View {
        Group {
            if let avatarImage = avatarManager.avatarImage {
                Image(uiImage: avatarImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Image(systemName: "cat.fill")
                    .font(.system(size: size * 0.5))
                    .foregroundStyle(.white)
                    .frame(width: size, height: size)
                    .background(
                        Circle()
                            .fill(.white.opacity(0.2))
                    )
            }
        }
    }
}

#Preview("Avatar Photo Picker") {
    VStack(spacing: 40) {
        Text("Choose Your Avatar 🐱")
            .font(.title.bold())
        
        EditableAvatarView(size: 100)
        
        Text("Tap the paw to choose a photo!")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
        LinearGradient(
            colors: [Color.Sky, Color.OceanBlue],
            startPoint: .top,
            endPoint: .bottom
        )
    )
}

#Preview("Different Sizes") {
    VStack(spacing: 30) {
        Text("Avatar Sizes")
            .font(.title2.bold())
        
        HStack(spacing: 20) {
            VStack {
                AvatarDisplay(size: 50)
                Text("Small")
                    .font(.caption)
            }
            
            VStack {
                AvatarDisplay(size: 70)
                Text("Medium")
                    .font(.caption)
            }
            
            VStack {
                AvatarDisplay(size: 100)
                Text("Large")
                    .font(.caption)
            }
        }
        
        Divider()
        
        VStack(spacing: 20) {
            Text("Editable Version")
                .font(.headline)
            
            EditableAvatarView(size: 80)
        }
    }
    .padding()
}

#Preview("In Header Context") {
    ZStack {
        LinearGradient(
            colors: [Color.Sky, Color.OceanBlue],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 12) {
                EditableAvatarView(size: 60)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hi, Jennifer!")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                    Text("Your purr-fect money tracker 🐾")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
    }
}
