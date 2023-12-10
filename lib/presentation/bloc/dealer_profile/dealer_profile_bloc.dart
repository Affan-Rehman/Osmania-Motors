import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/models/dealer_user/dealer_user.dart';
import 'package:motors_app/data/repositories/car_detail_repository_impl.dart';

part 'dealer_profile_event.dart';

part 'dealer_profile_state.dart';

class DealerProfileBloc extends Bloc<DealerProfileEvent, DealerProfileState> {
  DealerProfileBloc(this.carDetailRepository) : super(InitialDealerProfileState()) {
    on<LoadDealerProfileEvent>((event, emit) async {
      emit(InitialDealerProfileState());
      try {
        DealerResponse dealerResponse = await carDetailRepository.getDealerProfile(event.dealerId);

        emit(LoadedDealerProfileState(dealerResponse));
      } on DioError catch (e, s) {
        logger.e('Error during with getDealerProfile, $e, $s');
        emit(ErrorDealerProfileState());
      }
    });
  }

  final CarDetailRepository carDetailRepository;
}
