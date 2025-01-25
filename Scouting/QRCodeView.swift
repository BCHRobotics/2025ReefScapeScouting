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
    @Binding var algeaNetAuto: Int
    
    @Binding var knockedOffAlgae: Bool
    @Binding var teleopCoral1: Int
    @Binding var teleopCoral2: Int
    @Binding var teleopCoral3: Int
    @Binding var teleopCoral4: Int
    @Binding var processorScoreTeleop: Int
    @Binding var algeaNetTeleop: Int
    
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
                VStack(alignment: .leading, spacing: 10) {
                    Text("Prematch Phase:").bold()
                    Group {
                        
                        Text("Match Number:") + Text(" \(matchNumber.isEmpty ? "null" : matchNumber)")
                        Text("Team Number:") + Text(" \(teamNumber.isEmpty ? "null" : teamNumber)")
                        Text("Scouter Initials:") + Text(" \(scouterInitials.isEmpty ? "null" : scouterInitials)")
                        Text("Alliance Position:") + Text(" \(selectedAlliancePosition.isEmpty ? "null" : selectedAlliancePosition)")
                    }

                    Text("Auto Phase:").bold()
                    Group {
                        Text("• Robot Left Starting Line:") + Text(" \(robotLeftStartingLine ? "Yes" : "No")")
                        Text("• Auto Coral Scores:") + Text(" \(autoCoral1), \(autoCoral2), \(autoCoral3), \(autoCoral4)")
                        Text("• Auto Processor Score:") + Text(" \(processorScoreAuto)")
                        Text("• Net Algae Score:") + Text(" \(algeaNetAuto)")
                    }

                    Text("Teleop Phase:").bold()
                    Group {
                        Text("• Knocked Off Algae:") + Text(" \(knockedOffAlgae ? "Yes" : "No")")
                        Text("• Teleop Coral Scores:") + Text(" \(teleopCoral1), \(teleopCoral2), \(teleopCoral3), \(teleopCoral4)")
                        Text("• Teleop Processor Score:")  + Text(" \(processorScoreTeleop)")
                        Text("• Teleop Net Algae Score:")  + Text(" \(algeaNetTeleop)")
                    }

                    Text("Endgame/Defensive Play:").bold()
                    Group {
                        Text("• Endgame Status:") + Text(" \(endgameStatus.isEmpty ? "null" : endgameStatus)")
                        Text("• Stopped Opponents:") + Text(" \(stoppedOpponents.isEmpty ? "null" : stoppedOpponents)")
                        Text("• Impeded Opponents:") + Text(" \(impededOpponents.isEmpty ? "null" : impededOpponents)")
                        Text("• Didn't Stop Opponents:") + Text(" \(didntStopOpponents.isEmpty ? "null" : didntStopOpponents)")
                    }

                    Text("Comments:").bold() + Text(" \(comments.isEmpty ? "null" : comments)")
                }
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
    
    func generateQRCode() {
        // Tab-delimited data for Excel compatibility
        let combinedData = """
           \(matchNumber.isEmpty ? "null" : matchNumber)\t\
           \(teamNumber.isEmpty ? "null" : teamNumber)\t\
           \(scouterInitials.isEmpty ? "null" : scouterInitials)\t\
           \(selectedAlliancePosition.isEmpty ? "null" : selectedAlliancePosition)\t\
           \(robotLeftStartingLine ? "1" : "0")\t\
           \(autoCoral1)\t\
           \(autoCoral2)\t\
           \(autoCoral3)\t\
           \(autoCoral4)\t\
           \(processorScoreAuto)\t\
           \(algeaNetAuto)\t\
           \(knockedOffAlgae ? "1" : "0")\t\
           \(teleopCoral1)\t\
           \(teleopCoral2)\t\
           \(teleopCoral3)\t\
           \(teleopCoral4)\t\
           \(processorScoreTeleop)\t\
           \(algeaNetTeleop)\t\
           \(endgameStatus.isEmpty ? "null" : endgameStatus)\t\
           \(stoppedOpponents.isEmpty ? "null" : stoppedOpponents)\t\
           \(impededOpponents.isEmpty ? "null" : impededOpponents)\t\
           \(didntStopOpponents.isEmpty ? "null" : didntStopOpponents)\t\
           \(comments.isEmpty ? "null" : comments)
           """
        
        // Convert the data to generate QR Code
        if let data = combinedData.data(using: .utf8) {
            let filter = CIFilter.qrCodeGenerator()
            filter.setValue(data, forKey: "inputMessage")
            
            if let outputImage = filter.outputImage {
                let context = CIContext()
                let scaleX = 500 / outputImage.extent.size.width
                let scaleY = 500 / outputImage.extent.size.height
                let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
                
                if let cgImage = context.createCGImage(transformedImage, from: transformedImage.extent) {
                    qrCodeImage = UIImage(cgImage: cgImage)
                }
            }
        }
    }
}
