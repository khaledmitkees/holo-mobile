import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holo_mobile/design_system/components/primary_button.dart';
import 'package:holo_mobile/features/products/presentation/bloc/products_bloc.dart';
import 'package:holo_mobile/features/products/presentation/bloc/products_event.dart';
import 'package:holo_mobile/features/products/presentation/bloc/products_state.dart';
import 'package:holo_mobile/features/products/presentation/widgets/product_card.dart';
import 'package:holo_mobile/design_system/components/common_app_bar.dart';
import 'package:holo_mobile/design_system/components/error_widget.dart'
    as custom;

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(title: 'Holo', showBackButton: false),
      body: BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
          if (state is ProductsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          switch (state) {
            case ProductsLoading():
              return const Center(child: CircularProgressIndicator());
            case ProductsLoaded():
              return _buildContent(context, state);
            case ProductsError():
              return custom.ErrorWidget(
                title: 'Something went wrong',
                message: 'Failed to load products. Please try again.',
                onRetry:
                    () => context.read<ProductsBloc>().add(
                      const RefreshProducts(),
                    ),
                icon: Icons.error_outline,
              );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProductsLoaded state) {
    if (state.products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No products available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductsBloc>().add(const RefreshProducts());
      },
      child: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: state.products[index],
                onTap: () => _onProductTapped(context, state.products[index]),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                onPressed: () => _onViewCartPressed(context),
                text: 'View Cart',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onProductTapped(BuildContext context, dynamic product) {
    // TODO: Navigate to product details
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Product tapped: ${product.title}')));
  }

  void _onViewCartPressed(BuildContext context) {
    // TODO: Navigate to cart screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('View Cart pressed')));
  }
}
