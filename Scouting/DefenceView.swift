import SwiftUI

// Enum to represent the climb status (only one can be selected at a time)

struct DefenceView: View {
    @Binding var defenceData: DefenceData

    var body: some View {
        Form {
            // Clim Status Section
            Section(header: Text("Climb Status")) {
                Button(action: {
                    // Set climbStatus to .parked, ensuring only one is selected
                    defenceData.climbStatus = .none
                }) {
                    HStack {
                        Text("Did Not Attempt")
                        Spacer()
                        if defenceData.climbStatus == .none {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    // Set climbStatus to .parked, ensuring only one is selected
                    defenceData.climbStatus = .parked
                }) {
                    HStack {
                        Text("Parked")
                        Spacer()
                        if defenceData.climbStatus == .parked {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    // Set climbStatus to .shallow, ensuring only one is selected
                    defenceData.climbStatus = .shallow
                }) {
                    HStack {
                        Text("Climbed Shallow Cage")
                        Spacer()
                        if defenceData.climbStatus == .shallow {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    // Set climbStatus to .deep, ensuring only one is selected
                    defenceData.climbStatus = .deep
                }) {
                    HStack {
                        Text("Climbed Deep Cage")
                        Spacer()
                        if defenceData.climbStatus == .deep {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }

            // Defence Metrics Section
            Section(header: Text("Defence Metrics")) {
                ToggleInput(label: "Stopped Opponents", isOn: $defenceData.stoppedOpponents)
                ToggleInput(label: "Attempted Defence", isOn: $defenceData.triedToStopOpponents)
            }

            // Robot Control Section
            Section(header: Text("Robot")) {
                ToggleInput(label: "Was the robot unbalanced?", isOn: $defenceData.tippy)
                ToggleInput(label: "Did the robot disable?", isOn: $defenceData.disabled)
            }

            // Comments Field
            Section(header: Text("Comments")) {
                TextField("Enter comments here...", text: $defenceData.comments)
            }
        }
        .navigationTitle("Defence Metrics")
    }
}
