import Foundation

/// Pure Swift age verification engine
public struct AgeEngine {
    /// Minimum age requirement for verification
    public static let minimumAge = 20
    
    /// Verifies if a person is at least 20 years old
    /// - Parameters:
    ///   - birthDate: The person's date of birth
    ///   - referenceDate: The date to check against (defaults to current date)
    /// - Returns: True if the person is 20 or older
    public static func isOverMinimumAge(birthDate: Date, referenceDate: Date = Date()) -> Bool {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: referenceDate)
        
        guard let age = ageComponents.year else {
            return false
        }
        
        return age >= minimumAge
    }
    
    /// Calculates exact age from birth date
    /// - Parameters:
    ///   - birthDate: The person's date of birth
    ///   - referenceDate: The date to calculate age from (defaults to current date)
    /// - Returns: Age in years, or nil if calculation fails
    public static func calculateAge(birthDate: Date, referenceDate: Date = Date()) -> Int? {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: referenceDate)
        return ageComponents.year
    }
    
    /// Checks if today is the person's birthday
    /// - Parameter birthDate: The person's date of birth
    /// - Returns: True if today matches the birth date's month and day
    public static func isBirthday(birthDate: Date, referenceDate: Date = Date()) -> Bool {
        let calendar = Calendar.current
        let birthComponents = calendar.dateComponents([.month, .day], from: birthDate)
        let todayComponents = calendar.dateComponents([.month, .day], from: referenceDate)
        
        return birthComponents.month == todayComponents.month &&
               birthComponents.day == todayComponents.day
    }
}