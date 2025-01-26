import SwiftUI
import Combine

struct ContentView: View {
    @State private var matchDetails = MatchDetails()
    @State private var autoData = AutoData()
    @State private var teleopData = TeleopData()
    @State private var defenceData = DefenceData()
    @State private var qrCodeImage: UIImage? = nil
    
    @State private var isKeyboardVisible = false
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
                .edgesIgnoringSafeArea(.all)

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
                .navigationBarTitleDisplayMode(.inline)  // Use inline mode for smaller title
                                .toolbar {
                                    // Clear Form Button
                                    ToolbarItem(placement: .navigationBarLeading) {
                                        Button("Clear Form") {
                                            clearForm()
                                        }
                                        .foregroundColor(.red)
                                        .font(.headline)
                                    }
                                    
                                    // Custom Navigation Title
                                    ToolbarItem(placement: .principal) {
                                        Text("FRC Scouter")
                                            .font(.system(size: 18))  // Make title smaller
                                            .bold()
                                    }

                                    // Show "Done" button only if the keyboard is visible
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        if isKeyboardVisible {
                                            Button("Done") {
                                                hideKeyboard()
                                            }
                                            .font(.headline)
                                        }
                                    }
                                }
                .onAppear {
                    // Register for keyboard notifications when the view appears
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                        withAnimation {
                            isKeyboardVisible = true
                        }
                    }
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                        withAnimation {
                            isKeyboardVisible = false
                        }
                    }
                }
                .onDisappear {
                    // Remove keyboard notifications when the view disappears
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
    }
    
    // Function to hide the keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
