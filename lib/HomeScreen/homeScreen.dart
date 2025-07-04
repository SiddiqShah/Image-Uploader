import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<XFile> images = [];
  final _picker = ImagePicker();
  bool showSpiner = false;

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  // Load image paths from shared preferences
  Future<void> loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePaths = prefs.getStringList('saved_images') ?? [];
    setState(() {
      images = imagePaths.map((path) => XFile(path)).toList();
    });
  }

  // Save image paths to shared preferences
  Future<void> saveImages() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePaths = images.map((img) => img.path).toList();
    await prefs.setStringList('saved_images', imagePaths);
  }

  Future<void> getImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 80);

    if (pickedFiles.isNotEmpty) {
      setState(() {
        images.addAll(pickedFiles);
      });
      await saveImages();
    } else {
      print('no images selected');
    }
  }

  Future<void> uploadImages() async {
    if (images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select images first')),
      );
      return;
    }

    setState(() {
      showSpiner = true;
    });

    var uri = Uri.parse('https://fakestoreapi.com/products');
    var request = MultipartRequest('POST', uri);
    request.fields['title'] = 'Static title';

    for (var img in images) {
      var multipartFile = await MultipartFile.fromPath('image', img.path);
      request.files.add(multipartFile);
    }

    var response = await request.send();

    setState(() {
      showSpiner = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Images uploaded')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Upload failed')));
    }
  }

  Future<void> removeImage(int index) async {
    setState(() {
      images.removeAt(index);
    });
    await saveImages();
  }

  Future<void> clearAllImages() async {
    setState(() {
      images.clear();
    });
    await saveImages();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpiner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Image Uploader'),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
        ),
        backgroundColor: const Color.fromARGB(255, 224, 224, 224),
        body: Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: images.isNotEmpty
                  ? GridView.builder(
                      itemCount: images.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) => Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(images[index].path),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => removeImage(index),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: Text('No images selected')),
            ),
            Container(
              height: 75,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Upload images button
                    GestureDetector(
                      onTap: uploadImages,
                      child: Container(
                        height: 50,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Upload\nPictures',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Add images button
                    GestureDetector(
                      onTap: getImages,
                      child: Container(
                        height: 50,
                        width: 75,
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Clear all images button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: images.isNotEmpty ? clearAllImages : null,
                        icon: const Icon(Icons.delete_forever),
                        label: const Text('Clear All Images'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(200, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
