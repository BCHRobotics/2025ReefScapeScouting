import SwiftUI
import CoreImage.CIFilterBuiltins
import UIKit

struct QRCodeView: View {
    @Binding var matchDetails: MatchDetails
    @Binding var autoData: AutoData
    @Binding var teleopData: TeleopData
    @Binding var defenceData: DefenceData
    
    @State private var qrCodeImage: UIImage? = nil
    @State private var showingQRCode = false
    @State private var showSaveConfirmation = false
    @State private var showSavedQRCodes = false
    @State private var saveMessage = "" // Message for the alert

    var body: some View {
        VStack(spacing: 20) {
            Text("QR Code Summary")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top)
            
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
                        Text("• Impeded Opponents:") + Text(" \(defenceData.triedToStopOpponents ? "Yes" : "No")")
                        Text("• Didn't Stop Opponents:") + Text(" \(defenceData.didntStopOpponents ? "Yes" : "No")")
                    }

                    Text("Comments:").bold() + Text(" \(defenceData.comments.isEmpty ? "null" : defenceData.comments)")
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            }

            HStack {
                Button("Generate QR Code") {
                    generateQRCode()
                    showingQRCode = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Saved QR Codes") {
                    showSavedQRCodes = true
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            generateQRCode()  // Automatically generate the QR code when the view appears
        }
        .sheet(isPresented: $showingQRCode) {
            VStack {
                if let qrCodeImage = qrCodeImage {
                    Text("Match Number: \(matchDetails.matchNumber)")
                    Text("Scouter Initials: \(matchDetails.scouterInitials)")
                    Image(uiImage: qrCodeImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .padding()
                } else {
                    Text("QR Code will appear here.")
                        .padding()
                }
                HStack {
                    Button("Save QR Code") {
                        saveQRCode()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.headline)
                    
                    Button("Close") {
                        showingQRCode = false
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.headline)
 
                }
            }
            .padding()
        }
        .sheet(isPresented: $showSavedQRCodes) {
            SavedQRCodesView()
        }
        .alert(isPresented: $showSaveConfirmation) {
            Alert(title: Text("Save Confirmation"), message: Text(saveMessage), dismissButton: .default(Text("OK")))
        }
    }

    func generateQRCode() {
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
           \(defenceData.triedToStopOpponents ? "Yes" : "No")\t\
           \(defenceData.didntStopOpponents ? "Yes" : "No")\t\
           \(defenceData.tippy ? "1" : "0")\t\
           \(defenceData.disabled ? "1" : "0")\t\           
           \(defenceData.comments.isEmpty ? "null" : defenceData.comments)
           """
        
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

    func saveQRCode() {
        guard let qrCodeImage = qrCodeImage else {
            return
        }
        
        let qrCodesFolder = getDocumentsDirectory().appendingPathComponent("QRCodes")
        do {
            try FileManager.default.createDirectory(at: qrCodesFolder, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating directory: \(error.localizedDescription)")
            return
        }
        
        let filename = "QRCode_\(matchDetails.matchNumber)_\(matchDetails.teamNumber).png"
        let url = qrCodesFolder.appendingPathComponent(filename)
        
        if let data = qrCodeImage.pngData() {
            do {
                try data.write(to: url)
                
                saveMessage = "QR code successfully saved!"
                DispatchQueue.main.async {
                    showingQRCode = false
                    showSaveConfirmation = true
                }
            } catch {
                print("Error saving QR code: \(error.localizedDescription)")
            }
        }
    }


    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
