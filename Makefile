.PHONY: all clean build test run-simulator open-ios open-landing help

# Default target
all: build

# Help
help:
	@echo "Available targets:"
	@echo "  make build          - Build the iOS app"
	@echo "  make test           - Run unit tests"
	@echo "  make run-simulator  - Build and run in iOS Simulator"
	@echo "  make clean          - Clean build artifacts"
	@echo "  make open-ios       - Open iOS project in Xcode"
	@echo "  make open-landing   - Open landing page in VS Code"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	cd ios && rm -rf .build DerivedData
	cd landing && rm -rf .next node_modules

# Build the iOS project
build:
	@echo "Building Inro iOS app..."
	cd ios && xcodebuild build \
		-project Inro.xcodeproj \
		-scheme Inro \
		-destination 'platform=iOS Simulator,name=iPhone 15' \
		-derivedDataPath DerivedData

# Run tests
test:
	@echo "Running iOS tests..."
	cd ios && swift test

# Build and run in simulator
run-simulator:
	@echo "Building and running in iOS Simulator..."
	# First, boot the simulator if needed
	xcrun simctl boot "iPhone 15" 2>/dev/null || true
	# Open Simulator app
	open -a Simulator
	# Wait for simulator to be ready
	sleep 3
	# Build
	cd ios && xcodebuild build \
		-project Inro.xcodeproj \
		-scheme Inro \
		-destination 'platform=iOS Simulator,name=iPhone 15' \
		-derivedDataPath DerivedData \
		CODE_SIGN_IDENTITY="" \
		CODE_SIGNING_REQUIRED=NO
	# Install and launch the app
	cd ios && xcrun simctl install booted DerivedData/Build/Products/Debug-iphonesimulator/Inro.app
	xcrun simctl launch booted com.inro.age-verification

# Open iOS project in Xcode
open-ios:
	@echo "Opening iOS project in Xcode..."
	open ios/Inro.xcodeproj

# Open landing page in VS Code
open-landing:
	@echo "Opening landing page in VS Code..."
	code landing/