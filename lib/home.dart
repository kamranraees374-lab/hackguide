import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';
import 'ad_service.dart';
import 'certificate.dart';

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

/// Translation helper. Looks at the global app language and
/// returns the Urdu or English string accordingly.
String T(String ur, String en) => app.lang == 'en' ? en : ur;

class QuizQ {
  final String q, qEn;
  final List<String> o, oEn;
  final int a;
  const QuizQ(this.q, this.o, this.qEn, this.oEn, this.a);
  String question() => T(q, qEn);
  List<String> options() => app.lang == 'en' ? oEn : o;
}

class Lesson {
  final String t;
  final IconData icon;
  final String body, bodyEn;
  final List<QuizQ> quizzes;
  const Lesson(this.t, this.icon, this.body, this.bodyEn, this.quizzes);
  String content() => T(body, bodyEn);
}

class Level {
  final String t, d;
  final IconData icon;
  final List<Lesson> lessons;
  const Level(this.t, this.d, this.icon, this.lessons);
}

/* ===================== 40-LESSON CURRICULUM ===================== */
const levels = <Level>[
Level("Module 1: Foundations & Legal", "CIA Triad, Laws, Networking, Linux, Lab", Icons.shield_outlined, [
Lesson("Intro to Ethical Hacking & CIA Triad", Icons.shield_outlined,
"## Overview\nEthical hacking matlab hai authorized tareeqe se systems ki security test karna, taake kamzoriyan attackers se pehle pata chal sakein. Har professional security assessment ka buniyad **CIA Triad** hai.\n\n## CIA Triad Ke Teen Hissay\n- **Confidentiality**: Sirf authorized log hi data dekh sakein. Encryption aur access control isay protect karte hain.\n- **Integrity**: Data galat tarike se change na ho. Hashing aur checksums isay verify karte hain.\n- **Availability**: System jab zaroorat ho tab accessible rahe. DDoS attacks isay target karte hain.\n\n## Hacker Types\nWhite Hat (authorized, ethical), Black Hat (illegal, malicious), aur Grey Hat (bina ijazat, lekin harmful niyat nahi) - teenon ka farq sirf niyat aur ijazat mein hai, skills same ho sakti hain.\n\n## Key Terms\n**Vulnerability** ek kamzori hai jo exploit ho sakti hai. **Threat** wo cheez hai jo us kamzori ka faida uthaye. **Risk** dono ka combined impact hai - jitni zyada vulnerability aur threat, utna zyada risk.\n\n## Practical Exercise\nTeen real-world security incidents socho (jaise data breach, website down, tampered records) aur har ek ko CIA Triad ke ek component se match karo.",
"## Overview\nEthical hacking means testing a system's security through authorized methods, so weaknesses are found before attackers can exploit them. The foundation of every professional security assessment is the **CIA Triad**.\n\n## The Three Parts of CIA\n- **Confidentiality**: Only authorized people can see the data. Encryption and access control protect this.\n- **Integrity**: Data must not be altered incorrectly. Hashing and checksums verify this.\n- **Availability**: Systems must stay accessible when needed. DDoS attacks target this.\n\n## Hacker Types\nWhite Hat (authorized, ethical), Black Hat (illegal, malicious), and Grey Hat (unauthorized but not malicious in intent) - the difference is purely about intent and authorization, not skill.\n\n## Key Terms\nA **Vulnerability** is a weakness that can be exploited. A **Threat** is something that could exploit that weakness. **Risk** is their combined impact - more vulnerability and threat means more risk.\n\n## Practical Exercise\nThink of three real-world security incidents (a data breach, a website outage, tampered records) and match each one to a CIA Triad component.",
[
QuizQ("Server crash hone par CIA Triad ka kaunsa component fail hota hai?", ["Confidentiality", "Integrity", "Availability"], "Which CIA Triad component fails when a server crashes?", ["Confidentiality", "Integrity", "Availability"], 2),
QuizQ("Confidentiality ko protect karne ka sabse aam tareeqa kya hai?", ["Encryption", "Backup", "Load Balancing"], "What is the most common way to protect Confidentiality?", ["Encryption", "Backup", "Load Balancing"], 0),
QuizQ("Ek Grey Hat hacker Black Hat se kaise mukhtalif hai?", ["Wo ijazat ke bina test karta hai lekin malicious niyat nahi rakhta", "Wo hamesha company ke liye kaam karta hai", "Wo sirf networking seekhta hai"], "How does a Grey Hat hacker differ from a Black Hat?", ["They test without permission but have no malicious intent", "They always work for a company", "They only study networking"], 0),
]),
Lesson("Cyber Laws, Ethics & RoE", Icons.gavel,
"## Overview\nEthical hacking sirf tab legal hai jab ek likhit ijazat mojood ho. Is ijazat ko **Rules of Engagement (RoE)** kehte hain, jo batata hai kya test karna hai, kya nahi, aur kab tak.\n\n## RoE Ke Zaroori Hisse\n- **Scope**: kaunse systems, IPs, ya applications test honge.\n- **Timeline**: test kab shuru aur khatam hoga.\n- **Rules**: kya tareeqe allowed hain.\n- **Emergency Contact**: agar kuch galat ho jaye to kisay inform karna hai.\n\n## NDA Ki Ahmiyat\n**Non-Disclosure Agreement (NDA)** client ka confidential data protect karta hai - tester kisi bhi mili hui information ko bahar share nahi kar sakta.\n\n## Qanoon Jo Jaanna Zaroori Hai\n**PECA** (Prevention of Electronic Crimes Act) aur **Computer Fraud & Abuse Act** jese qawaneen unauthorized access ko crime declare karte hain, chahe niyat achi ho ya buri.\n\n## Practical Exercise\nEk sample RoE document parho aur identify karo ke kaunse systems scope mein hain aur kaunse out-of-scope - phir socho agar tester un out-of-scope systems ko test kare to kya hoga.",
"## Overview\nEthical hacking is only legal when written permission exists. This permission is called the **Rules of Engagement (RoE)**, which defines what can be tested, what cannot, and for how long.\n\n## Essential Parts of an RoE\n- **Scope**: which systems, IPs, or applications will be tested.\n- **Timeline**: when the test starts and ends.\n- **Rules**: which methods are allowed.\n- **Emergency Contact**: who to notify if something goes wrong.\n\n## Why an NDA Matters\nA **Non-Disclosure Agreement (NDA)** protects the client's confidential data - the tester cannot share any information they obtain.\n\n## Laws You Should Know\nLaws like **PECA** (Prevention of Electronic Crimes Act) and the **Computer Fraud & Abuse Act** make unauthorized access a crime, regardless of intent.\n\n## Practical Exercise\nRead a sample RoE document and identify which systems are in scope and which are out of scope - then consider what happens if a tester tests an out-of-scope system.",
[
QuizQ("Unauthorized penetration testing conduct karne par kaunsa law violate hota hai agar client authorization sign na ho?", ["Copyright Act", "Computer Misuse / Cybercrime Act", "Data Protection Act"], "Which law is violated by conducting unauthorized penetration testing without signed client authorization?", ["Copyright Act", "Computer Misuse / Cybercrime Act", "Data Protection Act"], 1),
QuizQ("RoE mein Scope kis cheez ko define karta hai?", ["Konse systems test honge", "Tester ki salary", "Report ka design"], "What does 'Scope' define in an RoE?", ["Which systems will be tested", "The tester's salary", "The report's design"], 0),
QuizQ("NDA ka asal maqsad kya hai?", ["Confidential data ko bahar jaane se rokna", "Test ki speed badhana", "Zyada systems test karna"], "What is the real purpose of an NDA?", ["Preventing confidential data from leaking", "Speeding up the test", "Testing more systems"], 0),
]),
Lesson("Networking Fundamentals", Icons.lan,
"## Overview\nHar network attack ya defense samajhne ke liye networking ki buniyad janna zaroori hai. Do bade models hain: **OSI** aur **TCP/IP**.\n\n## OSI vs TCP/IP\nOSI Model mein 7 layers hoti hain (Physical se Application tak), jabke TCP/IP Model sirf 4 layers mein kaam simplify karta hai. Dono data ko network ke through safely bhejne ka tareeqa define karte hain.\n\n## Common Ports Yaad Rakho\n`21` FTP (file transfer), `22` SSH (secure remote access), `80` HTTP (web, unencrypted), `443` HTTPS (web, encrypted), `3389` RDP (Windows remote desktop).\n\n## TCP vs UDP\n**TCP** connection-oriented hai - pehle handshake hota hai, data guaranteed deliver hota hai. **UDP** connectionless hai - tez hai lekin delivery guaranteed nahi.\n\n## Practical Exercise\nApne phone ya computer par ek website kholo aur socho ke is request mein kaunse ports aur protocols involve honge.",
"## Overview\nUnderstanding networking basics is essential before any network attack or defense makes sense. There are two major models: **OSI** and **TCP/IP**.\n\n## OSI vs TCP/IP\nThe OSI Model has 7 layers (from Physical to Application), while the TCP/IP Model simplifies this into 4 layers. Both define how data travels safely across a network.\n\n## Common Ports to Remember\n`21` FTP (file transfer), `22` SSH (secure remote access), `80` HTTP (web, unencrypted), `443` HTTPS (web, encrypted), `3389` RDP (Windows remote desktop).\n\n## TCP vs UDP\n**TCP** is connection-oriented - a handshake happens first, and delivery is guaranteed. **UDP** is connectionless - faster but delivery is not guaranteed.\n\n## Practical Exercise\nOpen a website on your phone or computer and think about which ports and protocols are involved in that request.",
[
QuizQ("Encrypted remote terminal management ke liye konsa default port istemal hota hai?", ["Port 21", "Port 22", "Port 80"], "Which default port is used for encrypted remote terminal management?", ["Port 21", "Port 22", "Port 80"], 1),
QuizQ("TCP aur UDP mein buniyadi farq kya hai?", ["TCP guaranteed delivery deta hai, UDP nahi", "UDP zyada secure hai", "TCP sirf gaming ke liye hai"], "What is the basic difference between TCP and UDP?", ["TCP guarantees delivery, UDP does not", "UDP is more secure", "TCP is only for gaming"], 0),
QuizQ("HTTPS kis cheez se HTTP se mukhtalif hai?", ["HTTPS traffic ko encrypt karta hai", "HTTPS tez hai", "HTTPS sirf mobile par chalta hai"], "How is HTTPS different from HTTP?", ["HTTPS encrypts the traffic", "HTTPS is faster", "HTTPS only works on mobile"], 0),
]),
Lesson("Linux CLI Mastery", Icons.terminal,
"## Overview\nMost security tools Linux par chalte hain, is liye command line ka confident istemal zaroori hai. Chhote commands milkar powerful automation banate hain.\n\n## Zaroori Commands\n`pwd` - abhi ki directory dikhata hai.\n`ls -la` - saari files (hidden bhi) list karta hai.\n`cat file` - file ka content screen par print karta hai.\n`cd folder` - directory change karta hai.\n\n## Text Processing Tools\n`grep` kisi pattern ko text mein dhoondta hai. `awk` aur `sed` text ko columns ya patterns ke hisaab se process karte hain. Pipe `|` ek command ka output doosri command ko deta hai.\n\n## File Permissions\nLinux mein har file ke paas read (r), write (w), execute (x) permissions hoti hain - owner, group, aur others ke liye alag alag. `chmod` command permissions change karta hai.\n\n## Security Angle\n`/etc/shadow` jesi sensitive files sirf root access kar sakta hai. Galat permissions privilege escalation ka darwaza khol sakti hain.\n\n## Practical Exercise\nEk sample log file socho jis mein kai IP addresses hain - `grep` command likho jo sirf failed login attempts wali lines dikhaye.",
"## Overview\nMost security tools run on Linux, so confident use of the command line is essential. Small commands combine to form powerful automation.\n\n## Essential Commands\n`pwd` - shows the current directory.\n`ls -la` - lists all files, including hidden ones.\n`cat file` - prints a file's content to the screen.\n`cd folder` - changes directory.\n\n## Text Processing Tools\n`grep` searches text for a pattern. `awk` and `sed` process text by columns or patterns. The pipe `|` passes one command's output into another.\n\n## File Permissions\nEvery file in Linux has read (r), write (w), and execute (x) permissions - separately for owner, group, and others. `chmod` changes these permissions.\n\n## Security Angle\nSensitive files like `/etc/shadow` can only be accessed by root. Incorrect permissions can open the door to privilege escalation.\n\n## Practical Exercise\nImagine a sample log file with many IP addresses - write a `grep` command that shows only the failed login attempt lines.",
[
QuizQ("Linux mein /etc/shadow file ki access kin users ke paas hoti hai?", ["Har user", "Strictly Root User", "Guest user"], "Who has access to the /etc/shadow file on Linux?", ["Every user", "Strictly the Root User", "Guest user"], 1),
QuizQ("Kisi file mein pattern dhoondne ke liye kaunsa command use hota hai?", ["grep", "cd", "pwd"], "Which command is used to search for a pattern inside a file?", ["grep", "cd", "pwd"], 0),
QuizQ("Linux file permissions mein x ka matlab kya hai?", ["Execute", "Export", "Extend"], "What does 'x' mean in Linux file permissions?", ["Execute", "Export", "Extend"], 0),
]),
Lesson("Safe Virtual Hacking Lab", Icons.computer,
"## Overview\nKabhi bhi live, real-world systems par practice mat karo. Ek safe, isolated lab banana har ethical hacker ka pehla kadam hai.\n\n## Lab Ke Components\n- **Hypervisor** (VirtualBox ya VMware): multiple virtual machines ek hi computer par chalata hai.\n- **Attacker Machine**: usually **Kali Linux**, jis mein saare pentesting tools pre-installed hain.\n- **Target Machines**: **Metasploitable** ya **DVWA** jese intentionally vulnerable systems jahan practice ki ja sakti hai.\n\n## Networking Modes\n- **NAT**: VM ko internet access deta hai lekin host network se isolate rakhta hai.\n- **Bridged**: VM ko host ke network ka hissa bana deta hai (risky for practice).\n- **Host-Only**: VM sirf host computer se connect ho sakta hai, bahar ki duniya se bilkul isolated - practice ke liye sabse safe.\n\n## Kyun Zaroori Hai\nAgar tum apne hi ghar ke router ya kisi real website par attack practice karo, to ye illegal ho sakta hai aur nuqsaan bhi pohncha sakta hai. Isolated lab mein galtiyan bhi harmless hoti hain.\n\n## Practical Exercise\nApne lab mein attacker machine se `ping` command use karke target VM ki connectivity check karo.",
"## Overview\nNever practice on live, real-world systems. Building a safe, isolated lab is the first step for every ethical hacker.\n\n## Lab Components\n- **Hypervisor** (VirtualBox or VMware): runs multiple virtual machines on one computer.\n- **Attacker Machine**: usually **Kali Linux**, which comes with pentesting tools pre-installed.\n- **Target Machines**: intentionally vulnerable systems like **Metasploitable** or **DVWA** to practice on.\n\n## Networking Modes\n- **NAT**: gives the VM internet access but isolates it from the host network.\n- **Bridged**: makes the VM part of the host network (risky for practice).\n- **Host-Only**: the VM can only connect to the host computer, fully isolated from the outside world - the safest option for practice.\n\n## Why This Matters\nIf you practice attacks on your own home router or a real website, it could be illegal and cause real damage. In an isolated lab, even mistakes are harmless.\n\n## Practical Exercise\nFrom the attacker machine in your lab, use the `ping` command to check connectivity to the target VM.",
[
QuizQ("Target machine ko host aur internet se isolate rakhne ke liye kaunsa VM network mode best hai?", ["Bridged", "NAT", "Host-Only Network"], "Which VM network mode best isolates the target machine from the host and the internet?", ["Bridged", "NAT", "Host-Only Network"], 2),
QuizQ("Kaunsa tool ya system intentionally vulnerable hota hai practice ke liye?", ["Metasploitable", "Windows 11", "iOS"], "Which tool or system is intentionally vulnerable for practice?", ["Metasploitable", "Windows 11", "iOS"], 0),
QuizQ("NAT mode mein VM ko kya milta hai?", ["Internet access lekin host se isolation", "Direct access to host files", "No network at all"], "What does a VM get in NAT mode?", ["Internet access but isolation from the host", "Direct access to host files", "No network at all"], 0),
]),
]),
Level("Module 2: Reconnaissance", "OSINT, Nmap, DNS, Google Dorking", Icons.travel_explore, [
Lesson("Passive Recon & OSINT", Icons.travel_explore,
"## Overview\nPassive reconnaissance mein target se directly interact kiye baghair information collect ki jati hai - is liye ye sabse safe aur low-risk recon technique hai.\n\n## OSINT Kya Hai\n**OSINT (Open Source Intelligence)** har wo publicly available information hai jo internet par mojood hai - social media, company websites, job postings, public records.\n\n## Zaroori Tools\n- **WHOIS**: domain registration info deta hai.\n- **Shodan**: internet se connected devices ko index karta hai, sometimes unauthenticated bhi mil jate hain.\n- **archive.org (Wayback Machine)**: kisi website ke purane versions dekhne deta hai, jo deleted info reveal kar sakte hain.\n\n## Recon Kyun Pehla Qadam Hai\nJitni zyada information collect hogi, utna behtar agla step plan ho sakega. Companies bhi isi wajah se apna OSINT footprint kam rakhne ki koshish karti hain.\n\n## Practical Exercise\nShodan par webcam ya default password search karke dekho kitne unauthenticated devices publicly listed hain (sirf dekho, access mat karo).",
"## Overview\nPassive reconnaissance collects information without directly interacting with the target - making it the safest, lowest-risk recon technique.\n\n## What is OSINT\n**OSINT (Open Source Intelligence)** is any publicly available information on the internet - social media, company websites, job postings, public records.\n\n## Essential Tools\n- **WHOIS**: gives domain registration info.\n- **Shodan**: indexes internet-connected devices, sometimes finding unauthenticated ones.\n- **archive.org (Wayback Machine)**: lets you view old versions of a website, which can reveal deleted information.\n\n## Why Recon is the First Step\nThe more information gathered, the better the next step can be planned. This is why companies try to minimize their OSINT footprint too.\n\n## Practical Exercise\nSearch Shodan for webcam or default password and see how many unauthenticated devices are publicly listed (just observe, do not access).",
[
QuizQ("Shodan internet-connected devices ko index karne ke liye sab se pehle kya scan karta hai?", ["File content", "Service Banners", "User passwords"], "What does Shodan scan first to index internet-connected devices?", ["File contents", "Service Banners", "User passwords"], 1),
QuizQ("OSINT ka matlab kya hai?", ["Open Source Intelligence", "Online Security Information Network", "Operational System Intrusion Network"], "What does OSINT stand for?", ["Open Source Intelligence", "Online Security Information Network", "Operational System Intrusion Network"], 0),
QuizQ("Wayback Machine kis kaam aata hai?", ["Website ke purane versions dekhne ke liye", "Passwords crack karne ke liye", "Ports scan karne ke liye"], "What is the Wayback Machine used for?", ["Viewing a website's old versions", "Cracking passwords", "Scanning ports"], 0),
]),
Lesson("Active Recon & Network Discovery", Icons.radar,
"## Overview\nActive reconnaissance mein target se directly interact kiya jata hai - jaise ping bhejna ya connection try karna. Ye passive se zyada information deta hai lekin detect hone ka risk bhi zyada hota hai.\n\n## Host Discovery Techniques\n- **Ping Sweep** (`fping`): ek range ke saare IP addresses ko ping karke batata hai kaunse live hain.\n- **ARP Scan** (`arp-scan`): local network par mojood devices ko unki MAC address se discover karta hai.\n\n## ARP Kaise Kaam Karta Hai\n**ARP (Address Resolution Protocol)** IP address ko MAC address mein convert karta hai - har device apne LAN segment mein is tareeqe se pehchana jata hai.\n\n## Passive vs Active: Risk Trade-off\nPassive recon mein target ko pata nahi chalta ke koi dekh raha hai. Active recon mein target ke logs mein traffic record ho sakta hai, is liye authorization aur stealth dono zaroori hain.\n\n## Practical Exercise\nApne hi home network par arp-scan (ya equivalent app) chala kar dekho kitne devices connected hain.",
"## Overview\nActive reconnaissance directly interacts with the target - like sending a ping or attempting a connection. It reveals more information than passive recon but carries a higher risk of detection.\n\n## Host Discovery Techniques\n- **Ping Sweep** (`fping`): pings every IP in a range to find which ones are live.\n- **ARP Scan** (`arp-scan`): discovers devices on the local network by their MAC address.\n\n## How ARP Works\n**ARP (Address Resolution Protocol)** converts an IP address into a MAC address - this is how every device is identified within its LAN segment.\n\n## Passive vs Active: The Risk Trade-off\nIn passive recon, the target does not know they are being observed. In active recon, traffic may show up in the target's logs, so both authorization and stealth matter.\n\n## Practical Exercise\nRun arp-scan (or an equivalent app) on your own home network and see how many devices are connected.",
[
QuizQ("Kaunsa protocol LAN par IP address ko MAC address mein resolve karta hai?", ["DNS", "ARP", "DHCP"], "Which protocol resolves an IP address to a MAC address on a LAN?", ["DNS", "ARP", "DHCP"], 1),
QuizQ("Ping sweep kis kaam aata hai?", ["Ek range mein live hosts dhoondne ke liye", "Passwords crack karne ke liye", "Websites clone karne ke liye"], "What is a ping sweep used for?", ["Finding live hosts in a range", "Cracking passwords", "Cloning websites"], 0),
QuizQ("Active recon passive se zyada risky kyun hai?", ["Target ke logs mein traffic record ho sakta hai", "Ye hamesha illegal hota hai", "Ye sirf wireless networks par kaam karta hai"], "Why is active recon riskier than passive recon?", ["Traffic may get recorded in the target's logs", "It is always illegal", "It only works on wireless networks"], 0),
]),
Lesson("Advanced Port Scanning & Nmap", Icons.search,
"## Overview\n**Nmap (Network Mapper)** duniya ka sab se popular network scanning tool hai. Ye batata hai kaunse ports khule hain, kaunsi services chal rahi hain, aur kabhi kabhi OS bhi identify kar leta hai.\n\n## Scan Types\n- **-sS (SYN Scan)**: stealth scan kehlata hai, kyunke ye Three-Way Handshake pura nahi karta.\n- **-sU (UDP Scan)**: UDP-based services ke liye use hota hai, TCP se slow hota hai.\n- **-sV (Version Detection)**: service ka exact version pata karta hai.\n\n## Port States\nNmap teen cheezein batata hai: **open** (service response de rahi hai), **closed** (port band hai lekin host live hai), aur **filtered** (firewall response ko block kar raha hai).\n\n## NSE (Nmap Scripting Engine)\nNSE scripts extra automated checks karte hain - jaise kisi known vulnerability ko verify karna, bina manual kaam ke.\n\n## Practical Exercise\nTools tab mein jaa kar apna Port Scanner tool kisi authorized target par chalao aur results ka result samjho.",
"## Overview\n**Nmap (Network Mapper)** is the world's most popular network scanning tool. It shows which ports are open, which services are running, and sometimes even identifies the OS.\n\n## Scan Types\n- **-sS (SYN Scan)**: called a stealth scan because it does not complete the Three-Way Handshake.\n- **-sU (UDP Scan)**: used for UDP-based services, slower than TCP.\n- **-sV (Version Detection)**: finds the exact service version.\n\n## Port States\nNmap reports three states: **open** (the service is responding), **closed** (the port is shut but the host is alive), and **filtered** (a firewall is blocking the response).\n\n## NSE (Nmap Scripting Engine)\nNSE scripts run extra automated checks - like verifying a known vulnerability, without manual work.\n\n## Practical Exercise\nGo to the Tools tab and run the Port Scanner tool against an authorized target, then interpret the results.",
[
QuizQ("Nmap ka SYN Scan Three-Way Handshake kyun pura nahi karta?", ["Scan tez aur stealthy rakhne ke liye", "Target crash karne ke liye", "Password nikalne ke liye"], "Why does Nmap's SYN Scan not complete the Three-Way Handshake?", ["To keep the scan fast and stealthy", "To crash the target", "To extract passwords"], 0),
QuizQ("Nmap mein filtered port ka matlab kya hai?", ["Firewall response block kar raha hai", "Service chal rahi hai", "Host offline hai"], "What does a filtered port mean in Nmap?", ["A firewall is blocking the response", "The service is running", "The host is offline"], 0),
QuizQ("NSE scripts kya karte hain?", ["Automated extra checks (jaise vulnerability verify karna)", "Sirf ports band karte hain", "Password reset karte hain"], "What do NSE scripts do?", ["Run automated extra checks (like verifying a vulnerability)", "Only close ports", "Reset passwords"], 0),
]),
Lesson("DNS Enumeration & Subdomain Discovery", Icons.dns,
"## Overview\n**DNS (Domain Name System)** domain names ko IP addresses mein convert karta hai. DNS enumeration se target ki infrastructure ka naqsha bana sakta hai.\n\n## DNS Record Types\n- **A**: domain ko IPv4 address se map karta hai.\n- **MX**: mail servers batata hai.\n- **TXT**: verification aur policy records rakhta hai.\n- **NS**: nameservers batata hai.\n- **CNAME**: ek domain ko doosre domain ka alias banata hai.\n\n## Zone Transfer Attack\n**Zone Transfer (AXFR)** ek mechanism hai jahan secondary DNS server primary se poori zone copy karta hai. Agar misconfigured ho, to koi bhi poori DNS zone hasil kar sakta hai.\n\n## Subdomain Discovery\nCompanies ke paas aksar kai subdomains hote hain jo publicly advertise nahi hote lekin phir bhi accessible ho sakte hain.\n\n## Practical Exercise\nTools tab mein DNS Lookup tool se koi domain resolve karo aur dekho kitne IP addresses return hote hain.",
"## Overview\n**DNS (Domain Name System)** converts domain names into IP addresses. DNS enumeration lets you map out a target's infrastructure.\n\n## DNS Record Types\n- **A**: maps a domain to an IPv4 address.\n- **MX**: identifies mail servers.\n- **TXT**: holds verification and policy records.\n- **NS**: identifies nameservers.\n- **CNAME**: makes one domain an alias of another.\n\n## Zone Transfer Attacks\nA **Zone Transfer (AXFR)** is a mechanism where a secondary DNS server copies the entire zone from the primary. If misconfigured, anyone can obtain the entire DNS zone.\n\n## Subdomain Discovery\nCompanies often have many subdomains that are not publicly advertised but may still be accessible.\n\n## Practical Exercise\nUse the DNS Lookup tool in the Tools tab to resolve a domain and see how many IP addresses are returned.",
[
QuizQ("DNS Zone Transfer attack ke liye kaunsa record exploit hota hai?", ["AXFR record", "MX record", "TXT record"], "Which record type is exploited in a DNS Zone Transfer attack?", ["AXFR record", "MX record", "TXT record"], 0),
QuizQ("MX record kis kaam ke liye hota hai?", ["Mail servers identify karne ke liye", "Website ka design batane ke liye", "Password store karne ke liye"], "What is an MX record used for?", ["Identifying mail servers", "Showing a website design", "Storing passwords"], 0),
QuizQ("Subdomain discovery kyun zaroori hai?", ["Unadvertised lekin accessible subdomains mil sakte hain", "Ye sirf design behtar karta hai", "Ye sirf email ke liye hota hai"], "Why is subdomain discovery important?", ["It can reveal unadvertised but accessible subdomains", "It only improves design", "It is only for email"], 0),
]),
Lesson("Google Dorking & Metadata Analysis", Icons.image_search,
"## Overview\nGoogle jese search engines internet ka bohot bara hissa index karte hain - sahi queries se sensitive information bhi mil sakti hai jo kabhi accidentally publicly expose ho gayi ho.\n\n## Advanced Search Operators\n- `filetype:pdf` - sirf ek specific file type dhoondta hai.\n- `inurl:admin` - URL mein admin word wali pages dhoondta hai.\n- `intitle:index of` - open directory listings dhoondta hai.\n- `site:example.com` - sirf ek specific website ke andar search karta hai.\n\n## Google Dork Example\nQuery `filetype:env 'DB_PASSWORD'` jesi exposed env configuration files dhoond sakti hai jin mein database credentials hoti hain.\n\n## Metadata Analysis\nFiles ke andar **metadata** chhupa hota hai - jaise author ka naam, software version, ya GPS location. **Exiftool** jesa tool ye information extract kar sakta hai.\n\n## Practical Exercise\nKisi public PDF file ko Exiftool (ya online metadata viewer) se check karo aur dekho kitni information chhupi hui milti hai.",
"## Overview\nSearch engines like Google index a huge portion of the internet - the right queries can surface sensitive information that was accidentally exposed publicly.\n\n## Advanced Search Operators\n- `filetype:pdf` - finds only a specific file type.\n- `inurl:admin` - finds pages with admin in the URL.\n- `intitle:index of` - finds open directory listings.\n- `site:example.com` - searches only within a specific website.\n\n## Google Dork Example\nA query like `filetype:env 'DB_PASSWORD'` can find exposed env configuration files containing database credentials.\n\n## Metadata Analysis\nFiles hide **metadata** - like the author name, software version, or GPS location. A tool like **Exiftool** can extract this information.\n\n## Practical Exercise\nCheck a public PDF file with Exiftool (or an online metadata viewer) and see how much hidden information you find.",
[
QuizQ("Google dork filetype:env DB_PASSWORD kis cheez ko uncover karta hai?", ["Exposed config files", "Server logs", "User photos"], "What does the Google dork filetype:env DB_PASSWORD uncover?", ["Exposed config files", "Server logs", "User photos"], 0),
QuizQ("site:example.com operator kya karta hai?", ["Sirf us website ke andar search karta hai", "Website delete karta hai", "Password reset karta hai"], "What does the site:example.com operator do?", ["Searches only within that website", "Deletes the website", "Resets passwords"], 0),
QuizQ("Exiftool kis kaam aata hai?", ["Files se hidden metadata nikalne ke liye", "Ports scan karne ke liye", "Hashes crack karne ke liye"], "What is Exiftool used for?", ["Extracting hidden metadata from files", "Scanning ports", "Cracking hashes"], 0),
]),
]),
Level("Module 3: Vulnerability Assessment", "CVSS, Scanning, Burp Suite", Icons.assessment, [
Lesson("VA Methodology & CVSS", Icons.assessment,
"## Overview\nVulnerability Assessment (VA) ek systematic process hai jahan systems ko scan karke kamzoriyan dhoondi jati hain aur unki severity score ki jati hai - bina unhe actually exploit kiye.\n\n## CVSS Scoring\n**CVSS (Common Vulnerability Scoring System)** har vulnerability ko 0 se 10 tak score deta hai. 0-3.9 Low, 4.0-6.9 Medium, 7.0-8.9 High, aur 9.0-10 Critical kehlata hai.\n\n## CVSS Metrics\n- **Attack Vector**: kya exploit remote network se ho sakta hai ya sirf physical access se.\n- **Attack Complexity**: exploit karna kitna mushkil hai.\n- **Privileges Required**: attacker ko pehle se kitni access chahiye.\n\n## False Positive vs True Positive\nScanners kabhi kabhi galat alert dete hain (**False Positive**) - manual verification se pata chalta hai ke ye asal kamzori hai (**True Positive**) ya nahi.\n\n## Practical Exercise\nEk sample CVE description parho aur uske Attack Vector aur Privileges Required metrics identify karne ki koshish karo.",
"## Overview\nVulnerability Assessment (VA) is a systematic process of scanning systems to find weaknesses and score their severity - without actually exploiting them.\n\n## CVSS Scoring\n**CVSS (Common Vulnerability Scoring System)** scores every vulnerability from 0 to 10. 0-3.9 is Low, 4.0-6.9 Medium, 7.0-8.9 High, and 9.0-10 is Critical.\n\n## CVSS Metrics\n- **Attack Vector**: whether it is exploitable remotely over a network or only with physical access.\n- **Attack Complexity**: how difficult the exploit is to carry out.\n- **Privileges Required**: how much access the attacker needs beforehand.\n\n## False Positive vs True Positive\nScanners sometimes give incorrect alerts (**False Positive**) - manual verification determines whether it is a real weakness (**True Positive**) or not.\n\n## Practical Exercise\nRead a sample CVE description and try to identify its Attack Vector and Privileges Required metrics.",
[
QuizQ("CVSS metric mein Attack Vector: Network ka kya matlab hai?", ["Sirf physical access se exploit", "Remote internet se exploit", "Sirf local user exploit kar sakta hai"], "What does Attack Vector: Network mean in a CVSS metric?", ["Exploitable only with physical access", "Exploitable remotely over the internet", "Only a local user can exploit it"], 1),
QuizQ("CVSS score 9.5 kis category mein aayega?", ["Critical", "Low", "Medium"], "A CVSS score of 9.5 falls into which category?", ["Critical", "Low", "Medium"], 0),
QuizQ("False Positive ka matlab kya hai?", ["Scanner ki ghalat alert", "Asal kamzori jo confirm ho chuki hai", "Ek naya exploit"], "What does a False Positive mean?", ["An incorrect scanner alert", "A confirmed real weakness", "A new exploit"], 0),
]),
Lesson("Network Vulnerability Scanning", Icons.network_check,
"## Overview\nManual recon ke baad, automated scanners bara scale par vulnerabilities dhoondne mein madad karte hain - ye hundreds of checks minutes mein kar lete hain.\n\n## Popular Scanners\n**Nessus** aur **OpenVAS** industry-standard tools hain jo network devices, servers, aur applications ko scan karke known vulnerabilities ke against match karte hain.\n\n## Credentialed vs Non-Credentialed\n- **Non-credentialed scan**: bahar se, jese ek attacker dekhta hai.\n- **Credentialed scan**: scanner ko login credentials diye jate hain, jisse wo zyada accurate hota hai.\n\n## Compliance Checks\nMany organizations ko regulatory standards (jaise PCI-DSS, HIPAA) follow karna hota hai - scanners inke against bhi check kar sakte hain.\n\n## Scan Ke Baad Kya\nRaw scan results mein bohot sari false positives hoti hain - in results ko analyze karna agla zaroori step hai.\n\n## Practical Exercise\nSocho tumhare paas ek credentialed aur ek non-credentialed scan ka report hai - dono mein kya farq expect karoge?",
"## Overview\nAfter manual recon, automated scanners help find vulnerabilities at scale - running hundreds of checks in minutes.\n\n## Popular Scanners\n**Nessus** and **OpenVAS** are industry-standard tools that scan network devices, servers, and applications against known vulnerabilities.\n\n## Credentialed vs Non-Credentialed\n- **Non-credentialed scan**: from the outside, like an attacker sees it.\n- **Credentialed scan**: the scanner is given login credentials, making it far more accurate.\n\n## Compliance Checks\nMany organizations must follow regulatory standards (like PCI-DSS, HIPAA) - scanners can check against these too.\n\n## What Comes After Scanning\nRaw scan results contain plenty of false positives - analyzing them is the next essential step.\n\n## Practical Exercise\nImagine you have one credentialed and one non-credentialed scan report - what differences would you expect between them?",
[
QuizQ("Credentialed scan non-credentialed se zyada accurate kyun hota hai?", ["Yeh OS ke andar config aur patches read karta hai", "Yeh tez chalta hai", "Yeh encrypted hota hai"], "Why is a credentialed scan more accurate than a non-credentialed one?", ["It can read internal OS config and missing patches", "It runs faster", "It is encrypted"], 0),
QuizQ("Non-credentialed scan kis perspective se kiya jata hai?", ["Jaise ek bahar wala attacker dekhta hai", "Jaise admin dekhta hai", "Jaise database dekhta hai"], "From which perspective is a non-credentialed scan done?", ["Like an outside attacker sees it", "Like an admin sees it", "Like a database sees it"], 0),
QuizQ("Compliance checks kis liye zaroori hain?", ["Regulatory standards follow karne ke liye", "Sirf speed test karne ke liye", "Sirf design check karne ke liye"], "Why are compliance checks important?", ["To follow regulatory standards", "Only to test speed", "Only to check design"], 0),
]),
Lesson("Web App Scanning with Burp Suite", Icons.language,
"## Overview\nWeb applications aaj kal sab se zyada attack hone wale targets hain. **Burp Suite** ek intercepting proxy hai jo browser aur server ke beech traffic ko dekhne aur modify karne deta hai.\n\n## Burp Ke Core Tools\n- **Proxy**: browser traffic ko capture karta hai.\n- **Repeater**: ek single request ko bar bar modify karke resend karne deta hai.\n- **Intruder**: automated attacks chalata hai, jaise multiple payloads ek parameter par try karna.\n\n## HTTP Request Ka Structure\nHar HTTP request mein **method** (GET/POST), **headers**, aur **body** hota hai.\n\n## Kyun Proxy Zaroori Hai\nBina proxy ke, browser ka traffic directly server ko chala jata hai. Proxy isay beech mein rok kar edit karne ka mauka deta hai.\n\n## Practical Exercise\nBurp Proxy on karke apne browser se koi website kholo aur dekho kitni requests capture hoti hain.",
"## Overview\nWeb applications are among today's most attacked targets. **Burp Suite** is an intercepting proxy that lets you see and modify traffic between the browser and server.\n\n## Burp Core Tools\n- **Proxy**: captures browser traffic.\n- **Repeater**: lets you modify and resend a single request repeatedly.\n- **Intruder**: runs automated attacks, like trying multiple payloads against one parameter.\n\n## HTTP Request Structure\nEvery HTTP request has a **method** (GET/POST), **headers**, and a **body**.\n\n## Why a Proxy Matters\nWithout a proxy, browser traffic goes directly to the server. A proxy intercepts it in the middle, giving the chance to edit it.\n\n## Practical Exercise\nTurn on Burp Proxy, open any website in your browser, and see how many requests get captured.",
[
QuizQ("Burp Suite ka Repeater tool kis kaam ke liye use hota hai?", ["Multiple requests automate karna", "Single request modify karke bar-bar test karna", "Network scan karna"], "What is Burp Suite's Repeater tool mainly used for?", ["Automating multiple requests", "Modifying and resending a single request repeatedly", "Scanning the network"], 1),
QuizQ("Burp Suite ka Intruder tool kis liye use hota hai?", ["Automated attacks (multiple payloads) chalane ke liye", "Sirf screenshots lene ke liye", "File download karne ke liye"], "What is Burp Suite's Intruder tool used for?", ["Running automated attacks (multiple payloads)", "Only taking screenshots", "Downloading files"], 0),
QuizQ("HTTP request mein method kya batata hai?", ["Request ka type (jaise GET ya POST)", "Server ka naam", "Browser ka version"], "What does the method in an HTTP request indicate?", ["The type of request (like GET or POST)", "The server name", "The browser version"], 0),
]),
Lesson("Banner Grabbing & Service Enumeration", Icons.router,
"## Overview\nEk baar ports open mil jayein, to agla step hai pata lagana ke har port par konsi exact service aur version chal rahi hai - isay banner grabbing kehte hain.\n\n## Banner Kya Hota Hai\nMany services connection hote hi apna naam aur version announce kar dete hain - isay **banner** kehte hain.\n\n## Tools\n`netcat` (nc) aur `telnet` simple raw connections bana kar banners capture karte hain. Nmap ka -sV flag bhi automated version detection karta hai.\n\n## Banner Grabbing Kyun Important Hai\nEk baar exact version pata chal jaye, attacker us version ki known vulnerabilities dhoond sakta hai - isliye bohot se admins banners hide ya fake kar dete hain.\n\n## Security Through Obscurity Ki Limit\nBanner hide karna poori security nahi hai - asal security patching aur hardening se aati hai.\n\n## Practical Exercise\nSocho ek web server banner nginx/1.18.0 return kar raha hai - is version ki known vulnerabilities online search karo (sirf information ke liye).",
"## Overview\nOnce open ports are found, the next step is identifying exactly which service and version is running on each port - this is called banner grabbing.\n\n## What is a Banner\nMany services announce their name and version as soon as a connection is made - this is called a **banner**.\n\n## Tools\n`netcat` (nc) and `telnet` create simple raw connections to capture banners. Nmap's -sV flag also does automated version detection.\n\n## Why Banner Grabbing Matters\nOnce the exact version is known, an attacker can look up its known vulnerabilities - which is why many admins hide or fake banners.\n\n## The Limit of Security Through Obscurity\nHiding a banner is not full security - real security comes from patching and hardening.\n\n## Practical Exercise\nImagine a web server banner returns nginx/1.18.0 - search online for that version's known vulnerabilities (for information only).",
[
QuizQ("Server banners hide karne se kis attack ko mushkil hota hai?", ["Phishing", "Automated service-specific exploit", "Password reset"], "Hiding server banners makes which type of attack harder?", ["Phishing", "Automated service-specific exploitation", "Password reset"], 1),
QuizQ("Banner kya reveal karta hai?", ["Service ka naam aur version", "User ka password", "Database ka structure"], "What does a banner reveal?", ["The service name and version", "The user's password", "The database structure"], 0),
QuizQ("Nmap ka kaunsa flag version detect karta hai?", ["-sV", "-sS", "-Pn"], "Which Nmap flag detects the version?", ["-sV", "-sS", "-Pn"], 0),
]),
Lesson("Analyzing & Prioritizing Scan Results", Icons.filter_alt,
"## Overview\nEk scan sainkron findings return kar sakta hai - lekin sab exploitable nahi hote. Results ko samajhna aur prioritize karna scanning jitna hi zaroori skill hai.\n\n## Triage Process\n**Triage** matlab findings ko categorize karna: kaunse definitely real hain, kaunse false positives hain.\n\n## False Positive Ko Pehchanna\nAgar scanner kisi service ko vulnerable bataye lekin manual testing se exploit na ho sake, to ye **False Positive** hai.\n\n## Business Context Risk Mapping\nSirf CVSS score hi kaafi nahi - ek Medium severity vulnerability agar production database par ho, to usay High priority milni chahiye.\n\n## Prioritization Framework\nSimple approach: Severity x Exploitability x Business Impact = Priority.\n\n## Practical Exercise\nSocho tumhare paas 10 findings hain - 3 Critical (lekin low business impact), 2 Medium (high business impact production server par). Konse 3 pehle fix karoge?",
"## Overview\nA scan can return hundreds of findings - but not all are exploitable. Understanding and prioritizing results is just as important as scanning itself.\n\n## The Triage Process\n**Triage** means categorizing findings: which are definitely real, which are false positives.\n\n## Recognizing a False Positive\nIf a scanner flags a service as vulnerable but manual testing cannot exploit it, that is a **False Positive**.\n\n## Business Context Risk Mapping\nA CVSS score alone is not enough - a Medium-severity vulnerability on a production database should get High priority.\n\n## A Prioritization Framework\nA simple approach: Severity x Exploitability x Business Impact = Priority.\n\n## Practical Exercise\nImagine you have 10 findings - 3 Critical (but low business impact), 2 Medium (high business impact on a production server). Which 3 would you fix first?",
[
QuizQ("Agar scanner vulnerable bataye par manual test se exploit na ho, to yeh kya hai?", ["True Positive", "False Positive", "Critical Risk"], "If a scanner flags something vulnerable but manual testing cannot exploit it, what is this called?", ["True Positive", "False Positive", "Critical Risk"], 1),
QuizQ("Triage process ka maqsad kya hai?", ["Findings ko categorize aur verify karna", "Scan ko tez karna", "Report delete karna"], "What is the purpose of the triage process?", ["Categorizing and verifying findings", "Speeding up the scan", "Deleting the report"], 0),
QuizQ("Business context risk mapping mein sabse zaroori factor kya hai?", ["Production system par asal impact", "Sirf CVSS number", "Scanner ka naam"], "In business context risk mapping, what matters most?", ["The real impact on a production system", "Just the CVSS number", "The name of the scanner"], 0),
]),
]),
Level("Module 4: System Hacking", "Passwords, Metasploit, Privesc, Malware", Icons.lock_open, [
Lesson("Password Cracking & Hashing", Icons.key,
"## Overview\nPasswords aksar plaintext mein store nahi hote - unka **hash** store hota hai. Password cracking ka matlab hai in hashes ko reverse engineer karne ki koshish karna.\n\n## Hashing Algorithms\n- **MD5**: purana aur weak, aaj kal insecure mana jata hai.\n- **SHA256**: zyada secure, lekin passwords ke liye akela kaafi nahi.\n- **bcrypt**: specially passwords ke liye design kiya gaya, intentionally slow hai.\n\n## Cracking Techniques\n- **Dictionary Attack**: common passwords ki list try karta hai.\n- **Brute-force**: har possible combination try karta hai.\n- **Rainbow Tables**: pre-computed hash-to-password mappings.\n\n## Salt Ki Ahmiyat\n**Salt** ek random value hai jo password ke saath hash hone se pehle add hoti hai. Isse rainbow tables un-effective ho jate hain.\n\n## Tools\n`Hashcat` GPU power use karke tezi se hashes crack karta hai, `John the Ripper` ek aur popular tool hai.\n\n## Practical Exercise\nSocho do users ka password same hai lekin alag salt hai - kya unka hash same hoga? Kyun ya kyun nahi?",
"## Overview\nPasswords usually are not stored as plaintext - their **hash** is stored instead. Password cracking means attempting to reverse-engineer these hashes.\n\n## Hashing Algorithms\n- **MD5**: old and weak, considered insecure today.\n- **SHA256**: more secure, but not enough alone for passwords.\n- **bcrypt**: designed specifically for passwords, intentionally slow.\n\n## Cracking Techniques\n- **Dictionary Attack**: tries a list of common passwords.\n- **Brute-force**: tries every possible combination.\n- **Rainbow Tables**: pre-computed hash-to-password mappings.\n\n## Why Salt Matters\nA **salt** is a random value added before hashing a password. This makes rainbow tables ineffective.\n\n## Tools\n`Hashcat` uses GPU power to crack hashes quickly; `John the Ripper` is another popular tool.\n\n## Practical Exercise\nImagine two users have the same password but different salts - will their hashes be the same? Why or why not?",
[
QuizQ("Rainbow tables ko un-effective banane ke liye hash mein kya add kiya jata hai?", ["Salt", "Extra length", "Compression"], "What is added to a hash to make rainbow tables ineffective?", ["Salt", "Extra length", "Compression"], 0),
QuizQ("Bcrypt intentionally slow kyun hai?", ["Brute-force attacks ko mushkil banane ke liye", "Zyada memory use karne ke liye", "Storage bachane ke liye"], "Why is bcrypt intentionally slow?", ["To make brute-force attacks harder", "To use more memory", "To save storage"], 0),
QuizQ("Rainbow table attack kis cheez se roka ja sakta hai?", ["Salt add karke", "Password ko chota karke", "Hash remove karke"], "A rainbow table attack can be prevented by...?", ["Adding a salt", "Making the password shorter", "Removing the hash"], 0),
]),
Lesson("Metasploit Framework", Icons.flash_on,
"## Overview\n**Metasploit Framework (MSF)** duniya ka sab se mashhoor exploitation framework hai - isme hazaron pre-built exploits ready-to-use hain.\n\n## MSF Ke Core Components\n- **Exploits**: code jo kisi specific vulnerability ka faida uthata hai.\n- **Payloads**: wo code jo successful exploit ke baad target par chalta hai.\n- **Auxiliary Modules**: scanning, fuzzing, ya info-gathering ke liye hote hain.\n- **Encoders**: payloads ko detection se bachane ke liye obfuscate karte hain.\n\n## Staged vs Unstaged Payloads\n**Unstaged** payload poora code ek hi baar mein bhejta hai. **Staged** payload pehle ek chhota stager bhejta hai jo phir baki payload download karta hai.\n\n## Meterpreter\n**Meterpreter** Metasploit ka advanced shell hai jo memory mein chalta hai, jisse detection mushkil hoti hai.\n\n## Practical Exercise\nSocho tumhare paas ek chhoti bandwidth wala connection hai - staged ya unstaged payload use karoge, aur kyun?",
"## Overview\nThe **Metasploit Framework (MSF)** is the world's most famous exploitation framework - it comes with thousands of ready-to-use pre-built exploits.\n\n## MSF Core Components\n- **Exploits**: code that takes advantage of a specific vulnerability.\n- **Payloads**: the code that runs on the target after a successful exploit.\n- **Auxiliary Modules**: used for scanning, fuzzing, or info-gathering.\n- **Encoders**: obfuscate payloads to evade detection.\n\n## Staged vs Unstaged Payloads\nAn **unstaged** payload sends the entire code at once. A **staged** payload sends a small stager first, which then downloads the rest.\n\n## Meterpreter\n**Meterpreter** is Metasploit's advanced shell that runs in memory, making detection harder.\n\n## Practical Exercise\nImagine you have a low-bandwidth connection - would you use a staged or unstaged payload, and why?",
[
QuizQ("Staged aur Unstaged Payload mein kya farq hai?", ["Staged chhota initial code bhejta hai jo baki download karta hai", "Unstaged zyada secure hai", "Koi farq nahi"], "What is the difference between a staged and an unstaged payload?", ["A staged payload sends a small stub that downloads the rest", "Unstaged is more secure", "There is no difference"], 0),
QuizQ("Meterpreter khaas kyun hai?", ["Memory mein chalta hai, disk par nahi", "Sirf Windows par kaam karta hai", "Ye sirf scanning karta hai"], "What makes Meterpreter special?", ["It runs in memory, not on disk", "It only works on Windows", "It only does scanning"], 0),
QuizQ("Auxiliary modules ka maqsad kya hai?", ["Scanning/info-gathering, direct exploit nahi", "Direct exploitation karna", "Reports banana"], "What is the purpose of auxiliary modules?", ["Scanning/info-gathering, not direct exploitation", "Direct exploitation", "Generating reports"], 0),
]),
Lesson("Privilege Escalation", Icons.arrow_upward,
"## Overview\nPehli baar system mein access milne ke baad, aksar attacker ke paas sirf low-level permissions hoti hain. **Privilege Escalation** ka maqsad zyada access hasil karna hai.\n\n## Vertical vs Horizontal Escalation\n**Vertical escalation** low-privilege se high-privilege tak jata hai. **Horizontal escalation** same level par rehte hue doosre user ka access hasil karna hai.\n\n## Common Linux Techniques\n- **SUID Binaries**: files jo file-owner ke privilege se execute hoti hain.\n- **Misconfigured Sudo**: agar koi user bina password ke kuch commands root ke tor par chala sakta hai.\n\n## Common Windows Techniques\n**Unquoted Service Paths**: agar service path mein space ho aur quotes na hon, Windows galat executable chala sakta hai.\n\n## Kyun Ye Itna Common Hai\nSystems complex hote hain aur chhoti misconfigurations bara impact de sakti hain.\n\n## Practical Exercise\nSocho ek SUID binary mil gayi jo /bin/bash ko call karti hai - ye kyun dangerous hai?",
"## Overview\nAfter gaining initial access to a system, an attacker often has only low-level permissions. **Privilege Escalation** aims to gain higher access.\n\n## Vertical vs Horizontal Escalation\n**Vertical escalation** moves from low-privilege to high-privilege. **Horizontal escalation** stays at the same level but gains another user's access.\n\n## Common Linux Techniques\n- **SUID Binaries**: files that execute with the file-owner's privilege.\n- **Misconfigured Sudo**: if a user can run certain commands as root without a password.\n\n## Common Windows Techniques\n**Unquoted Service Paths**: if a service path has a space and no quotes, Windows might run the wrong executable.\n\n## Why This is So Common\nSystems are complex, and small misconfigurations can have a big impact.\n\n## Practical Exercise\nImagine you found a SUID binary that calls /bin/bash - why is this dangerous?",
[
QuizQ("Linux mein konsa bit binary ko file-owner ke privilege se run karne deta hai?", ["SUID bit", "Read bit", "Execute bit"], "Which bit lets a binary run with the file-owner's privilege on Linux?", ["SUID bit", "Read bit", "Execute bit"], 0),
QuizQ("Horizontal escalation kya hai?", ["Same level par doosre user ka access lena", "Root access lena", "Server crash karna"], "What is horizontal escalation?", ["Gaining another user's access at the same level", "Gaining root access", "Crashing the server"], 0),
QuizQ("Unquoted Service Path kyun dangerous ho sakta hai?", ["Windows galat executable chala sakta hai", "Ye sirf Linux par hota hai", "Ye koi khatra nahi hai"], "Why can an unquoted service path be dangerous?", ["Windows might run the wrong executable", "It only happens on Linux", "It poses no danger"], 0),
]),
Lesson("Malware Threats", Icons.bug_report,
"## Overview\nMalware systems ko compromise, control, ya data churane ke liye design kiya jata hai. Har type ka apna specific maqsad hota hai.\n\n## Common Malware Types\n- **Trojan**: khud ko legitimate software ki tarah dikhata hai lekin andar malicious code hota hai.\n- **Keylogger**: user ki har keystroke record karta hai.\n- **Backdoor**: attacker ko system mein hamesha ke liye secret access deta hai.\n\n## C2 (Command & Control)\nCompromised machine attacker ke **C2 server** se connect hoti hai - attacker wahan se commands bhejta hai aur stolen data wapis leta hai.\n\n## Obfuscation Aur Evasion\nAttackers apna malware antivirus se bachane ke liye obfuscate karte hain.\n\n## Defense Ki Buniyad\nEndpoint protection, regular updates, aur user awareness malware se bachne ke sab se asar tareeqe hain.\n\n## Practical Exercise\nSocho ek email mein ek invoice.pdf.exe attachment hai - ye kaunsi malware technique ho sakti hai aur kyun?",
"## Overview\nMalware is designed to compromise, control, or steal data from systems. Each type has its own specific purpose.\n\n## Common Malware Types\n- **Trojan**: disguises itself as legitimate software but contains malicious code inside.\n- **Keylogger**: records every keystroke a user makes.\n- **Backdoor**: gives an attacker permanent secret access to a system.\n\n## C2 (Command & Control)\nA compromised machine connects to the attacker's **C2 server** - the attacker sends commands from there and retrieves stolen data.\n\n## Obfuscation and Evasion\nAttackers obfuscate their malware to evade antivirus.\n\n## The Foundation of Defense\nEndpoint protection, regular updates, and user awareness are the most effective ways to prevent malware.\n\n## Practical Exercise\nImagine an email has an invoice.pdf.exe attachment - what malware technique might this be, and why?",
[
QuizQ("Malware ka C2 server kis liye istemal hota hai?", ["Commands bhejne aur data exfiltrate karne ke liye", "Sirf logging ke liye", "Antivirus update ke liye"], "What is a malware's C2 server used for?", ["Sending commands and exfiltrating data", "Logging only", "Updating antivirus"], 0),
QuizQ("Trojan kis cheez ki tarah disguise hota hai?", ["Legitimate software", "Antivirus update", "Email attachment hamesha"], "What does a Trojan disguise itself as?", ["Legitimate software", "An antivirus update", "Always an email attachment"], 0),
QuizQ("Obfuscation malware mein kyun use hoti hai?", ["Antivirus detection se bachne ke liye", "File size badhane ke liye", "Internet speed badhane ke liye"], "Why is obfuscation used in malware?", ["To evade antivirus detection", "To increase file size", "To increase internet speed"], 0),
]),
Lesson("Covering Tracks & Log Evasion", Icons.visibility_off,
"## Overview\nHar system activities ko **logs** mein record karta hai. Attacker apni presence chhupane ke liye in logs ko modify ya delete karne ki koshish karta hai.\n\n## Windows Event Logs\nWindows security events ko record karta hai. **Event ID 1102** specifically indicate karta hai ke security audit log clear kiya gaya hai.\n\n## Linux Log Files\nLinux mein /var/log/ directory mein kai log files hoti hain. Attacker history -c jese commands se apni bash history clear karne ki koshish karta hai.\n\n## Timestomping\n**Timestomping** ek technique hai jahan attacker files ke modification timestamps change kar deta hai.\n\n## Ethical Considerations\nEthical hackers logs ko delete nahi karte - unka kaam sirf vulnerabilities dikhana hai.\n\n## Practical Exercise\nAgar tum ek SOC analyst ho aur dekho ke Event ID 1102 trigger hua hai, tumhara agla step kya hoga?",
"## Overview\nEvery system records activities in **logs**. An attacker tries to modify or delete these logs to hide their presence.\n\n## Windows Event Logs\nWindows records security events. **Event ID 1102** specifically indicates that the security audit log was cleared.\n\n## Linux Log Files\nLinux has several log files in the /var/log/ directory. An attacker might try to clear their bash history with commands like history -c.\n\n## Timestomping\n**Timestomping** is a technique where an attacker changes a file's modification timestamps.\n\n## Ethical Considerations\nEthical hackers do not delete logs - their job is only to reveal vulnerabilities.\n\n## Practical Exercise\nIf you are a SOC analyst and you see Event ID 1102 was triggered, what would your next step be?",
[
QuizQ("Windows mein Security logs clean hone ka Event ID kya hai?", ["Event ID 4625", "Event ID 1102", "Event ID 1000"], "Which Windows Event ID indicates Security logs were cleared?", ["Event ID 4625", "Event ID 1102", "Event ID 1000"], 1),
QuizQ("Timestomping ka maqsad kya hai?", ["Forensic investigators ko confuse karna", "Files ko encrypt karna", "Internet speed test karna"], "What is the purpose of timestomping?", ["Confusing forensic investigators", "Encrypting files", "Testing internet speed"], 0),
QuizQ("Ethical hackers logs ke saath kya karte hain?", ["Unhe delete nahi karte, sirf vulnerabilities dikhate hain", "Hamesha delete karte hain", "Unhe encrypt karte hain"], "What do ethical hackers do with logs?", ["They do not delete them, only reveal vulnerabilities", "Always delete them", "Always encrypt them"], 0),
]),
]),
Level("Module 5: Web App Security", "OWASP Top 10: SQLi, XSS, CSRF, LFI", Icons.web, [
Lesson("OWASP Top 10 Overview", Icons.web,
"## Overview\n**OWASP (Open Web Application Security Project)** ek non-profit organization hai jo web security best practices promote karta hai. Unki sab se mashhoor publication **OWASP Top 10** hai.\n\n## OWASP Top 10 Kya Hai\nYe ek regularly-updated list hai jo web applications ke sab se critical security risks highlight karti hai.\n\n## Client-Server Model\nWeb security samajhne ke liye client-server model zaroori hai: **client** (browser) requests bhejta hai, **server** unhe process karke response deta hai.\n\n## HTTP Headers Aur Cookies\n**Headers** request/response ke metadata carry karte hain. **Cookies** session information store karte hain.\n\n## Yeh Module Kyun Zaroori Hai\nAgle 4 lessons mein hum OWASP Top 10 ke sab se mashhoor vulnerabilities ko detail se cover karenge.\n\n## Practical Exercise\nApne browser mein Developer Tools (F12) kholo, Application tab mein jaa kar dekho kitne cookies kisi website ne set kiye hain.",
"## Overview\n**OWASP (Open Web Application Security Project)** is a non-profit organization that promotes web security best practices. Their most famous publication is the **OWASP Top 10**.\n\n## What is the OWASP Top 10\nIt is a regularly-updated list that highlights the most critical security risks in web applications.\n\n## The Client-Server Model\nUnderstanding web security requires the client-server model: the **client** (browser) sends requests, the **server** processes them and returns a response.\n\n## HTTP Headers and Cookies\n**Headers** carry metadata about the request/response. **Cookies** store session information.\n\n## Why This Module Matters\nIn the next 4 lessons, we will cover the OWASP Top 10's most famous vulnerabilities in detail.\n\n## Practical Exercise\nOpen Developer Tools (F12) in your browser, go to the Application tab, and see how many cookies a website has set.",
[
QuizQ("OWASP Top 10 list kis maqsad ke liye publish ki jati hai?", ["Marketing ke liye", "Critical web risks highlight karne ke liye", "Sirf developers training ke liye"], "What is the purpose of publishing the OWASP Top 10 list?", ["Marketing", "Highlighting critical web risks", "Training developers only"], 1),
QuizQ("Client-server model mein client kya hai?", ["Browser", "Database", "Firewall"], "In the client-server model, what is the client?", ["Browser", "Database", "Firewall"], 0),
QuizQ("Cookies ke liye Secure flag kya karta hai?", ["Cookie ko sirf HTTPS par bhejta hai", "Cookie ko delete karta hai", "Cookie ko encrypt karta hai hamesha"], "What does the Secure flag do for cookies?", ["Sends the cookie only over HTTPS", "Deletes the cookie", "Always encrypts the cookie"], 0),
]),
Lesson("SQL Injection", Icons.storage,
"## Overview\n**SQL Injection (SQLi)** web ki sab se purani aur dangerous vulnerabilities mein se ek hai. Ye tab hoti hai jab user input directly SQL query mein bina proper sanitization ke daal diya jata hai.\n\n## SQLi Ke Types\n- **In-Band SQLi**: result direct response mein dikhta hai.\n- **Error-Based SQLi**: database errors se information leak hoti hai.\n- **Blind SQLi**: koi direct output nahi milta, lekin Boolean ya time delays se information extract ki jati hai.\n\n## Classic Example\nAgar koi login form `' OR '1'='1` jesa input accept kare aur query ko bina sanitize kiye run kare, to WHERE condition hamesha true ban jati hai.\n\n## SQLmap Tool\n`SQLmap` ek automated tool hai jo kisi bhi parameter mein SQLi vulnerabilities dhoondta aur exploit karta hai.\n\n## Prevention\nSab se secure tareeqa **Prepared Statements** hai - ismein user input kabhi bhi query ka hissa nahi banta.\n\n## Practical Exercise\nSocho ek query hai: SELECT * FROM users WHERE username='INPUT'. Agar INPUT mein `' OR '1'='1` daala jaye to query kaisi ban jayegi?",
"## Overview\n**SQL Injection (SQLi)** is one of the oldest and most dangerous web vulnerabilities. It happens when user input is inserted directly into a SQL query without proper sanitization.\n\n## Types of SQLi\n- **In-Band SQLi**: the result shows directly in the response.\n- **Error-Based SQLi**: database errors leak information.\n- **Blind SQLi**: no direct output, but information is extracted through Boolean responses or time delays.\n\n## A Classic Example\nIf a login form accepts input like `' OR '1'='1` and runs the query without sanitizing it, the WHERE condition always becomes true.\n\n## The SQLmap Tool\n`SQLmap` is an automated tool that finds and exploits SQLi vulnerabilities in any parameter.\n\n## Prevention\nThe most secure method is **Prepared Statements** - here, user input never becomes part of the query itself.\n\n## Practical Exercise\nImagine a query: SELECT * FROM users WHERE username='INPUT'. If INPUT contains `' OR '1'='1`, what does the query become?",
[
QuizQ("SQL Injection prevent karne ka sabse secure tarika kya hai?", ["Prepared Statements", "Input hide karna", "Password length badhana"], "What is the most secure way to prevent SQL Injection?", ["Prepared Statements", "Hiding input fields", "Increasing password length"], 0),
QuizQ("Blind SQLi ke bare mein kya sahi hai?", ["Koi direct output nahi milta, Boolean/time se info milti hai", "Hamesha result screen par dikhta hai", "Ye sirf login forms mein hoti hai"], "What is true about Blind SQLi?", ["No direct output, info comes via Boolean or time delays", "The result always shows on screen", "It only happens in login forms"], 0),
QuizQ("SQLmap kya karta hai?", ["SQLi vulnerabilities ko automated tareeqe se dhoondta aur exploit karta hai", "Websites ko design karta hai", "Passwords ko hash karta hai"], "What does SQLmap do?", ["Automatically finds and exploits SQLi vulnerabilities", "Designs websites", "Hashes passwords"], 0),
]),
Lesson("Cross-Site Scripting (XSS)", Icons.code,
"## Overview\n**XSS (Cross-Site Scripting)** tab hoti hai jab attacker malicious JavaScript code kisi website mein inject kar deta hai, jo doosre users ke browser mein chal jata hai.\n\n## XSS Ke Teen Types\n- **Stored XSS**: malicious script database mein save ho jata hai aur har visitor ko affect karta hai.\n- **Reflected XSS**: script URL ya form input ke through turant response mein wapis aata hai.\n- **DOM-based XSS**: client-side JavaScript khud vulnerability create karta hai.\n\n## Cookie Theft Example\nAgar XSS successful ho jaye, attacker `<script>alert(document.cookie)</script>` jesa code chala kar victim ki session cookie steal kar sakta hai.\n\n## Kyun Stored Zyada Dangerous Hai\nReflected XSS ko kaam karne ke liye victim ko ek specific malicious link click karna parta hai. Stored XSS automatically har normal visitor ko affect karta hai.\n\n## Prevention\nUser input ko output karne se pehle encode/escape karna XSS se bachata hai.\n\n## Practical Exercise\nSocho ek comment section hai jahan HTML escape nahi hota - agar koi script tag comment mein daale to kya hoga?",
"## Overview\n**XSS (Cross-Site Scripting)** happens when an attacker injects malicious JavaScript code into a website, which then runs in other users' browsers.\n\n## The Three Types of XSS\n- **Stored XSS**: the malicious script gets saved in the database and affects every visitor.\n- **Reflected XSS**: the script comes back immediately in the response via a URL or form input.\n- **DOM-based XSS**: client-side JavaScript itself creates the vulnerability.\n\n## Cookie Theft Example\nIf XSS succeeds, an attacker can run code like `<script>alert(document.cookie)</script>` to steal the victim's session cookie.\n\n## Why Stored is More Dangerous\nReflected XSS requires the victim to click a specific malicious link. Stored XSS automatically affects every normal visitor.\n\n## Prevention\nEncoding/escaping user input before outputting it prevents XSS.\n\n## Practical Exercise\nImagine a comment section where HTML is not escaped - what happens if someone puts a script tag in a comment?",
[
QuizQ("Stored XSS Reflected se zyada dangerous kyun hai?", ["Yeh database mein save hoke har visitor ko affect karta hai", "Yeh tez chalta hai", "Yeh sirf admin ko affect karta hai"], "Why is Stored XSS more dangerous than Reflected XSS?", ["It gets saved in the database and affects every visitor", "It runs faster", "It only affects admins"], 0),
QuizQ("DOM-based XSS ke bare mein kya sahi hai?", ["Server involve nahi hota, client-side JS vulnerability create karta hai", "Hamesha database mein save hoti hai", "Sirf admin ko affect karti hai"], "What is true about DOM-based XSS?", ["The server is not involved, client-side JS creates the vulnerability", "It is always saved in the database", "It only affects admins"], 0),
QuizQ("XSS prevention ka sabse aam tareeqa kya hai?", ["User input ko encode/escape karna", "Password length badhana", "Ports band karna"], "What is the most common way to prevent XSS?", ["Encoding/escaping user input", "Increasing password length", "Closing ports"], 0),
]),
Lesson("CSRF & Auth Flaws", Icons.sync_problem,
"## Overview\n**CSRF (Cross-Site Request Forgery)** ek attack hai jahan victim ka browser, uski jaante bujhte bina, ek authenticated action trigger kar deta hai.\n\n## CSRF Kaise Kaam Karta Hai\nAgar koi user kisi banking site mein login hai aur ek malicious website visit kare jahan ek hidden form automatically submit ho jaye, browser automatically saved cookies attach kar deta hai.\n\n## CSRF Tokens\nHar form mein ek unique, unpredictable **CSRF token** add kiya jata hai. Agar request mein ye token na ho, server use reject kar deta hai.\n\n## SameSite Cookie Attribute\n**SameSite** cookie attribute browser ko batata hai ke cookie sirf same-site requests ke sath bheji jaye.\n\n## Broken Authentication\nWeak session management **Broken Authentication** kehlata hai aur attackers ko account hijack karne deta hai.\n\n## Practical Exercise\nSocho ek banking website ka form bina CSRF token ke hai - ek attacker kaise is form ko exploit kar sakta hai?",
"## Overview\n**CSRF (Cross-Site Request Forgery)** is an attack where the victim's browser, without their knowledge, triggers an authenticated action.\n\n## How CSRF Works\nIf a user is logged into a banking site and visits a malicious website where a hidden form automatically submits, the browser automatically attaches saved cookies.\n\n## CSRF Tokens\nA unique, unpredictable **CSRF token** is added to every form. If a request does not include this token, the server rejects it.\n\n## The SameSite Cookie Attribute\nThe **SameSite** cookie attribute tells the browser to only send a cookie with same-site requests.\n\n## Broken Authentication\nWeak session management is called **Broken Authentication** and lets attackers hijack accounts.\n\n## Practical Exercise\nImagine a banking website's form has no CSRF token - how could an attacker exploit this form?",
[
QuizQ("CSRF attack kis cheez ka faida uthata hai?", ["Browser ka automated credentials bhejne ka trust", "Weak password", "Server downtime"], "What does a CSRF attack take advantage of?", ["The browser's automatic credential-sending trust", "Weak passwords", "Server downtime"], 0),
QuizQ("CSRF token ka maqsad kya hai?", ["Attacker ko predictable token banane se rokna", "Password ko encrypt karna", "Website ko design karna"], "What is the purpose of a CSRF token?", ["Preventing an attacker from predicting the token", "Encrypting the password", "Designing the website"], 0),
QuizQ("SameSite cookie attribute kya karta hai?", ["Cookie ko cross-site requests ke sath bhejne se rokta hai", "Cookie ko delete karta hai", "Cookie ko encrypt karta hai"], "What does the SameSite cookie attribute do?", ["Prevents the cookie from being sent with cross-site requests", "Deletes the cookie", "Encrypts the cookie"], 0),
]),
Lesson("File Inclusion (LFI/RFI) & RCE", Icons.folder_open,
"## Overview\n**File Inclusion** vulnerabilities tab hoti hain jab application user-controlled input ke through files include karti hai.\n\n## LFI vs RFI\n**LFI (Local File Inclusion)** server ke apne system se files include karta hai. **RFI (Remote File Inclusion)** attacker ke apne server se ek remote file include karta hai.\n\n## Path Traversal\n**Path Traversal** (../) use hoti hai directories ke beech climb karne ke liye.\n\n## RCE Mein Conversion\nAgar attacker apna code server ke logs ya uploaded files mein inject kar sake, aur phir LFI use karke usay include kar de, to ye **Remote Code Execution (RCE)** ban jati hai.\n\n## Prevention\nUser input ko file paths mein kabhi directly use na karo. Whitelist approach sab se secure tareeqa hai.\n\n## Practical Exercise\nSocho ek URL hai page.php?file=about.php - agar file parameter ko ../../../../etc/passwd se replace kiya jaye to kya ho sakta hai?",
"## Overview\n**File Inclusion** vulnerabilities occur when an application includes files through user-controlled input.\n\n## LFI vs RFI\n**LFI (Local File Inclusion)** includes files from the server's own system. **RFI (Remote File Inclusion)** includes a remote file from the attacker's own server.\n\n## Path Traversal\n**Path Traversal** (../) is used to climb between directories.\n\n## Conversion to RCE\nIf an attacker can inject their code into the server's logs or uploaded files, and then use LFI to include it, this becomes **Remote Code Execution (RCE)**.\n\n## Prevention\nNever use user input directly in file paths. A whitelist approach is the most secure method.\n\n## Practical Exercise\nImagine a URL page.php?file=about.php - what could happen if the file parameter is replaced with ../../../../etc/passwd?",
[
QuizQ("LFI vulnerability RCE mein kab convert hoti hai?", ["Jab attacker PHP code logs/uploads mein inject kar sake", "Jab server slow ho", "Jab user logout kare"], "When does LFI convert into RCE?", ["When the attacker can inject PHP code into logs or uploads", "When the server is slow", "When the user logs out"], 0),
QuizQ("RFI, LFI se zyada dangerous kyun hai?", ["Attacker apna khud ka code remote server se include kar sakta hai", "RFI sirf images ke liye hota hai", "RFI hamesha encrypted hota hai"], "Why is RFI more dangerous than LFI?", ["An attacker can include their own code from a remote server", "RFI only applies to images", "RFI is always encrypted"], 0),
QuizQ("File inclusion prevent karne ka best tareeqa kya hai?", ["Whitelist approach (sirf predefined files allow karna)", "User input ko bilkul validate na karna", "Files ko public rakhna"], "What is the best way to prevent file inclusion?", ["A whitelist approach (only allow predefined files)", "Not validating user input at all", "Keeping files public"], 0),
]),
]),
Level("Module 6: Network & Wireless", "MITM, Wi-Fi, DDoS, Evasion", Icons.wifi, [
Lesson("Sniffing & MITM", Icons.hub,
"## Overview\nNetwork par chalne wala data agar unencrypted ho, to koi bhi beech mein baitha attacker usay sniff kar sakta hai - khaas kar jab wo **Man-in-the-Middle (MITM)** position mein ho.\n\n## Promiscuous Mode\nNormal mode mein network card sirf apne liye bheji gayi packets ko process karta hai. **Promiscuous mode** mein ye saari packets capture karta hai.\n\n## ARP Poisoning\n**ARP Poisoning** mein attacker fake ARP responses bhejta hai taake target machines ka traffic unke through pass ho.\n\n## Tools\n`Wireshark` traffic capture aur analyze karne ke liye use hota hai. `Ettercap`/`Bettercap` ARP poisoning automate karte hain.\n\n## HTTPS Ki Ahmiyat\nAgar traffic HTTPS ho, to MITM attacker data capture to kar sakta hai lekin usay padh nahi sakta.\n\n## Practical Exercise\nWireshark kholo (agar available ho) aur socho agar koi unencrypted HTTP login form submit kare to kaunsi info packet mein nazar aa sakti hai.",
"## Overview\nIf data traveling on a network is unencrypted, any attacker sitting in the middle can sniff it - especially when in a **Man-in-the-Middle (MITM)** position.\n\n## Promiscuous Mode\nIn normal mode, a network card only processes packets meant for itself. **Promiscuous mode** captures all packets.\n\n## ARP Poisoning\nIn **ARP Poisoning**, an attacker sends fake ARP responses so that target machines' traffic passes through them.\n\n## Tools\n`Wireshark` is used to capture and analyze traffic. `Ettercap`/`Bettercap` automate ARP poisoning.\n\n## Why HTTPS Matters\nIf traffic is HTTPS, a MITM attacker can capture the data but cannot read it.\n\n## Practical Exercise\nOpen Wireshark (if available) and think about what information might be visible in a packet if someone submits an unencrypted HTTP login form.",
[
QuizQ("Switched network par MITM ke liye attacker kis table ko corrupt karta hai?", ["Routing table", "ARP Cache table", "DNS cache"], "Which table does an attacker corrupt for MITM on a switched network?", ["Routing table", "ARP Cache table", "DNS cache"], 1),
QuizQ("Promiscuous mode kya karta hai?", ["Saari packets capture karta hai, apni ya na", "Sirf apni packets process karta hai", "Internet speed tez karta hai"], "What does promiscuous mode do?", ["Captures all packets, not just its own", "Only processes its own packets", "Speeds up the internet"], 0),
QuizQ("HTTPS traffic MITM attacker ke liye kyun mushkil hai?", ["Traffic encrypted hota hai, padha nahi ja sakta", "HTTPS slow hota hai", "HTTPS sirf mobile par hai"], "Why is HTTPS traffic hard for a MITM attacker?", ["The traffic is encrypted and cannot be read", "HTTPS is slow", "HTTPS only works on mobile"], 0),
]),
Lesson("Wireless Hacking", Icons.wifi,
"## Overview\nWireless networks par data hawa mein travel karta hai, is liye inki security encryption par heavily depend karti hai.\n\n## WEP vs WPA2 vs WPA3\n**WEP** bohot purana aur weak hai. **WPA2** zyada secure hai aur abhi bhi widely used hai. **WPA3** sab se naya aur secure hai.\n\n## 4-Way Handshake\nJab koi device WPA2 network se connect hota hai, ek **4-Way Handshake** hoti hai jo encryption keys establish karti hai.\n\n## Deauthentication Attack\nAttacker ek deauth attack bhej kar kisi connected device ko force se disconnect kar sakta hai.\n\n## Tools\n`Aircrack-ng` suite mein airodump-ng, aireplay-ng, aur aircrack-ng shamil hain.\n\n## Practical Exercise\nSocho ek open (bina password) Wi-Fi network hai - ye WPA2 se kis tarah mukhtalif risk deta hai?",
"## Overview\nOn wireless networks, data travels through the air, so security depends heavily on encryption.\n\n## WEP vs WPA2 vs WPA3\n**WEP** is very old and weak. **WPA2** is more secure and still widely used. **WPA3** is the newest and most secure.\n\n## The 4-Way Handshake\nWhen a device connects to a WPA2 network, a **4-Way Handshake** occurs that establishes encryption keys.\n\n## Deauthentication Attack\nAn attacker can send a deauth attack to force a connected device to disconnect.\n\n## Tools\nThe `Aircrack-ng` suite includes airodump-ng, aireplay-ng, and aircrack-ng.\n\n## Practical Exercise\nImagine an open (passwordless) Wi-Fi network - how is its risk different from WPA2?",
[
QuizQ("WPA2 cracking ke liye attacker ko kya capture karna padta hai?", ["SSID broadcast", "4-Way WPA Handshake", "MAC address"], "What does an attacker need to capture to crack WPA2?", ["SSID broadcast", "4-Way WPA Handshake", "MAC address"], 1),
QuizQ("WPA3 WPA2 se kis tarah behtar hai?", ["Offline dictionary attacks ko resist karta hai", "Sirf speed mein behtar hai", "Sirf 5GHz par kaam karta hai"], "How is WPA3 better than WPA2?", ["It resists offline dictionary attacks", "It is only better in speed", "It only works on 5GHz"], 0),
QuizQ("Deauth attack ka maqsad kya hai?", ["Device ko disconnect karke dobara handshake capture karna", "Internet band karna", "Router ko crash karna"], "What is the purpose of a deauth attack?", ["Disconnecting a device to capture the handshake again", "Shutting down the internet", "Crashing the router"], 0),
]),
Lesson("DoS & DDoS", Icons.flash_on,
"## Overview\n**Denial of Service (DoS)** attacks system ko legitimate users ke liye unavailable banane ki koshish karte hain. Jab ye attack multiple machines se ek sath hota hai, to **DDoS** kehlata hai.\n\n## Common Attack Types\n- **SYN Flood**: TCP handshake adhoora chhor kar server ki resources khatam kar deta hai.\n- **UDP Flood**: random UDP packets bhej kar bandwidth khatam karta hai.\n- **HTTP Flood**: application layer par bohot sari fake requests bhejta hai.\n\n## Amplification Attacks\n**Amplification attack** mein attacker ek chhoti request bhejta hai spoofed source IP ke sath, aur server us chhoti request par bara response bhej deta hai victim ko.\n\n## Botnets\nAttackers aksar **botnets** use karte hain - hazaron compromised devices jo ek sath ek target par attack karte hain.\n\n## Defense Approaches\nRate limiting, traffic filtering, aur specialized DDoS protection services in attacks se defend karne mein madad karte hain.\n\n## Practical Exercise\nSocho ek chhoti si DNS query bheji gayi jiska response 50x bara hai - ye amplification attack ke liye kyun perfect hai?",
"## Overview\n**Denial of Service (DoS)** attacks try to make a system unavailable to legitimate users. When this attack comes from multiple machines at once, it is called **DDoS**.\n\n## Common Attack Types\n- **SYN Flood**: leaves the TCP handshake incomplete, exhausting server resources.\n- **UDP Flood**: sends random UDP packets, exhausting bandwidth.\n- **HTTP Flood**: sends many fake requests at the application layer.\n\n## Amplification Attacks\nIn an **amplification attack**, the attacker sends a small request with a spoofed source IP, and the server sends a huge response back to the victim.\n\n## Botnets\nAttackers often use **botnets** - thousands of compromised devices that attack a single target together.\n\n## Defense Approaches\nRate limiting, traffic filtering, and specialized DDoS protection services help defend against these attacks.\n\n## Practical Exercise\nImagine a small DNS query is sent whose response is 50x larger - why is this perfect for an amplification attack?",
[
QuizQ("Amplification DDoS attack kis protocol mechanism ko exploit karta hai?", ["TCP handshake", "UDP (chhoti request, bada response)", "HTTPS encryption"], "Which protocol mechanism does an amplification DDoS attack exploit?", ["TCP handshake", "UDP (small request, huge response)", "HTTPS encryption"], 1),
QuizQ("SYN Flood kis cheez ko target karta hai?", ["TCP handshake ko adhoora chhorna", "DNS records", "File storage"], "What does a SYN Flood target?", ["Leaving the TCP handshake incomplete", "DNS records", "File storage"], 0),
QuizQ("Botnet kya hota hai?", ["Hazaron compromised devices jo ek sath attack karte hain", "Ek single powerful server", "Ek antivirus program"], "What is a botnet?", ["Thousands of compromised devices attacking together", "A single powerful server", "An antivirus program"], 0),
]),
Lesson("Session Hijacking", Icons.link,
"## Overview\nJab user kisi website mein login karta hai, server use ek **session ID** deta hai. Agar ye session ID chori ho jaye, attacker victim ban kar login ho sakta hai.\n\n## TCP Sequence Numbers\nPuraane network-level hijacking attacks mein attacker **TCP sequence numbers** predict karke ek active connection mein khud ko insert kar leta tha.\n\n## Session ID Prediction\nAgar session IDs predictable pattern follow karte hain, attacker agla valid session ID guess kar sakta hai.\n\n## Cookie Manipulation\nAgar session cookie HttpOnly flag ke baghair ho, JavaScript usay read kar sakti hai.\n\n## Prevention\nSecure, random, aur long session IDs, HttpOnly aur Secure cookie flags, aur session timeout - ye sab session hijacking ko mushkil banate hain.\n\n## Practical Exercise\nSocho ek website session ID sequential numbers deti hai - attacker is pattern ka faida kaise utha sakta hai?",
"## Overview\nWhen a user logs into a website, the server gives them a **session ID**. If this session ID is stolen, an attacker can log in as the victim.\n\n## TCP Sequence Numbers\nIn older network-level hijacking attacks, attackers would predict **TCP sequence numbers** to insert themselves into an active connection.\n\n## Session ID Prediction\nIf session IDs follow a predictable pattern, an attacker can guess the next valid session ID.\n\n## Cookie Manipulation\nIf a session cookie lacks the HttpOnly flag, JavaScript can read it.\n\n## Prevention\nSecure, random, long session IDs, HttpOnly and Secure cookie flags, and session timeouts all make session hijacking harder.\n\n## Practical Exercise\nImagine a website gives sequential session IDs - how could an attacker exploit this pattern?",
[
QuizQ("TCP Session Hijacking ke liye attacker ko kya predict karna hota hai?", ["Next TCP Sequence Number", "Server IP", "DNS record"], "What must an attacker predict to hijack a TCP session?", ["Next TCP Sequence Number", "Server IP", "DNS record"], 0),
QuizQ("HttpOnly flag cookies ke liye kya karta hai?", ["JavaScript ko cookie read karne se rokta hai", "Cookie delete karta hai", "Cookie ko bara banata hai"], "What does the HttpOnly flag do for cookies?", ["Prevents JavaScript from reading the cookie", "Deletes the cookie", "Makes the cookie bigger"], 0),
QuizQ("Predictable session IDs kyun khatarnak hain?", ["Attacker agla valid ID guess kar sakta hai", "Wo slow hote hain", "Wo encrypted nahi ho sakte"], "Why are predictable session IDs dangerous?", ["An attacker can guess the next valid ID", "They are slow", "They cannot be encrypted"], 0),
]),
Lesson("Evasion Techniques", Icons.security,
"## Overview\nFirewalls aur IDS/IPS systems traffic ko monitor karke attacks detect karte hain. Attackers apni activities chhupane ke liye kai evasion techniques use karte hain.\n\n## Fragmentation\n**Packet Fragmentation** mein attacker apni payload ko chhote chhote packets mein tor deta hai.\n\n## Proxy Chains aur Tor\nApna traffic ek se zyada proxies ke through route karne se asal source IP chhupaya ja sakta hai. **Tor** network multiple layers of encryption ke sath anonymity provide karta hai.\n\n## Encrypted Tunnels\nAgar traffic encrypted tunnel ke through jaye, network-level monitoring tools sirf encrypted data dekhte hain.\n\n## Payload Encoding/Obfuscation\nSignature-based IDS/IPS specific patterns dhoondte hain. Agar payload ko encode kiya jaye, signature match nahi hoga.\n\n## Defense Ki Taraf\nModern systems **behavior-based detection** use karte hain, jo in evasion techniques ko bhi pakad sakte hain.\n\n## Practical Exercise\nSocho Nmap -f (fragmentation) flag use karta hai - ye kyun firewall detection se bachne mein madad karta hai?",
"## Overview\nFirewalls and IDS/IPS systems monitor traffic to detect attacks. Attackers use several evasion techniques to hide their activity.\n\n## Fragmentation\nIn **Packet Fragmentation**, an attacker breaks their payload into small pieces.\n\n## Proxy Chains and Tor\nRouting traffic through multiple proxies can hide the real source IP. **Tor** provides anonymity with multiple layers of encryption.\n\n## Encrypted Tunnels\nIf traffic travels through an encrypted tunnel, network-level monitoring tools only see encrypted data.\n\n## Payload Encoding/Obfuscation\nSignature-based IDS/IPS looks for specific patterns. If a payload is encoded, the signature will not match.\n\n## The Defense Side\nModern systems use **behavior-based detection**, which can catch these evasion techniques too.\n\n## Practical Exercise\nImagine Nmap uses the -f (fragmentation) flag - why does this help evade firewall detection?",
[
QuizQ("IDS/IPS ko signature-based detection se bypass karne ke liye payload mein kya karte hain?", ["Payload encoding/obfuscation", "Payload size badhana", "Payload delete karna"], "What do attackers do to the payload to bypass signature-based IDS/IPS detection?", ["Encode/obfuscate the payload", "Increase payload size", "Delete the payload"], 0),
QuizQ("Tor network kya provide karta hai?", ["Multiple layers of encryption ke sath anonymity", "Faster internet speed", "Zyada storage"], "What does the Tor network provide?", ["Anonymity with multiple layers of encryption", "Faster internet speed", "More storage"], 0),
QuizQ("Behavior-based detection signature-based se kyun behtar hota hai?", ["Ye evasion techniques bhi pakad sakta hai", "Ye sirf tez hai", "Ye free hota hai"], "Why is behavior-based detection better than signature-based?", ["It can catch evasion techniques too", "It is just faster", "It is free"], 0),
]),
]),
Level("Module 7: Social Engineering", "Phishing, SET, Physical, OSINT on Humans", Icons.groups, [
Lesson("Phishing & Spear-Phishing", Icons.mail,
"## Overview\n**Social Engineering** attacks technology ki bajaye insaan ki psychology exploit karte hain. **Phishing** inme sab se aam hai.\n\n## Phishing Ke Types\n- **Bulk Phishing**: generic emails hazaron logon ko bheji jati hain.\n- **Spear Phishing**: ek specific individual ya organization ke liye customized attack.\n- **Whaling**: high-profile targets ko target karta hai.\n- **Smishing/Vishing**: SMS aur phone calls ke through phishing.\n\n## Typosquatting\n**Typosquatting** mein attacker domain names register karta hai jo real domains se milte julte hon.\n\n## Email Spoofing\nAttackers email headers ko forge karke aise dikhate hain jaise email kisi trusted source se aaya ho. **SPF**, **DKIM**, aur **DMARC** ye detect karne mein madad karte hain.\n\n## Red Flags\nUrgency create karna, generic greetings, suspicious links, aur grammar mistakes phishing ke common signs hain.\n\n## Practical Exercise\nKisi suspicious email ke headers check karo aur dekho ke Return-Path asal sender domain se match karta hai ya nahi.",
"## Overview\n**Social Engineering** attacks exploit human psychology rather than technology. **Phishing** is the most common of these.\n\n## Types of Phishing\n- **Bulk Phishing**: generic emails sent to thousands.\n- **Spear Phishing**: an attack customized for a specific individual or organization.\n- **Whaling**: targets high-profile individuals.\n- **Smishing/Vishing**: phishing through SMS and phone calls.\n\n## Typosquatting\nIn **Typosquatting**, an attacker registers domain names that resemble real ones.\n\n## Email Spoofing\nAttackers forge email headers to make it look like the email came from a trusted source. **SPF**, **DKIM**, and **DMARC** help detect this.\n\n## Red Flags\nCreating urgency, generic greetings, suspicious links, and grammar mistakes are all common signs of phishing.\n\n## Practical Exercise\nCheck a suspicious email's headers and see if the Return-Path matches the real sender's domain.",
[
QuizQ("DMARC policy email security mein kya check karti hai?", ["SPF/DKIM alignment", "Password strength", "File size"], "What does DMARC policy check in email security?", ["SPF/DKIM alignment", "Password strength", "File size"], 0),
QuizQ("Spear Phishing bulk phishing se kaise mukhtalif hai?", ["Ek specific target ke liye customized hota hai", "Hamesha phone call hoti hai", "Ye sirf CEOs ko target karti hai"], "How is Spear Phishing different from bulk phishing?", ["It is customized for a specific target", "It is always a phone call", "It only targets CEOs"], 0),
QuizQ("Typosquatting mein attacker kya karta hai?", ["Real domain se milte julte fake domains register karta hai", "Email headers delete karta hai", "Websites hack karta hai"], "What does an attacker do in typosquatting?", ["Registers fake domains that resemble real ones", "Deletes email headers", "Hacks websites"], 0),
]),
Lesson("SET & Harvesting", Icons.content_copy,
"## Overview\nPhishing ko effective banane ke liye attackers aksar fake login pages create karte hain jo asli site jese dikhte hain - **Credential Harvesting** isi process ko kehte hain.\n\n## Social Engineering Toolkit (SET)\n**SET** ek popular framework hai jo social engineering attacks ko automate karta hai.\n\n## Credential Harvesting Kaise Kaam Karta Hai\nAttacker ek fake page hosting karta hai jo bilkul asal login page jesa dikhta hai. Victim jab apna username/password enter karta hai, wo data **attacker ke listening server** par chala jata hai.\n\n## Detection Tips\nURL bar check karna, HTTPS lock icon dekhna, aur browser ke phishing warnings ko seriously lena - ye sab se asan defense hain.\n\n## Ethical Testing\nOrganizations apne employees ko test karne ke liye controlled phishing simulations run karte hain, lekin sirf written authorization ke sath.\n\n## Practical Exercise\nSocho tum ek fake login page dekhte ho jiska URL thora different hai - kya clues isay fake batate hain?",
"## Overview\nTo make phishing effective, attackers often create fake login pages that look like the real site - this is called **Credential Harvesting**.\n\n## The Social Engineering Toolkit (SET)\n**SET** is a popular framework that automates social engineering attacks.\n\n## How Credential Harvesting Works\nAn attacker hosts a fake page that looks exactly like the real login page. When the victim enters their username/password, that data goes to the **attacker's listening server**.\n\n## Detection Tips\nChecking the URL bar, looking for the HTTPS lock icon, and taking browser phishing warnings seriously are the easiest defenses.\n\n## Ethical Testing\nOrganizations run controlled phishing simulations to test their employees, but only with written authorization.\n\n## Practical Exercise\nImagine you see a fake login page with a slightly different URL - what clues make this fake?",
[
QuizQ("Credential Harvester attack mein victim ka data kahan redirect hota hai?", ["Attacker ke listening server par", "Asal website par", "Email inbox mein"], "Where is the victim's data redirected in a Credential Harvester attack?", ["To the attacker's listening server", "To the real website", "To an email inbox"], 0),
QuizQ("SET framework kya karta hai?", ["Social engineering attacks automate karta hai", "Antivirus install karta hai", "Network scan karta hai"], "What does the SET framework do?", ["Automates social engineering attacks", "Installs antivirus", "Scans networks"], 0),
QuizQ("Credential harvesting ke baad victim ko kya hota hai?", ["Asal website par redirect kar diya jata hai", "Account turant delete ho jata hai", "Phone band ho jata hai"], "What happens to the victim after credential harvesting?", ["They get redirected to the real website", "Their account is immediately deleted", "Their phone shuts down"], 0),
]),
Lesson("Physical Security & Hardware Attacks", Icons.usb,
"## Overview\nSecurity sirf digital nahi hoti - **physical access** milne se bhi systems compromise ho sakte hain.\n\n## Common Physical Attacks\n- **Tailgating**: authorized entry ke peeche peeche secure building mein ghus jana.\n- **Shoulder Surfing**: kisi ke screen ya keyboard ko peeche se dekh kar sensitive info chura lena.\n- **Lock Picking**: physical locks ko bina key ke open karna.\n\n## BadUSB / Rubber Ducky\n**USB Rubber Ducky** ek device hai jo dikhne mein normal USB drive jesa hota hai, lekin computer isay ek keyboard samajhta hai.\n\n## DuckyScript\nRubber Ducky **DuckyScript** mein commands likhta hai jo keystrokes ki tarah inject hoti hain.\n\n## Physical Security Kyun Overlooked Hoti Hai\nOrganizations aksar digital defense par focus karte hain lekin physical access control ignore kar dete hain.\n\n## Practical Exercise\nApne office ya ghar mein socho - koi tailgating se andar ghus sakta hai? Kya precautions hain?",
"## Overview\nSecurity is not just digital - gaining **physical access** can also compromise systems.\n\n## Common Physical Attacks\n- **Tailgating**: entering a secure building right behind an authorized person.\n- **Shoulder Surfing**: watching someone's screen or keyboard to steal sensitive info.\n- **Lock Picking**: opening physical locks without a key.\n\n## BadUSB / Rubber Ducky\nA **USB Rubber Ducky** is a device that looks like a normal USB drive, but the computer recognizes it as a keyboard.\n\n## DuckyScript\nThe Rubber Ducky writes commands in **DuckyScript** that get injected as keystrokes.\n\n## Why Physical Security Gets Overlooked\nOrganizations often focus on digital defense but ignore physical access control.\n\n## Practical Exercise\nThink about your office or home - could someone get in through tailgating? What precautions exist?",
[
QuizQ("USB Rubber Ducky attack computer par detect kyun nahi hota?", ["Yeh antivirus ko bypass karta hai", "Computer isay standard USB Keyboard samajhta hai", "Yeh encrypted hota hai"], "Why does a USB Rubber Ducky attack not get detected by the computer?", ["It bypasses antivirus", "The computer treats it as a standard USB keyboard", "It is encrypted"], 1),
QuizQ("Tailgating kya hai?", ["Authorized person ke peeche secure building mein ghusna", "Password guess karna", "Email bhejna"], "What is tailgating?", ["Entering a secure building behind an authorized person", "Guessing a password", "Sending an email"], 0),
QuizQ("DuckyScript kis cheez ke liye use hoti hai?", ["Rubber Ducky ke liye keystroke commands likhne ke liye", "Websites design karne ke liye", "Hashes crack karne ke liye"], "What is DuckyScript used for?", ["Writing keystroke commands for the Rubber Ducky", "Designing websites", "Cracking hashes"], 0),
]),
Lesson("OSINT on Humans", Icons.person_search,
"## Overview\nSocial engineering attacks plan karne ke liye attackers pehle target individual ke bare mein jitni ho sake information collect karte hain.\n\n## Social Media Intelligence\nLinkedIn, Facebook, Instagram jesi platforms par log kaafi personal info share karte hain.\n\n## Maltego\n**Maltego** ek relationship-mapping tool hai jo automatically ek person ke bare mein connected information visualize kar deta hai.\n\n## Breach Data\nJab companies hack hoti hain, unka data aksar dark web par leak ho jata hai. **Breach data aggregation services** is data ko search karne dete hain.\n\n## Username Tracking\nLog aksar same username multiple platforms par use karte hain.\n\n## Privacy Ki Ahmiyat\nYe lesson awareness ke liye hai - samajhna ke tumhari apni public information kitni expose ho sakti hai.\n\n## Practical Exercise\nApna khud ka naam Google karo aur dekho kitni public information milti hai - kya tumhe is mein se kuch hide karna chahiye?",
"## Overview\nTo plan social engineering attacks, attackers first collect as much information as possible about a target individual.\n\n## Social Media Intelligence\nPeople share a lot of personal info on platforms like LinkedIn, Facebook, and Instagram.\n\n## Maltego\n**Maltego** is a relationship-mapping tool that automatically visualizes connected information about a person.\n\n## Breach Data\nWhen companies get hacked, their data often leaks onto the dark web. **Breach data aggregation services** let you search this data.\n\n## Username Tracking\nPeople often use the same username across multiple platforms.\n\n## Why Privacy Matters\nThis lesson is for awareness - understanding how much of your own public information is exposed.\n\n## Practical Exercise\nGoogle your own name and see how much public information you find - is there anything you should hide?",
[
QuizQ("Breach Data aggregation services testers ko kya find karne mein help karti hain?", ["Reused passwords aur leaked credentials", "Server uptime", "Network speed"], "What do breach data aggregation services help testers find?", ["Reused passwords and leaked credentials", "Server uptime", "Network speed"], 0),
QuizQ("Maltego kya karta hai?", ["Connected information ko visualize karta hai", "Passwords crack karta hai", "Websites down karta hai"], "What does Maltego do?", ["Visualizes connected information", "Cracks passwords", "Takes websites down"], 0),
QuizQ("Username tracking kyun risky ho sakta hai?", ["Ek hi username se poori online presence map ho sakti hai", "Ye sirf email ke liye hota hai", "Ye password change kar deta hai"], "Why can username tracking be risky?", ["One username can map an entire online presence", "It only applies to email", "It changes the password"], 0),
]),
Lesson("Defense & Countermeasures", Icons.verified_user,
"## Overview\nAb tak humne attacks dekhe - is lesson mein hum dekhenge ke individuals aur organizations apne aap ko kaise protect kar sakte hain.\n\n## Multi-Factor Authentication (MFA)\n**MFA** mein login ke liye do ya zyada factors chahiye hote hain: something you know, something you have, ya something you are.\n\n## SMS 2FA Ki Weakness\nSMS-based 2FA ko **SIM-swapping** se bypass kiya ja sakta hai.\n\n## TOTP Apps\n**TOTP apps** (jaise Google Authenticator) SIM-swapping se immune hain kyunke code phone ke andar generate hota hai.\n\n## Zero Trust Architecture\n**Zero Trust** ka principle hai: kabhi trust mat karo, hamesha verify karo.\n\n## Employee Awareness Training\nRegular security awareness training phishing aur social engineering ke against sab se asar defense hai.\n\n## Practical Exercise\nApne khud ke accounts check karo - kitne par SMS 2FA hai aur kitne par Authenticator App? Konse upgrade karne chahiye?",
"## Overview\nSo far we have seen attacks - in this lesson we will see how individuals and organizations can protect themselves.\n\n## Multi-Factor Authentication (MFA)\n**MFA** requires two or more factors to log in: something you know, something you have, or something you are.\n\n## The Weakness of SMS 2FA\nSMS-based 2FA can be bypassed through **SIM-swapping**.\n\n## TOTP Apps\n**TOTP apps** (like Google Authenticator) are immune to SIM-swapping because the code is generated inside the phone.\n\n## Zero Trust Architecture\nThe principle of **Zero Trust** is: never trust, always verify.\n\n## Employee Awareness Training\nRegular security awareness training is the most effective defense against phishing and social engineering.\n\n## Practical Exercise\nCheck your own accounts - how many use SMS 2FA versus an Authenticator App? Which ones should you upgrade?",
[
QuizQ("MFA mein kaunsa combination sahi hai?", ["Do passwords", "Password + Authenticator App", "Username + Email"], "Which combination is correct for MFA?", ["Two passwords", "Password + Authenticator App", "Username + Email"], 1),
QuizQ("SIM-swapping kis cheez ko target karta hai?", ["SMS-based 2FA", "TOTP apps", "Email encryption"], "What does SIM-swapping target?", ["SMS-based 2FA", "TOTP apps", "Email encryption"], 0),
QuizQ("Zero Trust ka core principle kya hai?", ["Kabhi trust mat karo, hamesha verify karo", "Sirf internal network ko trust karo", "Password kabhi change mat karo"], "What is the core principle of Zero Trust?", ["Never trust, always verify", "Only trust the internal network", "Never change your password"], 0),
]),
]),
Level("Module 8: Advanced & Career", "Crypto, Mobile, Cloud, Forensics, Reports", Icons.school, [
Lesson("Cryptography & PKI", Icons.enhanced_encryption,
"## Overview\n**Cryptography** data ko protect karne ka science hai, taake sirf authorized log hi usay padh sakein.\n\n## Symmetric vs Asymmetric\n**Symmetric Encryption** mein encryption aur decryption dono ke liye same key use hoti hai. **Asymmetric Encryption** mein public aur private key ka pair hota hai.\n\n## Hashing vs Encryption\nHashing ek-tarfa hai, jabke Encryption do-tarfa hai (reverse ho sakta hai with the right key).\n\n## PKI Aur SSL/TLS\n**PKI** digital certificates manage karta hai. **SSL/TLS handshake** HTTPS website ke liye encrypted connection establish karta hai.\n\n## Why This Matters\nBina cryptography ke, online banking aur e-commerce bilkul insecure ho jate.\n\n## Practical Exercise\nSocho tum kisi ko ek encrypted message bhejna chahte ho - kya tum unki public ya private key use karoge, aur kyun?",
"## Overview\n**Cryptography** is the science of protecting data so only authorized people can read it.\n\n## Symmetric vs Asymmetric\nIn **Symmetric Encryption**, the same key is used for both encryption and decryption. In **Asymmetric Encryption**, there is a pair of public and private keys.\n\n## Hashing vs Encryption\nHashing is one-way, while Encryption is two-way (reversible with the right key).\n\n## PKI and SSL/TLS\n**PKI** manages digital certificates. The **SSL/TLS handshake** establishes an encrypted connection for an HTTPS website.\n\n## Why This Matters\nWithout cryptography, online banking and e-commerce would be completely insecure.\n\n## Practical Exercise\nImagine you want to send someone an encrypted message - would you use their public or private key, and why?",
[
QuizQ("Asymmetric Encryption mein data encrypt karne ke liye kaunsi key use hoti hai?", ["Sender ki Private Key", "Recipient ki Public Key", "Shared Secret Key"], "Which key is used to encrypt data in Asymmetric Encryption?", ["The sender's private key", "The recipient's public key", "A shared secret key"], 1),
QuizQ("Hashing aur Encryption mein buniyadi farq kya hai?", ["Hashing one-way hai, Encryption reversible hai", "Dono same hain", "Hashing sirf images ke liye hai"], "What is the basic difference between hashing and encryption?", ["Hashing is one-way, encryption is reversible", "They are the same", "Hashing is only for images"], 0),
QuizQ("SSL/TLS handshake kya establish karta hai?", ["Browser aur server ke beech encrypted connection", "Database connection", "Wi-Fi password"], "What does the SSL/TLS handshake establish?", ["An encrypted connection between browser and server", "A database connection", "A Wi-Fi password"], 0),
]),
Lesson("Mobile Security", Icons.phone_android,
"## Overview\nMobile apps mein bhi web applications jesi vulnerabilities ho sakti hain, lekin inka testing approach thora different hota hai.\n\n## Android APK Structure\nEk Android app .apk file mein package hoti hai, jisme compiled code, resources, aur AndroidManifest.xml hota hai.\n\n## Decompilation with JADX\n**JADX** jesa tool .apk file ko wapis readable code mein convert kar deta hai.\n\n## Static vs Dynamic Analysis\n**Static Analysis** app ko chalaye baghair examine karta hai. **Dynamic Analysis** app ko actual device par chala kar uska runtime behavior observe karta hai.\n\n## ADB (Android Debug Bridge)\n**ADB** ek command-line tool hai jo computer se Android device ko connect karta hai.\n\n## Insecure Storage\nBohot si apps sensitive data ko plain text mein local storage mein save kar deti hain.\n\n## Practical Exercise\nSocho tumne ek APK decompile kiya aur usme ek hardcoded API key mil gayi - ye kyun ek security risk hai?",
"## Overview\nMobile apps can have vulnerabilities similar to web applications, but testing approaches differ.\n\n## Android APK Structure\nAn Android app is packaged in a .apk file, containing compiled code, resources, and AndroidManifest.xml.\n\n## Decompilation with JADX\nA tool like **JADX** converts a .apk file back into readable code.\n\n## Static vs Dynamic Analysis\n**Static Analysis** examines the app without running it. **Dynamic Analysis** runs the app on an actual device and observes its runtime behavior.\n\n## ADB (Android Debug Bridge)\n**ADB** is a command-line tool that connects a computer to an Android device.\n\n## Insecure Storage\nMany apps save sensitive data in plain text in local storage.\n\n## Practical Exercise\nImagine you decompiled an APK and found a hardcoded API key - why is this a security risk?",
[
QuizQ("Android Reverse Engineering ke liye konsi utility device se connect hoti hai?", ["ADB", "SSH", "FTP"], "Which utility connects to the device for Android reverse engineering?", ["ADB", "SSH", "FTP"], 0),
QuizQ("JADX kis liye use hota hai?", ["APK ko readable code mein decompile karne ke liye", "Apps install karne ke liye", "Network scan karne ke liye"], "What is JADX used for?", ["Decompiling an APK into readable code", "Installing apps", "Scanning networks"], 0),
QuizQ("Static Analysis aur Dynamic Analysis mein farq kya hai?", ["Static app chalaye baghair karta hai, Dynamic app chala kar", "Dono same hain", "Static sirf iOS ke liye hai"], "What is the difference between Static and Dynamic Analysis?", ["Static works without running the app, Dynamic runs it", "They are the same", "Static is only for iOS"], 0),
]),
Lesson("Cloud Security", Icons.cloud,
"## Overview\nJaise jaise companies apna infrastructure cloud par shift kar rahi hain, cloud-specific vulnerabilities bhi ek bara concern ban gayi hain.\n\n## Cloud Service Models\n- **IaaS**: virtual servers, storage - customer OS aur upar ka sab kuch manage karta hai.\n- **PaaS**: development platform - customer sirf code deploy karta hai.\n- **SaaS**: ready-made software - customer sirf use karta hai.\n\n## Misconfigured S3 Buckets\nAgar admin galti se bucket ko public set kar de, koi bhi internet se wo data access kar sakta hai.\n\n## IAM Policy Errors\nAgar permissions zyada wasee di jayein, ek compromised account bhi bohot nuqsaan pohncha sakta hai.\n\n## Shared Responsibility Model\nCloud provider data centers secure karta hai, lekin **customer** apna data aur access management khud secure karne ka zimedar hota hai.\n\n## Practical Exercise\nSocho ek company ne S3 bucket public kar diya jisme customer data tha - ye galti kis model ki responsibility thi: provider ya customer?",
"## Overview\nAs companies move their infrastructure to the cloud, cloud-specific vulnerabilities have become a major concern too.\n\n## Cloud Service Models\n- **IaaS**: virtual servers, storage - the customer manages the OS and everything above it.\n- **PaaS**: a development platform - the customer just deploys code.\n- **SaaS**: ready-made software - the customer just uses it.\n\n## Misconfigured S3 Buckets\nIf an admin accidentally sets a bucket to public, anyone on the internet can access that data.\n\n## IAM Policy Errors\nIf permissions are too broad, even one compromised account can cause massive damage.\n\n## The Shared Responsibility Model\nThe cloud provider secures data centers, but the **customer** is responsible for securing their own data and access management.\n\n## Practical Exercise\nImagine a company made an S3 bucket public that contained customer data - was this mistake the responsibility of the provider or the customer?",
[
QuizQ("Shared Responsibility Model mein Customer ki primary responsibility kya hai?", ["Data center security", "Data security aur IAM", "Hardware maintenance"], "What is the primary responsibility of the customer in the Shared Responsibility Model?", ["Data center security", "Data security and IAM", "Hardware maintenance"], 1),
QuizQ("IaaS mein customer kya manage karta hai?", ["OS aur upar ka sab kuch", "Sirf code", "Sirf hardware"], "What does the customer manage in IaaS?", ["The OS and everything above it", "Just the code", "Just the hardware"], 0),
QuizQ("Misconfigured S3 bucket ka sabse bara risk kya hai?", ["Data publicly accessible ho jata hai", "Server slow ho jata hai", "Cost zyada ho jati hai"], "What is the biggest risk of a misconfigured S3 bucket?", ["Data becomes publicly accessible", "The server becomes slow", "Costs increase"], 0),
]),
Lesson("Incident Response & Forensics", Icons.biotech,
"## Overview\nJab ek security breach ho jati hai, organizations ko systematic tareeqe se react karna hota hai - isay **Incident Response (IR)** kehte hain.\n\n## PICERL Lifecycle\nPreparation, Identification, Containment, Eradication, Recovery, aur Lessons Learned - ye 6 steps PICERL banate hain.\n\n## Digital Forensics\n**Forensics** evidence collect aur analyze karne ka science hai, bina evidence ko tamper kiye.\n\n## Order of Volatility\nForensics mein pehle sab se volatile cheezein collect ki jati hain: RAM sab se pehle, phir network connections, phir disk.\n\n## Memory Forensics with Volatility\n**Volatility** tool ek memory dump analyze karta hai - isse running processes aur malware dhoonda ja sakta hai.\n\n## Practical Exercise\nSocho ek machine compromise hui hai - forensics team RAM pehle kyun collect karegi disk se pehle?",
"## Overview\nWhen a security breach occurs, organizations need to react systematically - this is called **Incident Response (IR)**.\n\n## The PICERL Lifecycle\nPreparation, Identification, Containment, Eradication, Recovery, and Lessons Learned - these 6 steps form PICERL.\n\n## Digital Forensics\n**Forensics** is the science of collecting and analyzing evidence, without tampering with it.\n\n## Order of Volatility\nIn forensics, the most volatile things are collected first: RAM first, then network connections, then disk.\n\n## Memory Forensics with Volatility\nThe **Volatility** tool analyzes a memory dump - revealing running processes and sometimes malware.\n\n## Practical Exercise\nImagine a machine has been compromised - why would a forensics team collect RAM before the disk?",
[
QuizQ("Order of Volatility ke mutabiq sabse pehle kya collect karna chahiye?", ["Hard disk", "RAM / Volatile Memory", "Log files"], "According to the Order of Volatility, what should be collected first?", ["Hard disk", "RAM / Volatile Memory", "Log files"], 1),
QuizQ("PICERL mein C kis liye hai?", ["Containment (phelao rokna)", "Cracking", "Coding"], "What does the C stand for in PICERL?", ["Containment", "Cracking", "Coding"], 0),
QuizQ("Volatility tool kis cheez ko analyze karta hai?", ["Memory dump (RAM snapshot)", "Website design", "Network bandwidth"], "What does the Volatility tool analyze?", ["A memory dump (RAM snapshot)", "Website design", "Network bandwidth"], 0),
]),
Lesson("Pentest Report Writing", Icons.description,
"## Overview\nEk pentest chahe kitna bhi acha ho, agar uska report clear aur actionable na ho, to client ko koi faida nahi hota.\n\n## Report Ke Zaroori Hisse\n- **Executive Summary**: non-technical overview.\n- **Technical Details**: har vulnerability ki detail, severity.\n- **Proof of Concept (PoC)**: step-by-step evidence.\n- **Remediation Steps**: kaise fix karein.\n\n## Audience Ki Pehchan\nExecutive Summary C-Level Executives ke liye hota hai. Technical Details developers aur IT staff ke liye hota hai.\n\n## Achi PoC Kya Banati Hai\nEk acha PoC clear screenshots aur exact steps deta hai.\n\n## CISO-Level Remediation Advisory\nRemediation advice mein priority, estimated effort, aur business impact bhi shamil hona chahiye.\n\n## Practical Exercise\nSocho tumne ek SQL Injection vulnerability dhoondi hai - Executive Summary mein ek sentence aur Technical Details mein ek paragraph likho.",
"## Overview\nNo matter how good a pentest is, if the report is not clear and actionable, the client gets no real benefit.\n\n## Essential Parts of a Report\n- **Executive Summary**: a non-technical overview.\n- **Technical Details**: detail of every vulnerability, its severity.\n- **Proof of Concept (PoC)**: step-by-step evidence.\n- **Remediation Steps**: how to fix it.\n\n## Knowing the Audience\nThe Executive Summary is for C-Level Executives. The Technical Details section is for developers and IT staff.\n\n## What Makes a Good PoC\nA good PoC provides clear screenshots and exact steps.\n\n## CISO-Level Remediation Advisory\nRemediation advice should include priority, estimated effort, and business impact.\n\n## Practical Exercise\nImagine you found a SQL Injection vulnerability - write one sentence for the Executive Summary and one paragraph for Technical Details.",
[
QuizQ("Pentest Report ka Executive Summary kis audience ke liye likha jata hai?", ["Developers", "C-Level Executives (non-technical)", "Hackers"], "Who is the Executive Summary of a pentest report written for?", ["Developers", "C-Level Executives (non-technical)", "Hackers"], 1),
QuizQ("Proof of Concept (PoC) ka maqsad kya hai?", ["Dikhana ke vulnerability asal mein exploit ho sakti hai", "Sirf report ko lamba karna", "Client ko darana"], "What is the purpose of a Proof of Concept (PoC)?", ["Showing that the vulnerability can actually be exploited", "Just making the report longer", "Scaring the client"], 0),
QuizQ("Remediation advice mein kya shamil hona chahiye?", ["Priority, effort, aur business impact", "Sirf fix this likhna", "Sirf code snippets"], "What should remediation advice include?", ["Priority, effort, and business impact", "Just writing fix this", "Only code snippets"], 0),
]),
]),
];

