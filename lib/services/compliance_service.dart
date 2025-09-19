import 'package:sih/models/product_models.dart';

class ComplianceService {
  static List<Product> getSampleProducts() {
    return [
      Product(
        id: 'P001',
        title: 'Organic Basmati Rice 1kg',
        imageUrl: '',
        mrp: '₹299.00',
        netQuantity: '1 kg',
        countryOfOrigin: 'India',
        manufacturer: 'ABC Foods Pvt Ltd, Delhi',
        mfgDate: '02/2024',
        complianceScore: 100,
        violations: [],
        ocrText:
            'ORGANIC BASMATI RICE\nNet Qty: 1 kg\nMRP: ₹299.00\nManufactured by: ABC Foods Pvt Ltd, Delhi\nCountry of Origin: India\nMfg Date: 02/2024',
      ),
      Product(
        id: 'P002',
        title: 'Premium Tea Leaves 250g',
        imageUrl: '',
        mrp: '',
        netQuantity: '250g',
        countryOfOrigin: 'India',
        manufacturer: 'XYZ Tea Company',
        mfgDate: '01/2024',
        complianceScore: 75,
        violations: ['Missing MRP'],
        ocrText:
            'PREMIUM TEA LEAVES\nNet Weight: 250g\nManufactured by: XYZ Tea Company\nCountry of Origin: India\nMfg: 01/2024',
      ),
      Product(
        id: 'P003',
        title: 'Coconut Oil 500ml',
        imageUrl: '',
        mrp: '₹450.00',
        netQuantity: '500',
        countryOfOrigin: '',
        manufacturer: 'Kerala Oils Ltd',
        mfgDate: '03/2024',
        complianceScore: 50,
        violations: ['Missing unit in quantity', 'Missing Country of Origin'],
        ocrText:
            'PURE COCONUT OIL\nQuantity: 500\nMRP: ₹450.00\nManufactured by: Kerala Oils Ltd\nMfg Date: 03/2024',
      ),
      Product(
        id: 'P004',
        title: 'Wheat Flour 5kg',
        imageUrl: '',
        mrp: '₹180.00',
        netQuantity: '5 kg',
        countryOfOrigin: 'India',
        manufacturer: 'Flour Mills India',
        mfgDate: '02/2024',
        complianceScore: 100,
        violations: [],
        ocrText:
            'WHEAT FLOUR\nNet Qty: 5 kg\nMRP: ₹180.00\nManufactured by: Flour Mills India\nCountry of Origin: India\nMfg Date: 02/2024',
      ),
      Product(
        id: 'P005',
        title: 'Imported Olive Oil',
        imageUrl: '',
        mrp: '₹899.00',
        netQuantity: '',
        countryOfOrigin: 'Spain',
        manufacturer: 'Mediterranean Foods',
        mfgDate: '',
        complianceScore: 25,
        violations: ['Missing Net Quantity', 'Missing Manufacturing Date'],
        ocrText:
            'EXTRA VIRGIN OLIVE OIL\nMRP: ₹899.00\nManufactured by: Mediterranean Foods\nCountry of Origin: Spain',
      ),
      Product(
        id: 'P006',
        title: 'Organic Honey 250g',
        imageUrl: '',
        mrp: '₹350.00',
        netQuantity: '250 g',
        countryOfOrigin: 'India',
        manufacturer: 'Bee Natural Products',
        mfgDate: '01/2024',
        complianceScore: 100,
        violations: [],
        ocrText:
            'ORGANIC HONEY\nNet Weight: 250 g\nMRP: ₹350.00\nManufactured by: Bee Natural Products\nCountry of Origin: India\nMfg Date: 01/2024',
      ),
    ];
  }
}
