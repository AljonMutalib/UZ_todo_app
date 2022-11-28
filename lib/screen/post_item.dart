import 'package:flutter/material.dart';

import '../data/connect.dart';
import '../model/post_model.dart';
import 'post_form.dart';
import 'post_page.dart';

class PostItem extends StatelessWidget {
  const PostItem({super.key, required this.post});

  final PostModel post; //requested value of PostModel

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) {
            return PostFormPage(
              //pass value of PostModel
              postModel: post,
              //pass value of Form Mode @ post_form.dart
              mode: PostFormMode.edit,
            );
          }),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: const Color(0xFFF1EEE9),
                          height: 64,
                          width: 64,
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFF0F3460),
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              //display value of title
                              post.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F3460),
                              ),
                            ),
                            Text(
                              //display value of description
                              post.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      //Edit Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) {
                              return PostFormPage(
                                //pass value of PostModel
                                postModel: post,
                                //pass value of Form Mode @ post_form.dart
                                mode: PostFormMode.edit,
                              );
                            }),
                          );
                        },
                        child: const Text('Edit'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      //Delete Buttton
                      ElevatedButton(
                        onPressed: () async {
                          //connect to Class of MySql @ data/connect.dart
                          var db = MySql();
                          //connect to getConnection function @ data/connect.dart
                          var conn = await db.getConnection();
                          //Delete Query
                          await conn.execute(
                            'DELETE FROM post_tbl WHERE ID= :id',
                            {'id': post.id},
                          ).then((value) {
                            //if success this codes will run
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => PostPage(),
                              ),
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
