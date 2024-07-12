import 'package:get/get.dart';
import 'package:tezdo/model/category.dart';
import 'package:tezdo/model/network/Network.dart';
import 'package:tezdo/model/products.dart';
import 'package:tezdo/model/user.dart';
import 'package:tezdo/model/token.dart';

abstract class FSGetXController extends GetxController {

  Future<JsonResponseToken> postToken(endPoint,{Map<String,dynamic> params = const {}}) async{
    JsonResponseToken responseObj = JsonResponseToken();
    final network = Network();
    final JsonResponse response = await network.post(endPoint,params: params);
    Token token = Token.fromJson(response.response);
    responseObj.statusCode = response.statusCode;
    responseObj.message = response.message;
    responseObj.response = token;
    return responseObj;
  }

  // Future<JsonResponseSingIn> postSignIn(endPoint,{Map<String,dynamic> params = const {}}) async{
  //   JsonResponseSingIn responseObj = JsonResponseSingIn();
  //   final network = Network();
  //   final JsonResponse response = await network.post(endPoint,params: params);
  //   UserModel singIn = UserModel.fromJson(response.response);
  //   responseObj.statusCode = response.statusCode;
  //   responseObj.message = response.message;
  //   responseObj.response = singIn;
  //   return responseObj;
  // }

  Future<JsonResponseList> getProducts(endPoint,{Map<String,dynamic> params = const {}}) async{
    JsonResponseList response = JsonResponseList();
    final network = Network();
    final JsonObjectResponse responseJson = await network.get(endPoint,params: params);
    if(responseJson.statusCode == 200){
      List<Product> listProducts = [];
      for (var element in responseJson.response) {
        listProducts.add(Product.fromJson(element));
      }
      response.statusCode = responseJson.statusCode;
      response.message = responseJson.message;
      response.response = listProducts;
    }
    return response;
  }

  Future<JsonResponseListCategory> getCategories(String endPoint) async {
    JsonResponseListCategory response = JsonResponseListCategory();
    final network = Network();
    final JsonObjectResponse responseJson = await network.get(endPoint);
    
    if(responseJson.statusCode == 200){
      List<Category> listCategories = [];
      for (var element in responseJson.response) {
        listCategories.add(Category.fromJson(element));
      }
      response.statusCode = responseJson.statusCode;
      response.message = responseJson.message;
      response.response = listCategories;
    }
    return response;
  }

}


class JsonResponse {
  String message;
  int statusCode;
  Map<String,dynamic> response;

  JsonResponse({
    this.message = '',
    this.statusCode = 0,
    this.response = const {},
  });
}

class JsonResponseToken {
  String message;
  int statusCode;
  Token? response;

  JsonResponseToken({
    this.message = '',
    this.statusCode = 0,
    this.response,
  });
}

class JsonResponseSingIn {
  String message;
  int statusCode;
  UserModel? response;

  JsonResponseSingIn({
    this.message = '',
    this.statusCode = 0,
    this.response,
  });
}

class JsonObjectResponse {
  String message;
  int statusCode;
  List<dynamic> response;

  JsonObjectResponse({
    this.message = '',
    this.statusCode = 0,
    this.response = const [],
  });
}

class JsonResponseList {
  String message;
  int statusCode;
  List<Product> response;

  JsonResponseList({
    this.message = '',
    this.statusCode = 0,
    this.response = const [],
  });
}

class JsonResponseListCategory {
  String message;
  int statusCode;
  List<Category> response;

  JsonResponseListCategory({
    this.message = '',
    this.statusCode = 0,
    this.response = const [],
  });
}