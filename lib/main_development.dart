import 'package:pingpongbuddy/app/app.dart';
import 'package:pingpongbuddy/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