/* ===================== STATE ===================== */
class AppState extends ChangeNotifier {
  late SharedPreferences p;
  Set<String> done = {};
  int xp = 0, streak = 0;
  String lastDay = '';
  bool agreed = false;
  String lang = 'ur';

  String _today() => DateTime.now().toIso8601String().substring(0, 10);

  Future<void> load() async {
    p = await SharedPreferences.getInstance();
    done = (p.getStringList('done') ?? []).toSet();
    xp = p.getInt('xp') ?? 0;
    streak = p.getInt('streak') ?? 0;
    lastDay = p.getString('lastDay') ?? '';
    agreed = p.getBool('agreed') ?? false;
    lang = p.getString('lang') ?? 'ur';

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

  void setLang(String l) {
    lang = l;
    p.setString('lang', l);
    notifyListeners();
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

/// Renders a lesson body split into "## Heading" sections with styled
/// section headers, falling back to plain paragraphs for the rest.
List<Widget> renderLessonBody(String text) {
  final widgets = <Widget>[];
  final blocks = text.split('\n\n');
  for (final raw in blocks) {
    final block = raw.trim();
    if (block.isEmpty) continue;
    if (block.startsWith('## ')) {
      widgets.add(Padding(
        padding: EdgeInsets.only(top: widgets.isEmpty ? 0 : 20, bottom: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
                color: C.accent, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(block.substring(3).trim(),
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w800, color: C.accentL)),
          ),
        ]),
      ));
    } else {
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text.rich(
          TextSpan(children: rich(block)),
          style: const TextStyle(fontSize: 15, height: 1.75, color: Color(0xFFCBD5E1)),
        ),
      ));
    }
  }
  return widgets;
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

