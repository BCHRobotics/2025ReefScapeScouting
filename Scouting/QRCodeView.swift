import SwiftUI
import CoreImage.CIFilterBuiltins
import UIKit

struct QRCodeView: View {
    // Bindings to the data passed from ContentView
    @Binding var matchNumber: String
    @Binding var teamNumber: String
    @Binding var scouterInitials: String
    @Binding var selectedAlliancePosition: String
    @Binding var comments: String
    
    @Binding var robotLeftStartingLine: Bool
    @Binding var autoCoral1: Int
    @Binding var autoCoral2: Int
    @Binding var autoCoral3: Int
    @Binding var autoCoral4: Int
    @Binding var processorScoreAuto: Int
    
    @Binding var knockedOffAlgae: Bool
    @Binding var teleopCoral1: Int
    @Binding var teleopCoral2: Int
    @Binding var teleopCoral3: Int
    @Binding var teleopCoral4: Int
    @Binding var processorScoreTeleop: Int
    
    @Binding var endgameStatus: String
    @Binding var stoppedOpponents: String
    @Binding var impededOpponents: String
    @Binding var didntStopOpponents: String
    
    @State private var qrCodeImage: UIImage? = nil
    @State private var summaryText: String = ""
    @State private var showingQRCode = false  // State to control showing the QR code sheet
    
    var body: some View {
        VStack(spacing: 20) {
            // Heading
            Text("QR Code Summary")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            // Display summarized stats
            ScrollView {
                Text(summaryText)  // Display the summarized stats as text
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
            }
            
            // Button to regenerate QR code
            Button("Generate QR Code") {
                generateQRCode()
                showingQRCode = true  // Show the QR code sheet when the button is tapped
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.headline)
        }
        .padding()
        .onAppear {
            generateQRCode()  // Automatically generate the QR code when the view appears
        }
        .sheet(isPresented: $showingQRCode) {
            // Show QR Code in a modal sheet
            VStack {
                if let qrCodeImage = qrCodeImage {
                    Text("Match Number: \(matchNumber)")
                    Image(uiImage: qrCodeImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .padding()
                } else {
                    Text("QR Code will appear here.")
                        .padding()
                }
                
                Button("Close") {
                    showingQRCode = false  // Close the sheet when tapped
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
                .font(.headline)
            }
            .padding()
        }
    }
    
    // Function to generate the QR code
    func generateQRCode() {
        let combinedData = """
        Match: \(matchNumber), Team: \(teamNumber), Scouter: \(scouterInitials)
        Alliance: \(selectedAlliancePosition)
        
        
        Auto: \(robotLeftStartingLine ? "Left Line" : "Didn't Start") 
        Auto Corals: \(autoCoral1), \(autoCoral2), \(autoCoral3), \(autoCoral4)
        Auto Score: \(processorScoreAuto)
        
        Teleop: Algae: \(knockedOffAlgae ? "Yes" : "No")
        Teleop Corals: \(teleopCoral1), \(teleopCoral2), \(teleopCoral3), \(teleopCoral4)
        Teleop Score: \(processorScoreTeleop)
        
        Defence/Endgame: \(endgameStatus), Stopped: \(stoppedOpponents), Impeded: \(impededOpponents),
        Didn't Stop: \(didntStopOpponents)
        Comments: \(comments)
        """
        
        // Save the summary to display it
        summaryText = combinedData
        
        // Convert the data to generate QR Code
        if let data = combinedData.data(using: .utf8) {
            let filter = CIFilter.qrCodeGenerator()
            filter.setValue(data, forKey: "inputMessage")
            
            if let outputImage = filter.outputImage {
                let context = CIContext()
                if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                    let uiImage = UIImage(cgImage: cgImage)
                    qrCodeImage = uiImage
                }
            }
        }
    }
}
