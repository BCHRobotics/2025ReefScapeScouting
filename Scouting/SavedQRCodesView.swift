import SwiftUI

struct SavedQRCodesView: View {
    @State private var savedQRCodes: [URL] = []
    @State private var selectedQRCodes: Set<URL> = []
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                if savedQRCodes.isEmpty {
                    Text("No QR Codes Saved")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(savedQRCodes, id: \.self) { qrCodeURL in
                                QRCodeRowView(
                                    qrCodeURL: qrCodeURL,
                                    isSelected: selectedQRCodes.contains(qrCodeURL)
                                )
                                .onTapGesture {
                                    toggleSelection(qrCodeURL)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .principal) {
                                   Text("My QR Codes")
                                       .font(.headline)
                                       .lineLimit(1)
                               }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Delete") {
                        deleteSelectedQRCodes()
                    }
                    .foregroundColor(.red)
                    .disabled(selectedQRCodes.isEmpty)
                }
            }
            .onAppear(perform: loadSavedQRCodes)
        }
    }

    func loadSavedQRCodes() {
        let documentsDirectory = getDocumentsDirectory()
        let qrCodesFolder = documentsDirectory.appendingPathComponent("QRCodes")

        let fileManager = FileManager.default
        let files = try? fileManager.contentsOfDirectory(at: qrCodesFolder, includingPropertiesForKeys: nil)
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
        let filename = url.deletingPathExtension().lastPathComponent
        let components = filename.split(separator: "_")
        return components.count > 1 ? Int(components[1]) : nil
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
        loadSavedQRCodes()
        selectedQRCodes.removeAll()
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

struct QRCodeRowView: View {
    let qrCodeURL: URL
    let isSelected: Bool

    var body: some View {
        VStack {
            if let qrImage = UIImage(contentsOfFile: qrCodeURL.path) {
                Image(uiImage: qrImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
                    .padding()

                if let matchNumber = extractMatchNumber(from: qrCodeURL) {
                    Text("Match Number: \(matchNumber)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                }
                if let teamNumber = extractTeamNumber(from: qrCodeURL) {
                                    Text("Team Number: \(teamNumber)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(.bottom, 5)
                                }
            }
        }
        .background(isSelected ? Color.blue.opacity(0.2) : Color(.secondarySystemBackground))
        .cornerRadius(10)
        .overlay(
            isSelected ? RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2) : nil
        )
        .padding(.horizontal)
    }

    func extractMatchNumber(from url: URL) -> Int? {
        let filename = url.deletingPathExtension().lastPathComponent
        let components = filename.split(separator: "_")
        return components.count > 1 ? Int(components[1]) : nil
    }
    func extractTeamNumber(from url: URL) -> Int? {
        let filename = url.deletingPathExtension().lastPathComponent
        let components = filename.split(separator: "_")
        return components.count > 2 ? Int(components[2]) : nil
    }

}