/// Fixed-size slot matching a standard 320x50 mobile banner ad.
/// Swap the child content here for a real ad SDK widget later.
class BannerAdPlaceholder extends StatelessWidget {
  const BannerAdPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      color: C.surface2,
      alignment: Alignment.center,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.campaign_outlined, size: 16, color: C.muted),
        const SizedBox(width: 8),
        Text(T('Ad banner space (320x50)', 'Ad banner space (320x50)'),
            style: const TextStyle(color: C.muted, fontSize: 11, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

/* ===================== MAIN ===================== */
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AdService.initialize();
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
    if (ready) return const AuthGate();
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
        title: Text(T('🛡️ Safety First', '🛡️ Safety First'), style: const TextStyle(color: C.accent)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
              T('HackGuide sirf ethical aur authorized security learning ke liye hai. Testing sirf apne systems, practice labs ya written permission wale targets par karo.',
                  'HackGuide is only for ethical and authorized security learning. Only test your own systems, practice labs, or targets you have written permission for.'),
              style: const TextStyle(color: C.muted, fontSize: 14, height: 1.5)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: C.danger.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: C.danger.withOpacity(.3))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(T('Strict Rule:', 'Strict Rule:'),
                  style: const TextStyle(color: C.danger, fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                  T('Bina ijazat kisi account, phone, ya network ko access karna allowed nahi hai.',
                      'Accessing any account, phone, or network without permission is not allowed.'),
                  style: const TextStyle(color: C.muted, fontSize: 12)),
            ]),
          ),
        ]),
        actions: [
          SizedBox(
            width: double.infinity,
            child: PrimaryBtn(T('I Understand & Agree', 'I Understand & Agree'), () {
              app.setAgreed();
              Navigator.pop(c);
            }),
          ),
        ],
      ),
    );
  }

  void showSettings() {
    showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, setD) => AlertDialog(
          backgroundColor: C.surface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: C.border)),
          title: Text(T('⚙️ App Settings', '⚙️ App Settings')),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(T('Language', 'Language'),
                    style: const TextStyle(fontWeight: FontWeight.w600))),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: _LangChip(
                  label: 'اردو',
                  selected: app.lang == 'ur',
                  onTap: () {
                    app.setLang('ur');
                    setD(() {});
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _LangChip(
                  label: 'English',
                  selected: app.lang == 'en',
                  onTap: () {
                    app.setLang('en');
                    setD(() {});
                  },
                ),
              ),
            ]),
            const Divider(height: 28, color: C.border),
            Row(children: [
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(T('Reset Data', 'Reset Data'),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(T('Lessons, XP aur streak delete', 'Delete lessons, XP and streak'),
                    style: const TextStyle(color: C.muted, fontSize: 11)),
              ])),
              OutlinedButton(
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: c,
                    builder: (d) => AlertDialog(
                      title: Text(T('Progress aur XP reset karna hai?',
                          'Reset your progress and XP?')),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(d, false),
                            child: Text(T('No', 'No'))),
                        TextButton(
                            onPressed: () => Navigator.pop(d, true),
                            child: Text(T('Yes', 'Yes'))),
                      ],
                    ),
                  );
                  if (ok == true) {
                    app.reset();
                    if (c.mounted) Navigator.pop(c);
                    if (mounted) toast(context, T('Data Reset!', 'Data Reset!'));
                  }
                },
                child: Text(T('Reset', 'Reset')),
              ),
            ]),
          ]),
          actions: [
            SizedBox(
              width: double.infinity,
              child: PrimaryBtn(T('Done', 'Done'), () {
                Navigator.pop(c);
                setState(() {});
                toast(context, T('Settings Saved', 'Settings Saved'));
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const pages = [LessonsHomePage(), ToolsPage(), TutorPage(), BadgesPage()];
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
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              try { await GoogleSignIn().signOut(); } catch (_) {}
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthGate()), (route) => false);
              }
            },
            icon: const Icon(Icons.logout, color: C.muted),
          ),
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AdBannerForModule(moduleIndex: 0),
          NavigationBar(
            backgroundColor: C.surface,
            indicatorColor: C.accent.withOpacity(.15),
            selectedIndex: tab,
            onDestinationSelected: (i) => setState(() => tab = i),
            destinations: [
              NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home, color: C.accentL),
                  label: T('Learn', 'Learn')),
              NavigationDestination(
                  icon: const Icon(Icons.terminal),
                  selectedIcon: const Icon(Icons.terminal, color: C.accentL),
                  label: T('Tools', 'Tools')),
              NavigationDestination(
                  icon: const Icon(Icons.smart_toy_outlined),
                  selectedIcon: const Icon(Icons.smart_toy, color: C.accentL),
                  label: T('Tutor', 'Tutor')),
              NavigationDestination(
                  icon: const Icon(Icons.auto_awesome_outlined),
                  selectedIcon: const Icon(Icons.auto_awesome, color: C.accentL),
                  label: T('Badges', 'Badges')),
            ],
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LangChip({required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? C.accent : C.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? C.accent : C.border),
        ),
        child: Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : C.muted)),
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
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(T('Welcome, Hacker_', 'Welcome, Hacker_'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(T('Apni skills upgrade karo. Safely.', 'Upgrade your skills. Safely.'),
                  style: const TextStyle(color: C.muted, fontSize: 13)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: C.success.withOpacity(.1), borderRadius: BorderRadius.circular(99)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.circle, size: 6, color: C.success),
                const SizedBox(width: 6),
                Text(T('ONLINE', 'ONLINE'),
                    style: const TextStyle(color: C.success, fontSize: 10, fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            stat('${app.completed}/${app.total}', T('Lessons', 'Lessons')),
            stat('${app.xp}', 'XP', C.accent),
            stat('🔥 ${app.streak}', T('Streak', 'Streak'), C.warning),
          ]),
        ]),
      ),
      if (app.completed >= app.total && app.total > 0) ...[
        const SizedBox(height: 12),
        PrimaryBtn('🎓 View Certificate', () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CertificatePage()));
        }),
      ],
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(T('Learning Modules', 'Learning Modules'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: C.accent.withOpacity(.1), borderRadius: BorderRadius.circular(8)),
          child: Text('${app.percent}% ${T('Done', 'Done')}',
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
            Text(isDone ? T('COMPLETED', 'COMPLETED') : T('TAP TO LEARN', 'TAP TO LEARN'),
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
  late List<int?> picked;
  late List<bool?> correct;
  late List<String?> result;

  @override
  void initState() {
    super.initState();
    final n = levels[widget.i].lessons[widget.j].quizzes.length;
    picked = List<int?>.filled(n, null);
    correct = List<bool?>.filled(n, null);
    result = List<String?>.filled(n, null);
  }

  Future<void> check(int qi, int k) async {
    final qz = levels[widget.i].lessons[widget.j].quizzes[qi];
    setState(() {
      picked[qi] = k;
      if (k == qz.a) {
        correct[qi] = true;
        result[qi] = T('✅ Sahi!', '✅ Correct!');
      } else {
        correct[qi] = false;
        result[qi] = T('❌ Dobara koshish karo.', '❌ Try again.');
      }
    });

    if (correct.every((c) => c == true)) {
      final total = levels[widget.i].lessons.length;
      final beforeCount = app.levelDone(widget.i);
      final isNew = app.complete(widget.i, widget.j);
      final afterCount = app.levelDone(widget.i);
      if (isNew) {
        toast(context, T('Lesson Completed! +50 XP', 'Lesson Completed! +50 XP'));
        final justFinishedLevel = beforeCount < total && afterCount == total;
        if (justFinishedLevel) {
          // Show interstitial only after completing modules 2–8 (zero-based indexes 1–7).
          await AdService.showInterstitialIfAllowed(widget.i);
          Future.delayed(const Duration(milliseconds: 900), () {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      LevelCompleteScreen(level: levels[widget.i], levelIndex: widget.i),
                ),
              );
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final x = levels[widget.i].lessons[widget.j];
    return Scaffold(
      appBar: AppBar(backgroundColor: C.bg, title: Text(T('Lesson', 'Lesson'))),
      bottomNavigationBar: AdBannerForModule(moduleIndex: widget.i),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(20), children: [
          Row(children: [
            Sticker(x.icon, size: 60),
            const SizedBox(width: 16),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(x.t, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(T('+50 XP REWARD', '+50 XP REWARD'),
                  style: const TextStyle(color: C.accent, fontSize: 12, fontWeight: FontWeight.w700)),
            ])),
          ]),
          const SizedBox(height: 20),
          GCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: renderLessonBody(x.content()),
            ),
          ),
          const SizedBox(height: 8),
          GCard(
            borderColor: C.accent,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(T('🧠 Concept Quiz', '🧠 Concept Quiz'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              for (int qi = 0; qi < x.quizzes.length; qi++) ...[
                if (qi > 0) const Divider(height: 28, color: C.border),
                quizBlock(x, qi),
              ],
            ]),
          ),
        ]),
      ),
    );
  }

  Widget quizBlock(Lesson x, int qi) {
    final qz = x.quizzes[qi];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${T('Question', 'Question')} ${qi + 1}/${x.quizzes.length}',
            style: const TextStyle(
                color: C.muted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
        const SizedBox(height: 6),
        Text(qz.question(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        for (int k = 0; k < qz.options().length; k++) option(qz, qi, k),
        if (result[qi] != null)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Text(result[qi]!,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: correct[qi] == true ? C.success : C.danger)),
          ),
      ],
    );
  }

  Widget option(QuizQ qz, int qi, int k) {
    final isPicked = picked[qi] == k;
    final ok = isPicked && correct[qi] == true;
    final no = isPicked && correct[qi] == false;
    final col = ok ? C.success : (no ? C.danger : C.border);
    return GestureDetector(
      onTap: () => check(qi, k),
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
          Expanded(child: Text(qz.options()[k], style: const TextStyle(fontWeight: FontWeight.w500))),
        ]),
      ),
    );
  }
}

