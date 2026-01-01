import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});


class HiveService {
  // init
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapter();
    await openBoxes();
  }

  // Register Adapter
  void _registerAdapter() {
    if(!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)){
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  // Open Boxes
  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  }

  // Close Boxes
  Future<void> close() async {
    await Hive.close();
  }


  //-------------------Auth Queries-----------------
  Box<AuthHiveModel> get _authBox => 
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  // Register
  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;
  }

  // Login
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
        (user) => user.email == email && user.password == password,
    );
    if(users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  // Logout
  Future<void> logoutUser() async {}

  // get current user
  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  // is email exists
  bool isEmailExists(String email) {
    final users =_authBox.values.where((user) => user.email == email);
    return users.isNotEmpty;
  }

  //-------------Splash Page---------------
  // Returns true if user has logged in
  // bool isUserLoggedIn() {
  //   return _authBox.values.isNotEmpty;
  // }
  Future<bool> isUserLoggedIn() async {
    final box = Hive.box<AuthHiveModel>(HiveTableConstant.authTable);
    return box.values.isNotEmpty;
  }
}