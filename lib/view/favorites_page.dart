import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezdo/controller/home_controller.dart';
import 'package:tezdo/model/products.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Obx(() {
        return controller.favorites.isEmpty
            ? const Center(child: Text('No favorites added'))
            : ListView.builder(
                itemCount: controller.favorites.length,
                itemBuilder: (context, index) {
                  final product = controller.favorites[index];
                  return _buildProductCard(product, context, controller);
                },
              );
      }),
    );
  }

  Widget _buildProductCard(
      Product product, BuildContext context, HomeController controller) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () =>
            controller.goToDetailProduct(product.id.toString(), product),
        child: SizedBox(
          width: 250,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  height: 100,
                  fit: BoxFit.cover,
                  imageUrl: product.image!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(height: 10),
                Text(
                  product.title!,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${product.price}',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
