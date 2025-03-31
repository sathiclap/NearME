import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  String createOrderMessage(Map<String, dynamic> orderData, String shopName) {
    final items = (orderData['items'] as List);
    
    String message = 'New Order from ${orderData['customer_name']}\n\n';
    message += 'Shop: $shopName\n';
    message += '--------------------------------\n';
    
    message += 'Items:\n';
    for (var item in items) {
      message += '${item['quantity']}x ${item['product_name']} - \$${(item['price'] * item['quantity']).toStringAsFixed(2)}\n';
    }
    
    message += '--------------------------------\n';
    message += 'Total: \$${orderData['total_amount'].toStringAsFixed(2)}\n\n';
    
    message += 'Customer Details:\n';
    message += 'Name: ${orderData['customer_name']}\n';
    message += 'Address: ${orderData['customer_address']}\n';
    message += 'Mobile: ${orderData['customer_mobile']}';
    
    return message;
  }

  Future<void> sendMessage(String phoneNumber, String message) async {
    // Format phone number - remove any non-digit characters
    final formattedPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // Encode message for URL
    final encodedMessage = Uri.encodeComponent(message);
    
    // Create WhatsApp URL
    final url = 'whatsapp://send?phone=$formattedPhone&text=$encodedMessage';
    
    // Launch URL
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }
}