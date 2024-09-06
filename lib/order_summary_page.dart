import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zartek_test/controller/app_controller.dart';
import 'package:zartek_test/user_home_screen.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  AppController appCt = Get.find();
  bool screenLoad = true;
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getOrderSummary();
    });

    // });

    super.initState();
  }

  int totalAmount = 0;
  getOrderSummary() async {
    await appCt.addCartList();

    if (mounted) {
      setState(() {
        screenLoad = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 21,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey.shade600,
            )),
        centerTitle: true,
        title: Text(
          "Order Summary",
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ),
      body: screenLoad
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), // Greyish shadow color
                              spreadRadius: 2, // How far the shadow spreads
                              blurRadius: 5, // Softening the shadow
                              offset: Offset(0,
                                  3), // Horizontal and vertical shadow offset
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green),
                            child: Center(
                                child: Text(
                              "${appCt.dishCount} Dishes - ${appCt.itemCount} Items",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            )),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ListView.builder(
                            itemCount: appCt.cartList.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                children: appCt.cartList[index].dishes!
                                    .map((e) => Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          height: 15,
                                                          width: 15,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .green)),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 5,
                                                                backgroundColor:
                                                                    index.isEven
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .red,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Flexible(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                appCt
                                                                        .cartList[
                                                                            index]
                                                                        .name ??
                                                                    "",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 5,
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                  "${e.currency ?? ""} ${e.price ?? ""}"),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                  "${e.calories ?? ""} calaries")
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          if (e.itemCount !=
                                                              0) {
                                                            setState(() {
                                                              e.itemCount--;
                                                            });
                                                            appCt
                                                                .updateItemTotal();
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.green,
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          30))),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.remove,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.green,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "${e.itemCount}",
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            e.itemCount++;
                                                          });
                                                          appCt
                                                              .updateItemTotal();
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.green,
                                                              borderRadius: BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          30))),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.add,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  GetBuilder<AppController>(
                                                      builder: (ct) {
                                                    return Text(
                                                        "INR ${e.total}");
                                                  }),
                                                ],
                                              ),
                                              Divider()
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Amount",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16),
                              ),
                              GetBuilder<AppController>(builder: (ct) {
                                return Text(
                                  "INR ${ct.totalAmount}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Colors.green),
                                );
                              })
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
                Positioned(
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "Success",
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Text(
                                    "Order successfully placed",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white),
                                        onPressed: () async {
                                          await appCt.getItems();
                                          appCt.cartCount = 0;
                                          appCt.cartList.clear();
                                          Get.offAll(() => UserHomeScreen());
                                        },
                                        child: Text(
                                          "Back",
                                        ))
                                  ],
                                );
                              });
                        },
                        child: Text(
                          "Place Order",
                        )))
              ],
            ),
    );
  }
}
