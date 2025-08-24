import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:holo_mobile/design_system/components/common_app_bar.dart';
import 'package:holo_mobile/design_system/components/primary_button.dart';
import 'package:holo_mobile/design_system/components/loading_overlay.dart';
import 'package:holo_mobile/design_system/components/error_widget.dart'
    as design_system;
import 'package:holo_mobile/features/products/domain/entities/product.dart';
import 'package:holo_mobile/features/carts/domain/entities/cart_product.dart';
import 'package:holo_mobile/features/carts/presentation/bloc/cart_bloc.dart';
import 'package:holo_mobile/features/carts/presentation/bloc/cart_event.dart';
import 'package:holo_mobile/features/carts/presentation/bloc/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const CommonAppBar(title: 'Cart'),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartLoaded && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<CartBloc>().add(const ClearCartError());
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            CartInitial() => const SizedBox.shrink(),
            CartLoading() => const Center(child: CircularProgressIndicator()),
            CartEmpty() => const _EmptyCartView(),
            CartLoaded() => LoadingOverlay(
              isLoading: state.isUpdating,
              child: _CartContentView(
                cart: state.cart!,
                products: state.products,
                total: state.total,
              ),
            ),
            CartError() => Center(
              child: design_system.ErrorWidget(
                title: 'Error Loading Cart',
                message: state.message,
                onRetry: () {
                  context.read<CartBloc>().add(const LoadCart());
                },
              ),
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 120,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              'Your Cart is Empty',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add some products to get started',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Start Shopping',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CartContentView extends StatelessWidget {
  final dynamic cart;
  final List<Product> products;
  final double total;

  const _CartContentView({
    required this.cart,
    required this.products,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final product = products[index];
              final cartProduct = cart.products.firstWhere(
                (cp) => cp.productId == product.id,
              );
              return _CartItemCard(product: product, cartProduct: cartProduct);
            },
          ),
        ),
        _CartSummary(total: total),
      ],
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final Product product;
  final CartProduct cartProduct;

  const _CartItemCard({required this.product, required this.cartProduct});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.contain,
                    placeholder:
                        (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                    errorWidget:
                        (context, url, error) => const Center(
                          child: Icon(Icons.error, color: Colors.grey),
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Quantity Controls positioned at bottom right
          Positioned(
            bottom: 0,
            right: 0,
            child: Row(
              children: [
                _QuantityButton(
                  icon: Icons.remove,
                  onPressed: () {
                    context.read<CartBloc>().add(
                      UpdateCartItemQuantity(
                        productId: product.id,
                        quantity: cartProduct.quantity - 1,
                      ),
                    );
                  },
                ),
                Container(
                  width: 40,
                  height: 32,
                  alignment: Alignment.center,
                  child: Text(
                    '${cartProduct.quantity}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _QuantityButton(
                  icon: Icons.add,
                  onPressed: () {
                    context.read<CartBloc>().add(
                      UpdateCartItemQuantity(
                        productId: product.id,
                        quantity: cartProduct.quantity + 1,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuantityButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onPressed != null ? Colors.black : Colors.grey[300],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onPressed != null ? Colors.white : Colors.grey[500],
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final double total;

  const _CartSummary({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    text: 'Checkout',
                    onPressed: () {
                      // TODO: Implement checkout functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Checkout functionality coming soon!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
