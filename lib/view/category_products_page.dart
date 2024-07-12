import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezdo/controller/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tezdo/model/products.dart';

class CategoryProductsPage extends StatelessWidget {
  final String category;

  const CategoryProductsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Obx(() {
        final filteredProducts = controller.products
            .where((product) => product.category == category)
            .toList();

        return filteredProducts.isEmpty
            ? const Center(child: Text('No products available'))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return _buildProductCard(product, controller, context);
                  },
                ),
              );
      }),
    );
  }

  Widget _buildProductCard(Product product, HomeController controller, BuildContext context) {
    return GestureDetector(
      onTap: () => controller.goToDetailProduct(product.id.toString(), product),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: product.image ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.title ?? '',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                '\$${product.price}',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
