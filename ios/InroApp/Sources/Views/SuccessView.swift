import SwiftUI

struct SuccessView: View {
    let onDismiss: () -> Void
    @State private var showCheckmark = false
    
    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 200, height: 200)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(showCheckmark ? 1 : 0.5)
                    .opacity(showCheckmark ? 1 : 0)
            }
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    showCheckmark = true
                }
            }
            
            Text(NSLocalizedString("over_20_badge", comment: ""))
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.green)
            
            Text(NSLocalizedString("verification_success", comment: ""))
                .font(.title3)
                .foregroundColor(.secondary)
            
            Button(action: onDismiss) {
                Text(NSLocalizedString("done_button", comment: ""))
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
        }
    }
}