/* ===================== LEVEL COMPLETE CELEBRATION ===================== */
class _ConfettiPiece {
  double x, y, speed, size, angle, angleSpeed;
  Color color;
  _ConfettiPiece({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.angle,
    required this.angleSpeed,
    required this.color,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;
  _ConfettiPainter(this.pieces);
  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pieces) {
      final paint = Paint()..color = p.color;
      canvas.save();
      canvas.translate(p.x * size.width, p.y * size.height);
      canvas.rotate(p.angle);
      canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}

class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({super.key});
  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController ctrl;
  final rnd = Random();
  late List<_ConfettiPiece> pieces;
  static const colors = [C.accent, C.accentL, C.success, C.warning, Colors.white];

  @override
  void initState() {
    super.initState();
    pieces = List.generate(
        45,
        (_) => _ConfettiPiece(
              x: rnd.nextDouble(),
              y: -rnd.nextDouble() * 1.2,
              speed: 0.15 + rnd.nextDouble() * 0.3,
              size: 6 + rnd.nextDouble() * 7,
              angle: rnd.nextDouble() * 6.28,
              angleSpeed: (rnd.nextDouble() - 0.5) * 0.25,
              color: colors[rnd.nextInt(colors.length)],
            ));
    ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..addListener(() {
        setState(() {
          for (final p in pieces) {
            p.y += p.speed * 0.016;
            p.angle += p.angleSpeed;
            if (p.y > 1.2) {
              p.y = -0.2;
              p.x = rnd.nextDouble();
            }
          }
        });
      })
      ..repeat();
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: _ConfettiPainter(pieces), size: Size.infinite),
    );
  }
}

