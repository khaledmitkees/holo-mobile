import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:holo_mobile/design_system/components/common_app_bar.dart';
import 'package:holo_mobile/design_system/components/primary_button.dart';
import 'package:holo_mobile/design_system/components/loading_overlay.dart';
import 'package:holo_mobile/design_system/components/error_widget.dart'
    as design_system;
import 'package:holo_mobile/features/products/presentation/bloc/product_details_bloc.dart';
import 'package:holo_mobile/features/products/presentation/bloc/product_details_event.dart';
import 'package:holo_mobile/features/products/presentation/bloc/product_details_state.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: 'Product Details',
        showBackButton: true,
      ),
      body: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
        listener: (context, state) {
          if (state is ProductAddedToCart) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.product.title} added to cart!'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is AddToCartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to add to cart: ${state.message}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        buildWhen:
            (previous, current) =>
                current is! AddToCartError || current is! ProductAddedToCart,
        builder: (context, state) {
          switch (state) {
            case ProductDetailsLoading():
              return const Center(child: CircularProgressIndicator());
            case ProductDetailsLoaded():
              final product = state.product;
              final isLoading = state.isLoading;
              return LoadingOverlay(
                isLoading: isLoading,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            Center(
                              child: Container(
                                height: 300,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: product.image,
                                    fit: BoxFit.contain,
                                    placeholder:
                                        (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    errorWidget:
                                        (context, url, error) => const Center(
                                          child: Icon(
                                            Icons.error,
                                            color: Colors.grey,
                                            size: 50,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Product Title
                            Text(
                              product.title,
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Category
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                product.category.toUpperCase(),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Price and Rating Row
                            Row(
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const Spacer(),
                                if (product.rating != null) ...[
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber[600],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product.rating!.rate} (${product.rating!.count})',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Description
                            Text(
                              'Description',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              product.description,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[700],
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 100), // Space for button
                          ],
                        ),
                      ),
                    ),

                    // Add to Cart Button (Fixed at bottom)
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            text: 'Add to Cart',
                            onPressed: () {
                              context.read<ProductDetailsBloc>().add(
                                AddProductToCart(productId: product.id),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );

            case ProductDetailsError():
              return Center(
                child: design_system.ErrorWidget(
                  title: 'Error Loading Product',
                  message: state.message,
                  onRetry: () {
                    context.read<ProductDetailsBloc>().add(
                      LoadProductDetails(productId),
                    );
                  },
                ),
              );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
