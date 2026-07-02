import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WhatsAppFabWidget extends StatelessWidget {
  const WhatsAppFabWidget({super.key});

  static const _fallbackNumber = '4771118588';

  Future<void> _openWhatsApp(String number) async {
    final cleanNumber = number.replaceAll(RegExp(r'\D'), '');
    final fullNumber = cleanNumber.startsWith('52')
        ? cleanNumber
        : '52$cleanNumber';
    final message = Uri.encodeComponent(
        '¡Hola LeguFrut! Me gustaría recibir más información y ofertas.');
    final url = Uri.parse('https://wa.me/$fullNumber?text=$message');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('app_config')
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        var phone = _fallbackNumber;
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final data =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          final configuredPhone =
              (data['whatsapp_number'] as String? ?? '').trim();
          if (configuredPhone.isNotEmpty) {
            phone = configuredPhone;
          }
        }

        return GestureDetector(
          onTap: () => _openWhatsApp(phone),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF25D366).withOpacity(0.88),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              FontAwesomeIcons.whatsapp,
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}
