import 'package:zartek_test/responses/home_items_response.dart';
import 'package:zartek_test/services/network/dio_request_hndler.dart';

class HomeApi {
  Future<ItemsResponse?> getItemList() async {
    ItemsResponse? response;
    var isSuccess;
    DioRequestHandler requestHandler = DioRequestHandler();
    isSuccess = await requestHandler.getRequest(
        "https://run.mocky.io/v3/18e8dae4-f39d-46bc-9cf6-9f8b97c32f9c", {});
    if (isSuccess) {
      print(requestHandler.responsebody);
      response = ItemsResponse.fromJson(requestHandler.responsebody);
    }
    return response;
  }
}
