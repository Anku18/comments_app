import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaeRemote {
  FirebaeRemote.init();
  static final FirebaeRemote instance = FirebaeRemote.init();

  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 1000),
        minimumFetchInterval: const Duration(seconds: 1)));
    await remoteConfig.setDefaults(<String, dynamic>{
      'showDiscountedPrice': false, // Default value
    });

    try {
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Failed to fetch remote config: $e');
    }
  }

  bool get showDiscountedPrice => remoteConfig.getBool("showDiscountedPrice");
}
