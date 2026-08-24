.PHONY: setup run apk aab install-apk ipa open-ios open-archive install-ipa clean android-clean lint format fix check

# Install deps and configure git hooks. New developers should run this first.
setup:
	flutter pub get
	git config core.hooksPath .githooks
	git update-index --chmod=+x .githooks/pre-commit .githooks/pre-push

# ── Run ──────────────────────────────────────────────────────────────────────

run:
	flutter run

# ── Android ──────────────────────────────────────────────────────────────────

apk:
	flutter build apk

# App Bundle — required for Play Store upload
aab:
	flutter build appbundle

install-apk:
	adb install -r build/app/outputs/flutter-apk/app-release.apk

# ── iOS ───────────────────────────────────────────────────────────────────────

ipa:
	flutter build ipa --export-method app-store

# Open the iOS project in Xcode (e.g. to distribute/install an archive to a device)
open-ios:
	open ios/Runner.xcworkspace

# Open the last built iOS archive in Xcode Organizer
open-archive:
	open build/ios/archive/Runner.xcarchive

# Install an exported .ipa onto a physical iPhone via devicectl.
# Usage: make install-ipa DEVICE=<udid> IPA_PATH="build/ios/ipa/finhub.ipa"
install-ipa:
	xcrun devicectl device install app --device "$(DEVICE)" "$(IPA_PATH)"

# ── Misc ──────────────────────────────────────────────────────────────────────

clean:
	flutter clean
	flutter pub get

# Clean Gradle + Flutter Android build caches without a full `flutter clean`.
android-clean:
	cd android && ./gradlew clean
	rm -rf build/app
	rm -rf .dart_tool/flutter_build

# ── Code Quality ─────────────────────────────────────────────────────────────

lint:
	flutter analyze --fatal-infos --fatal-warnings

format:
	dart format --line-length 120 lib/

fix:
	dart fix --apply
	dart format --line-length 120 lib/

check:
	dart format --line-length 120 --output=none --set-exit-if-changed lib/
	flutter analyze --fatal-infos --fatal-warnings
