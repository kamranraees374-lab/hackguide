import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class C {
  static const bg = Color(0xFF0B0F19);
  static const surface = Color(0xFF131A2A);
  static const surface2 = Color(0xFF1E293B);
  static const border = Color(0x2638BDF8);
  static const text = Color(0xFFF8FAFC);
  static const muted = Color(0xFF94A3B8);
  static const accent = Color(0xFF0EA5E9);
  static const accentL = Color(0xFF38BDF8);
  static const success = Color(0xFF10B981);
  static const danger = Color(0xFFF43F5E);
  static const warning = Color(0xFFF59E0B);
}

class Quiz {
  final String q;
  final List<String> o;
  final int a;
  const Quiz(this.q, this.o, this.a);
}

class Lesson {
  final String t, body;
  final IconData icon;
  final Quiz quiz;
  const Lesson(this.t, this.icon, this.body, this.quiz);
}

class Level {
  final String t, d;
  final IconData icon;
  final List<Lesson> lessons;
  const Level(this.t, this.d, this.icon, this.lessons);
}

const levels = <Level>[
  Level('Level 1: Buniyad', 'Qanoon, ethics aur Linux', Icons.shield_outlined, [
    Lesson(
      'Ethical hacking kya hai',
      Icons.shield_outlined,
      'Ethical hacker wo hai jo **likhit ijazat** ke saath kisi system ki kamzoriyan dhoondta hai.\n\n'
          '- Scope: kya test karna hai pehle tay ho.\n'
          '- Ijazat ke baghair check karna jurm hai.\n'
          '- Legal jagah: VM, TryHackMe, HackTheBox.',
      Quiz('Test shuru karne se pehle sabse zaroori?',
          ['Tools install karna', 'Likhit ijazat', 'Fast internet'], 1),
    ),
    Lesson(
      'Linux ke basic commands',
      Icons.terminal,
      'Zyadatar tools Linux par chalte hain.\n\n'
          '`pwd` abhi kahan ho\n`ls -la` files list\n`cat file` file ka content\n`grep text` dhoondo',
      Quiz('File ke andar kisi lafz ko dhoondne ka command?',
          ['ls', 'grep', 'pwd'], 1),
    ),
  ]),
  Level('Level 2: Networking', 'IP, port, DNS, protocols', Icons.public, [
    Lesson(
      'IP, port aur protocol',
      Icons.public,
      '**IP** device ka pata hai. **Port** darwaza hai.\n\n'
          'Aam ports:\n`22` SSH, `80` HTTP, `443` HTTPS.\n\n'
          '**TCP** bharosemand hai, **UDP** tez hai.',
      Quiz('HTTPS kis port par chalta hai?', ['22', '80', '443'], 2),
    ),
  ]),
  Level('Level 3: Recon', 'Nmap aur output parhna', Icons.search, [
    Lesson(
      'Nmap ke basics',
      Icons.search,
      'Nmap batata hai ke ports khule hain. Sirf **authorized targets** par.\n\n'
          '`nmap -sV host` service ka version\n'
          'Output: **open** (chal rahi), **closed** (band), **filtered** (firewall).',
      Quiz('Nmap mein "filtered" ka matlab?',
          ['Service on hai', 'Firewall roak raha hai', 'Host band hai'], 1),
    ),
  ]),
];

class AppState extends ChangeNotifier {
  late SharedPreferences p;
  Set<String> done = {};
  int xp = 0, streak = 0;
  String lastDay = '';
  bool agreed = false;
  String url = 'http://localhost:8080';

  String _today() => DateTime.now().toIso8601String().substring(0, 10);

  Future<void> load() async {
    p = await SharedPreferences.getInstance();
    done = (p.getStringList('done') ?? []).toSet();
    xp = p.getInt('xp') ?? 0;
    streak = p.getInt('streak') ?? 0;
    lastDay = p.getString('lastDay') ?? '';
    agreed = p.getBool('agreed') ?? false;
    url = p.getString('url') ?? url;

    final t = _today();
    if (lastDay != t) {
      if (lastDay.isEmpty) {
        streak = 1;
      } else {
        final diff =
            DateTime.parse(t).difference(DateTime.parse(lastDay)).inDays;
        streak = diff == 1 ? streak + 1 : 1;
      }
      lastDay = t;
      p.setInt('streak', streak);
      p.setString('lastDay', t);
    }
  }

