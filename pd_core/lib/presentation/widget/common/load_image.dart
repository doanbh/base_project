import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../resource/resource.dart';
import '../../../utils/utils.dart';

class LoadImage extends StatelessWidget {
  
  LoadImage(this.image, {
    Key? key,
    this.width, 
    this.height,
    this.fit = BoxFit.cover, 
    this.format = ImageFormat.png,
    this.holderImg,
    this.cacheWidth,
    this.cacheHeight,
    this.typeImage,
  }) : super(key: key){
    if (typeImage == TypeImage.Product){
      this.holderImg = ImageConstant.ic_place_holder_product;
    } else if (typeImage == TypeImage.Basic){
      this.holderImg = ImageConstant.ic_place_holder_basic;
    } else {
      this.holderImg = ImageConstant.ic_user;
    }
  }
  
  String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ImageFormat format;
  late String? holderImg;
  final int? cacheWidth;
  final int? cacheHeight;
  final TypeImage? typeImage;

  @override
  Widget build(BuildContext context) {

    if (image.isEmpty || image.startsWith('http') || '.'.allMatches(image).length >= 3) {
      // neu ko bat dau bang http thi tu them
      if (!image.startsWith('http')){
        image = 'https:' + image;
      }
      // print(image);
      final Widget holder = LoadAssetImage(holderImg!, height: height, width: width, fit: fit);
      return CachedNetworkImage(
        imageUrl: image,
        // placeholder: (_, __) => holder,
        errorWidget: (_, __, dynamic error) => holder,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: cacheWidth,
        memCacheHeight: cacheHeight,
        // progressIndicatorBuilder: (context, url, downloadProgress) =>
        //     CircularProgressIndicator(value: downloadProgress.progress),
        progressIndicatorBuilder: (context, _, __) =>
            ShimmerLoading(dimension: double.infinity),
      );
    } else {
      return LoadAssetImage(image,
        height: height,
        width: width,
        fit: fit,
        format: format,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      );
    }
  }
}

class LoadAssetImage extends StatelessWidget {
  
  const LoadAssetImage(this.image, {
    Key? key,
    this.width,
    this.height, 
    this.cacheWidth,
    this.cacheHeight,
    this.fit,
    this.format = ImageFormat.png,
    this.color
  }): super(key: key);

  final String image;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BoxFit? fit;
  final ImageFormat format;
  final Color? color;
  
  @override
  Widget build(BuildContext context) {
    // print(image);
    return Image.asset(
      image,
      height: height,
      width: width,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      fit: fit,
      color: color,
      excludeFromSemantics: true,
      errorBuilder: (_, err, ___) {
        print("load assets err: ${err.toString()}");
        return const SizedBox();
      },
    );
  }
}

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    Key? key,
    this.dimension,
    this.boxDecoration,
    this.size,
  }) : super(key: key);

  final double? dimension;
  final Size? size;
  final BoxDecoration? boxDecoration;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  get shimmerGradient => LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.6,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
    transform:
    _SlidingGradientTransform(slidePercent: _shimmerController.value),
  );

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000))
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.values[5],
      shaderCallback: (bounds) => shimmerGradient.createShader(bounds),
      child: Container(
        height: widget.size?.height ?? widget.dimension,
        width: widget.size?.width ?? widget.dimension,
        decoration: widget.boxDecoration?.copyWith(
          color: Colors.white,
        ),
        color: widget.boxDecoration == null ? Colors.white : null,
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

enum TypeImage {
  Product,
  Profile,
  Basic,
}
