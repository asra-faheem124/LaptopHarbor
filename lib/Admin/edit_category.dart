import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laptop_harbor/Admin/admin_category.dart';
import 'package:laptop_harbor/controller/categoryController.dart';
import 'package:laptop_harbor/model/category_model.dart';
import 'package:laptop_harbor/userPanel/Widgets/SnackBar.dart';
import 'package:laptop_harbor/userPanel/Widgets/button.dart';
import 'package:laptop_harbor/userPanel/constant.dart';

class EditCategoryPage extends StatefulWidget {
  final CategoryModel categoryModel;

  const EditCategoryPage({super.key, required this.categoryModel});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  final Categorycontroller categorycontroller = Get.put(Categorycontroller());
  final TextEditingController categoryName = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    super.initState();
    categoryName.text = widget.categoryModel.categoryName;
  }

  @override
  Widget build(BuildContext context) {
    Uint8List defaultImage = base64Decode(widget.categoryModel.categoryImage);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
               Admin_Heading(title: 'Edit Category'),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: categoryName,
                          decoration: const InputDecoration(
                            hintText: 'Enter your category name',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your category name';
                            }
                            if (value.length < 3) {
                              return 'Name must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () async {
                            image = await imagePicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            setState(() {});
                          },
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              image: image != null
                                  ? DecorationImage(
                                      image: FileImage(File(image!.path)),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: MemoryImage(defaultImage),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            alignment: Alignment.center,
                            child: image == null
                                ? const Text(
                                    'Tap to upload a new image',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                : Text(image!.name),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: MyButton(
                            title: 'Update',
                            height: 50.0,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Uint8List updatedImage = image != null
                                    ? await image!.readAsBytes()
                                    : defaultImage;

                                await categorycontroller.updateCategory(
                                  categoryId: widget.categoryModel.categoryId,
                                  categoryName: categoryName.text.trim(),
                                  categoryImage: updatedImage,
                                );

                                greenSnackBar('Updated', 'Category updated successfully.');
                                Get.off(() => AdminCategoryPage());
                              } else {
                                redSnackBar('Error', 'Please fill out all fields correctly.');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
