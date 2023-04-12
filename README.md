# Event App

This event app, developed with Flutter, allows users to view registered events, see the details of the listed events, and register for the events they choose. The application uses Firebase for user login and database operations. Users can enter the event by scanning the QR codes in the event halls with their phones.

## Features

- Users can use the application by logging in with Firebase
- The list of events is fetched from the Firebase database and presented to users
- Users can register for events and view the events they have registered for
- On the event details page, they can get more information about the event
- Users can enter the event by scanning the QR codes in the event halls

## Setup

Start by cloning the project:
```sh
git clone https://github.com/furknataman/register-event
cd flutter_event_app 
```

Install the Flutter packages:
```sh
flutter pub get
```

Connect your Firebase project and place the required configuration files in the android/app and ios/Runner directories.

Finally, run the application on an Android or iOS emulator:
```sh
flutter run
```

## Usage

After launching the application, you can log in with your username and password or create a new account. After logging in, you can see the list of events and view event details. When you want to attend an event, register for the event and scan the hall's QR code to enter on the day of the event.


