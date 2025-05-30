import SwiftUI

struct ReadyView: View {
    let onScanTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "person.text.rectangle")
                .font(.system(size: 100))
                .foregroundColor(.blue)
                .symbolEffect(.pulse)
            
            Text(NSLocalizedString("age_verification_title", comment: ""))
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(NSLocalizedString("scan_instruction", comment: ""))
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button(action: onScanTapped) {
                Label(NSLocalizedString("scan_card_button", comment: ""), systemImage: "wave.3.right")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
        }
    }
}