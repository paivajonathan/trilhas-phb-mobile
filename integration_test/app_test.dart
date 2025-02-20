import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:trilhas_phb/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App starts and shows home screen', (WidgetTester tester) async {
    await dotenv.load();
    await tester.pumpWidget(const MainApp()); // Replace with your main widget
    await tester.pumpAndSettle();

    expect(find.text('Bem Vindo(a)!'), findsOneWidget); // Adjust based on UI
  });
}
