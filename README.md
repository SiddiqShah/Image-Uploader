# Image Uploader

A simple Flutter application to pick, display, persist, and upload images from your device gallery.

## Features

- Pick multiple images from device gallery  
- Display images in a grid  
- Remove individual images or clear all  
- Persistent storage of image selection  
- Upload images to a demo API endpoint

## Getting Started

1. **Clone this repository**
2. **Install dependencies**
   ```bash
   flutter pub get
   ```
3. **Run the app**
   ```bash
   flutter run
   ```

## Dependencies

- [image_picker](https://pub.dev/packages/image_picker)
- [modal_progress_hud_nsn](https://pub.dev/packages/modal_progress_hud_nsn)
- [http](https://pub.dev/packages/http)
- [shared_preferences](https://pub.dev/packages/shared_preferences)

## API

Uploads images to the [Fake Store API](https://fakestoreapi.com/docs), using:
```
https://fakestoreapi.com/products
```
You can read more about the API in their [official documentation](https://fakestoreapi.com/docs).


# 1. High-Level Flow Diagram

+-------------------+
|   User Interface  |
|  (Flutter Widget) |
+-------------------+
          |
          v
+-------------------+         +---------------------+
|  User Taps Button |-------> |  Image Picker Opens |
+-------------------+         +---------------------+
          |                            |
          v                            v
+-----------------------------------------------+
|  User selects images from gallery             |
+-----------------------------------------------+
          |
          v
+-------------------+    +------------------------+
| Images List in    |<---| Shared Preferences     |
| App State         |    | (save image paths)     |
+-------------------+    +------------------------+
          |
          v
+----------------------------+
| Display Images in GridView |
+----------------------------+
          |
          v
+--------------------------------------------+
| User taps:                                 |
|   "Upload" --> Send images to API          |
|   "Clear All" --> Remove all images        |
|   "X" on image --> Remove one image        |
+--------------------------------------------+


# 2. Button and API call flow
      +------------------+
      |   Upload Button  |
      +------------------+
               |
               v
    +--------------------------+
    |   Collect all images     |
    +--------------------------+
               |
               v
    +---------------------------+
    |  Create POST API request  |
    |  (https://fakestoreapi...)|
    +---------------------------+
               |
               v
    +------------------+
    |   API Response   |
    +------------------+
          |        |
   Success|        |Failure
          v        v
   Show success   Show failure
   message        message


# 3. Widget Tree
Scaffold
 ├── AppBar
 ├── Column
 │    ├── SizedBox
 │    ├── Expanded
 │    │     └── GridView (shows images)
 │    └── Container (Row of buttons)
 │          ├── Upload
 │          ├── Add
 │          └── Clear All

 
