// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import firestore cloud
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/data/models/blogs/blog.dart';
import 'package:motors_app/data/models/buyer_requests/buy_request.dart';
import 'package:motors_app/presentation/bloc/home/home_bloc.dart';
import 'package:motors_app/presentation/bloc/home/home_state.dart';
import 'package:motors_app/presentation/screens/buy_requests/buy_requests_screen.dart';
import 'package:motors_app/presentation/screens/home/widgets/expandable_text.dart';
import 'package:motors_app/presentation/screens/home/widgets/lowToHigh.dart';
import 'package:motors_app/presentation/screens/home/widgets/near_you_list.dart';
import 'package:motors_app/presentation/screens/home/widgets/recently_added_grid.dart';
import 'package:motors_app/presentation/screens/home/widgets/recently_added_list.dart';
import 'package:motors_app/presentation/screens/home/widgets/recommended_card.dart';
import 'package:motors_app/presentation/screens/home/widgets/video_player.dart';
import 'package:motors_app/presentation/screens/search/new_search_page.dart';
import 'package:motors_app/presentation/widgets/search/search_suggestions.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({this.onRemove, Key? key}) : super(key: key);
  Function(List, int)? onRemove;
  static const String routeName = '/home_screen';

  // searchController
  final TextEditingController searchController = TextEditingController();
  final PageController pageController = PageController();
  final ScrollController scrollController = ScrollController();

  apptracint() async {
    await AppTrackingTransparency.requestTrackingAuthorization();
    fetchBlogPosts();
  }

  @override
  Widget build(BuildContext context) {
    apptracint();

    print('height ${MediaQuery.of(context).size.height}');
    print('width ${MediaQuery.of(context).size.width}');
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        flexibleSpace: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                elevation: 0,
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () async {
                    final selected = await showSearch<String>(
                      context: context,
                      delegate: CustomSearchDelegate(),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          LineIcons.moon,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.18,
                        ),
                        Center(
                          child: Text(
                            'Search Your Dream Car..',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: state is LoadedHomeState,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text(
                              translations?['top_brands'] ?? 'Top Brands',
                              style: GoogleFonts.montserrat(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      // Top Brands
                      SizedBox(
                        height: 100,
                        child: state is! LoadedHomeState
                            ? Center(
                                child: LoadingAnimationWidget.bouncingBall(
                                  color: red,
                                  size: 20,
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.brands?.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            log(
                                              'brand: ${state.brands![index].label}',
                                            );
                                            return SearchPage(
                                              query: state.brands![index].label,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(8),
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            state.brands != null
                                                ? state.brands![index].logo
                                                : '',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),

                      // cool banner with text "Find Vehicle In"
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(
                                'Find Vehicle In',
                                style: GoogleFonts.montserrat(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                          Align(
                            child: Center(child: CityListWidget()),
                          ),
                          // SizedBox(
                          //   height: 50,
                          // ),
                          // Card containg text "Osmania Specials" on the center
                          SizedBox(
                            height: 75,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Osmania Specials',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                          // carousel banner for ads with images with indicator
                          // at the bottom
                          StreamBuilder<List<dynamic>>(
                            stream: getAdsUrls,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text(
                                    'Something went wrong',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                return CarouselSlider.builder(
                                  options: CarouselOptions(
                                    scrollDirection: Axis.horizontal,
                                    autoPlay: true,
                                    // aspectRatio: 2.0,
                                    viewportFraction: 1,
                                    height: 130.0,
                                    enlargeCenterPage: true,
                                  ),
                                  // shrinkWrap: true,
                                  // physics:
                                  //     const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index, i) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data![index],
                                            fit: BoxFit.fill,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                              return Center(
                                child: LoadingAnimationWidget.bouncingBall(
                                  color: red,
                                  size: 20,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is InitialHomeState) {
                        return const LoaderWidget();
                      }

                      if (state is LoadedHomeState) {
                        return Column(
                          // shrinkWrap: true,
                          // physics: BouncingScrollPhysics(),
                          children: [
                            // Recommended Card
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: RecommendedCard(
                                mainPage: state.mainPage.featured,
                              ),
                            ),
                            // Recently Added
                            RecentlyAddedList(mainPage: state.mainPage),
                            //low to high
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: LowToHigh(
                                mainPage: state.mainPage,
                              ),
                            ),
                            //near you
                            if (state.mainPage.viewType == 'main_ra_grid_view')
                              RecentlyAddedGrid(mainPage: state.mainPage)
                            else
                              NearYouList(
                                mainPage: state.mainPage,
                              ),

                            Column(
                              children: [
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        "Buyer Requests",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(),
                                //ads
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 8,
                                  ),
                                  child: StreamBuilder<List<BuyRequest>>(
                                    stream: getBuyRequests(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const Center(
                                          child: Text(
                                            'Something went wrong',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Montserrat',
                                            ),
                                          ),
                                        );
                                      } else if (snapshot.hasData) {
                                        return CarouselSlider.builder(
                                          options: CarouselOptions(
                                            autoPlay: true,
                                            // aspectRatio: 2.0,
                                            viewportFraction: 1,
                                            height: 400.0,
                                            enlargeCenterPage: true,
                                          ),
                                          // shrinkWrap: true,
                                          // physics:
                                          //     const NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index, i) {
                                            return requests(
                                              buyRequest: snapshot.data![index],
                                              context: context,
                                            );
                                          },
                                        );
                                      }
                                      return Center(
                                        child:
                                            LoadingAnimationWidget.bouncingBall(
                                          color: red,
                                          size: 20,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Text(
                                        'Car News',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // open webview with url
                                          var controller = WebViewController()
                                            ..setJavaScriptMode(
                                              JavaScriptMode.unrestricted,
                                            )
                                            ..setBackgroundColor(
                                              const Color(
                                                0x00000000,
                                              ),
                                            )
                                            ..setNavigationDelegate(
                                              NavigationDelegate(
                                                onProgress: (int progress) {
                                                  // Update loading bar.
                                                },
                                                onPageStarted: (String url) {},
                                                onPageFinished: (String url) {},
                                                onWebResourceError: (
                                                  WebResourceError error,
                                                ) {},
                                                onNavigationRequest: (
                                                  NavigationRequest request,
                                                ) {
                                                  if (request.url.startsWith(
                                                    'https://osmaniamotors.com/?page_id=1640',
                                                  )) {
                                                    return NavigationDecision
                                                        .prevent;
                                                  }
                                                  return NavigationDecision
                                                      .navigate;
                                                },
                                              ),
                                            )
                                            ..loadRequest(
                                              Uri.parse(
                                                'https://osmaniamotors.com/index.php/blog-posts/',
                                              ),
                                            );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return Scaffold(
                                                  appBar: AppBar(
                                                    title: Text(
                                                      'Automotive News',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  body: WebViewWidget(
                                                    controller: controller,
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Read All News',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                // latest blog with image and title and date
                                SizedBox(
                                  height: 300,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: blogPosts.length,
                                    itemBuilder: (context, index) {
                                      BlogPost post = blogPosts[index];
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: buildBlogPostWidget(
                                          context,
                                          post,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 50,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 8,
                                                    ),
                                                    child: Text(
                                                      'Osmania\'s Latest',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // Spacer(),
                                                TextButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    'View All',
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return VideoPlayerScreen(
                                                videoId:
                                                    state.latestVideos['items']
                                                        [0]['id']['videoId'],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 2,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                              8.0,
                                            ),
                                            child: Column(
                                              children: [
                                                CachedNetworkImage(
                                                  height: 150,
                                                  width: MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.9,
                                                  imageUrl: state.latestVideos[
                                                                  'items'][0]
                                                              ['snippet']
                                                          ['thumbnails']['high']
                                                      ['url'],
                                                  fit: BoxFit.cover,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 12.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        state.latestVideos[
                                                                    'items'][0]
                                                                ['snippet']
                                                            ['title'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'Montserrat',
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      // description
                                                      Text(
                                                        state.latestVideos[
                                                                    'items'][0]
                                                                ['snippet']
                                                            ['description'],
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'Montserrat',
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return VideoPlayerScreen(
                                                  videoId: state
                                                          .latestVideos['items']
                                                      [1]['id']['videoId'],
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CachedNetworkImage(
                                                  height: 120,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  imageUrl: state.latestVideos[
                                                                  'items'][1]
                                                              ['snippet']
                                                          ['thumbnails']['high']
                                                      ['url'],
                                                  fit: BoxFit.contain,
                                                ),
                                                SizedBox(width: 12),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 8.0,
                                                  ),
                                                  child: SizedBox(
                                                    height: 100,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                context,
                                                              ).size.width *
                                                              0.4,
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            child: Text(
                                                              state
                                                                  .latestVideos[
                                                                      'items']
                                                                      [1][
                                                                      'snippet']
                                                                      ['title']
                                                                  .toString()
                                                                  .substring(
                                                                    0,
                                                                    30,
                                                                  ),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Montserrat',
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        // description
                                                        Container(
                                                          width: MediaQuery.of(
                                                                context,
                                                              ).size.width *
                                                              0.4,
                                                          child: Text(
                                                            state.latestVideos[
                                                                    'items'][1]
                                                                    ['snippet'][
                                                                    'description']
                                                                .toString()
                                                                .substring(
                                                                  0,
                                                                  30,
                                                                ),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Montserrat',
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return VideoPlayerScreen(
                                                  videoId: state
                                                          .latestVideos['items']
                                                      [1]['id']['videoId'],
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CachedNetworkImage(
                                                  height: 120,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  imageUrl: state.latestVideos[
                                                                  'items'][2]
                                                              ['snippet']
                                                          ['thumbnails']['high']
                                                      ['url'],
                                                  fit: BoxFit.contain,
                                                ),
                                                SizedBox(width: 12),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 8.0,
                                                  ),
                                                  child: SizedBox(
                                                    height: 100,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                context,
                                                              ).size.width *
                                                              0.4,
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            child: Text(
                                                              state
                                                                  .latestVideos[
                                                                      'items']
                                                                      [2][
                                                                      'snippet']
                                                                      ['title']
                                                                  .toString()
                                                                  .substring(
                                                                    0,
                                                                    30,
                                                                  ),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Montserrat',
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        // description
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          child: Text(
                                                            state.latestVideos[
                                                                    'items'][2]
                                                                    ['snippet'][
                                                                    'description']
                                                                .toString()
                                                                .substring(
                                                                  0,
                                                                  30,
                                                                ),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Montserrat',
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }

                      if (state is ErrorHomeState) {
                        return Center(
                          child: Text(translations?['error'] ?? 'Error'),
                        );
                      }

                      return Text(translations?['error'] ?? 'Error');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  requests({required BuyRequest buyRequest, required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return UserMessageScreen(
                buyRequestId: buyRequest.buyRequestID,
              );
            },
          ),
        );
      },
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              ListTile(
                visualDensity: VisualDensity(
                  horizontal: 4,
                ),
                // leading: CircleAvatar(
                //   radius: 40,
                //   backgroundImage: CachedNetworkImageProvider(
                //     'https://gravatar.com/avatar/00630ebc6bc398bd100d7ca15827de3a?s=400&d=robohash&r=x',
                //     errorListener: () {
                //       log('error');
                //     },
                //   ),
                // ),
                title: Text(
                  buyRequest.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat',
                  ),
                ),
                subtitleTextStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UserMessageScreen(
                                buyRequestId: buyRequest.buyRequestID,
                              );
                            },
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.phone,
                        color: Colors.blue,
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(
                    //     Icons.message,
                    //     color: Colors.blue,
                    //   ),
                    // ),
                  ],
                ),
              ),
              // horizontal divider
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Divider(
                  height: 20,
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: ExpandableText(
                  text: buyRequest.description,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // TextButton(
                    //   onPressed: () {},
                    //   child: Text(
                    //     'PKR: ' + buyRequest.price.toString(),
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.w400,
                    //       fontFamily: 'Montserrat',
                    //     ),
                    //   ),
                    // ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UserMessageScreen(
                                buyRequestId: buyRequest.buyRequestID,
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        '0 offers sent',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // make offer button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return UserMessageScreen(
                              buyRequestId: buyRequest.buyRequestID,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Comments',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchAndLogData() async {
    final url = Uri.parse('https://osmaniamotors.com/blog-posts/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        log('Data from URL: $responseData');
        // You can process the responseData as needed
      } else {
        log('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  Stream<List<dynamic>> getAdsUrls =
      FirebaseFirestore.instance.collection('Ads').snapshots().asyncMap(
            (snapshot) => Future.delayed(
              Duration(milliseconds: 500),
              () {
                return snapshot.docs.map((doc) {
                  return doc.data()['url'];
                }).toList();
              },
            ),
          );

  Widget buildBlogPostWidget(BuildContext context, BlogPost post) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.9,
              imageUrl: post.image,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat',
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 8),
                  Text(
                    post.content,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Stream<List<BuyRequest>> getBuyRequests() {
  return FirebaseFirestore.instance.collection('requests').snapshots().asyncMap(
        (snapshot) => Future.delayed(Duration(milliseconds: 500), () {
          return snapshot.docs.map((doc) {
            return BuyRequest.fromJson(doc.data());
          }).toList();
        }),
      );
}

class SearchInput extends StatelessWidget {
  SearchInput({
    required this.searchController,
    required this.hintText,
    this.onChanged,
    Key? key,
  }) : super(
          key: key,
        );
  final TextEditingController searchController;
  final String hintText;
  final primaryColor = const Color(0xff4338CA);
  final secondaryColor = const Color(0xff6D28D9);
  final accentColor = const Color(0x99ffffff);
  final greyColor = const Color(0xff9CA3AF);
  final errorColor = const Color(0xffEF4444);
  final Function? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        // color: mainColor.withOpacity(.8),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      child: TextField(
        textInputAction: TextInputAction.search,
        // enabled: false,
        controller: searchController,
        textAlign: TextAlign.center,
        // onChanged: (value) {
        //   onChanged!(value);
        // },
        onSubmitted: (value) {
          onChanged!(value);
        },
        style: TextStyle(fontSize: 18, color: Colors.black),
        decoration: InputDecoration(
          // prefixIcon: Icon(Icons.email),
          // prefixIcon: Icon(Icons.search, size: 20, color: accentColor),
          suffixIcon: IconButton(
            onPressed: () {
              searchController.clear();
            },
            icon: Icon(Icons.clear, size: 20, color: accentColor),
          ),
          // filled: true,
          fillColor: Colors.transparent,
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.black38, height: 0.5, fontSize: 16),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}

class CityListWidget extends StatefulWidget {
  @override
  _CityListWidgetState createState() => _CityListWidgetState();
}

class _CityListWidgetState extends State<CityListWidget> {
  int _currentIndex = 0;

  List<Widget> pages = [
    PageWidget(cities: ['Bahawalpur', 'Rahim Yar Khan', 'Liāquatpur']),
    PageWidget(cities: ['Multan', 'Lahore', 'Karachi']),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarouselSlider(
            items: pages.map((page) {
              return Container(
                margin: EdgeInsets.all(8.0),
                child: Center(child: page),
              );
            }).toList(),
            options: CarouselOptions(
              // disableCenter: true,
              autoPlay: true,
              aspectRatio: 1.0,
              viewportFraction: 1,
              height: 80.0,
              enlargeCenterPage: false,
              onPageChanged: (index, _) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: pages.asMap().entries.map((entry) {
              int index = entry.key;
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.blue : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class PageWidget extends StatelessWidget {
  PageWidget({Key? key, this.cities}) : super(key: key);
  final List<String>? cities;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: MediaQuery.sizeOf(context).width,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: cities?.length ?? 0,
        itemBuilder: (context, index) {
          String city = cities?[index] ?? '';
          return Container(
            margin: EdgeInsets.all(8.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SearchPage(
                          query: city,
                        );
                      },
                    ),
                  );
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      city,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
