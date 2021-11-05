# mylocation

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Add this to your additional arguments:

```
--no-sound-null-safety
```

If using vscode. 
I. run `flutter run --no-sound-null-safety`
II. create .vscode/launch.json in project root and add

```
"args": [
     "--no-sound-null-safety"
    ]
complete code :-

    "version": "0.2.0",
    "configurations": [
            {
                    "name": "YOUR_PROJECT_NAME",
                    "program": "lib/main.dart",
                    "request": "launch",
                    "type": "dart",
                    "args": [
                            "--no-sound-null-safety"
                        ]
            }
    ]
```