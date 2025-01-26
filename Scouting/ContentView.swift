import SwiftUI

// Data Models
public struct MatchDetails {
    public var scouterInitials: String = ""
    public var matchNumber: String = ""
    public var teamNumber: String = ""
    public var selectedAlliancePosition: String = "Default"
}

// Data structure for Auto phase
public struct AutoData {
    public var robotLeftStartingLine: Bool = false
    public var coral1: Int = 0
    public var coral2: Int = 0
    public var coral3: Int = 0
    public var coral4: Int = 0
    public var processorScore: Int = 0
    public var netAlgae: Int = 0
}

// Data structure for Teleop phase
public struct TeleopData {
    public var knockedOffAlgae: Bool = false
    public var coral1: Int = 0
    public var coral2: Int = 0
    public var coral3: Int = 0
    public var coral4: Int = 0
    public var processorScore: Int = 0
    public var netAlgae: Int = 0
}

public struct DefenceData {
    public var endgameStatus: String = "Not Attempted"
    public var stoppedOpponents: Bool = false
    public var impededOpponents: Bool = false
    public var didntStopOpponents: Bool = false
    public var tippy: Bool = false
    public var disabled: Bool = false
    public var comments: String = ""
}

// Main Content View
struct ContentView: View {
    @State private var matchDetails = MatchDetails()
    @State private var autoData = AutoData()
    @State private var teleopData = TeleopData()
    @State private var defenceData = DefenceData()
    @State private var qrCodeImage: UIImage? = nil

    private let alliancePositions = ["Default", "Red 1", "Red 2", "Red 3", "Blue 1", "Blue 2", "Blue 3"]
    private let endgameOptions = ["Not Attempted", "Parked", "Failed to Climb", "Shallow Cage", "Deep Cage"]

    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }

    var body: some View {
        ZStack {
            // Background Image
            Image("fd_frc_reefscape_socialgraphics_igstory")
                .resizable()

            NavigationView {
                TabView {
                    // Prematch Tab
                    PrematchView(
                        matchDetails: $matchDetails,
                        alliancePositions: alliancePositions
                    )
                    .tabItem {
                        Label("Prematch", systemImage: "1.circle")
                    }

                    // Auto Tab
                    AutoView(autoData: $autoData)
                        .tabItem {
                            Label("Auto", systemImage: "2.circle")
                        }

                    // Teleop Tab
                    TeleopView(teleopData: $teleopData)
                        .tabItem {
                            Label("Teleop", systemImage: "3.circle")
                        }

                    // Defence Tab
                    DefenceView(defenceData: $defenceData,
                                endgameOptions: endgameOptions)
                        .tabItem {
                            Label("Defence/Endgame", systemImage: "4.circle")
                        }

                    // QR Code Tab
                    QRCodeView(
                        matchDetails: $matchDetails,
                        autoData: $autoData,
                        teleopData: $teleopData,
                        defenceData: $defenceData
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

    // Function to reset all data
    func clearForm() {
        matchDetails = MatchDetails()
        autoData = AutoData()
        teleopData = TeleopData()
        defenceData = DefenceData()
        qrCodeImage = nil
        //self.navigationController?.popToViewController(animated: true)
    }
}
