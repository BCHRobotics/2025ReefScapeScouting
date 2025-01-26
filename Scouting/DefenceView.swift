import SwiftUI

struct DefenceView: View {
    @Binding var defenceData: DefenceData
    let endgameOptions: [String]
    
    var body: some View {
        Form {
            Section(header: Text("Endgame Status")) {
                            Picker("Climb Status", selection: $defenceData.endgameStatus) {
                                ForEach(endgameOptions, id: \.self) { status in
                                    Text(status).tag(status)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
            
            // Defence Metrics Section
            Section(header: Text("Defence Metrics")) {
                ToggleInput(label: "Stopped Opponents", isOn: $defenceData.stoppedOpponents)
                ToggleInput(label: "Impeded Opponents", isOn: $defenceData.impededOpponents)
                ToggleInput(label: "Didn't Stop Opponents", isOn: $defenceData.didntStopOpponents)
            }
            
            // Robot Control Section
            Section(header: Text("Robot Control")) {
                ToggleInput(label: "Was the robot tippy?", isOn: $defenceData.tippy)
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
