# Pasta

## Demo

<video src="video/video.mp4" controls muted playsinline style="max-width: 100%; height: auto;"></video>

If the video doesn’t render in your Git viewer, open it directly: [video/video.mp4](video/video.mp4)

## About

The project was for a gaming venue (PlayStation, billiards, etc.). I noticed their booking system was entirely paper-based, so I developed a mobile-based system to streamline price and time calculations and provide daily, weekly, and monthly statistics.

## How it was built

- Followed best practices and separation of concerns using a feature-based structure (presentation → logic → data), which makes the app easy to maintain and scale.
- Designed the data model first (categories, tables, sessions) to keep time/price calculations reliable.
- Used repositories + DAOs on top of Drift (SQLite) to keep data access clean and testable.
- Centralized dependency injection with `get_it` (service locator) so features can grow without tight coupling.
- Wrapped notifications behind `ILocalNotificationService` and implemented automated tests using an in-memory database + mocked notifications.

## How it works

- The client requests a booking time directly or books a future appointment by phone.
- The user selects the game, specifies the start time (immediate or later) and booking duration, or chooses an open-ended timeframe. The system handles all the details and displays each session with its specific information.
- An automatic notification is sent upon booking completion, containing the booking details and total price.
- The booking period can be extended or canceled before the end date, and the system automatically handles these changes.

## The system helps with

- Automatic price and time calculation
- Displaying daily, weekly, and monthly statistics
- Reducing errors resulting from manual calculations
- Notifying users when sessions end

## Technical

- Flutter (Material)
- State management: `flutter_bloc`
- Local database: Drift (SQLite)
- Dependency injection: `get_it`
- Local notifications: `flutter_local_notifications`
- Charts: `fl_chart`

## Project tour

- App entry point: `lib/main.dart`
- Dependency injection: `lib/core/di/service_locator.dart`
- Notifications: `lib/core/notifications/local_notification_service.dart`
- Feature modules (UI/logic/data): `lib/app_feature/`
- Unit tests (repositories): `test/app_feature/data/repos/` (category/table/session)

## Architecture tree

```text
lib/
	main.dart
	app_feature/
		presentation/
			home/
			notification/
			settings/
			start_new_session/
		logic/
			home/
			notification/
			settings/
			start_new_session/
		data/
			data_base/
			repos/
			models/
	core/
		di/
		notifications/
		routing/
		theme/
		helper/
		extension/
```

