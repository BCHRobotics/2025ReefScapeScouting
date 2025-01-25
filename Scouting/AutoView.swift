import SwiftUI

struct AutoView: View {
    // Binding variables from ContentView
    @Binding var robotLeftStartingLine: Bool
    @Binding var coral1: Int
    @Binding var coral2: Int
    @Binding var coral3: Int
    @Binding var coral4: Int
    @Binding var processorScoreAuto: Int
    @Binding var netAlgaeAuto: Int

    var body: some View {
        Form {
            Section(header: Text("Autonomous Phase")) {
                // Robot left starting line toggle
                Toggle("Robot Left Starting Line", isOn: $robotLeftStartingLine)

                // Steppers for Coral 1, 2, 3, 4 (1-10)
                HStack {
                    Text("Coral Level 1")
                    Spacer()
                    Stepper("\(coral1)", value: $coral1, in: 0...10)
                        .frame(maxWidth: 150)
                }
                
                HStack {
                    Text("Coral Level 2")
                    Spacer()
                    Stepper("\(coral2)", value: $coral2, in: 0...10)
                        .frame(maxWidth: 150)
                }
                
                HStack {
                    Text("Coral Level 3")
                    Spacer()
                    Stepper("\(coral3)", value: $coral3, in: 0...10)
                        .frame(maxWidth: 150)
                }
                
                HStack {
                    Text("Coral Level 4")
                    Spacer()
                    Stepper("\(coral4)", value: $coral4, in: 0...10)
                        .frame(maxWidth: 150)
                }
                
                // Processor score stepper (0-10)
                HStack {
                    Text("Processor Score")
                    Spacer()
                    Stepper("\(processorScoreAuto)", value: $processorScoreAuto, in: 0...10)
                        .frame(maxWidth: 150)
                }
                // Processor score stepper (0-10)
                HStack {
                    Text("Net Algae Score")
                    Spacer()
                    Stepper("\(netAlgaeAuto)", value: $netAlgaeAuto, in: 0...10)
                        .frame(maxWidth: 150)
                }
            }
        }
        .navigationTitle("Auto Phase")
    }
}