class LevelCompleteScreen extends StatelessWidget {
  final Level level;
  final int levelIndex;
  const LevelCompleteScreen({super.key, required this.level, required this.levelIndex});

  @override
  Widget build(BuildContext context) {
    final nextLocked = levelIndex + 1 < levels.length;
    return Scaffold(
      backgroundColor: C.bg,
      body: Stack(children: [
        const Positioned.fill(child: ConfettiOverlay()),
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('🎉', style: TextStyle(fontSize: 54)),
                const SizedBox(height: 10),
                Text(T('Level Complete!', 'Level Complete!'),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(level.t,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: C.accentL, fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 36),
                SizedBox(
                  width: 190,
                  height: 190,
                  child: Stack(alignment: Alignment.center, children: [
                    Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [C.accent.withOpacity(.3), Colors.transparent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        border: Border.all(color: C.accent.withOpacity(.4), width: 2),
                      ),
                    ),
                    Container(
                      width: 116,
                      height: 116,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                            colors: [C.accent, Color(0xFF8B5CF6)]),
                        boxShadow: [
                          BoxShadow(color: C.accent.withOpacity(.5), blurRadius: 30)
                        ],
                      ),
                      child: Icon(level.icon, color: Colors.white, size: 52),
                    ),
                    const Positioned(
                        bottom: 4, right: 8, child: Text('🏆', style: TextStyle(fontSize: 38))),
                  ]),
                ),
                const SizedBox(height: 36),
                GCard(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    Column(children: [
                      Text('${level.lessons.length}',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w800, color: C.accentL)),
                      Text(T('LESSONS', 'LESSONS'),
                          style: const TextStyle(
                              color: C.muted, fontSize: 10, fontWeight: FontWeight.w600)),
                    ]),
                    Container(width: 1, height: 36, color: C.border),
                    Column(children: [
                      Text('+${level.lessons.length * 50}',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w800, color: C.warning)),
                      Text(T('XP EARNED', 'XP EARNED'),
                          style: const TextStyle(
                              color: C.muted, fontSize: 10, fontWeight: FontWeight.w600)),
                    ]),
                  ]),
                ),
                const SizedBox(height: 8),
                Text(
                  nextLocked
                      ? T('Agla module unlock ho gaya: ${levels[levelIndex + 1].t}',
                          'Next module unlocked: ${levels[levelIndex + 1].t}')
                      : T('Tumne poora course complete kar liya! 🚀',
                          'You completed the entire course! 🚀'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: C.muted, fontSize: 13),
                ),
                const SizedBox(height: 28),
                PrimaryBtn(T('Continue', 'Continue'), () {
                  Navigator.of(context).pop();
                  if (app.completed >= app.total && app.total > 0) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CertificatePage()));
                  }
                }),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