  String key(int i, int j) => '$i-$j';
  int get total => levels.fold(0, (s, l) => s + l.lessons.length);
  int get completed => done.length;
  int levelDone(int i) =>
      List.generate(levels[i].lessons.length, (j) => j)
          .where((j) => done.contains(key(i, j)))
          .length;
  bool unlocked(int i) =>
      i == 0 || levelDone(i - 1) == levels[i - 1].lessons.length;
  int get percent => total == 0 ? 0 : (completed / total * 100).round();

  bool complete(int i, int j) {
    if (done.contains(key(i, j))) return false;
    done.add(key(i, j));
    xp += 50;
    p.setStringList('done', done.toList());
    p.setInt('xp', xp);
    notifyListeners();
    return true;
  }

  void reset() {
    done = {};
    xp = 0;
    streak = 0;
    p.setStringList('done', []);
    p.setInt('xp', 0);
    p.setInt('streak', 0);
    notifyListeners();
  }

  void setAgreed() {
    agreed = true;
    p.setBool('agreed', true);
  }

  void setUrl(String u) {
    url = u;
    p.setString('url', u);
  }
}

final app = AppState();

void toast(BuildContext c, String msg) {
  ScaffoldMessenger.of(c)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
      behavior: SnackBarBehavior.floating,
      backgroundColor: C.surface2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
        side: const BorderSide(color: C.border),
      ),
      duration: const Duration(seconds: 2),
    ));
}

List<InlineSpan> rich(String s) {
  final spans = <InlineSpan>[];
  int last = 0;
  for (final m in RegExp(r'\*\*(.+?)\*\*|`([^`]+)`').allMatches(s)) {
    if (m.start > last) spans.add(TextSpan(text: s.substring(last, m.start)));
    if (m.group(1) != null) {
      spans.add(TextSpan(
          text: m.group(1),
          style: const TextStyle(fontWeight: FontWeight.w700, color: C.text)));
    } else {
      spans.add(TextSpan(
          text: m.group(2),
          style: TextStyle(
              fontFamily: 'monospace',
              color: C.accentL,
              backgroundColor: C.accent.withOpacity(.15))));
    }
    last = m.end;
  }
  if (last < s.length) spans.add(TextSpan(text: s.substring(last)));
  return spans;
}

class GCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? borderColor;
  final double opacity;
  const GCard(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(18),
      this.borderColor,
      this.opacity = 1});

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: opacity,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          padding: padding,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [C.surface, Color(0xFF0F1523)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor ?? C.border),
            boxShadow: const [
              BoxShadow(color: Colors.black38, blurRadius: 30, offset: Offset(0, 10))
            ],
          ),
          child: child,
        ),
      );
}

class Sticker extends StatelessWidget {
  final IconData icon;
  final double size;
  const Sticker(this.icon, {super.key, this.size = 50});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: C.surface2,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: C.border)),
        child: Icon(icon, color: C.accentL, size: size * .48),
      );
}

class PrimaryBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const PrimaryBtn(this.label, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: C.accent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HackGuideApp());
}

class HackGuideApp extends StatelessWidget {
  const HackGuideApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'HackGuide Pro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: C.bg,
          colorScheme: const ColorScheme.dark(primary: C.accent, surface: C.surface),
          useMaterial3: true,
        ),
        home: const Boot(),
      );
}

class Boot extends StatefulWidget {
  const Boot({super.key});
  @override
  State<Boot> createState() => _BootState();
}

class _BootState extends State<Boot> {
  bool ready = false;
  @override
  void initState() {
    super.initState();
    Future.wait([app.load(), Future.delayed(const Duration(milliseconds: 2500))])
        .then((_) => setState(() => ready = true));
  }

