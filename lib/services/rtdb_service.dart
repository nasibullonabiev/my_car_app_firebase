import 'package:firebase_database/firebase_database.dart';
import 'package:my_car_app_firebase/models/car_post_model.dart';

class RTDBService{
  static final  database = FirebaseDatabase.instance.ref();


  static Future<Stream<DatabaseEvent>> storePost(PostCarModel post)async{
    String? key = database.child('posts').push().key;
    post.postKey = key!;
    await database.child('posts').child(post.postKey).set(post.toJson());
    return database.onChildAdded;
  }

  static Future<List<PostCarModel>> loadPosts({String? id})async{
    List<PostCarModel> items = [];
    DatabaseReference reference = database.child('posts');

    var snapshot  = await reference.get();
    var result = snapshot.children;
    for(DataSnapshot item in result) {
      if(item.value != null) {
        items.add(PostCarModel.fromJson(Map<String, dynamic>.from(item.value as Map)));
      }
    }

    return items;

  }

  static Future<void> deletePost(String postKey) async {
    await database.child("posts").child(postKey).remove();
  }


  static Future<Stream<DatabaseEvent>> updatePost(PostCarModel post) async {
    await database.child("posts").child(post.postKey).set(post.toJson());
    return database.onChildAdded;
  }
}
