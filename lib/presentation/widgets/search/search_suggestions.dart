import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motors_app/presentation/screens/search/new_search_page.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  static var _titleToIdMap = {};
  final _PopularSearches = [
    'SUZUKI A6',
    'TOYOTA COROLLA',
    'HONDA CIVIC',
  ];
  var _PastSearches = [];
  final String _baseUrl = 'https://osmaniamotors.com/wp-json/stm-mra/v1';
  final http.Client _client = http.Client();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  Future<List<Listing>> getListings() async {
    final response = await _client.get(Uri.parse('$_baseUrl/listings'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final listings = (data['listings'] as List)
          .map((listingData) => Listing.fromJson(listingData))
          .toList();

      _titleToIdMap = Map.fromIterable(listings,
          key: (listing) => listing.title.toLowerCase(),
          value: (listing) => listing.id,);
      return listings;
    } else {
      throw Exception('An error occurred: ${response.statusCode}');
    }
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  void showResults(BuildContext context) {
    goToResults(context);
    //super.showResults(context);
  }

  goToResults(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchPage(
                  query: query,
                ),

            //  CarDetailScreen(
            //   idCar: id,
            // ),
            ),);
  }

  @override
  Widget buildResults(BuildContext context) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => SearchResult(
    //               query: query,
    //             )

    //         //  CarDetailScreen(
    //         //   idCar: id,
    //         // ),
    //         ));

    // Implement search results page based on the selected query
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: FutureBuilder<List<String>>(
          future: _fetchSuggestions(query),
          builder: (context, snapshot) {
            if (query.isEmpty) {
              return ListView(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_PastSearches.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            'Recently Searched',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: _PastSearches.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _PastSearches.removeAt(index);
                                  });
                                },
                              ),
                              title: Text(_PastSearches[index]),
                              leading: Icon(Icons.history),
                              onTap: () async {
                                await getListings();
                                print(_PastSearches[index]);
                                final id = _titleToIdMap[
                                    '${_PastSearches[index].toLowerCase()}'];
                                print(id);
                                _PastSearches.add(_PastSearches[index]);

                                // _PastSearches.add(_PastSearches[index]);

                                if (id == null) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchPage(
                                                query: query,
                                              ),

                                          //  CarDetailScreen(
                                          //   idCar: id,
                                          // ),
                                          ),
                                    );
                                  });
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchPage(
                                              query: query,
                                            ),

                                        //  CarDetailScreen(
                                        //   idCar: id,
                                        // ),
                                        ),
                                  );
                                }

                                //close(context, _PastSearches[index]);
                              },
                            ),
                          );
                        },
                        shrinkWrap: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Popular Searches',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: _PopularSearches.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(_PopularSearches[index]),
                              onTap: () async {
                                await getListings();
                                _PastSearches.add(_PopularSearches[index]);
                                //_PastSearches.add(_PopularSearches[index]);
                                final id = _titleToIdMap[
                                    _PopularSearches[index].toLowerCase()];
                                print(id);

                                if (id == null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchPage(
                                              query: query,
                                            ),

                                        //  CarDetailScreen(
                                        //   idCar: id,
                                        // ),
                                        ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchPage(
                                              query: query,
                                            ),

                                        //  CarDetailScreen(
                                        //   idCar: id,
                                        // ),
                                        ),
                                  );
                                }
                                //close(context, _PopularSearches[index]);
                              },
                            ),
                          );
                        },
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                ),
              ],);
            } else {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: LoaderWidget());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('Press Enter To Search'));
              } else {
                final suggestions = snapshot.data!;
                return ListView.builder(
                  itemCount: suggestions.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      child: ListTile(
                        // shape: RoundedRectangleBorder(
                        //     side: BorderSide(
                        //   color: Colors.red,
                        //   width: 1,
                        // )),
                        title: Text(
                          suggestions[index],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,),
                        ),
                        onTap: () async {
                          //_PastSearches.add(suggestions[index]);
                          _PastSearches.add(query);

                          //final id = maps['${_PastSearches[index]}'];
                          await getListings();
                          final id = await _titleToIdMap[
                              suggestions[index].toLowerCase()];
                          print(id);

                          if (id == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage(
                                        query: query,
                                      ),

                                  //  CarDetailScreen(
                                  //   idCar: id,
                                  // ),
                                  ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage(
                                        query: query,
                                      ),

                                  //  CarDetailScreen(
                                  //   idCar: id,
                                  // ),
                                  ),
                            );
                          }
                          //close(context, suggestions[index]);
                        },
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
      );
    },);
  }

  Future<List<String>> _fetchSuggestions(String query) async {
    final response = await _client.get(Uri.parse('$_baseUrl/listings'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final listings = (data['listings'] as List)
          .map((listingData) => Listing.fromJson(listingData))
          .toList();

      final suggestionList = listings
          .where((listing) =>
              listing.title.toLowerCase().contains(query.toLowerCase()),)
          .map((listing) => listing.title)
          .toList();
      if (suggestionList.isEmpty) {
        return [query];
      }

      return suggestionList;
    } else {
      throw Exception('An error occurred: ${response.statusCode}');
    }
  }
}

class Listing {

  Listing({required this.title, required this.id});

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(title: json['grid']['title'], id: json['ID']);
  }
  final String title;
  final int id;

  get getID {
    return id;
  }

  get getTitle {
    return title;
  }
}

// class SearchScreenPage extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreenPage> {
//   final PopularSearches = [
//     'SUZUKI A6',
//     'TOYOTA COROLLA',
//     'HONDA CIVIC',
//   ];
//   var PastSearched = [];
//   onAdd(List a, value) {
//     setState(() {
//       //a.add(value);
//       PastSearched.add(value);
//     });
//   }

//   onRemove(List a, int b) {
//     setState(() {
//       //a.removeAt(b);
//       PastSearched.removeAt(b);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Open the search delegate automatically when the page loads
//     // openSearchDelegate();
//   }

//   Future<void> openSearchDelegate() async {
//     await showSearch<String>(
//       context: context,
//       delegate:
//           CustomSearchDelegate(onRemove, PopularSearches, PastSearched, onAdd),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//             child: ElevatedButton(
//                 child: Text("Click me"),
//                 onPressed: () async {
//                   await showSearch<String>(
//                     context: context,
//                     delegate: CustomSearchDelegate(
//                         onRemove, PopularSearches, PastSearched, onAdd),
//                   );
//                 })),
//       ), // Your other content here
//     );
//   }
// }
