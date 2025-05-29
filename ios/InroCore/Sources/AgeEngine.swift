import Foundation

/// Pure Swift age verification engine
public struct AgeEngine {
    /// Minimum age requirement for verification in Japan
    public static let minimumAge = 20
    
    /// Verifies if a person is at least 20 years old
    /// - Parameters:
    ///   - birthDate: The person's date of birth
    ///   - referenceDate: The date to check against (defaults to current date)
    /// - Returns: True if the person is 20 or older
    public static func isOverMinimumAge(birthDate: Date, referenceDate: Date = Date()) -> Bool {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year, .month, .day], from: birthDate, to: referenceDate)
        
        guard let years = ageComponents.year else {
            return false
        }
        
        // Person is definitely over 20 if they have more than 20 years
        if years > minimumAge {
            return true
        }
        
        // If exactly 20 years, need to check month and day
        if years == minimumAge {
            // Check if birthday has passed this year
            let birthComponents = calendar.dateComponents([.month, .day], from: birthDate)
            let currentComponents = calendar.dateComponents([.month, .day], from: referenceDate)
            
            if let birthMonth = birthComponents.month,
               let birthDay = birthComponents.day,
               let currentMonth = currentComponents.month,
               let currentDay = currentComponents.day {
                
                if currentMonth > birthMonth {
                    return true
                } else if currentMonth == birthMonth && currentDay >= birthDay {
                    return true
                }
            }
        }
        
        return false
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