import SwiftUI
import CoreImage.CIFilterBuiltins
import UIKit

struct QRCodeView: View {
    // Bindings to the data passed from ContentView
    @Binding var matchDetails: MatchDetails
    @Binding var autoData: AutoData
    @Binding var teleopData: TeleopData
    @Binding var defenceData: DefenceData
    
    @State private var qrCodeImage: UIImage? = nil
    @State private var showingQRCode = false  // State to control showing the QR code sheet
    @State private var showSaveConfirmation = false
    
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
                        Text("Match Number:") + Text(" \(matchDetails.matchNumber.isEmpty ? "null" : matchDetails.matchNumber)")
                        Text("Team Number:") + Text(" \(matchDetails.teamNumber.isEmpty ? "null" : matchDetails.teamNumber)")
                        Text("Scouter Initials:") + Text(" \(matchDetails.scouterInitials.isEmpty ? "null" : matchDetails.scouterInitials)")
                        Text("Alliance Position:") + Text(" \(matchDetails.selectedAlliancePosition.isEmpty ? "null" : matchDetails.selectedAlliancePosition)")
                    }

                    Text("Auto Phase:").bold()
                    Group {
                        Text("• Robot Left Starting Line:") + Text(" \(autoData.robotLeftStartingLine ? "Yes" : "No")")
                        Text("• Auto Coral Scores:") + Text(" \(autoData.coral1), \(autoData.coral2), \(autoData.coral3), \(autoData.coral4)")
                        Text("• Auto Processor Score:") + Text(" \(autoData.processorScore)")
                        Text("• Net Algae Score:") + Text(" \(autoData.netAlgae)")
                    }

                    Text("Teleop Phase:").bold()
                    Group {
                        Text("• Knocked Off Algae:") + Text(" \(teleopData.knockedOffAlgae ? "Yes" : "No")")
                        Text("• Teleop Coral Scores:") + Text(" \(teleopData.coral1), \(teleopData.coral2), \(teleopData.coral3), \(teleopData.coral4)")
                        Text("• Teleop Processor Score:") + Text(" \(teleopData.processorScore)")
                        Text("• Teleop Net Algae Score:") + Text(" \(teleopData.netAlgae)")
                    }

                    Text("Endgame/Defensive Play:").bold()
                    Group {
                        Text("• Endgame Status:") + Text(" \(defenceData.endgameStatus.isEmpty ? "null" : defenceData.endgameStatus)")
                        Text("• Stopped Opponents:") + Text(" \(defenceData.stoppedOpponents ? "Yes" : "No")")
                        Text("• Impeded Opponents:") + Text(" \(defenceData.impededOpponents ? "Yes" : "No")")
                        Text("• Didn't Stop Opponents:") + Text(" \(defenceData.didntStopOpponents ? "Yes" : "No")")
                    }

                    Text("Comments:").bold() + Text(" \(defenceData.comments.isEmpty ? "null" : defenceData.comments)")
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
                    Text("Match Number: \(matchDetails.matchNumber)")
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
           \(matchDetails.matchNumber.isEmpty ? "null" : matchDetails.matchNumber)\t\
           \(matchDetails.teamNumber.isEmpty ? "null" : matchDetails.teamNumber)\t\
           \(matchDetails.scouterInitials.isEmpty ? "null" : matchDetails.scouterInitials)\t\
           \(matchDetails.selectedAlliancePosition.isEmpty ? "null" : matchDetails.selectedAlliancePosition)\t\
           \(autoData.robotLeftStartingLine ? "1" : "0")\t\
           \(autoData.coral1)\t\
           \(autoData.coral2)\t\
           \(autoData.coral3)\t\
           \(autoData.coral4)\t\
           \(autoData.processorScore)\t\
           \(autoData.netAlgae)\t\
           \(teleopData.knockedOffAlgae ? "1" : "0")\t\
           \(teleopData.coral1)\t\
           \(teleopData.coral2)\t\
           \(teleopData.coral3)\t\
           \(teleopData.coral4)\t\
           \(teleopData.processorScore)\t\
           \(teleopData.netAlgae)\t\
           \(defenceData.endgameStatus.isEmpty ? "null" : defenceData.endgameStatus)\t\
           \(defenceData.stoppedOpponents ? "Yes" : "No")\t\
           \(defenceData.impededOpponents ? "Yes" : "No")\t\
           \(defenceData.didntStopOpponents ? "Yes" : "No")\t\
           \(defenceData.tippy ? "1" : "0")\t\
           \(defenceData.disabled ? "1" : "0")\t\           
           \(defenceData.comments.isEmpty ? "null" : defenceData.comments)
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
