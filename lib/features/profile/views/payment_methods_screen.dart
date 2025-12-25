import 'package:flutter/material.dart';
import 'package:travel_tourism/core/theme/app_theme.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Payment Methods', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Cards',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
            ),
            const SizedBox(height: 16),
            _buildCreditCard(
              context,
              cardNumber: '**** **** **** 4242',
              expiryDate: '12/26',
              cardHolder: 'CHATHURA PERERA',
              cardType: 'Visa',
              color: const Color(0xFF1A1A1A),
            ),
            const SizedBox(height: 16),
            _buildCreditCard(
              context,
              cardNumber: '**** **** **** 8888',
              expiryDate: '10/25',
              cardHolder: 'CHATHURA PERERA',
              cardType: 'Mastercard',
              color: const Color(0xFF3B5998),
            ),
            const SizedBox(height: 32),
            _buildAddCardButton(context),
            const SizedBox(height: 32),
            Text(
              'Other Methods',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
            ),
            const SizedBox(height: 16),
            _buildPaymentOption(context, icon: Icons.account_balance_wallet_outlined, title: 'Apple Pay'),
            _buildPaymentOption(context, icon: Icons.account_balance_outlined, title: 'Bank Transfer'),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCard(BuildContext context, {
    required String cardNumber,
    required String expiryDate,
    required String cardHolder,
    required String cardType,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cardType,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
              const Icon(Icons.contactless, color: Colors.white, size: 30),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            cardNumber,
            style: const TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CARD HOLDER', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(cardHolder, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('EXPIRES', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(expiryDate, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddCardButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor, style: BorderStyle.solid),
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add_circle_outline, color: AppTheme.primaryColor),
        label: const Text('Add New Card', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, {required IconData icon, required String title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        onTap: () {},
      ),
    );
  }
}
