import 'package:appwrite/appwrite.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_saloon/constants.dart';
import 'package:my_saloon/models/salonmodel.dart';
import 'package:my_saloon/themes.dart';
import 'package:my_saloon/widgets/common_widgets.dart';

import 'services/detailPageController.dart';
import 'widgets/detail_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class _MyHomePageState extends State<MyHomePage> {
  late List<MainModel> salonlist;
  late final Future<List<MainModel>> future;
  late DetailPageController detailPageController =
      Get.put(DetailPageController());

  @override
  void initState() {
    super.initState();

    future = _loadSalons();
    // detailPageController.addToCart(
    //     "62c6cf91dab63c33a410", "62c6cfd5b96e59cdfad0", true, true, "timeSlot");
  }

  Future<List<MainModel>> _loadSalons() async {
    Client client = Client(endPoint: AppConstsnts.endPoint);
    client.setProject(AppConstsnts.project);
    client.setSelfSigned(status: true);

    // Account account = Account(client);
    //
    // await account
    //     .create(
    //     userId: 'unique()',
    //     email: 'harshilvekariya@gmail.com',
    //     password: 'password',
    //     name: 'My Name'
    // );
    salonlist = <MainModel>[];

    final databases = Database(client);
    try {
      final res = await databases.listDocuments(
          collectionId: AppConstsnts.saloncollection);
      print(res.documents[0].$id);
      // print(res.toMap().values);
      salonlist = res.convertTo<MainModel>(
          (p0) => MainModel.fromJson(p0 as Map<String, dynamic>));

      print(salonlist![0].toJson());

      // final services = await databases.listDocuments(
      //     collectionId: "62c6c30f7c339cbabbac",
      //     queries: [Query.equal('salon_id', '62c6cf91dab63c33a410')]);

      // print("rgergrgrgrgrg ${services.toMap().values}");

    } on AppwriteException catch (e) {
      print(e);
    }
    return salonlist;
  }

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  String reason = '';
  final CarouselController _controller = CarouselController();

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      reason = changeReason.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyThemes.darkblack,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: MyThemes.darkblack,
                foregroundColor: MyThemes.darkblack,
                pinned: false,
                floating: true,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Container(
                    color: MyThemes.darkblack,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(
                                    CupertinoIcons.home,
                                    color: MyThemes.purple,
                                    size: 20.0,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Home",
                                    style: TextStyle(
                                        color: MyThemes.txtwhite,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    CupertinoIcons.chevron_down,
                                    color: MyThemes.txtwhite,
                                    size: 18.0,
                                  )
                                ],
                              ),
                              Text("110, Thakordwar Soc, Simadagam, surat")
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              CupertinoIcons.person_crop_circle,
                              size: 28.0,
                              color: MyThemes.txtdarkwhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverAppBar(
                backgroundColor: MyThemes.darkblack,
                foregroundColor: MyThemes.darkblack,
                pinned: true,
                floating: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Container(
                    color: MyThemes.darkblack,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: MyThemes.darkblack,
                            borderOnForeground: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: MyThemes.purple)),
                            child: Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 6, 16, 6),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Search Your Favourite Saloon!!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: MyThemes.txtdarkwhite,
                                            fontSize: 15),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        CupertinoIcons.search,
                                        size: 22.0,
                                        color: MyThemes.txtdarkwhite,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    items: imageSliders,
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      height: 200,
                      aspectRatio: 16 / 9,
                      onPageChanged: onPageChange,
                      autoPlay: true,
                    ),
                    carouselController: _controller,
                  ),
                  GetBuilder<DetailPageController>(
                    builder: (controller) {
                      bool isAdded =
                          controller.getCartList("62c6cf91dab63c33a410");
                      if (isAdded) {
                        return Text(controller.cartlist.toString());
                      }
                      return Text("null");
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 0, 8),
                    child: Text(
                      "Categories",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  // ListView.builder(
                  //     itemCount: 5, itemBuilder: (context, index) {
                  //   return Horizontal_listview_item();
                  // })
                ],
              )),
              SliverToBoxAdapter(
                child: Container(
                  // color: Colors.deepPurple,
                  height: 187.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Horizontal_listview_item();
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 0, 8),
                  child: Text(
                    "Saloon To EXPLORE",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              FutureBuilder<List<MainModel>>(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            double rating = snapshot.data![index].rating
                                    .map((e) => int.parse(e))
                                    .toList()
                                    .reduce((a, b) => a + b) /
                                snapshot.data![index].rating.length;
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => detail_page(
                                            salonid: snapshot.data![index].id,
                                            salonmodel: snapshot.data![index]),
                                      ));
                                },
                                child: Vertical_listview_item(
                                    image: snapshot.data![index].image,
                                    title: snapshot.data![index].salonName,
                                    rating:
                                        "${rating.toStringAsFixed(2).toString()} (${snapshot.data![index].rating.length.toString()}) + Rating",
                                    // "${snapshot.data![index].rating.map((e) => e).reduce((value, element) => value + element) / snapshot.data![index].rating.length}",
                                    address: snapshot.data![index].address),
                              ),
                            );
                          },
                          childCount: snapshot.data!.length,
                        ), //SliverChildBuildDelegate
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
