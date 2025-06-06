import XCTest

final class AuthenticationUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testSignInFlow() throws {
        // Given - Auth view should be presented
        let emailTextField = app.textFields["Email"]
        let passwordSecureField = app.secureTextFields["Password"]
        let signInButton = app.buttons["Sign In"]
        
        // Wait for auth view to appear
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 5))
        
        // When - Enter credentials and sign in
        emailTextField.tap()
        emailTextField.typeText("test@example.com")
        
        passwordSecureField.tap()
        passwordSecureField.typeText("password123")
        
        signInButton.tap()
        
        // Then - Should navigate to main tab view
        let dashboardTab = app.tabBars.buttons["Dashboard"]
        XCTAssertTrue(dashboardTab.waitForExistence(timeout: 5))
    }
    
    func testSignUpFlow() throws {
        // Given - Switch to sign up
        let signUpSegment = app.segmentedControls.buttons["Sign Up"]
        signUpSegment.tap()
        
        let nameTextField = app.textFields["Full Name"]
        let emailTextField = app.textFields["Email"]
        let passwordSecureField = app.secureTextFields["Password"]
        let confirmPasswordSecureField = app.secureTextFields["Confirm Password"]
        let createAccountButton = app.buttons["Create Account"]
        
        // When - Fill in sign up form
        nameTextField.tap()
        nameTextField.typeText("New User")
        
        emailTextField.tap()
        emailTextField.typeText("newuser@example.com")
        
        passwordSecureField.tap()
        passwordSecureField.typeText("password123")
        
        confirmPasswordSecureField.tap()
        confirmPasswordSecureField.typeText("password123")
        
        createAccountButton.tap()
        
        // Then - Should navigate to main tab view
        let dashboardTab = app.tabBars.buttons["Dashboard"]
        XCTAssertTrue(dashboardTab.waitForExistence(timeout: 5))
    }
    
    func testSignOutFlow() throws {
        // Given - Sign in first
        signInWithTestCredentials()
        
        // Navigate to profile
        let profileTab = app.tabBars.buttons["Profile"]
        profileTab.tap()
        
        // When - Tap sign out
        let signOutButton = app.buttons["Sign Out"]
        XCTAssertTrue(signOutButton.waitForExistence(timeout: 5))
        signOutButton.tap()
        
        // Then - Should return to auth view
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 5))
    }
    
    func testPasswordMismatchValidation() throws {
        // Given - Switch to sign up
        let signUpSegment = app.segmentedControls.buttons["Sign Up"]
        signUpSegment.tap()
        
        let passwordSecureField = app.secureTextFields["Password"]
        let confirmPasswordSecureField = app.secureTextFields["Confirm Password"]
        
        // When - Enter mismatched passwords
        passwordSecureField.tap()
        passwordSecureField.typeText("password123")
        
        confirmPasswordSecureField.tap()
        confirmPasswordSecureField.typeText("password456")
        
        // Then - Should show error message
        let errorText = app.staticTexts["Passwords do not match"]
        XCTAssertTrue(errorText.exists)
        
        // And create account button should be disabled
        let createAccountButton = app.buttons["Create Account"]
        XCTAssertFalse(createAccountButton.isEnabled)
    }
    
    // MARK: - Helper Methods
    
    private func signInWithTestCredentials() {
        let emailTextField = app.textFields["Email"]
        let passwordSecureField = app.secureTextFields["Password"]
        let signInButton = app.buttons["Sign In"]
        
        emailTextField.tap()
        emailTextField.typeText("test@example.com")
        
        passwordSecureField.tap()
        passwordSecureField.typeText("password123")
        
        signInButton.tap()
        
        // Wait for navigation
        let dashboardTab = app.tabBars.buttons["Dashboard"]
        _ = dashboardTab.waitForExistence(timeout: 5)
    }
}
