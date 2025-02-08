import SwiftUI

// Enum to represent the climb status (only one can be selected at a time)

struct DefenceView: View {
    @Binding var defenceData: DefenceData
    
    var body: some View {
        Form {
            // Climb Status Section using ToggleInput
            Section(header: Text("Climb Status")) {
                ToggleInput(
                    label: "Did Not Attempt",
                    isOn: Binding(
                        get: { defenceData.climbStatus == .none },
                        set: { newValue in
                            if newValue {
                                defenceData.climbStatus = .none
                            }
                        }
                    )
                )
                
                ToggleInput(
                    label: "Parked",
                    isOn: Binding(
                        get: { defenceData.climbStatus == .parked },
                        set: { newValue in
                            if newValue {
                                defenceData.climbStatus = .parked
                            }
                        }
                    )
                )
                
                ToggleInput(
                    label: "Climbed Shallow Cage",
                    isOn: Binding(
                        get: { defenceData.climbStatus == .shallow },
                        set: { newValue in
                            if newValue {
                                defenceData.climbStatus = .shallow
                            }
                        }
                    )
                )
                
                ToggleInput(
                    label: "Climbed Deep Cage",
                    isOn: Binding(
                        get: { defenceData.climbStatus == .deep },
                        set: { newValue in
                            if newValue {
                                defenceData.climbStatus = .deep
                            }
                        }
                    )
                )
            }
                
                // Defence Metrics Section
                Section(header: Text("Defence Metrics")) {
                    ToggleInput(
                        label: "Did not Stop Opponents",
                        isOn: Binding(
                            get: { defenceData.defenseStatus == .none },
                            set: { newValue in
                                if newValue {
                                    defenceData.defenseStatus = .none
                                }
                            }
                        )
                    )
                    ToggleInput(
                        label: "Stopped Opponents",
                        isOn: Binding(
                            get: { defenceData.defenseStatus == .stoppedOpponenes },
                            set: { newValue in
                                if newValue {
                                    defenceData.defenseStatus = .stoppedOpponenes
                                }
                            }
                        )
                    )
                    ToggleInput(
                        label: "Attempted to Stop Opponents",
                        isOn: Binding(
                            get: { defenceData.defenseStatus == .attemptedToStopOpponenets },
                            set: { newValue in
                                if newValue {
                                    defenceData.defenseStatus = .attemptedToStopOpponenets
                                }
                            }
                        )
                    )
                }
                
                // Robot Control Section
                Section(header: Text("Robot")) {
                    ToggleInput(label: "Did The Robot Almost Tip Over?", isOn: $defenceData.tippy)
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

