import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezdo/controller/home_controller.dart';
import 'package:tezdo/view/favorites.dart';
import 'package:tezdo/view/profile_page.dart';
import 'package:tezdo/widget/home/skeletal_loader.dart';
import '../model/products.dart';
import '../widget/home/carousel_with_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Image.asset(
              'assets/images/logo.png',
              width: 50,
              height: 50,
            ),
          ),
          drawer: Drawer(
            child: Column(
              children: [
                ListTile(
                  onTap: () => controller.onCloseSession(),
                  title: const Column(
                    children: [
                      SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Log Out'),
                          Icon(Icons.logout_outlined),
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () { 
                    Navigator.pop(context);
                    Get.to(() => const FavoritesPage());
                  },
                  title: const Row(
                    children: [
                      Icon(Icons.favorite),
                      SizedBox(width: 10),
                      Text('Favorites'),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () { 
                    Navigator.pop(context);
                    Get.to(() => const ProfilePage());
                  },
                  title: const Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Text('Profile'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Obx(() {
            return controller.isLoading
                ? const SkeletonLoader()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Deals', style: Theme.of(context).textTheme.bodyLarge),
                          CarouselWithIndicator(
                            imgList: controller.products.take(5).map((product) {
                              return {
                                'url': product.image!,
                                'description': product.title!,
                                'id': product.id.toString(),
                              };
                            }).toList(),
                            currentIndex: controller.carouselIndex,
                            onPageChanged: (index) => controller.onPageChanged(index),
                          ),
                          const SizedBox(height: 20),
                          Text('Categories', style: Theme.of(context).textTheme.bodyLarge),
                          _buildCategoriesList(controller.categories, controller),
                          const SizedBox(height: 20),
                          Text(
                            'Trending Products',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          _buildTrendingProductsList(
                            controller.products.skip(5).take(5).toList(),
                            controller,
                          ),
                        ],
                      ),
                    ),
                  );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.toNamed('/cart');
            },
            child: const Icon(Icons.shopping_cart_rounded),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesList(List<String> categories, HomeController controller) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () => controller.onCategorySelected(categories[index]),
              child: Chip(
                label: Text(
                  categories[index],
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.grey[300],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendingProductsList(List<Product> trendingProducts, HomeController controller) {
    return SizedBox(
      height: 240, 
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
        itemCount: trendingProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildProductCard(trendingProducts[index], context, controller);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product, BuildContext context, HomeController controller) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => controller.goToDetailProduct(product.id.toString(), product),
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
                  placeholder: (context, url) => const CircularProgressIndicator(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '\$${product.price}',
                      style: Theme.of(context).textTheme.displaySmall,
                      textAlign: TextAlign.center, 
                    ),
                    IconButton(
                      icon: Icon(
                        controller.isFavorite(product) ? Icons.favorite : Icons.favorite_border,
                        color: controller.isFavorite(product) ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => controller.toggleFavorite(product),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
