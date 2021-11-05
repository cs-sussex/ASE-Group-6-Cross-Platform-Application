import 'package:json_annotation/json_annotation.dart';
import 'package:mylocation/location/model/GetAllLocationPOJO.dart';
import 'package:mylocation/userauthentication/Login/model/LoginPOJO.dart';
import 'package:mylocation/userauthentication/registration/model/RegistrationPOJO.dart';
import 'package:mylocation/location/LocationPOJO.dart';
import 'package:mylocation/util/appconstants/AppConstants.dart';
import 'package:mylocation/util/localstorage/UserAuthSharedPreferences.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
part 'RestClient.g.dart';

@RestApi(baseUrl: AppConstants.BASE_URL)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST(AppConstants.Sign_Up)
  Future<RegistrationPOJO> registerUser(
      @Body() RegistrationPOJO registrationPOJO);

  @POST(AppConstants.Sign_In)
  Future<LoginPOJO> loginUser(@Body() LoginPOJO loginPOJO);


  @GET(AppConstants.GET_ALL_LOCATION)
  Future<List<GetAllLocationPOJO>> getAllLocations(@Header("Authorization") String auth);


}
