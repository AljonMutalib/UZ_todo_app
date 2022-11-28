import 'package:mysql_client/mysql_client.dart';

class MySql {
  //Create a custom class
  Future<MySQLConnection> getConnection() async {
    //create a function to connect to MySql DB
    final conn = await MySQLConnection.createConnection(
      //create connection to MySql DB
      host: '127.0.0.1', //IP address of Apache Server
      port: 3306, //MySql port enrty
      userName: '', //Username of the PhpMyAdmin
      password: '', //Password of the PhpMyAdmin
      databaseName: 'todo_app', //Database Name
    ).timeout(const Duration(seconds: 30)); //Connection Timeout

    await conn.connect(); //waiting for connection
    return conn; //Return connection
  }
}
