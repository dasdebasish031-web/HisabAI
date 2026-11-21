
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(HisabAI(
    initialLanguage: prefs.getString('language'),
  ));
}

class HisabAI extends StatefulWidget {
  final String? initialLanguage;

  const HisabAI({super.key, this.initialLanguage});

  @override
  State<HisabAI> createState() => _HisabAIState();
}

class _HisabAIState extends State<HisabAI> {
  String? language;

  @override
  void initState() {
    super.initState();
    language = widget.initialLanguage;
  }

  Future<void> selectLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);

    setState(() {
      language = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hisab AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: language == null
          ? LanguageScreen(onSelected: selectLanguage)
          : HomePage(
              language: language!,
              onChangeLanguage: () {
                setState(() {
                  language = null;
                });
              },
            ),
    );
  }
}

class LanguageScreen extends StatelessWidget {
  final Function(String) onSelected;

  const LanguageScreen({
    super.key,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.teal,
                  size: 75,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Hisab AI',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Choose Your Language',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'আপনার পছন্দের ভাষা নির্বাচন করুন',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 28),
                languageButton(
                  'বাংলা',
                  'বাংলায় নমস্কার!',
                  'আপনার ব্যবসার হিসাব রাখুন সহজে।',
                  'বাংলা',
                ),
                const SizedBox(height: 14),
                languageButton(
                  'हिन्दी',
                  'नमस्ते!',
                  'अपने व्यवसाय का हिसाब आसानी से रखें।',
                  'हिन्दी',
                ),
                const SizedBox(height: 14),
                languageButton(
                  'English',
                  'Hello!',
                  'Manage your business easily.',
                  'English',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget languageButton(
    String name,
    String greeting,
    String description,
    String value,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onSelected(value),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: 19,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String language;
  final VoidCallback onChangeLanguage;

  const HomePage({
    super.key,
    required this.language,
    required this.onChangeLanguage,
  });

  String get greeting {
    if (language == 'বাংলা') return 'বাংলায় নমস্কার!';
    if (language == 'हिन्दी') return 'नमस्ते!';
    return 'Hello!';
  }

  String get subtitle {
    if (language == 'বাংলা') return 'আপনার ব্যবসার হিসাব রাখুন সহজে।';
    if (language == 'हिन्दी') return 'अपने व्यवसाय का हिसाब आसानी से रखें।';
    return 'Manage your business easily.';
  }

  String get balance {
    if (language == 'বাংলা') return 'বর্তমান ব্যালেন্স';
    if (language == 'हिन्दी') return 'वर्तमान बैलेंस';
    return 'Current Balance';
  }

  String get income {
    if (language == 'বাংলা') return 'মোট আয়';
    if (language == 'हिन्दी') return 'कुल आय';
    return 'Total Income';
  }

  String get expense {
    if (language == 'বাংলা') return 'মোট খরচ';
    if (language == 'हिन्दी') return 'कुल खर्च';
    return 'Total Expense';
  }

  String get quickActions {
    if (language == 'বাংলা') return 'দ্রুত হিসাব যোগ করুন';
    if (language == 'हिन्दी') return 'जल्दी हिसाब जोड़ें';
    return 'Quick Actions';
  }

  String get addIncome {
    if (language == 'বাংলা') return 'আয় যোগ';
    if (language == 'हिन्दी') return 'आय जोड़ें';
    return 'Add Income';
  }

  String get addExpense {
    if (language == 'বাংলা') return 'খরচ যোগ';
    if (language == 'हिन्दी') return 'खर्च जोड़ें';
    return 'Add Expense';
  }

  String get otherFeatures {
    if (language == 'বাংলা') return 'অন্যান্য সুবিধা';
    if (language == 'हिन्दी') return 'अन्य सुविधाएँ';
    return 'Other Features';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F7),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text(
          'Hisab AI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Language',
            onPressed: onChangeLanguage,
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(subtitle),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    balance,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '₹ 0.00',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: summaryCard(
                    income,
                    Colors.green,
                    Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: summaryCard(
                    expense,
                    Colors.red,
                    Icons.trending_down,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              quickActions,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: actionCard(
                    addIncome,
                    Colors.green,
                    Icons.add_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: actionCard(
                    addExpense,
                    Colors.red,
                    Icons.remove_circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              otherFeatures,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            menuTile(
              Icons.receipt_long,
              language == 'বাংলা'
                  ? 'লেনদেনের তালিকা'
                  : language == 'हिन्दी'
                      ? 'लेन-देन सूची'
                      : 'Transactions',
            ),
            menuTile(
              Icons.bar_chart,
              language == 'বাংলা'
                  ? 'মাসিক রিপোর্ট'
                  : language == 'हिन्दी'
                      ? 'मासिक रिपोर्ट'
                      : 'Monthly Report',
            ),
            menuTile(
              Icons.smart_toy,
              language == 'বাংলা'
                  ? 'AI সহকারী'
                  : language == 'हिन्दी'
                      ? 'AI सहायक'
                      : 'AI Assistant',
            ),
          ],
        ),
      ),
    );
  }

  Widget summaryCard(String title, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 5),
          Text(
            '₹ 0.00',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget actionCard(String title, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget menuTile(IconData icon, String title) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 9),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal, size: 28),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
