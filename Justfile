# LaunchNext task runner
# Install: brew install just
# Usage:  just --list

project     := "LaunchNext.xcodeproj"
scheme      := "LaunchNext"
app_name    := "LaunchNext"
updater_pkg := "UpdaterScripts/SwiftUpdater"

# Show available commands
default:
    @just --list

# Kill all running instances of LaunchNext
kill:
    @pkill -x "{{app_name}}" 2>/dev/null && echo "LaunchNext terminated." || echo "No running instances found."

# Remove DerivedData for LaunchNext
clean:
    @find ~/Library/Developer/Xcode/DerivedData -maxdepth 1 -name 'LaunchNext-*' -type d -exec rm -rf {} + 2>/dev/null || true
    rm -rf "{{updater_pkg}}/.build"
    @echo "Clean complete."

# Build the SwiftUpdater dependency
setup:
    swift build \
        --package-path "{{updater_pkg}}" \
        --configuration release \
        --arch arm64 --arch x86_64 \
        --product SwiftUpdater

# Build the app (Debug)
build:
    xcodebuild \
        -project "{{project}}" \
        -scheme "{{scheme}}" \
        -configuration Debug \
        build

# Build the app (Release)
build-release:
    xcodebuild \
        -project "{{project}}" \
        -scheme "{{scheme}}" \
        -configuration Release \
        build

# Build universal binary (arm64 + x86_64, Release)
build-universal:
    xcodebuild \
        -project "{{project}}" \
        -scheme "{{scheme}}" \
        -configuration Release \
        ARCHS="arm64 x86_64" \
        ONLY_ACTIVE_ARCH=NO \
        clean build

# Open/launch the built app
open:
    #!/usr/bin/env bash
    app=$(find ~/Library/Developer/Xcode/DerivedData/LaunchNext-*/Build/Products/Debug/LaunchNext.app -maxdepth 0 2>/dev/null | head -1)
    if [ -z "$app" ]; then
        echo "Error: App not found. Run 'just build' first."
        exit 1
    fi
    open "$app"
