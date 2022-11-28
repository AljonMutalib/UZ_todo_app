import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../data/connect.dart';
import '../model/post_model.dart';

enum PostFormMode {
  //Enumeration of what to do.
  add, //for Add Form
  edit, // for Edit Form
}

class PostFormPage extends StatefulWidget {
  final PostModel? postModel; //requested value of PostModel
  final PostFormMode mode; //requested value of Form Mode (Add or Edit)

  const PostFormPage({
    super.key,
    this.postModel,
    this.mode = PostFormMode.add,
  });

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _title = TextEditingController(); //Controller for title textbox
  final _description =
      TextEditingController(); //controller for description textbox

  // Called only on first time
  @override
  void initState() {
    //if form mode is equal to Edit
    if (widget.mode == PostFormMode.edit) {
      //if PostModel is not null
      if (widget.postModel != null) {
        //add value of PostModel Title/Description to Textbox Controller
        _title.text = widget.postModel!.title;
        _description.text = widget.postModel!.description;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            //if Form Mode is equal to Add, display New Item else display Edit Item
            widget.mode == PostFormMode.add ? 'New Item' : 'Edit Item',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    //Title Textbox
                    child: TextField(
                      //This controller refer to line 28 this code.
                      controller: _title,
                      decoration: const InputDecoration(label: Text('Title')),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    //Description Textbox
                    child: TextField(
                      //Maxlines number of breakline down
                      maxLines: 5,
                      //This controller refer to line 29 this code
                      controller: _description,
                      decoration: const InputDecoration(
                        label: Text('Description'),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                //this CustomButton refer to widgets/custom_button.dart
                child: CustomButton(
                  //if Form Mode is equal to Add, display caption of button Save, else Update
                  title: widget.mode == PostFormMode.add ? 'Save' : 'Update',
                  //Pass function or voidcallback to widgets/custom_button.dart
                  onItemPressed: () async {
                    //connect to Class of MySql @ data/connect.dart
                    var db = MySql();
                    //connect to getConnection function @ data/connect.dart
                    var conn = await db.getConnection();
                    //if title and description is not empty
                    if (_title.text.isNotEmpty &&
                        _description.text.isNotEmpty) {
                      //if Form Mode is equal to Add
                      if (widget.mode == PostFormMode.add) {
                        //Insert Query to Mysql Database
                        await conn.execute(
                          'INSERT INTO post_tbl (title,description) VALUES (:title, :description)',
                          {
                            //this is equal to :title, Line 116
                            'title': _title.text,
                            //this is equal to :description, Line 116
                            'description': _description.text,
                          },
                          //after insert will run this code
                        ).then((value) {
                          print('Successfully Added Record!');
                        });
                        //if Form Mode is equal to Edit
                      } else if (widget.mode == PostFormMode.edit) {
                        //Update Query to Mysql Database
                        await conn.execute(
                          "UPDATE post_tbl SET title = :title, description = :description WHERE ID = :id",
                          {
                            //this is equal to :title, Line 131
                            'title': _title.text,
                            //this is equal to :description, Line 131
                            'description': _description.text,
                            //this is equal to :id, Line 131
                            'id': widget.postModel!.id
                          },
                          //after updating will run this code
                        ).then((value) {
                          print('Successfully Updated Record');
                        });
                      }
                    } else {
                      //if title and description is empty
                      print('Empty Field');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
