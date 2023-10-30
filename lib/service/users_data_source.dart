import 'package:tugas2/service/base_network.dart';

class UsersDataSource {
  static UsersDataSource instance = UsersDataSource();

  Future<Map<String, dynamic>> loadUsers() {
    return BaseNetwork.get("users");
  }

  Future<Map<String, dynamic>> loadDetailUser(int idDiterima) {
    String id = idDiterima.toString();
    return BaseNetwork.get("users/$id");
  }
}
