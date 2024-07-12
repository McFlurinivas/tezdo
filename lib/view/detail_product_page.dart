import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezdo/controller/detail_product_controller.dart';
import 'package:tezdo/model/colors.dart';
import 'package:tezdo/model/l10n.dart';
import 'package:tezdo/view/ui/circular_progress.dart';
import 'package:tezdo/view/ui/fs_ratings.dart';

class DetailProductPage extends StatelessWidget {
  const DetailProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailProductController>(
      init: DetailProductController(),
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      top: 280,
                      left: 10,
                      right: 10,
                      child: SingleChildScrollView(
                        physics: const ScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              _.product.title!,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context)!.price,
                                  style: Theme.of(context).textTheme.displaySmall,
                                ),
                                Text(
                                  '\$ ${_.product.price.toString()}',
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context)!.ratings,
                                  style: Theme.of(context).textTheme.displaySmall,
                                ),
                                FSRating(
                                  rating: _.product.rating!.rate!,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context)!.votes,
                                  style: Theme.of(context).textTheme.displaySmall,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${_.product.rating!.count}',
                                      style: Theme.of(context).textTheme.displayMedium,
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(Icons.thumb_up_alt_outlined),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: OutlinedButton(
                                onPressed: () => _.addToCart(),
                                child: Text(
                                  S.of(context)!.buy,
                                  style: const TextStyle().copyWith(
                                    color: FSColors.purple,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Description',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _.product.description!,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      height: 270,
                      decoration: BoxDecoration(
                        color: FSColors.cardColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () => _.goBackHome(),
                              icon: const Icon(
                                Icons.keyboard_arrow_left_outlined,
                                size: 40,
                              ),
                            ),
                          ),
                          CachedNetworkImage(
                            width: double.maxFinite,
                            height: 160.0,
                            fit: BoxFit.scaleDown,
                            imageUrl: _.product.image!,
                            placeholder: (context, url) => const SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgress(
                                width: 10,
                                height: 10,
                              ),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/sinimagen.png',
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List<Widget>.from(
                              [
                                IconButton(
                                  onPressed: () => _.toggleFavorite(),
                                  icon: Icon(
                                    _.isFavorite()
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                    color: _.isFavorite()
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _showFullScreenImage(context, _.product.image!),
                                  icon: const Icon(Icons.fullscreen, size: 30, color: Colors.black),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: 'Share',
                                      content: const Column(
                                        children: [
                                          Text('Share this product with your friends'),
                                          SizedBox(height: 20),
                                          Text('https://tezdo.com/product/1'),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                  icon: const Icon(Icons.share),
                                  iconSize: 25,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16.0),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/sinimagen.png',
          ),
        ),
      ),
    );
  }
}