/* ===================== TOOLS HUB ===================== */
class ToolItem {
  final String title, desc;
  final IconData icon;
  final WidgetBuilder builder;
  const ToolItem(this.title, this.desc, this.icon, this.builder);
}

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = <ToolItem>[
      ToolItem(
          T('IP Checker', 'IP Checker'),
          T('Apna public IP, ISP aur location dekho', 'See your public IP, ISP and location'),
          Icons.public,
          (_) => const IpCheckerPage()),
      ToolItem(
          T('Port Scanner', 'Port Scanner'),
          T('Kisi host par common ports scan karo', 'Scan common ports on a host'),
          Icons.lan,
          (_) => const PortScannerPage()),
      ToolItem(
          T('DNS Lookup', 'DNS Lookup'),
          T('Domain ko IP addresses mein resolve karo', 'Resolve a domain to its IP addresses'),
          Icons.dns,
          (_) => const DnsLookupPage()),
      ToolItem(
          T('Subnet Calculator', 'Subnet Calculator'),
          T('Network, broadcast aur host range nikalo',
              'Find network, broadcast and host range'),
          Icons.calculate,
          (_) => const SubnetCalcPage()),
      ToolItem(
          T('Command Explainer', 'Command Explainer'),
          T('Nmap/Linux commands ko samjho', 'Understand Nmap/Linux commands'),
          Icons.terminal,
          (_) => const CommandExplainerPage()),
    ];

    return ListView(padding: const EdgeInsets.all(20), children: [
      Text(T('Tools', 'Tools'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      Text(
          T('Real network tools — sirf authorized targets par use karo.',
              'Real network tools — only use them on authorized targets.'),
          style: const TextStyle(color: C.muted, fontSize: 12)),
      const SizedBox(height: 16),
      for (final t in tools)
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: t.builder)),
          child: GCard(
            child: Row(children: [
              Sticker(t.icon),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(t.desc, style: const TextStyle(color: C.muted, fontSize: 12)),
              ])),
              const Icon(Icons.chevron_right, color: C.muted),
            ]),
          ),
        ),
    ]);
  }
}

