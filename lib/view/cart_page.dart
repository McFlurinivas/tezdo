import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezdo/controller/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: CartController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Cart'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => controller.goBackHome(),
            ),
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (controller.cartItems.isEmpty) {
              return const Center(
                child: Text('Your cart is empty'),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: controller.cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = controller.cartItems[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: cartItem.product.image ?? '',
                                  width: 100,
                                  height: 100,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartItem.product.title ?? 'No Title',
                                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '\$${(cartItem.product.price ?? 0.0).toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(color: Colors.green),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () => controller
                                                .decreaseQuantity(cartItem),
                                          ),
                                          Text(cartItem.quantity.toString()),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () => controller
                                                .increaseQuantity(cartItem),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => controller.removeItem(cartItem),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total: \$${controller.totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              );
            }
          }),
        );
      },
    );
  }
}
