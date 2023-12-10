import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icon.dart';
import 'package:motors_app/presentation/screens/car_detail/car_detail_screen.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';
import 'package:string_similarity/string_similarity.dart';

class Listing {
  Listing({
    required this.title,
    required this.price,
    required this.location,
    required this.imgurl,
    required this.model,
    required this.priceAsNumber,
    required this.year,
    required this.subtitle,
    required this.id,
  });
  final int? id;
  final String title;
  final String price;
  final String location;
  final String imgurl;
  final String model;
  final double priceAsNumber;
  final int year;
  final String subtitle;
}

class SearchPage extends StatefulWidget {
  SearchPage({this.query = ''});
  final String query;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  List<Listing> _listings = [];

  RangeValues _selectedPriceRange =
      RangeValues(0, 10000000); // Initial price range
  RangeValues _selectedYearRange = RangeValues(1800, 2023);

  Set<String> _selectedFilters = {}; // Initialize with no Location filters
  // Initialize with no Location filter
  Set<String> _selectedModelFilters = {}; // Initialize with no Model filters
// Initialize with no model filter
  var _availableModels = [];
  var _availableYears = [];

  var _isloading = false;

  void _applyFilter(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter); // Remove the filter
      } else {
        _selectedFilters.add(filter); // Add the filter
      }
      _fetchListings(_searchController.text);
    });
  }

  bool matchesLocations(Listing listing) {
    if (_selectedFilters.isEmpty) {
      return true; // No filters applied, all locations should match
    } else {
      return _selectedFilters.contains(listing.location);
    }
  }

  bool matchesModels(Listing listing) {
    if (_selectedModelFilters.isEmpty) {
      return true; // No filters applied, all models should match
    } else {
      return _selectedModelFilters.contains(listing.model);
    }
  }

  var _availableLocations = [];

  void _onSearchTextChanged() {
    _fetchListings(_searchController.text);
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchTextChanged);

    _fetchListings(widget.query);
    // _fetchAvailableLocationsAndModels();
    _availableYears.sort();

    print(_availableYears);
  }

  void _openLocationFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: _availableLocations.map((location) {
              final bool isSelected = _selectedFilters.contains(location);
              return ListTile(
                title: Text(location),
                trailing: isSelected ? Icon(Icons.check) : null,
                onTap: () {
                  _applyFilter(location);
                  Navigator.pop(context); // Close the bottom sheet
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _openModelFilterSheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            children: _availableModels.map((model) {
              final bool isSelected = _selectedModelFilters.contains(model);
              return ListTile(
                title: Text(model),
                trailing: isSelected ? Icon(Icons.check) : null,
                onTap: () {
                  _applyModelFilter(model);
                  Navigator.pop(context); // Close the bottom sheet
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _applyModelFilter(String model) {
    setState(() {
      if (_selectedModelFilters.contains(model)) {
        _selectedModelFilters.remove(model); // Remove the filter
      } else {
        _selectedModelFilters.add(model); // Add the filter
      }
      _fetchListings(_searchController.text);
    });
  }

  void _openPriceFilterSheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: ((context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Filter by Price Range',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Min.',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 300,
                      child: RangeSlider(
                        activeColor: Colors.red,
                        inactiveColor: Colors.grey,
                        values: _selectedPriceRange,
                        min: 0,
                        max: 10000000,
                        onChanged: (RangeValues priceRange) {
                          setState(() {
                            _selectedPriceRange = priceRange;
                            _fetchListings(_searchController.text);
                          });
                        },
                        divisions: 100,
                        labels: RangeLabels(
                          _selectedPriceRange.start.toStringAsFixed(0),
                          _selectedPriceRange.end.toStringAsFixed(0),
                        ),
                      ),
                    ),
                    Text(
                      'Max',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Add any additional UI components here
              ],
            );
          }),
        );
      },
    );
  }

  void _openYearFilterSheet() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: ((context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Year Range'),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 5,
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '1800',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RangeSlider(
                          activeColor: Colors.red,
                          inactiveColor: Colors.grey,
                          values: _selectedYearRange,
                          min: 1800,
                          max: DateTime.now().year.toDouble(),
                          onChanged: (values) {
                            setState(() {
                              _selectedYearRange = values;
                              _fetchListings(_searchController.text);
                            });
                          },
                          divisions: DateTime.now().year - 1800,
                          labels: RangeLabels(
                            _selectedYearRange.start.toStringAsFixed(0),
                            _selectedYearRange.end.toStringAsFixed(0),
                          ),
                        ),
                        Text(
                          DateTime.now().year.toString(),
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Future<void> _fetchListings(String query) async {
    setState(() {
      _isloading = true;
    });
    print('getting listing');
    final response = await http.get(
      Uri.parse('https://osmaniamotors.com/wp-json/stm-mra/v1/listings'),
    );
    print('got listing');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final listings = data['listings'] as List<dynamic>;
      print(listings.first);
      double _convertPriceToNumber(String price) {
        final priceString = price.replaceAll(RegExp(r'[^\d.]'), '');

        final num = double.tryParse(priceString);
        if (num == null) {
          return 0.0;
        }

        return num;
      }

      int extractYear(String input) {
        final yearMatch = RegExp(r'\b\d{4}\b').firstMatch(input);
        if (yearMatch != null) {
          return int.tryParse(yearMatch.group(0)!) ?? 0;
        }
        return 0; // Default year value if no match is found
      }

      String extractSearchedYear(String input) {
        RegExp regex = RegExp(r'\d{4}'); // Match a sequence of four digits

        Match? match = regex.firstMatch(input);
        if (match != null) {
          return match.group(0)!;
        } else {
          return 'Year not found';
        }
      }

      bool similarStrings(String a, String b) {
        final similarity = StringSimilarity.compareTwoStrings(a, b);
        return similarity >= 0.3;
      }

      if (query.isNotEmpty) {
        setState(() {
          _listings = listings.where((item) {
            final title = item['grid']['title'].toString().toLowerCase();
            final Stringprice = item['price'].toString().toLowerCase();

            final location =
                item['list']['infoThreeDesc'].toString().toLowerCase();
            final models =
                item['list']['title'].split(' ')[0].toString().toLowerCase();
            final years = extractYear(item['grid']['subTitle']);

            final subtitle = item['grid']['subTitle'].toString().toLowerCase();

            return
                //  query.toLowerCase().contains(title) ||
                //     query.toLowerCase().contains(Stringprice) ||
                //     query.toLowerCase().contains(location) ||
                //     query.toLowerCase().contains(models) ||
                //     query.toLowerCase().contains(years.toString());
                //||
                //query.toLowerCase().contains(subtitle);

                title.contains(query.toLowerCase().trim()) ||
                    Stringprice.contains(query.toLowerCase().trim()) ||
                    location.contains(query.toLowerCase().trim()) ||
                    models.contains(query.toLowerCase().trim()) ||
                    years.toString().contains(query.toLowerCase().trim()) ||
                    subtitle.contains(query.toLowerCase().trim()) ||
                    (query.toLowerCase().trim().contains(years.toString()) &&
                        query.toLowerCase().trim().contains(title)) ||
                    (title.contains(query.toLowerCase().trim()) &&
                        // years.toString().contains(query.toLowerCase().trim()) &&
                        query
                            .toLowerCase()
                            .trim()
                            .contains(years.toString().toLowerCase())) ||
                    (title.contains(query.toLowerCase().trim()) &&
                        years
                            .toString()
                            .contains(query.toLowerCase().trim())) ||
                    ((query.toLowerCase().trim().contains(title)) &&
                        years
                            .toString()
                            .contains(query.toLowerCase().trim())) ||
                    (similarStrings(query.toLowerCase(), title) &&
                        extractSearchedYear(query.toLowerCase()) ==
                            years.toString());
          }).map((item) {
            return Listing(
              title: item['grid']['title'],
              price: item['price'],
              location: item['list']['infoThreeDesc'],
              imgurl: item['imgUrl'],
              model: item['list']['title'].split(' ')[0],
              priceAsNumber: _convertPriceToNumber(item['price']) * 10000000,
              year: extractYear(item['grid']['subTitle']),
              subtitle: item['grid']['subTitle'],
              id: item['ID'],
            );
          }).toList();
        });
      } else {
        setState(() {
          _listings = listings.map((item) {
            return Listing(
              title: item['grid']['title'],
              price: item['price'],
              location: item['list']['infoThreeDesc'],
              imgurl: item['imgUrl'],
              model: item['list']['title'].split(' ')[0],
              priceAsNumber: _convertPriceToNumber(item['price']) * 10000000,
              year: extractYear(item['grid']['subTitle']),
              subtitle: item['grid']['subTitle'],
              id: item['ID'],
            );
          }).toList();
        });
      }

      setState(() {
        _isloading = false;
      });
    } else {
      print('response code: ${response.statusCode}');
      // Handle error
      print('Failed to fetch listings');
    }
  }

  List<Listing> _getFilteredResults(String query) {
    if (_selectedFilters.isEmpty &&
            _selectedModelFilters.isEmpty &&
            _selectedPriceRange.start == 0 &&
            _selectedPriceRange.end == 5000000 ||
        _selectedYearRange == 1800 &&
            _selectedYearRange == DateTime.now().year) {
      return _listings;
    } else {
      return _listings.where((listing) {
        print('Price is of ${listing.title} is ${listing.priceAsNumber}');
        final bool matchesQuery = listing.title.contains(query);
        final bool matchesLocation = matchesLocations(listing);

        final bool matchesModel = matchesModels(listing);

        final bool matchesPrice =
            listing.priceAsNumber >= _selectedPriceRange.start &&
                listing.priceAsNumber <= _selectedPriceRange.end;

        final bool matchesYear = listing.year >= _selectedYearRange.start &&
            listing.year <= _selectedYearRange.end;

        return (matchesQuery) ||
            (matchesLocation && matchesModel && matchesPrice && matchesYear);
      }).toList();
    }
  }

  void _openSortOptionsSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Sort by Price'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _showPriceSortOptions(); // Show price sort options
              },
            ),
            ListTile(
              title: Text('Sort by Year'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _showYearSortOptions(); // Show year sort options
              },
            ),
          ],
        );
      },
    );
  }

  void _showPriceSortOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Low to High'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _sortListingsByPrice(true); // Sort by ascending price
              },
            ),
            ListTile(
              title: Text('High to Low'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _sortListingsByPrice(false); // Sort by descending price
              },
            ),
          ],
        );
      },
    );
  }

  void _showYearSortOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Low to High'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _sortListingsByYear(true); // Sort by ascending year
              },
            ),
            ListTile(
              title: Text('High to Low'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                _sortListingsByYear(false); // Sort by descending year
              },
            ),
          ],
        );
      },
    );
  }

  void _sortListingsByPrice(bool ascending) {
    setState(() {
      _listings.sort((a, b) {
        if (ascending) {
          return a.priceAsNumber.compareTo(b.priceAsNumber);
        } else {
          return b.priceAsNumber.compareTo(a.priceAsNumber);
        }
      });
    });
  }

  void _sortListingsByYear(bool ascending) {
    setState(() {
      _listings.sort((a, b) {
        if (ascending) {
          return a.year.compareTo(b.year);
        } else {
          return b.year.compareTo(a.year);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Listings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0),
                ), // Red border color
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        hintText: '',
                        border: InputBorder.none,
                        prefixIcon: LineIcon.moon(
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                  _searchController.text.isEmpty
                      ? Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Search Your Dream Car...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color.fromARGB(
                                255,
                                0,
                                0,
                                0,
                              ),
                            ), // Adjust color as needed
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _openSortOptionsSheet(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'Sort By',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(
                          255,
                          0,
                          0,
                          0,
                        ),
                      ), // Red text color
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _openLocationFilterSheet(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(
                          255,
                          0,
                          0,
                          0,
                        ),
                      ), // Red text color
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: 5), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: _openModelFilterSheet,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'Make',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(
                          255,
                          0,
                          0,
                          0,
                        ),
                      ), // Red text color
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: 5), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: _openPriceFilterSheet,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(
                          255,
                          0,
                          0,
                          0,
                        ),
                      ), // Red text color
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: 5), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: _openYearFilterSheet,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'Year',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(
                          255,
                          0,
                          0,
                          0,
                        ),
                      ), // Red text color
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isloading
              ? LoaderWidget()
              : _getFilteredResults(_searchController.text).isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 4),
                      child: Center(
                        child: Text('Sorry, No results found'),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount:
                            _getFilteredResults(_searchController.text).length,
                        itemBuilder: (context, index) {
                          var item = _getFilteredResults(
                            _searchController.text,
                          )[index];

                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CarDetailScreen(
                                    idCar: item.id,
                                  );
                                },
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 254, 254),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  // Use Row to arrange image and information
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(12),
                                        right: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        item.imgurl,
                                        height: 120,
                                        width:
                                            140, // Set a fixed width for the image
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ), // Add some spacing between image and info
                                    Expanded(
                                      child: Container(
                                        height: 120,
                                        width: 160,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 16,
                                            left: 16,
                                            right: 16,
                                            top: 4,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.title,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(
                                                    255,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  'Price: ${item.price}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: const Color.fromARGB(
                                                      255,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  'Location: ${item.location}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: const Color.fromARGB(
                                                      255,
                                                      1,
                                                      1,
                                                      1,
                                                    ),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  'Year: ${item.year}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: const Color.fromARGB(
                                                      255,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
