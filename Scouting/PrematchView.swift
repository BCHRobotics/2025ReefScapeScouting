import SwiftUI

struct PrematchView: View {
    @Binding var matchDetails: MatchDetails
    let alliancePositions: [String]

    var body: some View {
        Form {
            Section(header: Text("Match Details")) {
                TextField("Scouting Initials", text: $matchDetails.scouterInitials)
                TextField("Match Number", text: $matchDetails.matchNumber)
                    .keyboardType(.numberPad)
                
                
                
                // Move the TextField for Team Number here, outside of the Picker
                TextField("Team Number", text: $matchDetails.teamNumber)
                    .keyboardType(.numberPad)
                
                Picker("Alliance Position", selection: $matchDetails.selectedAlliancePosition) {
                    ForEach(alliancePositions, id: \.self) { position in
                        Text(position)
                    }
                }
            }
        }
        .navigationTitle("Prematch")
    }
}
