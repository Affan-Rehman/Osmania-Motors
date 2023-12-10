import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/shared_components/image_slider.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/presentation/bloc/car_detail/car_detail_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class ImageSliderWidget extends StatelessWidget {
  const ImageSliderWidget({Key? key, required this.state}) : super(key: key);

  final LoadedCarDetailState state;

  @override
  Widget build(BuildContext context) {
    return state.loadedDetailCar.gallery.isNotEmpty
        ? CarouselSlider.builder(
            itemCount: state.loadedDetailCar.gallery.length,
            options: CarouselOptions(
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              viewportFraction: 1.0,
              autoPlay: false,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastLinearToSlowEaseIn,
              onPageChanged: (index, reason) {
                Provider.of<ImageSliderProvider>(context, listen: false).onPageViewChange(index);
              },
            ),
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => GestureDetector(
              onTap: () => _widgetOpenFullScreenImg(state, context),
              child: Stack(
                children: [
                  Image(
                    image: NetworkImage(
                      '${state.loadedDetailCar.gallery[itemIndex]!.url}',
                    ),
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width,
                  ),
                  //Price
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: mainColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          '${state.loadedDetailCar.price}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Index page
                  Positioned(
                    bottom: 0.5,
                    right: 0,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10, right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        boxShadow: [
                          BoxShadow(color: Colors.black38, blurRadius: .0),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 3, right: 10, bottom: 3),
                        child: Text(
                          '${Provider.of<ImageSliderProvider>(context).currentImgPage}/${state.loadedDetailCar.gallery.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Image(
            image: NetworkImage(state.loadedDetailCar.imgUrl),
          );
  }

  _widgetOpenFullScreenImg(LoadedCarDetailState state, context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ColoredBox(
              color: Colors.black,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, right: 5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Center(
                      child: Text(
                        '${Provider.of<ImageSliderProvider>(context).currentBottomSheetPage}/${state.loadedDetailCar.gallery.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  CarouselSlider.builder(
                    itemCount: state.loadedDetailCar.gallery.length,
                    itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                      return PhotoView(
                        imageProvider: NetworkImage(
                          '${state.loadedDetailCar.gallery[itemIndex]!.url}',
                        ),
                        minScale: 0.0,
                      );
                    },
                    options: CarouselOptions(
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      viewportFraction: 1,
                      height: MediaQuery.of(context).size.height / 1.3,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) => Provider.of<ImageSliderProvider>(context, listen: false).onPageViewChangeFullScreen(index),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() => Provider.of<ImageSliderProvider>(context, listen: false).currentBottomSheetPage = 1);
  }
}
