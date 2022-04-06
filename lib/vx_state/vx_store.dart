import 'package:dot_now/models/auth.dart';
import 'package:vxstate/vxstate.dart';

class MyStore extends VxStore {
  final auth = AuthModel();
}

class Increment extends VxMutation<MyStore> {
  perform() {}
}