  @override
  Widget build(BuildContext context) {
    if (ready) return const Shell();
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [C.accent, Color(0xFF3B82F6)]),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: C.accent.withOpacity(.4), blurRadius: 30)],
            ),
            child: const Icon(Icons.shield, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 20),
          RichText(
              text: const TextSpan(
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 1),
                  children: [
                TextSpan(text: 'HackGuide'),
                TextSpan(text: 'Pro', style: TextStyle(color: C.accent)),
              ])),
          const SizedBox(height: 8),
          const Text('Ethical Hacking Academy',
              style: TextStyle(color: C.muted, fontSize: 13)),
        ]),
      ),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int tab = 0;

  @override
  void initState() {
    super.initState();
    if (!app.agreed) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showScope());
    }
  }

  void showScope() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        backgroundColor: C.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: C.border)),
        title: const Text('🛡️ Safety First', style: TextStyle(color: C.accent)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text(
              'HackGuide sirf ethical aur authorized security learning ke liye hai. '
              'Testing sirf apne systems, practice labs ya written permission wale targets par karo.',
              style: TextStyle(color: C.muted, fontSize: 14, height: 1.5)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: C.danger.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: C.danger.withOpacity(.3))),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Strict Rule:',
                  style: TextStyle(color: C.danger, fontWeight: FontWeight.w700, fontSize: 13)),
              SizedBox(height: 4),
              Text('Bina ijazat kisi account, phone, ya network ko access karna allowed nahi hai.',
                  style: TextStyle(color: C.muted, fontSize: 12)),
            ]),
          ),
        ]),
        actions: [
          SizedBox(
            width: double.infinity,
            child: PrimaryBtn('I Understand & Agree', () {
              app.setAgreed();
              Navigator.pop(c);
            }),
          ),
        ],
      ),
    );
  }

  void showSettings() {
    final ctrl = TextEditingController(text: app.url);
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: C.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: C.border)),
        title: const Text('⚙️ App Settings'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            const Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Reset Data', style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text('Lessons, XP aur streak delete',
                  style: TextStyle(color: C.muted, fontSize: 11)),
            ])),
            OutlinedButton(
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: c,
                  builder: (d) => AlertDialog(
                    title: const Text('Progress aur XP reset karna hai?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(d, false), child: const Text('No')),
                      TextButton(onPressed: () => Navigator.pop(d, true), child: const Text('Yes')),
                    ],
                  ),
                );
                if (ok == true) {
                  app.reset();
                  if (c.mounted) Navigator.pop(c);
                  if (mounted) toast(context, 'Data Reset!');
                }
              },
              child: const Text('Reset'),
            ),
          ]),
          const Divider(height: 28, color: C.border),
          const Align(
              alignment: Alignment.centerLeft,
              child: Text('Local AI Server', style: TextStyle(fontWeight: FontWeight.w600))),
          const Align(
              alignment: Alignment.centerLeft,
              child: Text('OpenAI-compatible URL (Termux/PC)',
                  style: TextStyle(color: C.muted, fontSize: 11))),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            decoration: InputDecoration(
              hintText: 'http://localhost:8080',
              filled: true,
              fillColor: C.surface2,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
        ]),
        actions: [
          SizedBox(
            width: double.infinity,
            child: PrimaryBtn('Done', () {
              app.setUrl(ctrl.text.trim());
              Navigator.pop(c);
              toast(context, 'Settings Saved');
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const pages = [HomePage(), ToolsPage(), TutorPage(), BadgesPage()];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: C.surface.withOpacity(.9),
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: C.border)),
        titleSpacing: 20,
        title: Row(children: [
          const Sticker(Icons.verified_user_outlined, size: 40),
          const SizedBox(width: 12),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('HackGuide', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            Text('PRO EDITION',
                style: TextStyle(fontSize: 10, color: C.muted, fontWeight: FontWeight.w600, letterSpacing: 1)),
          ]),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: showSettings,
              icon: const Icon(Icons.settings_outlined, color: C.muted),
              style: IconButton.styleFrom(
                  backgroundColor: C.surface,
                  side: const BorderSide(color: C.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: app,
          builder: (_, __) => IndexedStack(index: tab, children: pages),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: C.surface,
        indicatorColor: C.accent.withOpacity(.15),
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: C.accentL), label: 'Learn'),
          NavigationDestination(icon: Icon(Icons.terminal), selectedIcon: Icon(Icons.terminal, color: C.accentL), label: 'Tools'),
          NavigationDestination(icon: Icon(Icons.smart_toy_outlined), selectedIcon: Icon(Icons.smart_toy, color: C.accentL), label: 'Tutor'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome, color: C.accentL), label: 'Badges'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget stat(String v, String l, [Color c = C.text]) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: C.surface2,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: C.border)),
          child: Column(children: [
            Text(v, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: c)),
            Text(l.toUpperCase(),
                style: const TextStyle(color: C.muted, fontSize: 10, fontWeight: FontWeight.w600)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(20), children: [
      GCard(
        borderColor: C.accent.withOpacity(.2),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Welcome, Hacker_',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              SizedBox(height: 6),
              Text('Apni skills upgrade karo. Safely.',
                  style: TextStyle(color: C.muted, fontSize: 13)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: C.success.withOpacity(.1), borderRadius: BorderRadius.circular(99)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.circle, size: 6, color: C.success),
                SizedBox(width: 6),
                Text('ONLINE',
                    style: TextStyle(color: C.success, fontSize: 10, fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            stat('${app.completed}/${app.total}', 'Lessons'),
            stat('${app.xp}', 'XP', C.accent),
            stat('🔥 ${app.streak}', 'Streak', C.warning),
          ]),
        ]),
      ),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Learning Modules', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: C.accent.withOpacity(.1), borderRadius: BorderRadius.circular(8)),
          child: Text('${app.percent}% Done',
              style: const TextStyle(color: C.accentL, fontSize: 12, fontWeight: FontWeight.w700)),
        ),
      ]),
      const SizedBox(height: 12),
      for (int i = 0; i < levels.length; i++) levelCard(context, i),
    ]);
  }

  Widget levelCard(BuildContext context, int i) {
    final l = levels[i];
    final ok = app.unlocked(i);
    final pct = app.levelDone(i) / l.lessons.length;
    return GCard(
      opacity: ok ? 1 : .6,
      child: Column(children: [
        Row(children: [
          Sticker(l.icon),
          const SizedBox(width: 14),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(l.d, style: const TextStyle(color: C.muted, fontSize: 12)),
          ])),
          if (!ok) const Icon(Icons.lock_outline, color: C.muted),
        ]),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
              value: pct, minHeight: 6, backgroundColor: Colors.white10, color: C.accent),
        ),
        const SizedBox(height: 8),
        for (int j = 0; j < l.lessons.length; j++) lessonTile(context, i, j, ok),
      ]),
    );
  }

  Widget lessonTile(BuildContext context, int i, int j, bool ok) {
    final x = levels[i].lessons[j];
    final isDone = app.done.contains(app.key(i, j));
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: ok
          ? () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => LessonPage(i: i, j: j)))
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: Colors.white10, borderRadius: BorderRadius.circular(10)),
            child: Icon(x.icon, size: 18, color: C.muted),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(x.t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text(isDone ? 'COMPLETED' : 'TAP TO LEARN',
                style: const TextStyle(color: C.muted, fontSize: 10, fontWeight: FontWeight.w600)),
          ])),
          isDone
              ? const Icon(Icons.check, color: C.success, size: 20)
              : const Icon(Icons.chevron_right, color: C.muted),
        ]),
      ),
    );
  }
}

