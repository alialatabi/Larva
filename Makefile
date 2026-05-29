SUPABASE_URL    := https://rbltthvigaropascfmiu.supabase.co
SUPABASE_ANON   := sb_publishable_9SbyquS03cMxOW29pKhKOw_YHbYlU1H
DART_DEFINES    := --dart-define=SUPABASE_URL=$(SUPABASE_URL) \
                   --dart-define=SUPABASE_ANON_KEY=$(SUPABASE_ANON)

.PHONY: run run-web run-ios run-android analyze

run:
	flutter run $(DART_DEFINES)

run-web:
	flutter run -d chrome $(DART_DEFINES)

run-ios:
	flutter run -d iPhone $(DART_DEFINES)

run-android:
	flutter run -d android $(DART_DEFINES)

analyze:
	flutter analyze
