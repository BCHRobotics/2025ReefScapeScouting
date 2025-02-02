import SwiftUI
import Combine

struct ContentView: View {
    @State private var matchDetails = MatchDetails()
    @State private var autoData = AutoData()
    @State private var teleopData = TeleopData()
    @State private var defenceData = DefenceData()
    @State private var qrCodeImage: UIImage? = nil
    
    @State private var isKeyboardVisible = false
  

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
                .doneButtonToolbar()
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

                    // Info Button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showAlert()
                        }) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 18))
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
        .alert(isPresented: $showingInfoAlert) {
            Alert(title: Text("FRC Scouter"), message: Text("Brought to you by Team 2386 and the Programming Team. We would like to thank you for using our app and hope you enjoyed it!"), dismissButton: .default(Text("OK")))
        }
    }

    @State private var showingInfoAlert = false

    private func showAlert() {
        showingInfoAlert = true
    }

    // Function to reset all data
    func clearForm() {
        matchDetails = MatchDetails()
        autoData = AutoData()
        teleopData = TeleopData()
        defenceData = DefenceData()
        qrCodeImage = nil
    }
}