class LessonPage extends StatefulWidget {
  final int i, j;
  const LessonPage({super.key, required this.i, required this.j});
  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  int? picked;
  String? result;
  bool? correct;

  void check(int k) {
    final x = levels[widget.i].lessons[widget.j];
    setState(() {
      picked = k;
      if (k == x.quiz.a) {
        correct = true;
        final isNew = app.complete(widget.i, widget.j);
        result = isNew ? '🎉 Correct! +50 XP added.' : '✅ Correct! (Already completed)';
        if (isNew) toast(context, 'Lesson Completed!');
      } else {
        correct = false;
        result = '❌ Incorrect. Try again.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final x = levels[widget.i].lessons[widget.j];
    return Scaffold(
      appBar: AppBar(backgroundColor: C.bg, title: const Text('Lesson')),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(20), children: [
          Row(children: [
            Sticker(x.icon, size: 60),
            const SizedBox(width: 16),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(x.t, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text('+50 XP REWARD',
                  style: TextStyle(color: C.accent, fontSize: 12, fontWeight: FontWeight.w700)),
            ])),
          ]),
          const SizedBox(height: 20),
          GCard(
            padding: const EdgeInsets.all(24),
            child: Text.rich(
              TextSpan(children: rich(x.body)),
              style: const TextStyle(fontSize: 15, height: 1.7, color: Color(0xFFCBD5E1)),
            ),
          ),
          const SizedBox(height: 8),
          GCard(
            borderColor: C.accent,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🧠 Concept Quiz',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text(x.quiz.q, style: const TextStyle(fontSize: 14)),
              for (int k = 0; k < x.quiz.o.length; k++) option(x, k),
              if (result != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(result!,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: correct == true ? C.success : C.danger)),
                ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget option(Lesson x, int k) {
    final isPicked = picked == k;
    final ok = isPicked && correct == true;
    final no = isPicked && correct == false;
    final col = ok ? C.success : (no ? C.danger : C.border);
    return GestureDetector(
      onTap: () => check(k),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ok
              ? C.success.withOpacity(.1)
              : no
                  ? C.danger.withOpacity(.1)
                  : C.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: col),
        ),
        child: Row(children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: ok ? C.success : Colors.white10,
                borderRadius: BorderRadius.circular(8)),
            child: Text(String.fromCharCode(65 + k),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: ok ? Colors.black : C.muted)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(x.quiz.o[k], style: const TextStyle(fontWeight: FontWeight.w500))),
        ]),
      ),
    );
  }
}

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});
  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  final ctrl = TextEditingController();
  List<String> out = [];

  static const dict = {
    'nmap': 'Network scanner: ports aur services dhoondta hai (sirf authorized targets).',
    '-sV': 'Service ka version detect karta hai.',
    '-sS': 'SYN (stealth) scan.',
    '-p': 'Specific ports chunna (e.g. -p 22,80).',
    '-A': 'Aggressive: OS, version, scripts, traceroute.',
    '-Pn': 'Host discovery (ping) skip karta hai.',
    'ls': 'Directory ki files list karta hai.',
    '-la': 'Saari files (hidden bhi) detail ke saath.',
    'pwd': 'Abhi ki directory dikhata hai.',
    'cat': 'File ka content print karta hai.',
    'grep': 'Text ke andar pattern dhoondta hai.',
    'cd': 'Directory change karta hai.',
  };

  void analyze() {
    final tokens = ctrl.text.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
    setState(() {
      out = [
        for (final t in tokens) '`$t` → ${dict[t] ?? 'Argument / target (custom value).'}'
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(20), children: [
      GCard(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
        child: Column(children: [
          const Sticker(Icons.terminal, size: 70),
          const SizedBox(height: 16),
          const Text('Command Explainer',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('Nmap ya Linux commands ko analyze karo.',
              style: TextStyle(color: C.muted, fontSize: 13)),
          const SizedBox(height: 24),
          TextField(
            controller: ctrl,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'monospace'),
            decoration: InputDecoration(
              hintText: 'e.g. nmap -sV target',
              filled: true,
              fillColor: C.surface,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: C.border)),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryBtn('Analyze Command', analyze),
        ]),
      ),
      if (out.isNotEmpty)
        GCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final line in out)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text.rich(TextSpan(children: rich(line)),
                    style: const TextStyle(height: 1.5, color: Color(0xFFCBD5E1))),
              ),
          ]),
        ),
    ]);
  }
}

