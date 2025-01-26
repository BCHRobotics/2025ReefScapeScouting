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
    public var triedToStopOpponents: Bool = false
    public var didntStopOpponents: Bool = false
    public var tippy: Bool = false
    public var disabled: Bool = false
    public var comments: String = ""
}

struct StepperInput: View {
    let label: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Stepper("\(value)", value: $value, in: range)
                .frame(maxWidth: 150)
        }
    }
}


struct ToggleInput: View {
    var label: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}


struct PickerInput: View {
    let label: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
            Picker(label, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}


