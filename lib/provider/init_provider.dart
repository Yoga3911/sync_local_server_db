import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tugas_paa/provider/state_provide.dart';
import 'package:tugas_paa/provider/user_provider.dart';

class InitProvider {
  InitProvider._();
  static final data = <SingleChildWidget>[
    ChangeNotifierProvider(
      create: (_) => UserProvier(),
    ),
    ChangeNotifierProvider(
      create: (_) => MyState(),
    ),
  ];
}
