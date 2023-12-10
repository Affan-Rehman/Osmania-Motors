import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/shared_components/expansion_panel.dart';
import 'package:motors_app/presentation/bloc/car_detail/car_detail_bloc.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({Key? key, required this.state}) : super(key: key);

  final LoadedCarDetailState state;

  @override
  Widget build(BuildContext context) {
    RegExp htmlTags = RegExp('<.+?>');
print('Hello test ${state.loadedDetailCar.toJson()}');
    return Visibility(
      visible: state.loadedDetailCar.listingSellerNote == '' || state.loadedDetailCar.listingSellerNote == null ? false : true,
      child: ExpansionPanelList(
        elevation: 0,
        expansionCallback: (int index, bool isExpanded) {
          Provider.of<ExpansionPanelProvider>(context, listen: false).toggleExpansionComment();
        },
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: Provider.of<ExpansionPanelProvider>(context).isExpandedComments,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 12.5),
                child: Text(
                  '${translations?['seller_comments'] ?? 'Car Description'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: htmlTags.hasMatch(state.loadedDetailCar.listingSellerNote ?? '')
                    ? Html(data: state.loadedDetailCar.listingSellerNote)
                    : Text(
                        state.loadedDetailCar.listingSellerNote == '' || state.loadedDetailCar.listingSellerNote == null
                            ? translations!['no_comment'] ?? 'No comment'
                            : state.loadedDetailCar.listingSellerNote == 'N/A'
                                ? 'No Description Added'
                                : state.loadedDetailCar.listingSellerNote,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
