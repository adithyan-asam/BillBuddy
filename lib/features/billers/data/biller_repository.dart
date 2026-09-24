import 'package:billbuddy/features/billers/domain/biller.dart';

class BillerRepository {
  Future<List<Biller>> getBillers() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );

    return const [
      Biller(
        id: 'electricity_001',
        name: 'Maharashtra Electricity Board',
        category: BillerCategory.electricity,
        state: 'Maharashtra',
        fields: [
          BillerField(
            key: 'consumerNumber',
            label: 'Consumer Number',
            regex: r'^\d{10}$',
          ),
        ],
        allowsPartial: true,
      ),
      Biller(
        id: 'water_001',
        name: 'Mumbai Water Supply',
        category: BillerCategory.water,
        state: 'Maharashtra',
        fields: [
          BillerField(
            key: 'consumerNumber',
            label: 'Consumer Number',
            regex: r'^\d{8}$',
          ),
        ],
        allowsPartial: false,
      ),
      Biller(
        id: 'gas_001',
        name: 'Mahanagar Gas',
        category: BillerCategory.gas,
        state: 'Maharashtra',
        fields: [
          BillerField(
            key: 'customerNumber',
            label: 'Customer Number',
            regex: r'^\d{10}$',
          ),
        ],
        allowsPartial: false,
      ),
      Biller(
        id: 'broadband_001',
        name: 'JioFiber',
        category: BillerCategory.broadband,
        state: 'All India',
        fields: [
          BillerField(
            key: 'accountNumber',
            label: 'Account Number',
            regex: r'^\d{10}$',
          ),
        ],
        allowsPartial: true,
      ),
      Biller(
        id: 'mobile_001',
        name: 'Airtel',
        category: BillerCategory.mobile,
        state: 'All India',
        fields: [
          BillerField(
            key: 'mobileNumber',
            label: 'Mobile Number',
            regex: r'^[6-9]\d{9}$',
          ),
        ],
        allowsPartial: false,
      ),
      Biller(
        id: 'dth_001',
        name: 'Tata Play',
        category: BillerCategory.dth,
        state: 'All India',
        fields: [
          BillerField(
            key: 'subscriberId',
            label: 'Subscriber ID',
            regex: r'^\d{10}$',
          ),
        ],
        allowsPartial: false,
      ),
      Biller(
        id: 'credit_card_001',
        name: 'ICICI Credit Card',
        category: BillerCategory.creditCard,
        state: 'All India',
        fields: [
          BillerField(
            key: 'cardNumber',
            label: 'Card Number',
            regex: r'^\d{16}$',
          ),
        ],
        allowsPartial: true,
      ),
    ];
  }
}