import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CertificatePage extends StatelessWidget {
  const CertificatePage({super.key});

  Future<Uint8List> _makePdf(String name) async {
    final doc = pw.Document();
    doc.addPage(pw.Page(pageFormat: PdfPageFormat.a4.landscape, build: (_) =>
      pw.Container(
        padding: const pw.EdgeInsets.all(28),
        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.blue, width: 4)),
        child: pw.Container(
          padding: const pw.EdgeInsets.all(26),
          decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.cyan, width: 1.5)),
          child: pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Text('HACKGUIDE', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 12),
            pw.Text('CERTIFICATE OF COMPLETION', textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 24),
            pw.Text('This certificate is proudly presented to', style: const pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 12),
            pw.Text(name, style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
            pw.SizedBox(height: 12),
            pw.Text('For successfully completing all 40 lessons of the HackGuide learning course.',
              textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 14)),
            pw.Spacer(),
            pw.Text('Ethical learning. Responsible practice.', style: const pw.TextStyle(fontSize: 11)),
          ]),
        ),
      )));
    return doc.save();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = (user?.displayName?.trim().isNotEmpty == true)
        ? user!.displayName!.trim() : 'HackGuide Learner';
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(title: const Text('Your Certificate')),
      body: Center(child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(children: [
          Container(width: double.infinity, padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF131A2A),
              border: Border.all(color: const Color(0xFF0EA5E9), width: 2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Container(padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFF38BDF8))),
              child: Column(children: [
                const Icon(Icons.workspace_premium, color: Color(0xFF38BDF8), size: 46),
                const SizedBox(height: 12),
                const Text('HACKGUIDE', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w900, letterSpacing: 3)),
                const SizedBox(height: 8),
                const Text('CERTIFICATE OF COMPLETION', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
                const SizedBox(height: 24),
                const Text('This certificate is proudly presented to', textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text(name, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
                const SizedBox(height: 14),
                const Text('For successfully completing all 40 lessons of the HackGuide learning course.',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, height: 1.5)),
                const SizedBox(height: 22),
                const Text('ETHICAL LEARNING • RESPONSIBLE PRACTICE',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.white54)),
              ]),
            ),
          ),
          const SizedBox(height: 22),
          Row(children: [
            Expanded(child: FilledButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Download / Save PDF'),
              onPressed: () async {
                final bytes = await _makePdf(name);
                await Printing.layoutPdf(onLayout: (_) async => bytes, name: 'HackGuide_Certificate.pdf');
              },
            )),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Share PDF'),
              onPressed: () async {
                final bytes = await _makePdf(name);
                await Printing.sharePdf(bytes: bytes, filename: 'HackGuide_Certificate.pdf');
              },
            )),
          ]),
        ]),
      )),
    );
  }
}
