import SwiftUI

struct ContentView: View {
    // Variables for Prematch
    @State private var scouterInitials: String = ""
    @State private var matchNumber: String = ""
    @State private var teamNumber: String = ""
    @State private var comments: String = ""
    @State private var selectedAlliancePosition: String = "Default"
    let alliancePositions = ["Default", "Red 1", "Red 2", "Red 3", "Blue 1", "Blue 2", "Blue 3"]
    @State  private var matchStart: TimeInterval = 0

    // Variables for Auto
    @State private var robotLeftStartingLine: Bool = false
    @State private var autoCoral1: Int = 0
    @State private var autoCoral2: Int = 0
    @State private var autoCoral3: Int = 0
    @State private var autoCoral4: Int = 0
    @State private var processorScoreAuto: Int = 0
    @State private var algaeNetAuto: Int = 0
    
    // Variables for Teleop
    @State private var knockedOffAlgae: Bool = false
    @State private var teleopCoral1: Int = 0
    @State private var teleopCoral2: Int = 0
    @State private var teleopCoral3: Int = 0
    @State private var teleopCoral4: Int = 0
    @State private var processorScoreTeleop: Int = 0
    @State private var algaeNetTeleop: Int = 0
    
    // Variables for Defence
    @State private var endgameStatus: String = "Not Attempted"
    @State private var stoppedOpponents: String = "No"
    @State private var impededOpponents: String = "No"
    @State private var didntStopOpponents: String = "No"
    @State private var tippy: Bool = false
    @State private var disabled: Bool = false
    
    // QR Code Image
    @State private var qrCodeImage: UIImage? = nil
    init() {
        
            // Set a default appearance for the Tab Bar
            UITabBar.appearance().backgroundColor = UIColor.white
            UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        }
    
    
    var body: some View {
        
        ZStack {
            // Background Image - ensure this is on the bottom layer
            Image("fd_frc_reefscape_socialgraphics_igstory")  .resizable()
                
                
            // Main content goes here, over the background
            NavigationView {
                TabView {
                    // Prematch Tab
                    PrematchView(
                        scouterInitials: $scouterInitials,
                        matchNumber: $matchNumber,
                        teamNumber: $teamNumber,
                        selectedAlliancePosition: $selectedAlliancePosition,
                        alliancePositions: alliancePositions
                    )
                    .tabItem {
                        Label("Prematch", systemImage: "1.circle")
                    }

                    // Auto Tab
                    AutoView(
                        robotLeftStartingLine: $robotLeftStartingLine,
                        coral1: $autoCoral1,
                        coral2: $autoCoral2,
                        coral3: $autoCoral3,
                        coral4: $autoCoral4,
                        processorScoreAuto: $processorScoreAuto,
                        netAlgaeAuto: $algaeNetAuto
                    )
                    .tabItem {
                        Label("Auto", systemImage: "2.circle")
                    }
             

                    // Teleop Tab
                    TeleopView(
                        knockedOffAlgae: $knockedOffAlgae,
                        coral1: $teleopCoral1,
                        coral2: $teleopCoral2,
                        coral3: $teleopCoral3,
                        coral4: $teleopCoral4,
                        processorScoreTeleop: $processorScoreTeleop, netAlgaeTeleop: $algaeNetTeleop
                    )
                    .tabItem {
                        Label("Teleop", systemImage: "3.circle" )
                    }

                    // Defence Tab
                    DefenceView(
                        endgameStatus: $endgameStatus,
                        stoppedOpponents: $stoppedOpponents,
                        impededOpponents: $impededOpponents,
                        didntStopOpponents: $didntStopOpponents,
                        tippy: $tippy,
                        disabled: $disabled,
                        comments: $comments
                    )
                    .tabItem {
                        Label("Defence/Endgame", systemImage: "4.circle")
                    }

                    QRCodeView(
                        matchNumber: $matchNumber,
                        teamNumber: $teamNumber,
                        scouterInitials: $scouterInitials,
                        selectedAlliancePosition: $selectedAlliancePosition,
                        comments: $comments,
                        robotLeftStartingLine: $robotLeftStartingLine,
                        autoCoral1: $autoCoral1,
                        autoCoral2: $autoCoral2,
                        autoCoral3: $autoCoral3,
                        autoCoral4: $autoCoral4,
                        processorScoreAuto: $processorScoreAuto,
                        algeaNetAuto: $algaeNetAuto, // Pass this variable
                        knockedOffAlgae: $knockedOffAlgae,
                        teleopCoral1: $teleopCoral1,
                        teleopCoral2: $teleopCoral2,
                        teleopCoral3: $teleopCoral3,
                        teleopCoral4: $teleopCoral4,
                        processorScoreTeleop: $processorScoreTeleop,
                        algeaNetTeleop: $algaeNetTeleop, // Pass this variable
                        endgameStatus: $endgameStatus,
                        stoppedOpponents: $stoppedOpponents,
                        impededOpponents: $impededOpponents,
                        didntStopOpponents: $didntStopOpponents,
                        tippy: $tippy,
                        disbled: $disabled
                    )

                    .tabItem {
                        Label("QR Code", systemImage: "5.circle")
                    }
                }
                .navigationTitle("2386 Scouting App")
                
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Clear Form") {
                            clearForm()
                        }
                        .foregroundColor(.red)
                        .font(.headline)
                    }
                }
            }
        }
    }

    // Function to clear all form values
    func clearForm() {
        // Reset all variables to their initial values
        scouterInitials = ""
        matchNumber = ""
        teamNumber = ""
        comments = ""
        selectedAlliancePosition = "Default"

        robotLeftStartingLine = false
        autoCoral1 = 0
        autoCoral2 = 0
        autoCoral3 = 0
        autoCoral4 = 0
        processorScoreAuto = 0
        algaeNetAuto = 0
        
        knockedOffAlgae = false
        teleopCoral1 = 0
        teleopCoral2 = 0
        teleopCoral3 = 0
        teleopCoral4 = 0
        processorScoreTeleop = 0
        algaeNetTeleop = 0
        
        endgameStatus = "Not Attempted"
        stoppedOpponents = "No"
        impededOpponents = "No"
        didntStopOpponents = "No"
        tippy = false
        disabled = false
        
        qrCodeImage = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
