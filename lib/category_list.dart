import 'package:flutter/material.dart';
import 'package:my_saloon/themes.dart';
import 'package:my_saloon/widgets/common_widgets.dart';
import 'package:my_saloon/Screens/Detail_Screen.dart';

import 'models/salonmodel.dart';

class category_list extends StatefulWidget {
  const category_list(this.future, {Key? key}) : super(key: key);
  final Future<List<SalonModel>> future;

  @override
  State<category_list> createState() => _category_listState();
}

class _category_listState extends State<category_list> {
  late List<SalonModel> salonlist;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SalonModel>>(
        future: widget.future,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("rghsarfegr ${snapshot.data.toString()}");
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  print("rghsarfegr ${snapshot.data.toString()}");
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detail_Screen(
                                  salonid: snapshot.data![index].salonId,
                                  salonmodel: snapshot.data![index]),
                            ));
                      },
                      child: Vertical_listview_item(
                          image: snapshot.data![index].image,
                          title: snapshot.data![index].salonName,
                          address: snapshot.data![index].address),
                    ),
                  );
                },
                childCount: snapshot.data!.length,
              ), //SliverChildBuildDelegate
            );
          } else {
            return SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(
                color: MyThemes.purple,
            )),
            );
          }
        });
  }
}
