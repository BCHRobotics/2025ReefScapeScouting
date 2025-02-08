import SwiftUI
struct AutoView: View {
    @Binding var autoData: AutoData

    var body: some View {
        Form {
            Section(header: Text("Autonomous Phase")) {
                

                StepperInput(label: "Coral Level 1", value: $autoData.coral1, range: 0...10)
                StepperInput(label: "Coral Level 2", value: $autoData.coral2, range: 0...10)
                StepperInput(label: "Coral Level 3", value: $autoData.coral3, range: 0...10)
                StepperInput(label: "Coral Level 4", value: $autoData.coral4, range: 0...10)

                StepperInput(label: "Processor Score", value: $autoData.processorScore, range: 0...10)
                StepperInput(label: "Net Algae Score", value: $autoData.netAlgae, range: 0...10)
                ToggleInput(label: "Robot Left Starting Line", isOn: $autoData.robotLeftStartingLine)
            }
        }
        .navigationTitle("Auto Phase")
    }
}
