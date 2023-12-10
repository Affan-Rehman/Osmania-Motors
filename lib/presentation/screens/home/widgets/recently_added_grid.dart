import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/main_page/main_page.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';

class RecentlyAddedGrid extends StatelessWidget {
  const RecentlyAddedGrid({Key? key, required this.mainPage}) : super(key: key);

  final MainPage mainPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 15.0, right: 20, bottom: 15, left: 20),
          child: Text(
            translations?['recently_added'] ?? 'RECENTLY ADDED',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff424141),
            ),
          ),
        ),
        const Divider(
          endIndent: 20,
          indent: 20,
          thickness: 0.5,
          color: Colors.black,
        ),
        for (var el in mainPage.recent)
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetailScreen(
                  idCar: el!.ID,
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.only(
                top: 7,
                bottom: 7,
                left: 15,
                right: 15,
              ),
              width: MediaQuery.of(context).size.width,
              color: const Color(0xffF3F3F3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: CachedNetworkImage(
                          height: 170,
                          width: double.infinity,
                          imageUrl: '${el!.imgUrl}',
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.15),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(right: 8, top: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                IconsMotors.addPhoto,
                                size: 15,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${el.gallery.length}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Price
                        ColoredBox(
                          color: mainColor,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                              top: 15,
                              bottom: 15,
                            ),
                            child: Text(
                              softWrap: false,
                              '${el.price}',
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      el.grid['subTitle'] ?? 'No info',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      el.grid['title'].toString().length > 20
                                          ? '${el.grid['title'].toString().substring(0, 20)}...'
                                          : el.grid['title'] ?? '',
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  //width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Icon(
                                          dictionaryIcons[el.grid['infoIcon']],
                                          size: 15,
                                          color: mainColor,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      //Text
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                softWrap: false,
                                                '${el.grid['infoTitle']}' ?? '',
                                                overflow: TextOverflow.fade,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: grey1,
                                                ),
                                              ),
                                              Text(
                                                softWrap: false,
                                                '${el.grid['infoDesc']}' ?? '',
                                                overflow: TextOverflow.fade,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
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
      ],
    );
  }
}
