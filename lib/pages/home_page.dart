import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_car_app_firebase/pages/detail_page.dart';
import '../models/car_post_model.dart';
import '../services/auth_service.dart';
import '../services/rtdb_service.dart';
import 'add_car_page.dart';

class HomePage extends StatefulWidget {
  static const String id  = 'home_page';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<PostCarModel> items = [];


  @override
  void initState() {
    super.initState();
    _getAllPost();
  }




  void _getAllPost() async {
    isLoading = true;
    setState(() {});


    items = await RTDBService.loadPosts();

    isLoading = false;
    setState(() {});
  }

  void _logout() {
    AuthService.signOutUser(context);
  }

  void _openAddCarPage() {
    Navigator.pushNamed(context, AddCarPage.id);
  }

  void _deleteDialog(String postKey) async {
    showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: const Text("Delete Post"),
            content: const Text("Do you want to delete this post?"),
            actions: [
              CupertinoDialogAction(
                onPressed: () => _deletePost(postKey),
                child: const Text("Confirm"),
              ),
              CupertinoDialogAction(
                onPressed: _cancel,
                child: const Text("Cancel"),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text("Delete Post"),
            content: const Text("Do you want to delete this post?"),
            actions: [
              TextButton(
                onPressed: () => _deletePost(postKey),
                child: const Text("Confirm"),
              ),
              TextButton(
                onPressed: _cancel,
                child: const Text("Cancel"),
              ),
            ],
          );
        }
      },
    );
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _deletePost(String postKey) async {
    Navigator.pop(context);
    isLoading = true;
    setState(() {});

    await RTDBService.deletePost(postKey);
    _getAllPost();
  }

  void _editPost(PostCarModel post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddCarPage(
            state: DetailState.update,
            post: post,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF004e92),
      appBar: AppBar(
        centerTitle: false,
        title: const Text("My Cars",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w800),),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient:LinearGradient(
              begin: Alignment.topRight,
                end: Alignment.bottomLeft,

                colors: [
                  Color(0xFF004e92),
                  Color(0xFF000428),
                ]
            ),
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(CupertinoIcons.add,size: 30,),
              onPressed: _openAddCarPage,
            ),
          )
        ],

        bottom: PreferredSize(
          preferredSize: const Size(200, 30),
          child: Column(
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 200),
                child: Text("Choose Cars",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30,fontStyle: FontStyle.italic),),
              ),


            ],
          )
        ),


      ),

      drawer: Drawer(
        backgroundColor: Colors.indigo,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),

            const SizedBox(height: 600,),

            Container(
              alignment: Alignment.bottomLeft,
              margin: const EdgeInsets.symmetric(horizontal: 60),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent
                ),
                  onPressed: _logout, child: const Text("Log Out")),
            )

          ],
        ),
      ),
    body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context,index){
              return _itemOfList(items[index]);


          }),
        ),

        Expanded(child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF004e92),
                  Color(0xFF000428),
                ],
            )
          ),
          child: Column(

            children: [
              Text("Top Dealers")
            ],
          ),

        ))
      ],
    ),



    );

  }


  Widget _itemOfList(PostCarModel postCarModel){
    return GestureDetector(
      onLongPress: () => _deleteDialog(postCarModel.postKey),
      onDoubleTap: () => _editPost(postCarModel),
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) => DetailPage(post: postCarModel)));
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30)
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Card(
            color: Colors.indigo.shade800,
            child: Column(
              children: [
                // postCarModel.image != null ? Image.network(postCarModel.image!,height: 360,fit: BoxFit.cover,alignment: Alignment.topCenter,) :  Image.asset("assets/images/image_placeholder.jpeg",height: 360,fit: BoxFit.cover,alignment: Alignment.topCenter,),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Hero(
            tag: postCarModel.image != null ? Image.network(postCarModel.image!,height: 360,fit: BoxFit.cover,alignment: Alignment.topCenter,) :  Image.asset("assets/images/image_placeholder.jpeg",height: 200,fit: BoxFit.cover),
                  child : postCarModel.image != null ? Image.network(postCarModel.image!,height: 360,fit: BoxFit.cover,alignment: Alignment.topCenter,) :  Image.asset("assets/images/image_placeholder.jpeg",height: 200,fit: BoxFit.cover)),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:20),
                      child: Text( "${postCarModel.carBrand} ${postCarModel.carModel}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white),),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                const Text("Starts from:",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w800,color: Colors.white),),
                Text("\$ ${postCarModel.price}",style: const TextStyle(fontWeight: FontWeight.w800,fontStyle: FontStyle.italic,color: Colors.white),),

                const Divider(),

              ],
            ),
          ),
        )
      ),
    );
  }
}