class TutorPage extends StatefulWidget {
  const TutorPage({super.key});
  @override
  State<TutorPage> createState() => _TutorPageState();
}

class _TutorPageState extends State<TutorPage> {
  final ctrl = TextEditingController();
  final scroll = ScrollController();
  final msgs = <Map<String, String>>[
    {'role': 'assistant', 'content': 'Hi Hacker! Aaj kya seekhna hai? Network scanning ya Web Security?'}
  ];
  bool loading = false;

  Future<void> send() async {
    final text = ctrl.text.trim();
    if (text.isEmpty || loading) return;
    ctrl.clear();
    setState(() {
      msgs.add({'role': 'user', 'content': text});
      loading = true;
    });
    try {
      final res = await http
          .post(
            Uri.parse('${app.url}/v1/chat/completions'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'model': 'local',
              'messages': [
                {
                  'role': 'system',
                  'content':
                      'Tum ek ethical hacking tutor ho. Roman Urdu mein jawab do. '
                      'Sirf authorized/legal learning mein madad karo; illegal ya bina ijazat attacks mein madad nahi.'
                },
                ...msgs,
              ],
            }),
          )
          .timeout(const Duration(seconds: 60));
      final data = jsonDecode(res.body);
      final reply = data['choices'][0]['message']['content'] as String;
      setState(() => msgs.add({'role': 'assistant', 'content': reply}));
    } catch (e) {
      setState(() => msgs.add({
            'role': 'system',
            'content': 'Server se connect nahi hua. Settings mein URL check karo.'
          }));
    } finally {
      setState(() => loading = false);
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scroll.hasClients) {
          scroll.animateTo(scroll.position.maxScrollExtent,
              duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        GCard(
          borderColor: C.accent,
          padding: const EdgeInsets.all(16),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('🤖 AI Tutor', style: TextStyle(color: C.accent, fontWeight: FontWeight.w700)),
            SizedBox(height: 4),
            Text('Local AI server se connected (Settings mein URL set karo).',
                style: TextStyle(fontSize: 12)),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            controller: scroll,
            itemCount: msgs.length,
            itemBuilder: (_, k) {
              final m = msgs[k];
              final u = m['role'] == 'user';
              final s = m['role'] == 'system';
              return Align(
                alignment: u ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .85),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: u ? C.accent : (s ? C.danger.withOpacity(.1) : C.surface),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(u ? 18 : 4),
                      bottomRight: Radius.circular(u ? 4 : 18),
                    ),
                    border: Border.all(
                        color: u ? Colors.transparent : (s ? C.danger.withOpacity(.3) : C.border)),
                  ),
                  child: SelectableText.rich(
                    TextSpan(children: rich(m['content']!)),
                    style: TextStyle(
                        fontSize: s ? 12 : 14,
                        height: 1.6,
                        color: u ? Colors.black : (s ? C.danger : C.text)),
                  ),
                ),
              );
            },
          ),
        ),
        if (loading) const LinearProgressIndicator(minHeight: 2, color: C.accent),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: TextField(
              controller: ctrl,
              onSubmitted: (_) => send(),
              decoration: InputDecoration(
                hintText: 'Message tutor...',
                filled: true,
                fillColor: C.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(color: C.border)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: send,
            style: IconButton.styleFrom(backgroundColor: C.accent, padding: const EdgeInsets.all(14)),
            icon: const Icon(Icons.send, size: 20),
          ),
        ]),
      ]),
    );
  }
}

class BadgesPage extends StatelessWidget {
  const BadgesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final ach = [
      ['🌱', 'Beginner', app.completed >= 1],
      ['🔥', 'Streaker', app.streak >= 3],
      ['🔎', 'Scanner', app.done.contains('2-0')],
      ['🏆', 'Pro Hacker', app.completed == app.total],
    ];
    return ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Achievements', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
      const SizedBox(height: 16),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          for (final a in ach)
            Opacity(
              opacity: (a[2] as bool) ? 1 : .4,
              child: GCard(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(a[0] as String, style: const TextStyle(fontSize: 40)),
                  const SizedBox(height: 10),
                  Text(a[1] as String,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
        ],
      ),
    ]);
  }
}
