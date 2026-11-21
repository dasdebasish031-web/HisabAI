
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(HisabAI(initialLanguage: prefs.getString('language')));
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
    setState(() => language = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hisab AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: language == null
          ? LanguageScreen(onSelected: selectLanguage)
          : HomePage(
              language: language!,
              onChangeLanguage: () => setState(() => language = null),
            ),
    );
  }
}

class LanguageScreen extends StatelessWidget {
  final Function(String) onSelected;
  const LanguageScreen({super.key, required this.onSelected});

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
                const Icon(Icons.account_balance_wallet,
                    color: Colors.teal, size: 75),
                const SizedBox(height: 15),
                const Text('Hisab AI',
                    style: TextStyle(fontSize: 32,
                        fontWeight: FontWeight.bold, color: Colors.teal)),
                const SizedBox(height: 12),
                const Text('Choose Your Language',
                    style: TextStyle(fontSize: 21,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('আপনার পছন্দের ভাষা নির্বাচন করুন'),
                const SizedBox(height: 28),
                languageButton('বাংলা', 'নমস্কার!',
                    'আপনার ব্যবসার হিসাব রাখুন সহজে।', 'বাংলা'),
                const SizedBox(height: 14),
                languageButton('हिन्दी', 'नमस्ते!',
                    'अपने व्यवसाय का हिसाब आसानी से रखें।', 'हिन्दी'),
                const SizedBox(height: 14),
                languageButton('English', 'Hello!',
                    'Manage your business easily.', 'English'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget languageButton(
      String name, String greeting, String description, String value) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onSelected(value),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(children: [
              Text(name, style: const TextStyle(
                  fontSize: 23, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(greeting, style: const TextStyle(
                  fontSize: 19, color: Colors.teal)),
              const SizedBox(height: 4),
              Text(description),
            ]),
          ),
        ),
      ),
    );
  }
}

class HisabEntry {
  final String type;
  final double amount;
  final String note;
  final DateTime date;

