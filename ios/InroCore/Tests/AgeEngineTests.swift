import XCTest
@testable import InroCore

final class AgeEngineTests: XCTestCase {
    
    func testIsOverMinimumAge_WhenExactly20_ReturnsTrue() {
        // Given
        let calendar = Calendar.current
        let twentyYearsAgo = calendar.date(byAdding: .year, value: -20, to: Date())!
        
        // When
        let result = AgeEngine.isOverMinimumAge(birthDate: twentyYearsAgo)
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testIsOverMinimumAge_WhenOver20_ReturnsTrue() {
        // Given
        let calendar = Calendar.current
        let thirtyYearsAgo = calendar.date(byAdding: .year, value: -30, to: Date())!
        
        // When
        let result = AgeEngine.isOverMinimumAge(birthDate: thirtyYearsAgo)
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testIsOverMinimumAge_WhenUnder20_ReturnsFalse() {
        // Given
        let calendar = Calendar.current
        let nineteenYearsAgo = calendar.date(byAdding: .year, value: -19, to: Date())!
        
        // When
        let result = AgeEngine.isOverMinimumAge(birthDate: nineteenYearsAgo)
        
        // Then
        XCTAssertFalse(result)
    }
    
    func testIsOverMinimumAge_WithLeapYearBirthDate() {
        // Given - Born on Feb 29, 2004
        var components = DateComponents()
        components.year = 2004
        components.month = 2
        components.day = 29
        let birthDate = Calendar.current.date(from: components)!
        
        // Reference date: Feb 28, 2024 (not quite 20 yet)
        components.year = 2024
        components.month = 2
        components.day = 28
        let beforeBirthday = Calendar.current.date(from: components)!
        
        // When
        let resultBefore = AgeEngine.isOverMinimumAge(birthDate: birthDate, referenceDate: beforeBirthday)
        
        // Then
        XCTAssertFalse(resultBefore, "Should be false before 20th birthday")
        
        // Reference date: Mar 1, 2024 (20 years old)
        components.month = 3
        components.day = 1
        let afterBirthday = Calendar.current.date(from: components)!
        
        // When
        let resultAfter = AgeEngine.isOverMinimumAge(birthDate: birthDate, referenceDate: afterBirthday)
        
        // Then
        XCTAssertTrue(resultAfter, "Should be true after 20th birthday")
    }
    
    func testCalculateAge_ReturnsCorrectAge() {
        // Given
        var components = DateComponents()
        components.year = 2000
        components.month = 1
        components.day = 1
        let birthDate = Calendar.current.date(from: components)!
        
        components.year = 2025
        components.month = 5
        components.day = 29
        let referenceDate = Calendar.current.date(from: components)!
        
        // When
        let age = AgeEngine.calculateAge(birthDate: birthDate, referenceDate: referenceDate)
        
        // Then
        XCTAssertEqual(age, 25)
    }
    
    func testIsBirthday_WhenSameMonthAndDay_ReturnsTrue() {
        // Given
        var components = DateComponents()
        components.year = 2000
        components.month = 5
        components.day = 29
        let birthDate = Calendar.current.date(from: components)!
        
        components.year = 2025
        let todayDate = Calendar.current.date(from: components)!
        
        // When
        let result = AgeEngine.isBirthday(birthDate: birthDate, referenceDate: todayDate)
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testIsBirthday_WhenDifferentDay_ReturnsFalse() {
        // Given
        var components = DateComponents()
        components.year = 2000
        components.month = 5
        components.day = 29
        let birthDate = Calendar.current.date(from: components)!
        
        components.year = 2025
        components.day = 30
        let differentDay = Calendar.current.date(from: components)!
        
        // When
        let result = AgeEngine.isBirthday(birthDate: birthDate, referenceDate: differentDay)
        
        // Then
        XCTAssertFalse(result)
    }
    
    func testIsOverMinimumAge_BoundaryCase_ExactlyOnBirthday() {
        // Given - Someone born exactly 20 years ago today
        var components = DateComponents()
        components.year = 2005
        components.month = 5
        components.day = 29
        let birthDate = Calendar.current.date(from: components)!
        
        components.year = 2025
        let referenceDate = Calendar.current.date(from: components)!
        
        // When
        let result = AgeEngine.isOverMinimumAge(birthDate: birthDate, referenceDate: referenceDate)
        
        // Then
        XCTAssertTrue(result, "Should be true on exact 20th birthday")
    }
}