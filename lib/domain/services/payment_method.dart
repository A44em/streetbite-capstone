/// Strategy/interface segregation: payment implementations can be replaced independently.
abstract class PaymentMethod {
  String get code;
  Future<bool> authorize(double amount);
}

class CashPayment implements PaymentMethod {
  @override
  String get code => 'cash';
  @override
  Future<bool> authorize(double amount) async => amount > 0;
}

/// Demo only; does not collect or transmit card details.
class DemoCardPayment implements PaymentMethod {
  @override
  String get code => 'card_demo';
  @override
  Future<bool> authorize(double amount) async => amount > 0;
}
