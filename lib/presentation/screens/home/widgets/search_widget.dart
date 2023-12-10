import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/utils/debounce.dart';
import 'package:motors_app/presentation/bloc/filter_result/filter_result_bloc.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 5),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  // debounce search event to avoid multiple requests on fast typing
                  Debouncer _debouncer = Debouncer(milliseconds: 2000);
                  _debouncer.run(() {
                    BlocProvider.of<FilterResultBloc>(context)
                        .add(searchEvent(value));
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          // const SizedBox(width: 20),
          // Container(
          //   padding: const EdgeInsets.all(15),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(10),
          //     boxShadow: const [
          //       BoxShadow(
          //         color: Colors.black12,
          //         offset: Offset(0, 5),
          //         blurRadius: 15,
          //       ),
          //     ],
          //   ),
          //   child: const Icon(Icons.tune),
          // ),
        ],
      ),
    );
  }
}
