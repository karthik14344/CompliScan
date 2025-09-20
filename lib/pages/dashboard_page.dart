// pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sih/models/product_models.dart';
import 'package:sih/services/mongo_service.dart';
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
  bool isConnected = false;
  final ScrollController _scrollController = ScrollController();
  String? errorMessage;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkConnectionAndLoadData();
  }

  Future<void> _checkConnectionAndLoadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // First check if the API is healthy
      final healthy = await MongoService.isHealthy();

      if (healthy) {
        setState(() {
          isConnected = true;
        });
        await _loadProductData();
      } else {
        setState(() {
          isConnected = false;
          errorMessage = 'Cannot connect to API server. Using sample data.';
        });
        _loadSampleData();
      }
    } catch (e) {
      setState(() {
        isConnected = false;
        errorMessage = 'Connection failed: ${e.toString()}';
      });
      _loadSampleData();
    }
  }

  void _loadSampleData() {
    setState(() {
      products = ComplianceService.getSampleProducts();
      filteredProducts = products;
      isLoading = false;
    });
  }

  Future<void> _loadProductData() async {
    try {
      final fetchedProducts =
          await ComplianceService.fetchProductsFromMongoDB();

      setState(() {
        products = fetchedProducts;
        filteredProducts = products;
        isLoading = false;
        errorMessage = null;
      });

      if (products.isEmpty) {
        _showSnackBar('No products found in database', Colors.orange);
      } else {
        print('Loaded ${products.length} products successfully');
      }
    } catch (e) {
      print('Error loading products: $e');

      setState(() {
        errorMessage = 'Failed to load from API: ${e.toString()}';
        isLoading = false;
      });

      // Fallback to sample data
      _loadSampleData();
      _showSnackBar(
        'API connection failed, using sample data: ${e.toString()}',
        Colors.orange,
      );
    }
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
    // TODO: Implement CSV export functionality
    _showSnackBar('CSV export feature coming soon...', Colors.blue);
  }

  Future<void> _runComplianceCheck() async {
    if (!isConnected) {
      _showSnackBar(
          'Cannot run compliance check: API not connected', Colors.red);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      int successCount = 0;
      int failCount = 0;

      for (final product in products) {
        try {
          final success = await MongoService.runComplianceCheck(product.id);
          if (success) {
            successCount++;
          } else {
            failCount++;
          }
        } catch (e) {
          failCount++;
          print('Failed to check product ${product.id}: $e');
        }
      }

      // Reload data to get updated compliance results
      await _loadProductData();

      _showSnackBar(
        'Compliance check completed! Success: $successCount, Failed: $failCount',
        Colors.green,
      );
    } catch (e) {
      _showSnackBar(
        'Compliance check failed: ${e.toString()}',
        Colors.red,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _checkConnectionAndLoadData();
  }

  void _clearAllData() async {
    if (!isConnected) {
      _showSnackBar('Cannot clear data: API not connected', Colors.red);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to delete all products from MongoDB? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              setState(() {
                isLoading = true;
              });

              try {
                final success = await MongoService.clearAllData();

                if (success) {
                  setState(() {
                    products = [];
                    filteredProducts = [];
                    isLoading = false;
                  });
                  _showSnackBar('All data cleared successfully!', Colors.green);
                } else {
                  _showSnackBar('Failed to clear data', Colors.red);
                }
              } catch (e) {
                _showSnackBar(
                    'Error clearing data: ${e.toString()}', Colors.red);
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                const Text('Delete All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
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
              // Connection Status Banner
              if (errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isConnected
                        ? Colors.orange.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isConnected ? Colors.orange : Colors.red,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isConnected ? Icons.warning : Icons.error,
                        color: isConnected ? Colors.orange : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(errorMessage!)),
                      if (!isConnected)
                        TextButton(
                          onPressed: _refreshData,
                          child: const Text('Retry'),
                        ),
                    ],
                  ),
                ),

              // Stats Overview
              StatsOverview(products: products),

              const SizedBox(height: 24),

              // Controls Header
              Row(
                children: [
                  const Text(
                    'Product Compliance Report',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isConnected
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isConnected ? Colors.green : Colors.red,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isConnected ? Icons.cloud_done : Icons.cloud_off,
                          color: isConnected ? Colors.green : Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isConnected ? 'MongoDB Connected' : 'Offline Mode',
                          style: TextStyle(
                            color: isConnected ? Colors.green : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Menu Button
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    enabled: isConnected,
                    onSelected: (value) {
                      switch (value) {
                        case 'clear':
                          _clearAllData();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'clear',
                        child: Row(
                          children: [
                            Icon(Icons.delete_forever, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Clear All Data'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Refresh Button
                  IconButton(
                    onPressed: isLoading ? null : _refreshData,
                    icon: Icon(
                      Icons.refresh,
                      color: isLoading ? Colors.grey : Colors.black,
                    ),
                    tooltip: isConnected
                        ? 'Refresh from MongoDB'
                        : 'Retry connection',
                  ),
                  const SizedBox(width: 8),

                  // Run Compliance Check Button
                  // ElevatedButton.icon(
                  //   onPressed: (isLoading || !isConnected)
                  //       ? null
                  //       : _runComplianceCheck,
                  //   icon: isLoading
                  //       ? const SizedBox(
                  //           width: 16,
                  //           height: 16,
                  //           child: CircularProgressIndicator(strokeWidth: 2),
                  //         )
                  //       : const Icon(Icons.play_arrow),
                  //   label: Text(isLoading ? 'Processing...' : 'Run Check'),
                  // ),
                  // const SizedBox(width: 12),

                  // Export CSV Button
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

              // Product Table or Loading Indicator
              if (isLoading && products.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(50),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading products...'),
                      ],
                    ),
                  ),
                )
              else if (products.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Column(
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (isConnected)
                          ElevatedButton(
                            onPressed: _refreshData,
                            child: const Text('Refresh'),
                          ),
                      ],
                    ),
                  ),
                )
              else
                SizedBox(
                  height: MediaQuery.of(context).size.height - 400,
                  child: ProductTable(
                    products: filteredProducts,
                    onProductTap: _showProductDetail,
                  ),
                ),

              // Bottom padding for better scrolling experience
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
