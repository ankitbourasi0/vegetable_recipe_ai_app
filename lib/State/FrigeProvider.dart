import 'package:provider/provider.dart';

import 'Fridge.dart';

class FridgeProvider extends ChangeNotifierProvider<Fridge> {
  FridgeProvider() : super(create: (_) => Fridge());
}