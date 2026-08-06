import SwiftUI

struct HistoryRow: View {
    let session: WorkSession

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(session.dateText)
                .font(.headline)
            HStack {
                Label(session.startText, systemImage: "play.fill")
                Spacer()
                Label(session.endDate != nil ? session.endText : "En curso", systemImage: "stop.fill")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            Text(session.durationText)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 10)
    }
}