/* ===================== TOOL: IP CHECKER ===================== */
class IpCheckerPage extends StatefulWidget {
  const IpCheckerPage({super.key});
  @override
  State<IpCheckerPage> createState() => _IpCheckerPageState();
}

class _IpCheckerPageState extends State<IpCheckerPage> {
  bool loading = false;
  String? error;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await http
          .get(Uri.parse('http://ip-api.com/json/'))
          .timeout(const Duration(seconds: 12));
      final j = jsonDecode(res.body);
      if (j['status'] == 'success') {
        setState(() => data = j);
      } else {
        setState(() => error = T('Lookup fail hua, dobara try karo.', 'Lookup failed, try again.'));
      }
    } catch (e) {
      setState(() => error = T('Internet connection check karo.', 'Check your internet connection.'));
    } finally {
      setState(() => loading = false);
    }
  }

  Widget row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(children: [
          SizedBox(
              width: 90,
              child: Text(k,
                  style: const TextStyle(
                      color: C.muted, fontSize: 12, fontWeight: FontWeight.w600))),
          Expanded(
              child: Text(v,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: C.bg, title: Text(T('IP Checker', 'IP Checker'))),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(20), children: [
          GCard(
            borderColor: C.accent,
            padding: const EdgeInsets.all(28),
            child: Column(children: [
              const Sticker(Icons.public, size: 60),
              const SizedBox(height: 16),
              if (loading) const CircularProgressIndicator(color: C.accent),
              if (!loading && error != null)
                Text(error!, textAlign: TextAlign.center, style: const TextStyle(color: C.danger)),
              if (!loading && data != null) ...[
                Text('${data!['query'] ?? '-'}',
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w800, color: C.accentL)),
                const SizedBox(height: 4),
                Text(T('YOUR PUBLIC IP', 'YOUR PUBLIC IP'),
                    style: const TextStyle(
                        color: C.muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1)),
              ],
            ]),
          ),
          if (!loading && data != null)
            GCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                row(T('Country', 'Country'), '${data!['country'] ?? '-'}'),
                row(T('Region', 'Region'), '${data!['regionName'] ?? '-'}'),
                row(T('City', 'City'), '${data!['city'] ?? '-'}'),
                row(T('ISP', 'ISP'), '${data!['isp'] ?? '-'}'),
                row(T('Org', 'Org'), '${data!['org'] ?? '-'}'),
                row(T('Timezone', 'Timezone'), '${data!['timezone'] ?? '-'}'),
              ]),
            ),
          PrimaryBtn(loading ? T('Checking...', 'Checking...') : T('Refresh', 'Refresh'),
              loading ? () {} : fetch),
        ]),
      ),
    );
  }
}

