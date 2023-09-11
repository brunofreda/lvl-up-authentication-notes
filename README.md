# LvL Up - Authentication and notes module

Welcome to the LvL Up app!

This is one module of a bigger project, a full-fledged self-management app with gamification features. This module includes the screens to register and log in to the app, and the notes screen to create, update and delete notes.

https://github.com/brunofreda/lvl-up-authentication-notes/assets/47567054/a6d057b8-2aeb-4e06-bc91-00a33161f2ff

![LvL Up - First image](/images/lvl_up_authentication_notes_1.jpg)

![LvL Up - Second image](/images/lvl_up_authentication_notes_2.jpg)

## Features

### Client side

- Login and registration screens
- Text fields with properties to accommodate email and password type inputs respectively
- Icon button to show or hide the password
- Verifying email screen which automatically sends a verification email to the user and lets him resend it
- Error handling for various authentication errors (wrong password, invalid email, etc.)
- Link between login and register screens
- Functionality to reset password
- Notes screen that emulates real sticky notes on a pinboard
- A button to add notes and a menu with the option to log out
- The notes can be updated upon tapping on them and have a button to delete them
- Score counter on the appbar that would be functional on the full app
- Loading screens

### Server side

- Backend with Firebase
- Firestore cloud storage (migrated from a CRUD local service stored in the repository as commented code)
- Backend logic abstracted away from the frontend logic using Bloc
- The repository includes unit tests for the authentication provider

## Some of the things the full app would include

- Title logo
- Icon next to the score counter
- Other useful features (a calendar, events, objectives, and more)
- Homepage with stats and thumbnails of the pages of the other features which link you to those pages
- The pages can also be accessed by dragging to the right or to the left
- Option to login with other common providers
- Customization (backgrounds, color of notes, themes, etc.)
- Order notes by date, modified and own order
- Functionality to select which notes to delete, including the option to select all
- A customizable profile with gamification features, such as level of user, milestones, items, more themes, all of which would be related to the score and objectives set by the user
