import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_car_app_firebase/models/car_post_model.dart';
import '../services/rtdb_service.dart';
import '../services/storage_service.dart';
import '../services/util.dart';
enum DetailState {
  create,
  update,
}
class AddCarPage extends StatefulWidget {

  static const String id  = 'add_car_page';
  final DetailState state;
  final PostCarModel? post;
  const AddCarPage({Key? key, this.state = DetailState.create, this.post}) : super(key: key);

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  TextEditingController cardBrandController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  TextEditingController carPriceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool isLoading = false;
  PostCarModel? updatePost;


  // for image
  final ImagePicker _picker = ImagePicker();
  File? file;

  @override
  void initState() {
    super.initState();
    _detectState();
  }

  void _detectState() {
    if (widget.state == DetailState.update && widget.post != null) {
      updatePost = widget.post;
      cardBrandController.text = updatePost!.carBrand;
      carModelController.text = updatePost!.carModel;
      carPriceController.text = updatePost!.price;
      descriptionController.text = updatePost!.description;
      dateController.text = updatePost!.date;
      setState(() {});
    }
  }

  void _getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        file = File(image.path);
      });
    } else {
      if (mounted) Utils.fireSnackBar("Please select image for post", context);
    }
  }


  void _addPost()async{
    String carModel = carModelController.text.trim();
    String carBrand = cardBrandController.text.trim();
    String carPrice = carPriceController.text.trim();
    String carDescription = descriptionController.text.trim();
    String date = dateController.text.trim();
    String? imageUrl;

    if (carModel.isEmpty ||
        carBrand.isEmpty ||
        carDescription.isEmpty ||
        carPrice.isEmpty ||
        date.isEmpty) {
      Utils.fireSnackBar("Please fill all fields", context);
      return;
    }
    isLoading = true;
    setState(() {});

    if (file != null) {
      imageUrl = await StorageService.uploadImage(file!);
    }
    PostCarModel post = PostCarModel(
        postKey: '',
        carBrand: carBrand,
        carModel: carModel,
        price: carPrice,
        date: date,
        description: carDescription,
      image: imageUrl
    );

    await RTDBService.storePost(post).then((value) {
      Navigator.of(context).pop();
    });

    isLoading = false;
    setState(() {});
  }


  void _updatePost()async{
    String carModel = carModelController.text.trim();
    String carBrand = cardBrandController.text.trim();
    String carPrice = carPriceController.text.trim();
    String carDescription = descriptionController.text.trim();
    String date = dateController.text.trim();
    String? imageUrl;


    if(carBrand.isEmpty || carModel.isEmpty || carPrice.isEmpty || carDescription.isEmpty || date.isEmpty){
      Utils.fireSnackBar("Please fill all gaps", context);
      return;
    }
    isLoading = true;
    setState(() {});

    if (file != null) {
      imageUrl = await StorageService.uploadImage(file!);
    }

    PostCarModel post = PostCarModel(
        postKey: updatePost!.postKey,
        // userId: updatePost!.userId,
        carBrand: carBrand,
        carModel: carModel,
        price: carPrice,
        date: date,
        description: carDescription,
       image: imageUrl ?? updatePost!.image
    );
    await RTDBService.updatePost(post).then((value) {
      Navigator.of(context).pop();
    });

    isLoading = false;
    setState(() {});
  }

  void _selectDate() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2122),
    ).then((date) {
      if (date != null) {
        dateController.text = date.toString();
      }
    });
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade800,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade800,
        title: widget.state == DetailState.update
            ? const Text("Update Post")
            : const Text("Add Post"),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // #image
                  GestureDetector(
                    onTap: _getImage,
                    child: SizedBox(
                      height: 130,
                      width: 130,
                      child: (updatePost != null &&
                          updatePost!.image != null &&
                          file == null)
                          ? Image.network(updatePost!.image!)
                          : (file == null
                          ? const Image(
                        image: AssetImage("assets/images/logo.png"),
                      )
                          : Image.file(file!)),

              ),
                    ),

                  const SizedBox(
                    height: 20,
                  ),

                  // #carBrand
                  TextField(
                    controller: cardBrandController,
                    decoration: const InputDecoration(
                      hintText: "Car Brand",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),


                  // #carModel
                  TextField(
                    controller: carModelController,
                    decoration: const InputDecoration(
                      hintText: "Car Model",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #carPrice
                  TextField(
                    controller: carPriceController,
                    decoration: const InputDecoration(
                      hintText: "Price",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // #carDescription
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: "Description",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(
                    height: 20,
                  ),


                  // #date
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    onTap: _selectDate,
                    decoration: const InputDecoration(
                      hintText: "Date",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  ElevatedButton(
                    onPressed: () {
                      if (widget.state == DetailState.update) {
                        _updatePost();
                      } else {
                        _addPost();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF000428),
                      shape: StadiumBorder(),
                        minimumSize: const Size(double.infinity, 50)),
                    child: Text(
                      widget.state == DetailState.update ? "Update" : "Add",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),

    );
  }
}
