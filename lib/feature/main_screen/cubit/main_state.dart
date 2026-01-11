import 'package:falcon/feature/main_screen/data/model/categories_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:falcon/feature/main_screen/data/model/my_profile_model.dart';
part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  const factory MainState.initial() = _Initial;

  //myProfile
  const factory MainState.myProfileloading() = myProfileLoading;
  const factory MainState.myProfilesuccess(MyProfileModel myProfileModel) =
      myProfileSuccess;
  const factory MainState.myProfileerror({required String error}) =
      myProfileError;

  //playerProfile
  const factory MainState.playerProfileloading() = playerProfileLoading;
  const factory MainState.playerProfilesuccess(
    MyProfileModel playerProfileModel,
  ) = playerProfileSuccess;
  const factory MainState.playerProfileerror({required String error}) =
      playerProfileError;

  //categories
  const factory MainState.categoriesloading() = categoriesLoading;
  const factory MainState.categoriessuccess(CategoriesModel categoriesModel) =
      categoriesSuccess;
  const factory MainState.categorieserror({required String error}) =
      categoriesError;

  const factory MainState.playVideoloading() = playVideoLoading;
  const factory MainState.playVideosuccess() = playVideoSuccess;
}
