import 'package:bloc/bloc.dart';
import 'package:structure/clean_architecture/features/auth/domain/entities/profile_entity.dart';
import 'package:structure/clean_architecture/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:structure/clean_architecture/features/profile/domain/usecases/update_profile_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial());

  void getProfile() async {
    emit(ProfileLoading());
    final result = await getProfileUseCase();
    result.fold(
      (error) => emit(ProfileError(error.toString())),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  void updateProfile(ProfileEntity profile) async {
    emit(ProfileLoading());
    final result = await updateProfileUseCase(profile);
    result.fold(
      (error) => emit(ProfileError(error.toString())),
      (updatedProfile) => emit(ProfileLoaded(updatedProfile)),
    );
  }
}
