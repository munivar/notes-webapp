import 'package:get_storage/get_storage.dart';

class AppStorage {
  // Storing data in Get Storage
  static Future<void> setData<T>(String key, T value) async {
    await GetStorage().write(key, value);
  }

  // Getting data from Get Storage
  Future<T?> getData<T>(String key) async {
    return GetStorage().read<T>(key);
  }

  // Removing data from Get Storage
  Future<void> remove(String key) async {
    await GetStorage().remove(key);
  }

  // Removing all data from Get Storage
  Future<void> removeAllData() async {
    await GetStorage().erase();
  }
}
