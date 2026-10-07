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

/* ===================== 40-LESSON CURRICULUM ===================== */
const levels = <Level>[
  Level('Module 1: Foundations & Legal', 'CIA Triad, Laws, Networking, Linux, Lab', Icons.shield_outlined, [
    Lesson('Intro to Ethical Hacking & CIA Triad', Icons.shield_outlined,
        '**CIA Triad** security ka buniyadi model hai: **Confidentiality**, **Integrity**, **Availability**.\n\n'
        '- White/Black/Grey Hat hackers ka farq niyat aur ijazat mein hai.\n'
        '- **Vulnerability** = kamzori, **Threat** = khatra, **Risk** = dono ka asar.\n\n'
        'Practical: Real-world security failures ko CIA Triad mein categorize karo.',
        Quiz('Server crash hone par CIA Triad ka kaunsa component fail hota hai?',
            ['Confidentiality', 'Integrity', 'Availability'], 2)),
    Lesson('Cyber Laws, Ethics & RoE', Icons.gavel,
        '**Rules of Engagement (RoE)** test ka scope likhit tay karta hai.\n\n'
        '- **NDA** client data confidential rakhta hai.\n'
        '- Scope se bahar kuch bhi test karna illegal hai.\n'
        '- Qawaneen: PECA, Computer Fraud & Abuse Act.\n\n'
        'Practical: Sample RoE document review karke out-of-scope tasks highlight karo.',
        Quiz('Unauthorized penetration testing conduct karne par kaunsa law violate hota hai agar client authorization sign na ho?',
            ['Copyright Act', 'Computer Misuse / Cybercrime Act', 'Data Protection Act'], 1)),
    Lesson('Networking Fundamentals', Icons.lan,
        '**OSI Model** (7 layers) vs **TCP/IP Model** (4 layers) networking ki buniyad hain.\n\n'
        'Aam ports:\n`21` FTP, `22` SSH, `80` HTTP, `443` HTTPS, `3389` RDP.\n\n'
        'Practical: Standard ports ke protocol mapping ki practice karo.',
        Quiz('Encrypted remote terminal management ke liye konsa default port istemal hota hai?',
            ['Port 21', 'Port 22', 'Port 80'], 1)),
    Lesson('Linux CLI Mastery', Icons.terminal,
        'Security auditing ke liye Linux command line zaroori hai.\n\n'
        '`grep` pattern dhoondta hai, `awk`/`sed` text process karte hain, pipe `|` commands jorta hai.\n\n'
        'Practical: Log files se failed login attempts ke liye Bash script likho.',
        Quiz('Linux mein /etc/shadow file ki access kin users ke paas hoti hai?',
            ['Har user', 'Strictly Root User', 'Guest user'], 1)),
    Lesson('Safe Virtual Hacking Lab', Icons.computer,
        'Practice ke liye isolated lab zaroori hai.\n\n'
        '- **VirtualBox/VMware** se virtualization.\n'
        '- **Kali Linux** attacker machine, **Metasploitable/DVWA** target.\n'
        '- **Host-Only Networking** se isolation.\n\n'
        'Practical: Kali se target VM ko ping karke connectivity check karo.',
        Quiz('Target machine ko host aur internet se isolate rakhne ke liye kaunsa VM network mode best hai?',
            ['Bridged', 'NAT', 'Host-Only Network'], 2)),
  ]),
  Level('Module 2: Reconnaissance', 'OSINT, Nmap, DNS, Google Dorking', Icons.travel_explore, [
    Lesson('Passive Recon & OSINT', Icons.travel_explore,
        '**OSINT** (Open Source Intelligence) publicly available data collect karta hai.\n\n'
        '`WHOIS` domain info, **Shodan** internet devices index karta hai, archive.org purani websites.\n\n'
        'Practical: Shodan se unauthenticated cameras aur open RDP ports dhoondo.',
        Quiz('Shodan internet-connected devices ko index karne ke liye sab se pehle kya scan karta hai?',
            ['File content', 'Service Banners', 'User passwords'], 1)),
    Lesson('Active Recon & Network Discovery', Icons.radar,
        'Active recon target se seedha interact karta hai.\n\n'
        '`fping` ping sweep, `arp-scan` LAN discovery.\n\n'
        '**ARP** IP ko MAC address mein resolve karta hai.\n\n'
        'Practical: fping aur arp-scan se subnet ke active hosts discover karo.',
        Quiz('Kaunsa protocol LAN par IP address ko MAC address mein resolve karta hai?',
            ['DNS', 'ARP', 'DHCP'], 1)),
    Lesson('Advanced Port Scanning & Nmap', Icons.search,
        '**Nmap** scanning ka sabse powerful tool hai.\n\n'
        '`-sS` stealth SYN scan, `-sU` UDP scan, `-sV` version detection.\n\n'
        '**NSE** scripts extra checks karte hain.\n\n'
        'Practical: Stealth SYN scan se services fingerprint karo.',
        Quiz('Nmap ka SYN Scan Three-Way Handshake kyun pura nahi karta?',
            ['Scan tez aur stealthy rakhne ke liye', 'Target crash karne ke liye', 'Password nikalne ke liye'], 0)),
    Lesson('DNS Enumeration & Subdomain Discovery', Icons.dns,
        'DNS records: `A`, `MX`, `TXT`, `NS`, `CNAME`.\n\n'
        '**Zone Transfer** attack se poora DNS zone leak ho sakta hai.\n\n'
        'Practical: `dig` aur `dnsrecon` se zone transfer vulnerability check karo.',
        Quiz('DNS Zone Transfer attack ke liye kaunsa record exploit hota hai?',
            ['AXFR record', 'MX record', 'TXT record'], 0)),
    Lesson('Google Dorking & Metadata Analysis', Icons.image_search,
        'Advanced search operators: `filetype:`, `inurl:`, `intitle:`.\n\n'
        '**Exiftool** files se hidden metadata nikalta hai.\n\n'
        'Practical: PDF files se usernames aur software versions extract karo.',
        Quiz('Google dork filetype:env "DB_PASSWORD" kis cheez ko uncover karta hai?',
            ['Exposed config files', 'Server logs', 'User photos'], 0)),
  ]),
  Level('Module 3: Vulnerability Assessment', 'CVSS, Scanning, Burp Suite', Icons.assessment, [
    Lesson('VA Methodology & CVSS', Icons.assessment,
        '**CVSS** (v3.1/v4.0) vulnerability ki severity score karta hai.\n\n'
        '**False Positive** = scanner ki ghalat alert, **True Positive** = asal kamzori.\n\n'
        'Practical: CVE report ka CVSS score calculate karke risk rating assign karo.',
        Quiz('CVSS metric mein "Attack Vector: Network" ka kya matlab hai?',
            ['Sirf physical access se exploit', 'Remote internet se exploit', 'Sirf local user exploit kar sakta hai'], 1)),
    Lesson('Network Vulnerability Scanning', Icons.network_check,
        '**Nessus/OpenVAS** automated scanners hain.\n\n'
        '**Credentialed scan** internal config dekh sakta hai, **non-credentialed** bahar se hi check karta hai.\n\n'
        'Practical: Lab environment scan karke report export karo.',
        Quiz('Credentialed scan non-credentialed se zyada accurate kyun hota hai?',
            ['Yeh OS ke andar config aur patches read karta hai', 'Yeh tez chalta hai', 'Yeh encrypted hota hai'], 0)),
    Lesson('Web App Scanning with Burp Suite', Icons.language,
        '**Burp Suite** intercepting proxy hai.\n\n'
        '**Repeater** single request repeat karta hai, **Intruder** automated attacks chalata hai.\n\n'
        'Practical: Burp proxy se browser traffic intercept karke headers analyze karo.',
        Quiz('Burp Suite ka Repeater tool kis kaam ke liye use hota hai?',
            ['Multiple requests automate karna', 'Single request modify karke bar-bar test karna', 'Network scan karna'], 1)),
    Lesson('Banner Grabbing & Service Enumeration', Icons.router,
        '`netcat`/`telnet` se service banners grab hote hain.\n\n'
        'Banner se exact software version pata chalta hai, jo attack ko target karta hai.\n\n'
        'Practical: Port 80 aur 21 se banner grab karo.',
        Quiz('Server banners hide karne se kis attack ko mushkil hota hai?',
            ['Phishing', 'Automated service-specific exploit', 'Password reset'], 1)),
    Lesson('Analyzing & Prioritizing Scan Results', Icons.filter_alt,
        'Har scan result exploitable nahi hota.\n\n'
        '**Triage** se false positives filter hote hain, business context risk mapping karta hai.\n\n'
        'Practical: Scan output se top 3 critical vulnerabilities filter karo.',
        Quiz('Agar scanner vulnerable bataye par manual test se exploit na ho, to yeh kya hai?',
            ['True Positive', 'False Positive', 'Critical Risk'], 1)),
  ]),
  Level('Module 4: System Hacking', 'Passwords, Metasploit, Privesc, Malware', Icons.lock_open, [
    Lesson('Password Cracking & Hashing', Icons.key,
        'Hashing algorithms: **MD5, SHA256, bcrypt**.\n\n'
        '**Dictionary attack**, **Brute-force**, **Rainbow Tables** cracking techniques hain.\n\n'
        '`Hashcat`/`John the Ripper` tools hain.\n\n'
        'Practical: Hashcat se MD5/NTLM hash crack karo.',
        Quiz('Rainbow tables ko un-effective banane ke liye hash mein kya add kiya jata hai?',
            ['Salt', 'Extra length', 'Compression'], 0)),
    Lesson('Metasploit Framework', Icons.flash_on,
        '**Metasploit** exploit framework hai.\n\n'
        '**Payload** (Singles/Stagers), **Auxiliary** modules, **Meterpreter** advanced shell.\n\n'
        'Practical: Vulnerable service par payload drop karke Meterpreter session gain karo.',
        Quiz('Staged aur Unstaged Payload mein kya farq hai?',
            ['Staged chhota initial code bhejta hai jo baki download karta hai', 'Unstaged zyada secure hai', 'Koi farq nahi'], 0)),
    Lesson('Privilege Escalation', Icons.arrow_upward,
        '**Vertical** escalation low se high privilege, **Horizontal** same-level access.\n\n'
        '**SUID binaries**, **Unquoted Service Paths**, misconfigured sudo common tareeqe hain.\n\n'
        'Practical: SUID binary exploit karke root shell gain karo.',
        Quiz('Linux mein konsa bit binary ko file-owner ke privilege se run karne deta hai?',
            ['SUID bit', 'Read bit', 'Execute bit'], 0)),
    Lesson('Malware Threats', Icons.bug_report,
        '**Trojans, Keyloggers, Backdoors** common malware types hain.\n\n'
        '**C2 (Command & Control)** server compromised machines ko control karta hai.\n\n'
        'Practical: MSFvenom se custom payload banakar obfuscation test karo.',
        Quiz('Malware ka C2 server kis liye istemal hota hai?',
            ['Commands bhejne aur data exfiltrate karne ke liye', 'Sirf logging ke liye', 'Antivirus update ke liye'], 0)),
    Lesson('Covering Tracks & Log Evasion', Icons.visibility_off,
        'Attackers logs clean karte hain taake trace na ho.\n\n'
        'Windows **Event ID 1102** = audit log clear hua.\n\n'
        'Practical: Linux par bash history flush karne ki technique seekho.',
        Quiz('Windows mein Security logs clean hone ka Event ID kya hai?',
            ['Event ID 4625', 'Event ID 1102', 'Event ID 1000'], 1)),
  ]),
  Level('Module 5: Web App Security', 'OWASP Top 10: SQLi, XSS, CSRF, LFI', Icons.web, [
    Lesson('OWASP Top 10 Overview', Icons.web,
        '**OWASP Top 10** web applications ki sab se critical risks list karta hai.\n\n'
        'HTTP headers, cookies, client-server model web security ki buniyad hain.\n\n'
        'Practical: Browser dev tools (F12) se cookies aur local storage inspect karo.',
        Quiz('OWASP Top 10 list kis maqsad ke liye publish ki jati hai?',
            ['Marketing ke liye', 'Critical web risks highlight karne ke liye', 'Sirf developers training ke liye'], 1)),
    Lesson('SQL Injection', Icons.storage,
        '**SQLi**: In-Band, Error-Based, Blind (Boolean/Time-Based).\n\n'
        '`SQLmap` automated exploitation tool hai.\n\n'
        'Practical: Login form mein `\' OR \'1\'=\'1` se authentication bypass karo.',
        Quiz('SQL Injection prevent karne ka sabse secure tarika kya hai?',
            ['Prepared Statements', 'Input hide karna', 'Password length badhana'], 0)),
    Lesson('Cross-Site Scripting (XSS)', Icons.code,
        '**Stored XSS** database mein save hota hai, **Reflected XSS** turant response mein aata hai, **DOM-based** client-side JS mein.\n\n'
        'Practical: `<script>alert(document.cookie)</script>` se Reflected XSS test karo.',
        Quiz('Stored XSS Reflected se zyada dangerous kyun hai?',
            ['Yeh database mein save hoke har visitor ko affect karta hai', 'Yeh tez chalta hai', 'Yeh sirf admin ko affect karta hai'], 0)),
    Lesson('CSRF & Auth Flaws', Icons.sync_problem,
        '**CSRF** browser ke trust ka faida uthata hai.\n\n'
        '**CSRF tokens**, **SameSite cookies** protection dete hain.\n\n'
        'Practical: Authenticated user se background action trigger karne wala HTML form banao.',
        Quiz('CSRF attack kis cheez ka faida uthata hai?',
            ['Browser ka automated credentials bhejne ka trust', 'Weak password', 'Server downtime'], 0)),
    Lesson('File Inclusion (LFI/RFI) & RCE', Icons.folder_open,
        '**LFI** local file include karta hai, **RFI** remote file.\n\n'
        '**Path Traversal** se directories climb hoti hain.\n\n'
        'Practical: URL mein `../../../../etc/passwd` inject karke LFI exploit karo.',
        Quiz('LFI vulnerability RCE mein kab convert hoti hai?',
            ['Jab attacker PHP code logs/uploads mein inject kar sake', 'Jab server slow ho', 'Jab user logout kare'], 0)),
  ]),
  Level('Module 6: Network & Wireless', 'MITM, Wi-Fi, DDoS, Evasion', Icons.wifi, [
    Lesson('Sniffing & MITM', Icons.hub,
        '**Promiscuous mode** se saara traffic capture hota hai.\n\n'
        '**ARP Poisoning** se attacker beech mein aa jata hai (MITM).\n\n'
        '`Wireshark`, `Ettercap` tools hain.\n\n'
        'Practical: Wireshark se plain-text passwords filter karo.',
        Quiz('Switched network par MITM ke liye attacker kis table ko corrupt karta hai?',
            ['Routing table', 'ARP Cache table', 'DNS cache'], 1)),
    Lesson('Wireless Hacking', Icons.wifi,
        '**WEP** weak hai, **WPA2/WPA3** secure.\n\n'
        '**4-Way Handshake** capture karke offline crack hota hai.\n\n'
        '`Aircrack-ng` suite se deauth aur capture hota hai.\n\n'
        'Practical: airodump-ng se WPA2 handshake capture karo.',
        Quiz('WPA2 cracking ke liye attacker ko kya capture karna padta hai?',
            ['SSID broadcast', '4-Way WPA Handshake', 'MAC address'], 1)),
    Lesson('DoS & DDoS', Icons.flash_on,
        '**SYN Flood**, **UDP Flood**, **HTTP Flood** common attacks hain.\n\n'
        '**Amplification attacks** (NTP/DNS) chhoti request se bada response generate karte hain.\n\n'
        'Practical: Wireshark par SYN flood pattern identify karo.',
        Quiz('Amplification DDoS attack kis protocol mechanism ko exploit karta hai?',
            ['TCP handshake', 'UDP (chhoti request, bada response)', 'HTTPS encryption'], 1)),
    Lesson('Session Hijacking', Icons.link,
        '**TCP Sequence numbers** aur **Session IDs** predict karke session hijack hoti hai.\n\n'
        'Cookie manipulation bhi ek tareeqa hai.\n\n'
        'Practical: Session hijacking ka flow diagram banao.',
        Quiz('TCP Session Hijacking ke liye attacker ko kya predict karna hota hai?',
            ['Next TCP Sequence Number', 'Server IP', 'DNS record'], 0)),
    Lesson('Evasion Techniques', Icons.security,
        '**Fragmentation**, **Proxy Chains**, **Tor**, encrypted tunnels firewall/IDS ko bypass karte hain.\n\n'
        'Practical: Nmap ke `-f` aur `--decoy` flags se detection bypass karo.',
        Quiz('IDS/IPS ko signature-based detection se bypass karne ke liye payload mein kya karte hain?',
            ['Payload encoding/obfuscation', 'Payload size badhana', 'Payload delete karna'], 0)),
  ]),
  Level('Module 7: Social Engineering', 'Phishing, SET, Physical, OSINT on Humans', Icons.groups, [
    Lesson('Phishing & Spear-Phishing', Icons.mail,
        'Types: **Bulk, Spear, Whaling, Smishing, Vishing**.\n\n'
        '**Typosquatting** aur **Email Spoofing** common tareeqe hain.\n\n'
        'Practical: Email headers se spoofed Return-Path aur SPF/DKIM failures check karo.',
        Quiz('DMARC policy email security mein kya check karti hai?',
            ['SPF/DKIM alignment', 'Password strength', 'File size'], 0)),
    Lesson('SET & Harvesting', Icons.content_copy,
        '**Social Engineering Toolkit (SET)** se login pages clone hote hain.\n\n'
        '**Credential Harvesting** se victim ka data chori hota hai.\n\n'
        'Practical: Lab mein login page clone karke credential capture test karo.',
        Quiz('Credential Harvester attack mein victim ka data kahan redirect hota hai?',
            ['Attacker ke listening server par', 'Asal website par', 'Email inbox mein'], 0)),
    Lesson('Physical Security & Hardware Attacks', Icons.usb,
        '**Tailgating**, **Shoulder Surfing**, **Lock Picking** physical attacks hain.\n\n'
        '**BadUSB (Rubber Ducky)** keyboard ban kar keystrokes inject karta hai.\n\n'
        'Practical: DuckyScript se automated keystroke injection test karo.',
        Quiz('USB Rubber Ducky attack computer par detect kyun nahi hota?',
            ['Yeh antivirus ko bypass karta hai', 'Computer isay standard USB Keyboard samajhta hai', 'Yeh encrypted hota hai'], 1)),
    Lesson('OSINT on Humans', Icons.person_search,
        'Social media intelligence se target profile banta hai.\n\n'
        '**Maltego** relationship mapping tool hai.\n\n'
        '**Breach Data** se leaked credentials milte hain.\n\n'
        'Practical: Username search tools se digital footprint map karo.',
        Quiz('Breach Data aggregation services testers ko kya find karne mein help karti hain?',
            ['Reused passwords aur leaked credentials', 'Server uptime', 'Network speed'], 0)),
    Lesson('Defense & Countermeasures', Icons.verified_user,
        '**MFA/2FA**, **Zero Trust Architecture**, employee training defense ke pillars hain.\n\n'
        'SMS 2FA weak hai (SIM-swapping), **TOTP apps** zyada secure.\n\n'
        'Practical: SMS 2FA ki jagah Authenticator App enforce karna seekho.',
        Quiz('MFA mein kaunsa combination sahi hai?',
            ['Do passwords', 'Password + Authenticator App', 'Username + Email'], 1)),
  ]),
  Level('Module 8: Advanced & Career', 'Crypto, Mobile, Cloud, Forensics, Reports', Icons.school, [
    Lesson('Cryptography & PKI', Icons.enhanced_encryption,
        '**Symmetric** (same key) vs **Asymmetric** (public/private key) encryption.\n\n'
        '**PKI** aur **SSL/TLS handshake** secure communication ensure karte hain.\n\n'
        'Practical: OpenSSL se RSA key pair generate karke file encrypt/decrypt karo.',
        Quiz('Asymmetric Encryption mein data encrypt karne ke liye kaunsi key use hoti hai?',
            ['Sender ki Private Key', 'Recipient ki Public Key', 'Shared Secret Key'], 1)),
    Lesson('Mobile Security', Icons.phone_android,
        '**JADX** se Android APK decompile hoti hai.\n\n'
        '**Static/Dynamic Analysis**, **ADB** commands, insecure storage common issues hain.\n\n'
        'Practical: JADX se APK decompile karke hardcoded API keys dhoondo.',
        Quiz('Android Reverse Engineering ke liye konsi utility device se connect hoti hai?',
            ['ADB', 'SSH', 'FTP'], 0)),
    Lesson('Cloud Security', Icons.cloud,
        '**IaaS, PaaS, SaaS** cloud service models hain.\n\n'
        '**Misconfigured S3 Buckets** aur **IAM policy errors** common vulnerabilities hain.\n\n'
        'Practical: AWS CLI se publicly readable S3 buckets scan karo.',
        Quiz('Shared Responsibility Model mein Customer ki primary responsibility kya hai?',
            ['Data center security', 'Data security aur IAM', 'Hardware maintenance'], 1)),
    Lesson('Incident Response & Forensics', Icons.biotech,
        '**PICERL** Incident Response Lifecycle hai.\n\n'
        '**Volatility** tool memory forensics ke liye use hota hai.\n\n'
        'Practical: Memory dump ko Volatility mein process karke running processes extract karo.',
        Quiz('Order of Volatility ke mutabiq sabse pehle kya collect karna chahiye?',
            ['Hard disk', 'RAM / Volatile Memory', 'Log files'], 1)),
    Lesson('Pentest Report Writing', Icons.description,
        'Report mein **Executive Summary**, Technical Details, **PoC**, Remediation Steps hote hain.\n\n'
        'Practical: Vulnerability ka PoC writeup aur CISO-level remediation advisory design karo.',
        Quiz('Pentest Report ka Executive Summary kis audience ke liye likha jata hai?',
            ['Developers', 'C-Level Executives (non-technical)', 'Hackers'], 1)),
  ]),
];

/* ===================== STATE ===================== */
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

/* ===================== HELPERS ===================== */
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

/* ===================== MAIN ===================== */
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
    '-sU': 'UDP scan.',
    '-p': 'Specific ports chunna (e.g. -p 22,80).',
    '-A': 'Aggressive: OS, version, scripts, traceroute.',
    '-Pn': 'Host discovery (ping) skip karta hai.',
    '-f': 'Packets fragment karta hai (evasion).',
    'ls': 'Directory ki files list karta hai.',
    '-la': 'Saari files (hidden bhi) detail ke saath.',
    'pwd': 'Abhi ki directory dikhata hai.',
    'cat': 'File ka content print karta hai.',
    'grep': 'Text ke andar pattern dhoondta hai.',
    'cd': 'Directory change karta hai.',
    'dig': 'DNS records query karta hai.',
    'netcat': 'Raw network connections banata hai (banner grabbing).',
    'hashcat': 'GPU-accelerated password cracking tool.',
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
      ['🔎', 'Scanner', app.done.contains('1-2')],
      ['💉', 'Injector', app.done.contains('4-1')],
      ['🕵️', 'Social Engineer', app.done.contains('6-0')],
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
