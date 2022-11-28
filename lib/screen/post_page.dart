import 'package:flutter/material.dart';
import 'post_form.dart';
import 'post_item.dart';
import '../data/connect.dart';
import '../model/post_model.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  //Start of the function
  Future<List<PostModel>> getPost() async {
    List<PostModel> post =
        []; //Create list variables with PostModel Type @ model/post_model.dart
    var db = MySql(); //Call MySql function @ data/connect.dart
    var conn = await db
        .getConnection(); //await connection from getConnection function @ data/connect.dart
    var result = await conn
        .execute("select ID,title,description from post_tbl"); //MySql Query

    result.rowsStream.listen((row) {
      //Create a Loop
      final PostModel mypost = PostModel(
        //Create a variable that contains values from mysql and prepare to add to PostModel @ model/post_model.dart
        id: row.colByName('ID').toString(), //Constructor
        title: row.colByName('title').toString(), //Constructor
        description: row.colByName('description').toString(), //Constructor
      );
      post.add(mypost); //add every record to  List<PostModel> post
    });
    await conn.close(); //close connection to MySql DB
    return post; //return all record from List<PostModel> post to FutureBuilder Function
  }
  //End of the function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                //Navitagate to Post Form @ post_form.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return const PostFormPage(
                      //pass values of constructor to Post Form
                      postModel: null, //declare null value for PostModel
                      mode: PostFormMode.add, //declare Add for New Post Form
                    );
                  }),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<PostModel>>(
          future: getPost(), //Calls the fuction @ Line 16 this file
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              //While waiting for return value of getPost function
              return const CircularProgressIndicator(
                color: Color(0xFF124a8f),
              );
            } else if (snapshot.hasError) {
              //if has error
              return const Text('Something went wrong');
            }
            return ListView.builder(
              //if successful
              itemCount: snapshot.data!.length, //how many records
              itemBuilder: (context, index) {
                final mypost = snapshot.data![
                    index]; // create variables that contains records from getPost Function
                return PostItem(
                  post: mypost, // pass constructor to post_item.dart
                );
              },
            );
          },
        ),
      ),
    );
  }
}
