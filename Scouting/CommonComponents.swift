import SwiftUI

// Data Models
public struct MatchDetails {
    public var scouterInitials: String = ""
    public var matchNumber: String = ""
    public var teamNumber: String = ""
    public var selectedAlliancePosition: String = "Red 1"
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

enum ClimbStatus {
    case none, parked, shallow, deep
}

enum DefenseStatus {
    case none, stoppedOpponenes, attemptedToStopOpponenets
}

struct DefenceData {

    public var climbStatus: ClimbStatus = .none
    public var defenseStatus: DefenseStatus = .none
    public var tippy: Bool = false
    public var disabled: Bool = false
    public var comments: String = ""
}

public let alliancePositions = ["Red 1", "Red 2", "Red 3", "Blue 1", "Blue 2", "Blue 3"]

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

struct DoneButtonToolbar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") {
                        // Dismiss the keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing) // Ensure the button takes the full width and aligns right
                    .padding()
                    .bold()
                }
            }
    }
}

extension View {
    func doneButtonToolbar() -> some View {
        self.modifier(DoneButtonToolbar())
    }
}

