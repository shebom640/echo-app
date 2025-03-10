# Echo App

Echo App is an anonymous platform where users can share their thoughts, experiences, or seek advice while maintaining privacy. Users can post messages, like and comment on posts, and interact with others in a safe and supportive environment.

## Features

- **User Authentication**: Sign in or register using Firebase Authentication.
- **Anonymous Posting**: Users can share their thoughts without revealing their identity.
- **Like & Comment System**: Engage with posts by liking and commenting.
- **Real-time Updates**: Posts and comments update in real-time using Firestore.
- **User-friendly UI**: A clean and minimalistic design for easy navigation.

### Installation

1. **Clone the Repository**

   ```sh
   git clone https://github.com/your-username/echo_app.git
   cd echo_app
   ```

2. **Install Dependencies**

   ```sh
   flutter pub get
   ```

3. **Setup Firebase**

   - Run the following command to configure Firebase with your project:
     ```sh
     flutterfire configure
     ```
   - This will generate `firebase_options.dart` inside the `lib` folder.
   - **Important**: Add `lib/firebase_options.dart` to `.gitignore` to keep credentials secure.

4. **Run the App**
   ```sh
   flutter run
   ```

## Project Structure

```
/lib
│-- auth/
│   ├── auth.dart
│   ├── login_or_register.dart
│-- components/
│   ├── my_button.dart
│   ├── comment.dart
│   ├── comment_button.dart
│   ├── like_button.dart
│   ├── my_drawer.dart
│   ├── my_list_tile.dart
│   ├── my_text_box.dart
│   ├── my_text_field.dart
│-- helper/
│   ├── helper_methods.dart
│-- pages/
│   ├── home_page.dart
│   ├── login_page.dart
│   ├── register_page.dart
│-- main.dart
```

## Tech Stack

- **Flutter** - UI Framework
- **Dart** - Programming Language
- **Firebase Authentication** - User Authentication
- **Cloud Firestore** - NoSQL Database

## Contributions

Contributions are welcome! Feel free to fork the project and submit a pull request.

## License

This project is licensed under the MIT License.
