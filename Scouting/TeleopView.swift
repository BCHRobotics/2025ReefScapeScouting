import SwiftUI
import SwiftUICore
struct TeleopView: View {
    @Binding var teleopData: TeleopData

    var body: some View {
        Form {
            Section(header: Text("Teleop Phase")) {
                ToggleInput(label: "Knocked Off Algae", isOn: $teleopData.knockedOffAlgae)

                StepperInput(label: "Coral Level 1", value: $teleopData.coral1, range: 0...10)
                StepperInput(label: "Coral Level 2", value: $teleopData.coral2, range: 0...10)
                StepperInput(label: "Coral Level 3", value: $teleopData.coral3, range: 0...10)
                StepperInput(label: "Coral Level 4", value: $teleopData.coral4, range: 0...10)

                StepperInput(label: "Processor Score", value: $teleopData.processorScore, range: 0...10)
                StepperInput(label: "Net Algae Score", value: $teleopData.netAlgae, range: 0...10)
            }
        }
        .navigationTitle("Teleop Phase")
    }
}
