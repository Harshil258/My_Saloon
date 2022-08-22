import 'package:flutter/material.dart';
import 'package:my_saloon/themes.dart';
import 'package:my_saloon/widgets/common_widgets.dart';
import 'package:my_saloon/widgets/detail_page.dart';

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
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  double rating = snapshot.data![index].rating2
                          .map((e) => e.rating)
                          .toList()
                          .reduce((a, b) => a + b) /
                      snapshot.data![index].rating2.length;
                  print("rghsarfegr ${snapshot.data.toString()}");
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => detail_page(
                                  salonid: snapshot.data![index].salonId,
                                  salonmodel: snapshot.data![index]),
                            ));
                      },
                      child: Vertical_listview_item(
                          image: snapshot.data![index].image,
                          title: snapshot.data![index].salonName,
                          rating:
                              "${rating.toStringAsFixed(2).toString()} (${snapshot.data![index].rating2.length.toString()}) + Rating",
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
              child: CircularProgressIndicator(color: MyThemes.purple),
            );
          }
        });
  }
}
