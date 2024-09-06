import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zartek_test/responses/home_items_response.dart';
import 'package:zartek_test/services/api/home_api.dart';

class AppController extends GetxController {
  ItemsResponse? itemsResponse;

  List<Categories> cartList = [];

  getItems() async {
    itemsResponse = await HomeApi().getItemList();
    itemsResponse?.categories?.forEach((e) {
      e.dishes?.forEach((e) {
        e.itemCount = 0;
        e.total = 0;
        e.total = num.parse(e.price!) * e.itemCount;
      });
    });
  }

  int cartCount = 0;
  updateCartCount() {
    cartCount = 0;
    totalAmount = 0;
    itemsResponse?.categories?.forEach((element) {
      element.dishes?.forEach((e) {
        cartCount = cartCount + e.itemCount;
        e.total = num.parse(e.price!) * e.itemCount;
        totalAmount = totalAmount + e.total;
      });
    });

    update();
  }

  updateItemTotal() {
    totalAmount = 0;
    cartList.forEach((element) {
      element.dishes?.forEach((e) {
        e.total = num.parse(e.price!) * e.itemCount;
        totalAmount = totalAmount + e.total;
      });
    });

    update();
  }

  int? dishCount = 0;
  int? itemCount = 0;
  num totalAmount = 0;
  addCartList() async {
    List<Categories> categoriesToRemove = [];

    itemsResponse?.categories?.forEach((element) {
      element.dishes?.forEach((e) {
        if (e.itemCount != 0) {
          var existingCategory = cartList.firstWhereOrNull(
            (cartCategory) => cartCategory.id == element.id,
          );

          if (existingCategory != null) {
            var existingDish = existingCategory.dishes!.firstWhereOrNull(
              (dishItem) => dishItem.id == e.id,
            );

            if (existingDish == null) {
              existingCategory.dishes!.add(Dishes(
                itemCount: e.itemCount,
                total: e.total,
                addons: e.addons,
                calories: e.calories,
                currency: e.currency,
                customizationsAvailable: e.customizationsAvailable,
                description: e.description,
                id: e.id,
                imageUrl: e.imageUrl,
                name: e.name,
                price: e.price,
              ));
            } else {
              existingDish.itemCount = e.itemCount;
            }
          } else {
            cartList
                .add(Categories(id: element.id, name: element.name, dishes: [
              Dishes(
                itemCount: e.itemCount,
                total: e.total,
                addons: e.addons,
                calories: e.calories,
                currency: e.currency,
                customizationsAvailable: e.customizationsAvailable,
                description: e.description,
                id: e.id,
                imageUrl: e.imageUrl,
                name: e.name,
                price: e.price,
              )
            ]));
          }
        } else if (e.itemCount == 0) {
          cartList.forEach((category) {
            if (category.id == element.id) {
              category.dishes!.removeWhere((dish) => dish.id == e.id);

              if (category.dishes!.isEmpty) {
                categoriesToRemove.add(category);
              }
            }
          });
        }
      });
    });

    cartList.removeWhere((category) => categoriesToRemove.contains(category));

    dishCount = cartList.length;
    itemCount = 0;
    totalAmount = 0;
    cartList.forEach((e) {
      itemCount = itemCount! + e.dishes!.length;
      e.dishes?.forEach((element) {
        element.total = num.parse(element.price!) * element.itemCount;
        totalAmount = totalAmount + element.total;
      });
    });
    update();
  }

  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    await getItems();
    update();
  }
}
