import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tugas2/model/users_model.dart';
import 'package:tugas2/service/users_data_source.dart';

class PageDetailUsers extends StatefulWidget {
  final Map<String, dynamic> detailUser;

  const PageDetailUsers({super.key, required this.detailUser});

  @override
  State<PageDetailUsers> createState() => _PageDetailUsers();
}

class _PageDetailUsers extends State<PageDetailUsers> {
  @override
  Widget build(BuildContext context) {
    final userData = widget.detailUser['data'];
    final users = Data.fromJson(userData);
    return Scaffold(
      appBar: AppBar(
        title: users.id != null
            ? Text(
                "Detail User ${users.id!}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            : Text("ID user tidak ditemukan"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.teal.shade200,
              Colors.teal.shade100,
              Colors.teal.shade50,
            ],
          ),
        ),
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        height: double.infinity,
        child: _buildDetailUsersBody(),
      ),
    );
  }

  Widget _buildDetailUsersBody() {
    return Container(
      padding: const EdgeInsets.all(5),
      child: FutureBuilder(
        future: UsersDataSource.instance.loadUsers(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingSection();
          } else if (snapshot.hasError) {
            debugPrint(snapshot.toString());
            return _buildErrorSection();
          } else if (snapshot.hasData) {
            return _buildSuccessSection();
          } else {
            return const ListTile(
              title: Text("Data User tidak ditemukan"),
            );
          }
        },
      ),
    );
  }

  Widget _buildErrorSection() {
    return Text("Data Error");
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection() {
    final userData = widget.detailUser['data'];
    final userSupport = widget.detailUser['support'];
    final users = Data.fromJson(userData);
    final support = Support.fromJson(userSupport);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: users.avatar != null
                ? Image(image: NetworkImage(users.avatar!))
                : Text("Gambar tidak tersedia"),
            padding: const EdgeInsets.all(12),
          ),
          SizedBox(
            child: Column(
              children: [
                users.firstName != null && users.lastName != null
                    ? Text(
                        users.firstName! + " " + users.lastName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )
                    : Text("Nama user tidak ditemukan"),
                users.email != null
                    ? Text(
                        users.email!,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      )
                    : Text("Email user tidak tersedia"),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 15),
            child: support.text != null
                ? Text(
                    support.text!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  )
                : Text("Text tidak tersedia"),
          ),
        ],
      ),
    );
  }
}
