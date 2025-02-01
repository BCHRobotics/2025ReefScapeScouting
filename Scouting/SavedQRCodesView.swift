import SwiftUI

struct SavedQRCodesView: View {
    @State private var savedQRCodes: [URL] = []
    @State private var selectedQRCodes: Set<URL> = []
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()  // Close the saved QR codes view
                }) {
                    Text("Close")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                }
                .padding(.leading)

                Text("My QR Codes")
                    .font(.system(size: 18))
                    .fontWeight(.bold) // Lighter than bold
                    .lineLimit(1) // Ensure it stays on one line
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()

                Button(action: {
                    deleteSelectedQRCodes()
                }) {
                    Text("Delete")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                }
                .padding(.trailing)
                .disabled(selectedQRCodes.isEmpty)
            }
            .padding([.top, .horizontal])

            ScrollView {
                ForEach(savedQRCodes, id: \.self) { qrCodeURL in
                    VStack {
                        if let qrImage = UIImage(contentsOfFile: qrCodeURL.path) {
                            Image(uiImage: qrImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .padding()
                            
                            // Extract the match number based on filename format: QRCode_<matchNumber>_<scouterInitials>.png
                            if let matchNumber = extractMatchNumber(from: qrCodeURL) {
                                Text("Match Number: \(matchNumber)")
                                    .font(.caption) // Smaller font size
                                    .foregroundColor(.gray)
                                    .padding([.top, .bottom], 5)
                            }
                        }
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding([.top, .bottom], 10)
                    .contentShape(Rectangle()) // Makes the entire area tappable
                    .onTapGesture {
                        toggleSelection(qrCodeURL)
                    }
                    .overlay(
                        Group {
                            if selectedQRCodes.contains(qrCodeURL) {
                                Rectangle()
                                    .strokeBorder(Color.blue, lineWidth: 2)
                                    .cornerRadius(10)
                            }
                        }
                    )
                }
            }
            .onAppear(perform: loadSavedQRCodes)
        }
        .padding()
    }

    func loadSavedQRCodes() {
        let documentsDirectory = getDocumentsDirectory()
        let qrCodesFolder = documentsDirectory.appendingPathComponent("QRCodes")

        // Get all PNG files from the "QRCodes" folder
        let fileManager = FileManager.default
        let files = try? fileManager.contentsOfDirectory(at: qrCodesFolder, includingPropertiesForKeys: nil)

        // Filter out only the PNG files (QR codes)
        savedQRCodes = files?.filter { $0.pathExtension == "png" } ?? []

        // Sort the QR codes by match number
        savedQRCodes.sort { url1, url2 in
            if let matchNumber1 = extractMatchNumber(from: url1),
               let matchNumber2 = extractMatchNumber(from: url2) {
                return matchNumber1 < matchNumber2
            }
            return false
        }
    }

    func extractMatchNumber(from url: URL) -> Int? {
        // Extract match number from the filename: QRCode_<matchNumber>_<scouterInitials>.png
        let filename = url.deletingPathExtension().lastPathComponent
        let components = filename.split(separator: "_")
        
        if components.count > 1, let matchNumber = Int(components[1]) {
            return matchNumber
        }
        
        return nil
    }

    func toggleSelection(_ qrCodeURL: URL) {
        if selectedQRCodes.contains(qrCodeURL) {
            selectedQRCodes.remove(qrCodeURL)
        } else {
            selectedQRCodes.insert(qrCodeURL)
        }
    }

    func deleteSelectedQRCodes() {
        let fileManager = FileManager.default

        for qrCodeURL in selectedQRCodes {
            do {
                try fileManager.removeItem(at: qrCodeURL)
            } catch {
                print("Error deleting QR code: \(error.localizedDescription)")
            }
        }

        // Refresh the list of saved QR codes after deletion
        loadSavedQRCodes()
        selectedQRCodes.removeAll() // Reset selected items
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
