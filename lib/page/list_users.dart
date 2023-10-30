import 'package:tugas2/page/detail_users.dart';
import 'package:tugas2/service/users_data_source.dart';
import 'package:tugas2/model/users_model.dart';
import 'package:flutter/material.dart';

class PageListUsers extends StatefulWidget {
  const PageListUsers({Key? key}) : super(key: key);

  @override
  State<PageListUsers> createState() => _PageListUsersState();
}

class _PageListUsersState extends State<PageListUsers> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Users",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
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
        padding: const EdgeInsets.all(1),
        child: _buildListUsersBody(),
      ),
    );
  }

  Widget _buildListUsersBody() {
    return Container(
      child: FutureBuilder(
        future: UsersDataSource.instance.loadUsers(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          } else if (snapshot.hasData) {
            UsersModel usersModel = UsersModel.fromJson(snapshot.data);
            return _buildSuccessSection(usersModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildErrorSection() {
    return Text('Data Error');
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(UsersModel data) {
    return ListView.builder(
      itemCount: data.data!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemUsers(data.data![index]);
      },
    );
  }

  Widget _buildItemUsers(Data userData) {
    return InkWell(
      onTap: () async {
        final id = userData.id;
        final detailData = await UsersDataSource.instance.loadDetailUser(id!);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PageDetailUsers(detailUser: detailData);
        }));
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.shade300,
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                width: 120,
                child: Image.network(userData.avatar!),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    userData.firstName! + " " + userData.lastName!,
                  ),
                  Text(
                    style: const TextStyle(fontSize: 14),
                    userData.email!,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