  HisabEntry({
    required this.type,
    required this.amount,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'amount': amount,
    'note': note,
    'date': date.toIso8601String(),
  };

  factory HisabEntry.fromJson(Map<String, dynamic> json) {
    return HisabEntry(
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }
}

class HomePage extends StatefulWidget {
  final String language;
  final VoidCallback onChangeLanguage;

  const HomePage({
    super.key,
    required this.language,
    required this.onChangeLanguage,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HisabEntry> entries = [];
  bool loading = true;

  bool get bn => widget.language == 'বাংলা';
  bool get hi => widget.language == 'हिन्दी';

  String get greeting => bn ? 'নমস্কার!' : hi ? 'नमस्ते!' : 'Hello!';
  String get subtitle => bn
      ? 'আপনার ব্যবসার হিসাব রাখুন সহজে।'
      : hi ? 'अपने व्यवसाय का हिसाब आसानी से रखें।'
      : 'Manage your business easily.';
  String get balance => bn ? 'বর্তমান ব্যালেন্স' : hi ? 'वर्तमान बैलेंस' : 'Current Balance';
  String get income => bn ? 'মোট আয়' : hi ? 'कुल आय' : 'Total Income';
  String get expense => bn ? 'মোট খরচ' : hi ? 'कुल खर्च' : 'Total Expense';
  String get quickActions => bn ? 'দ্রুত হিসাব যোগ করুন' : hi ? 'जल्दी हिसाब जोड़ें' : 'Quick Actions';
  String get addIncome => bn ? 'আয় যোগ' : hi ? 'आय जोड़ें' : 'Add Income';
  String get addExpense => bn ? 'খরচ যোগ' : hi ? 'खर्च जोड़ें' : 'Add Expense';
  String get transactions => bn ? 'লেনদেনের তালিকা' : hi ? 'लेन-देन सूची' : 'Transactions';
  String get amountLabel => bn ? 'টাকার পরিমাণ' : hi ? 'राशि' : 'Amount';
  String get noteLabel => bn ? 'বিবরণ (যেমন: পণ্য বিক্রি)' : hi ? 'विवरण' : 'Description';
  String get saveLabel => bn ? 'সেভ করুন' : hi ? 'सेव करें' : 'Save';
  String get cancelLabel => bn ? 'বাতিল' : hi ? 'रद्द करें' : 'Cancel';
  String get recent => bn ? 'সাম্প্রতিক লেনদেন' : hi ? 'हाल के लेन-देन' : 'Recent Transactions';
  String get noEntries => bn ? 'এখনও কোনো হিসাব যোগ করা হয়নি।' : hi ? 'अभी कोई हिसाब नहीं जोड़ा गया।' : 'No transactions yet.';
  String get invalidAmount => bn ? 'সঠিক টাকার পরিমাণ লিখুন।' : hi ? 'सही राशि दर्ज करें।' : 'Please enter a valid amount.';

  double get totalIncome => entries
      .where((e) => e.type == 'income')
      .fold(0, (sum, e) => sum + e.amount);

  double get totalExpense => entries
      .where((e) => e.type == 'expense')
      .fold(0, (sum, e) => sum + e.amount);

  double get currentBalance => totalIncome - totalExpense;

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  Future<void> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('hisab_entries');
    if (saved != null) {
      try {
        final List<dynamic> decoded = jsonDecode(saved);
        entries = decoded
            .map((e) => HisabEntry.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } catch (_) {
        entries = [];
      }
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'hisab_entries',
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> addEntry(String type) async {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(type == 'income' ? addIncome : addExpense),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: amountLabel,
                prefixText: '₹ ',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: noteLabel,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(cancelLabel),
          ),
          FilledButton(
            onPressed: () async {
              final amount = double.tryParse(
                amountController.text.trim().replaceAll(',', ''),
              );
              if (amount == null || !amount.isFinite || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(invalidAmount)),
                );
                return;
              }

              setState(() {
                entries.insert(0, HisabEntry(
                  type: type,
                  amount: amount,
                  note: noteController.text.trim(),
                  date: DateTime.now(),
                ));
              });

              await saveEntries();
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: Text(saveLabel),
          ),
        ],
      ),
    );

    amountController.dispose();
    noteController.dispose();
  }

  String money(double value) => '₹ ${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F7),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text('Hisab AI',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Language',
            onPressed: widget.onChangeLanguage,
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(greeting, style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold)),
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
                        Text(balance,
                            style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 10),
                        Text(money(currentBalance),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(children: [
                    Expanded(child: summaryCard(income, totalIncome, Colors.green, Icons.trending_up)),
                    const SizedBox(width: 12),
                    Expanded(child: summaryCard(expense, totalExpense, Colors.red, Icons.trending_down)),
                  ]),
                  const SizedBox(height: 25),
                  Text(quickActions, style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: actionCard(addIncome, Colors.green,
                        Icons.add_circle, () => addEntry('income'))),
                    const SizedBox(width: 12),
                    Expanded(child: actionCard(addExpense, Colors.red,
                        Icons.remove_circle, () => addEntry('expense'))),
                  ]),
                  const SizedBox(height: 25),
                  Text(recent, style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  if (entries.isEmpty)
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(child: Text(noEntries)),
                      ),
                    )
                  else
                    ...entries.map((entry) => Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: entry.type == 'income'
                              ? Colors.green.shade50 : Colors.red.shade50,
                          child: Icon(
                            entry.type == 'income'
                                ? Icons.add : Icons.remove,
                            color: entry.type == 'income'
                                ? Colors.green : Colors.red,
                          ),
                        ),
                        title: Text(entry.note.isEmpty
                            ? (entry.type == 'income' ? addIncome : addExpense)
                            : entry.note),
                        subtitle: Text(
                          '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                        ),
                        trailing: Text(
                          '${entry.type == 'income' ? '+' : '-'}${money(entry.amount)}',
                          style: TextStyle(
                            color: entry.type == 'income'
                                ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                ],
              ),
            ),
    );
  }

  Widget summaryCard(String title, double amount, Color color, IconData icon) {
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
          Text(money(amount), style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget actionCard(
      String title, Color color, IconData icon, VoidCallback onTap) {
    return Card(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Column(children: [
            Icon(icon, color: color, size: 35),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
        ),
      ),
    );
  }
}
