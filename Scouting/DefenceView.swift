import SwiftUI

struct DefenceView: View {
    // Bindings from ContentView
    @Binding var endgameStatus: String
    @Binding var stoppedOpponents: String
    @Binding var impededOpponents: String
    @Binding var didntStopOpponents: String
    @Binding var tippy: Bool
    @Binding var disabled: Bool
    @Binding var comments: String
    
    // Options for Endgame and Defence Metrics
    let endgameOptions = ["Not Attempted", "Parked" ,"Failed to Climb", "Shallow Cage", "Deep Cage"]
    let yesNoOptions = ["No", "Yes"] 
    
    var body: some View {
        Form {
            Section(header: Text("Endgame Status")) {
                // Dropdown for Endgame Status
                Picker("Endgame Status", selection: $endgameStatus) {
                    ForEach(endgameOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle()) // Dropdown Menu Picker
            }
            
            Section(header: Text("Defence Metrics")) {
                // Defence Metric: Stopped Opponents
                VStack(alignment: .leading) {
                    Picker("Stopped Opponents", selection: $stoppedOpponents) {
                        ForEach(yesNoOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Dropdown Menu Picker
                }
                
                // Defence Metric: Impeded Opponents
                VStack(alignment: .leading) {
                    Picker("Impeded Opponents", selection: $impededOpponents) {
                        ForEach(yesNoOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Dropdown Menu Picker
                }
                
                // Defence Metric: Didn't Stop Opponents
                VStack(alignment: .leading) {
                    Picker("Didn't Stop Opponents", selection: $didntStopOpponents) {
                        ForEach(yesNoOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Dropdown Menu Picker
                }
                
                VStack(alignment: .leading) {
                    Toggle("Was the robot tippy?", isOn: $tippy)
                }
                VStack(alignment: .leading) {
                    Toggle("Did the robot disable?", isOn: $disabled)
                }
                
                TextField("Comments", text: $comments)
            }
        }
        .navigationTitle("Defence")
    }
}