/* ===================== TOOL: PORT SCANNER ===================== */
class PortScannerPage extends StatefulWidget {
  const PortScannerPage({super.key});
  @override
  State<PortScannerPage> createState() => _PortScannerPageState();
}

class _PortScannerPageState extends State<PortScannerPage> {
  final hostCtrl = TextEditingController();
  bool scanning = false;
  int scanned = 0;
  final List<MapEntry<int, bool>> results = [];

  static const commonPorts = <int, String>{
    21: 'FTP',
    22: 'SSH',
    23: 'Telnet',
    25: 'SMTP',
    53: 'DNS',
    80: 'HTTP',
    110: 'POP3',
    143: 'IMAP',
    443: 'HTTPS',
    445: 'SMB',
    3306: 'MySQL',
    3389: 'RDP',
    8080: 'HTTP-Alt',
  };

  Future<void> scan() async {
    final host = hostCtrl.text.trim();
    if (host.isEmpty || scanning) return;
    setState(() {
      scanning = true;
      results.clear();
      scanned = 0;
    });

    for (final port in commonPorts.keys) {
      bool open = false;
      try {
        final socket =
            await Socket.connect(host, port, timeout: const Duration(milliseconds: 900));
        open = true;
        socket.destroy();
      } catch (_) {
        open = false;
      }
      if (!mounted) return;
      setState(() {
        results.add(MapEntry(port, open));
        scanned++;
      });
    }
    if (mounted) setState(() => scanning = false);
  }

  @override
  Widget build(BuildContext context) {
    final openCount = results.where((e) => e.value).length;
    final total = commonPorts.length;
    return Scaffold(
      appBar: AppBar(backgroundColor: C.bg, title: Text(T('Port Scanner', 'Port Scanner'))),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(20), children: [
          GCard(
            child: Column(children: [
              const Sticker(Icons.lan, size: 60),
              const SizedBox(height: 14),
              Text(T('Common Port Scanner', 'Common Port Scanner'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(
                  T('Sirf apne systems ya likhit ijazat wale targets par use karo.',
                      'Only use this on your own systems or targets you have written permission for.'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: C.danger, fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextField(
                controller: hostCtrl,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'monospace'),
                decoration: InputDecoration(
                  hintText: 'e.g. scanme.nmap.org',
                  filled: true,
                  fillColor: C.surface,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: C.border)),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryBtn(scanning ? T('Scanning...', 'Scanning...') : T('Start Scan', 'Start Scan'),
                  scanning ? () {} : scan),
            ]),
          ),
          if (scanning)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(children: [
                LinearProgressIndicator(
                    value: scanned / total, color: C.accent, backgroundColor: Colors.white10),
                const SizedBox(height: 6),
                Text('$scanned / $total ${T('ports checked', 'ports checked')}',
                    style: const TextStyle(color: C.muted, fontSize: 12)),
              ]),
            ),
          if (results.isNotEmpty)
            GCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${T('Results', 'Results')} — $openCount ${T('open', 'open')}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 10),
                for (final r in results)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(children: [
                      Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: r.value ? C.success : C.muted, shape: BoxShape.circle)),
                      const SizedBox(width: 10),
                      Text('Port ${r.key}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text('(${commonPorts[r.key]})',
                          style: const TextStyle(color: C.muted, fontSize: 12)),
                      const Spacer(),
                      Text(r.value ? 'OPEN' : T('closed', 'closed'),
                          style: TextStyle(
                              color: r.value ? C.success : C.muted,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ]),
                  ),
              ]),
            ),
        ]),
      ),
    );
  }
}

/* ===================== TOOL: DNS LOOKUP ===================== */
class DnsLookupPage extends StatefulWidget {
  const DnsLookupPage({super.key});
  @override
  State<DnsLookupPage> createState() => _DnsLookupPageState();
}

class _DnsLookupPageState extends State<DnsLookupPage> {
  final ctrl = TextEditingController();
  bool loading = false;
  String? error;
  List<InternetAddress> results = [];

  Future<void> lookup() async {
    final domain = ctrl.text.trim();
    if (domain.isEmpty || loading) return;
    setState(() {
      loading = true;
      error = null;
      results = [];
    });
    try {
      final addrs = await InternetAddress.lookup(domain).timeout(const Duration(seconds: 10));
      setState(() => results = addrs);
    } catch (e) {
      setState(() => error =
          T('Resolve nahi hua. Domain spelling check karo.', "Could not resolve. Check the domain spelling."));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: C.bg, title: Text(T('DNS Lookup', 'DNS Lookup'))),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(20), children: [
          GCard(
            child: Column(children: [
              const Sticker(Icons.dns, size: 60),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'monospace'),
                decoration: InputDecoration(
                  hintText: 'e.g. google.com',
                  filled: true,
                  fillColor: C.surface,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: C.border)),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryBtn(loading ? T('Looking up...', 'Looking up...') : T('Lookup', 'Lookup'),
                  loading ? () {} : lookup),
            ]),
          ),
          if (error != null)
            GCard(
                borderColor: C.danger,
                child: Text(error!, style: const TextStyle(color: C.danger))),
          if (results.isNotEmpty)
            GCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(T('Resolved Addresses', 'Resolved Addresses'),
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                for (final a in results)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(a.address,
                        style: const TextStyle(fontFamily: 'monospace', color: C.accentL, fontSize: 15)),
                  ),
              ]),
            ),
        ]),
      ),
    );
  }
}

/* ===================== TOOL: SUBNET CALCULATOR ===================== */
class SubnetCalcPage extends StatefulWidget {
  const SubnetCalcPage({super.key});
  @override
  State<SubnetCalcPage> createState() => _SubnetCalcPageState();
}

class _SubnetCalcPageState extends State<SubnetCalcPage> {
  final ipCtrl = TextEditingController(text: '192.168.1.0');
  final cidrCtrl = TextEditingController(text: '24');
  String? error;
  Map<String, String>? result;

  void calculate() {
    setState(() {
      error = null;
      result = null;
    });
    try {
      final parts = ipCtrl.text.trim().split('.').map(int.parse).toList();
      if (parts.length != 4 || parts.any((p) => p < 0 || p > 255)) {
        throw 'bad ip';
      }
      final cidr = int.parse(cidrCtrl.text.trim());
      if (cidr < 0 || cidr > 32) throw 'bad cidr';

      final ipInt = (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8) | parts[3];
      final mask = cidr == 0 ? 0 : (0xFFFFFFFF << (32 - cidr)) & 0xFFFFFFFF;
      final network = ipInt & mask;
      final broadcast = network | (~mask & 0xFFFFFFFF);
      final hosts = cidr >= 31 ? 0 : (1 << (32 - cidr)) - 2;

      String toIp(int v) => '${(v >> 24) & 255}.${(v >> 16) & 255}.${(v >> 8) & 255}.${v & 255}';

      setState(() => result = {
            T('Network Address', 'Network Address'): toIp(network),
            T('Broadcast Address', 'Broadcast Address'): toIp(broadcast),
            T('Subnet Mask', 'Subnet Mask'): toIp(mask),
            T('Usable Hosts', 'Usable Hosts'): hosts.toString(),
            T('First Usable', 'First Usable'): hosts > 0 ? toIp(network + 1) : '-',
            T('Last Usable', 'Last Usable'): hosts > 0 ? toIp(broadcast - 1) : '-',
          });
    } catch (_) {
      setState(() => error = T('Sahi IP aur CIDR (0-32) daalo.', 'Enter a valid IP and CIDR (0-32).'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: C.bg, title: Text(T('Subnet Calculator', 'Subnet Calculator'))),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(20), children: [
          GCard(
            child: Column(children: [
              const Sticker(Icons.calculate, size: 60),
              const SizedBox(height: 16),
              TextField(
                controller: ipCtrl,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'monospace'),
                decoration: InputDecoration(
                  labelText: T('IP Address', 'IP Address'),
                  filled: true,
                  fillColor: C.surface,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: C.border)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cidrCtrl,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontFamily: 'monospace'),
                decoration: InputDecoration(
                  labelText: T('CIDR (e.g. 24)', 'CIDR (e.g. 24)'),
                  filled: true,
                  fillColor: C.surface,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: C.border)),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryBtn(T('Calculate', 'Calculate'), calculate),
            ]),
          ),
          if (error != null)
            GCard(
                borderColor: C.danger,
                child: Text(error!, style: const TextStyle(color: C.danger))),
          if (result != null)
            GCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: result!.entries
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Row(children: [
                            Expanded(
                                child: Text(e.key,
                                    style: const TextStyle(
                                        color: C.muted, fontSize: 12, fontWeight: FontWeight.w600))),
                            Text(e.value,
                                style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.w700,
                                    color: C.accentL)),
                          ]),
                        ))
                    .toList(),
              ),
            ),
        ]),
      ),
    );
  }
}

/* ===================== TOOL: COMMAND EXPLAINER ===================== */
class CommandExplainerPage extends StatefulWidget {
  const CommandExplainerPage({super.key});
  @override
  State<CommandExplainerPage> createState() => _CommandExplainerPageState();
}

class _CommandExplainerPageState extends State<CommandExplainerPage> {
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

  static const dictEn = {
    'nmap': 'Network scanner: finds ports and services (authorized targets only).',
    '-sV': 'Detects the service version.',
    '-sS': 'SYN (stealth) scan.',
    '-sU': 'UDP scan.',
    '-p': 'Choose specific ports (e.g. -p 22,80).',
    '-A': 'Aggressive: OS, version, scripts, traceroute.',
    '-Pn': 'Skips host discovery (ping).',
    '-f': 'Fragments packets (evasion).',
    'ls': 'Lists the files in a directory.',
    '-la': 'All files (including hidden) with details.',
    'pwd': 'Shows the current directory.',
    'cat': "Prints a file's contents.",
    'grep': 'Searches text for a pattern.',
    'cd': 'Changes directory.',
    'dig': 'Queries DNS records.',
    'netcat': 'Creates raw network connections (banner grabbing).',
    'hashcat': 'GPU-accelerated password cracking tool.',
  };

  void analyze() {
    final activeDict = app.lang == 'en' ? dictEn : dict;
    final tokens = ctrl.text.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
    setState(() {
      out = [
        for (final t in tokens)
          '`$t` → ${activeDict[t] ?? T('Argument / target (custom value).', 'Argument / target (custom value).')}'
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: C.bg, title: Text(T('Command Explainer', 'Command Explainer'))),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(20), children: [
          GCard(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
            child: Column(children: [
              const Sticker(Icons.terminal, size: 70),
              const SizedBox(height: 16),
              Text(T('Command Explainer', 'Command Explainer'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(T('Nmap ya Linux commands ko analyze karo.', 'Analyze Nmap or Linux commands.'),
                  style: const TextStyle(color: C.muted, fontSize: 13)),
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
              PrimaryBtn(T('Analyze Command', 'Analyze Command'), analyze),
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
        ]),
      ),
    );
  }
}

/* ===================== AI TUTOR (COMING SOON) ===================== */
class TutorPage extends StatelessWidget {
  const TutorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [C.accent, Color(0xFF8B5CF6)]),
              boxShadow: [BoxShadow(color: C.accent.withOpacity(.4), blurRadius: 30)],
            ),
            child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 44),
          ),
          const SizedBox(height: 24),
          Text(T('AI Tutor', 'AI Tutor'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: C.accent.withOpacity(.12),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: C.accent.withOpacity(.4)),
            ),
            child: Text(T('COMING SOON', 'COMING SOON'),
                style: const TextStyle(
                    color: C.accentL,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1)),
          ),
          const SizedBox(height: 16),
          Text(
            T('Ek smart AI tutor jo tumhare sawalon ka jawab de, concepts samjhaye aur practice mein guide kare - jald aa raha hai.',
                "A smart AI tutor that answers your questions, explains concepts, and guides your practice - coming soon."),
            textAlign: TextAlign.center,
            style: const TextStyle(color: C.muted, fontSize: 13, height: 1.6),
          ),
        ]),
      ),
    );
  }
}

/* ===================== BADGES ===================== */
class BadgesPage extends StatelessWidget {
  const BadgesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final ach = <Map<String, Object>>[
      {'icon': Icons.eco, 'name': 'Beginner', 'unlocked': app.completed >= 1},
      {'icon': Icons.local_fire_department, 'name': 'Streaker', 'unlocked': app.streak >= 3},
      {'icon': Icons.radar, 'name': 'Scanner', 'unlocked': app.done.contains('1-2')},
      {'icon': Icons.vaccines, 'name': 'Injector', 'unlocked': app.done.contains('4-1')},
      {'icon': Icons.person_search, 'name': 'Social Engineer', 'unlocked': app.done.contains('6-0')},
      {'icon': Icons.emoji_events, 'name': 'Pro Hacker', 'unlocked': app.completed == app.total},
    ];
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text(T('Achievements', 'Achievements'),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
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
              opacity: (a['unlocked'] as bool) ? 1 : .4,
              child: GCard(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: (a['unlocked'] as bool)
                          ? const LinearGradient(colors: [C.accent, Color(0xFF8B5CF6)])
                          : const LinearGradient(colors: [C.surface2, C.surface2]),
                      border: Border.all(
                          color: (a['unlocked'] as bool) ? C.accent : C.border),
                    ),
                    child: Icon(a['icon'] as IconData,
                        color: (a['unlocked'] as bool) ? Colors.white : C.muted, size: 30),
                  ),
                  const SizedBox(height: 12),
                  Text(a['name'] as String,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
        ],
      ),
    ]);
  }
}


/* ===================== FIREBASE AUTH ===================== */
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snapshot.data == null ? const LoginPage() : const Shell();
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  bool busy = false;
  String? error;
  Future<void> signIn() async {
    setState(() { busy = true; error = null; });
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) { setState(() => busy = false); return; }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final result = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = result.user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_user_name', user?.displayName ?? googleUser.displayName ?? 'Learner');
      await prefs.setString('auth_user_email', user?.email ?? googleUser.email);
      await prefs.setString('auth_user_photo', user?.photoURL ?? googleUser.photoUrl ?? '');
      if (mounted) setState(() => busy = false);
    } catch (e) {
      if (mounted) setState(() { busy = false; error = 'Login failed. Firebase/Google Sign-In configuration check karein.'; });
    }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: C.bg,
    body: SafeArea(child: Center(child: SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 84, height: 84,
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [C.accent, Color(0xFF3B82F6)]), borderRadius: BorderRadius.circular(24)),
          child: const Icon(Icons.shield_outlined, size: 44, color: Colors.white)),
        const SizedBox(height: 22),
        const Text('HACKGUIDE', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2)),
        const SizedBox(height: 8),
        const Text('Learn ethical hacking. Practice safely.', textAlign: TextAlign.center, style: TextStyle(color: C.muted)),
        const SizedBox(height: 30),
        if (error != null) Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(error!, style: const TextStyle(color: C.danger), textAlign: TextAlign.center)),
        SizedBox(width: double.infinity, height: 54, child: FilledButton.icon(
          onPressed: busy ? null : signIn,
          icon: busy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.login),
          label: Text(busy ? 'Please wait...' : 'Continue with Google'),
        )),
        const SizedBox(height: 16),
        const Text('Only use your skills on systems you own or have permission to test.', textAlign: TextAlign.center, style: TextStyle(color: C.muted, fontSize: 12)),
      ]),
    ))),
  );
}
