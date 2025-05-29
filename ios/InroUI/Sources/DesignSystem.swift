import SwiftUI

/// Design system constants and styles for Inro app
public enum DesignSystem {
    
    // MARK: - Colors
    public enum Colors {
        public static let primaryBlue = Color.blue
        public static let successGreen = Color.green
        public static let failureRed = Color.red
        public static let warningOrange = Color.orange
        
        public static let backgroundGradientStart = Color.blue.opacity(0.1)
        public static let backgroundGradientEnd = Color.purple.opacity(0.1)
    }
    
    // MARK: - Typography
    public enum Typography {
        public static let largeTitle = Font.largeTitle.weight(.bold)
        public static let title = Font.title.weight(.semibold)
        public static let headline = Font.headline
        public static let body = Font.body
        public static let caption = Font.caption
    }
    
    // MARK: - Spacing
    public enum Spacing {
        public static let xxSmall: CGFloat = 4
        public static let xSmall: CGFloat = 8
        public static let small: CGFloat = 12
        public static let medium: CGFloat = 16
        public static let large: CGFloat = 24
        public static let xLarge: CGFloat = 32
        public static let xxLarge: CGFloat = 40
    }
    
    // MARK: - Animation
    public enum Animation {
        public static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        public static let spring = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.6)
        public static let pulse = SwiftUI.Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false)
    }
    
    // MARK: - Component Styles
    public struct ButtonStyle: SwiftUI.ButtonStyle {
        let backgroundColor: Color
        let foregroundColor: Color
        
        public init(backgroundColor: Color = Colors.primaryBlue, foregroundColor: Color = .white) {
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
        }
        
        public func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(Typography.headline)
                .foregroundColor(foregroundColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .cornerRadius(12)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
        }
    }
}