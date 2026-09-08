import 'package:easy_search_bar_2/easy_search_bar_2.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchValue = '';
  final List<String> _suggestions = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Australia',
    'Brazil',
    'Germany',
    'Madagascar',
    'Mozambique',
    'Portugal',
    'Zambia',
  ];

  Future<List<String>> _fetchSuggestions(String searchValue) async {
    await Future.delayed(const Duration(milliseconds: 750));

    return _suggestions
        .where(
          (element) =>
              element.toLowerCase().contains(searchValue.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Example',
        theme: ThemeData(primarySwatch: Colors.orange),
        home: Scaffold(
          appBar: EasySearchBar2(
            title: const Text('Example'),
            onSearch: (value) => setState(() => searchValue = value),
            actions: [
              IconButton(icon: const Icon(Icons.person), onPressed: () {}),
            ],
            asyncSuggestions: (value) async => _fetchSuggestions(value),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Drawer Header'),
                ),
                ListTile(
                  title: const Text('Item 1'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  title: const Text('Item 2'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          body: Center(child: Text('Value: $searchValue')),
        ),
      );
}
