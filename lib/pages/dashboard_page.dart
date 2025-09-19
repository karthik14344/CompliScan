// pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sih/models/product_models.dart';
import 'package:sih/widgets/productdetail_model.dart';
import '../widgets/stats_overview.dart';
import '../widgets/product_table.dart';
import '../services/compliance_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  String selectedFilter = 'All';
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadSampleData() {
    // Sample data for demonstration
    products = ComplianceService.getSampleProducts();
    filteredProducts = products;
  }

  void _filterProducts(String filter) {
    setState(() {
      selectedFilter = filter;
      switch (filter) {
        case 'Compliant':
          filteredProducts = products.where((p) => p.isCompliant).toList();
          break;
        case 'Non-Compliant':
          filteredProducts = products.where((p) => !p.isCompliant).toList();
          break;
        default:
          filteredProducts = products;
      }
    });
  }

  void _showProductDetail(Product product) {
    showDialog(
      context: context,
      builder: (context) => ProductDetailModal(product: product),
    );
  }

  void _exportToCsv() {
    // CSV export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting compliance report...')),
    );
  }

  void _runComplianceCheck() {
    setState(() {
      isLoading = true;
    });

    // Simulate processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compliance check completed!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.verified_user,
                  color: Colors.black, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('CompliScan Dashboard'),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home, color: Colors.white),
            label: const Text('Home', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        trackVisibility: true,
        thickness: 12,
        radius: const Radius.circular(6),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Overview
              StatsOverview(products: products),

              const SizedBox(height: 24),

              // Controls
              Row(
                children: [
                  const Text(
                    'Product Compliance Report',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _runComplianceCheck,
                    icon: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.play_arrow),
                    label: Text(isLoading ? 'Processing...' : 'Run Check'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _exportToCsv,
                    icon: const Icon(Icons.download),
                    label: const Text('Export CSV'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text('Filter: '),
                    const SizedBox(width: 12),
                    FilterChip(
                      label: const Text('All'),
                      selected: selectedFilter == 'All',
                      onSelected: (_) => _filterProducts('All'),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Compliant'),
                      selected: selectedFilter == 'Compliant',
                      onSelected: (_) => _filterProducts('Compliant'),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Non-Compliant'),
                      selected: selectedFilter == 'Non-Compliant',
                      onSelected: (_) => _filterProducts('Non-Compliant'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Product Table - with minimum height constraint
              SizedBox(
                height: MediaQuery.of(context).size.height -
                    400, // Adjust based on other content
                child: ProductTable(
                  products: filteredProducts,
                  onProductTap: _showProductDetail,
                ),
              ),

              // Add some bottom padding for better scrolling experience
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
