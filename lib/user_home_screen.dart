import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zartek_test/controller/app_controller.dart';
import 'package:zartek_test/order_summary_page.dart';
import 'package:zartek_test/user_authentication_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  AppController appCt = Get.find();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: appCt.itemsResponse!.categories!.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: appCt.itemsResponse!.categories!.length,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: appCt.user.photoUrl != null
                          ? NetworkImage(appCt.user.photoUrl!)
                          : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(appCt.user.displayName ?? ""),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Id : ${appCt.user.id}")
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () async {
                  await appCt.googleSignIn.signOut();
                  Get.offAll(() => UserAuthenticationScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(
                        width: 30,
                      ),
                      Text("Log Out")
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu));
          }),
          actions: [
            Stack(
              children: [
                IconButton(
                    onPressed: () async {
                      Get.to(() => OrderSummaryPage());
                    },
                    icon: Icon(Icons.shopping_cart)),
                Positioned(
                    top: 0,
                    right: 2,
                    bottom: 0,
                    child: GetBuilder<AppController>(builder: (ct) {
                      return CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Center(
                          child: Text(
                            "${ct.cartCount}",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      );
                    }))
              ],
            )
          ],
          bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.red,
              indicatorColor: Colors.red,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              tabs: appCt.itemsResponse!.categories!.map((e) {
                return Tab(
                  text: e.name,
                );
              }).toList()),
        ),
        body: TabBarView(
            controller: _tabController,
            children: appCt.itemsResponse!.categories!.map((e) {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: e.dishes?.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          isThreeLine: true,
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor:
                                  index.isEven ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(e.dishes?[index].name ?? ""),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${e.dishes?[index].currency} ${e.dishes?[index].price}"),
                                  Text("Calories ${e.dishes?[index].calories}")
                                ],
                              ),
                              Text(e.dishes?[index].description ?? ""),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (e.dishes![index].itemCount != 0) {
                                        setState(() {
                                          e.dishes![index].itemCount--;
                                        });
                                        appCt.updateCartCount();
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30))),
                                      child: Center(
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${e.dishes?[index].itemCount}",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        e.dishes![index].itemCount++;
                                      });
                                      appCt.updateCartCount();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              bottomRight:
                                                  Radius.circular(30))),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              if (e.dishes?[index].customizationsAvailable ==
                                  true)
                                Text(
                                  "customization available",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red),
                                ),
                            ],
                          ),
                          trailing: Container(
                            height: 100,
                            width: 70,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzojxjclj_4ioTHYYPCj66BQH1Th2zJekLxw&s"))),
                          ),
                        ));
                  });
            }).toList()),
      ),
    );
  }
}
