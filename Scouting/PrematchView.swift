import SwiftUI

struct PrematchView: View {
    @Binding var scouterInitials: String
    @Binding var matchNumber: String
    @Binding var teamNumber: String

    @Binding var selectedAlliancePosition: String
    let alliancePositions: [String]

    var body: some View {
            // Main content: Form
            Form {
                Section(header: Text("Match Details")) {
                    TextField("Scouting Initials", text: $scouterInitials)
                    TextField("Match Number", text: $matchNumber)
                        .keyboardType(.numberPad)
                    TextField("Team Number", text: $teamNumber)
                        .keyboardType(.numberPad)
                    
                    Picker("Alliance Position", selection: $selectedAlliancePosition) {
                        ForEach(alliancePositions, id: \.self) { position in
                            Text(position)
                        }
                    }
                    
                }
            
            .navigationTitle("Prematch")
            
        }
    }
}
