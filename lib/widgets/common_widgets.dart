import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_saloon/models/servicemodel.dart';
import 'package:readmore/readmore.dart';

import '../themes.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      required this.id,
      required this.hinttxt,
      required this.icon,
      required this.isObscure})
      : super(key: key);

  final String id;
  final String hinttxt;
  final Icon icon;
  final bool isObscure;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool defaultshow = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextFormField(
        validator: (text) {
          if (text == null || text.isEmpty) {
            return "${widget.id} can not be Empty!";
          }
          return null;
        },
        obscureText: defaultshow,
        style: TextStyle(color: MyThemes.txtwhite),
        cursorColor: MyThemes.txtwhite,
        decoration: InputDecoration(
          labelText: widget.id,
          labelStyle: TextStyle(color: MyThemes.txtdarkwhite),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: MyThemes.txtwhite,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: MyThemes.txtwhite,
            ),
          ),
          suffixIcon: widget.isObscure
              ? IconButton(
                  icon: defaultshow
                      ? Icon(
                          CupertinoIcons.eye_slash_fill,
                          color: MyThemes.txtwhite,
                        )
                      : Icon(CupertinoIcons.eye_solid,
                          color: MyThemes.txtwhite),
                  onPressed: () {
                    setState(() {
                      if (defaultshow == true) {
                        defaultshow = false;
                      } else {
                        defaultshow = true;
                      }
                    });
                  },
                )
              : null,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: MyThemes.txtdarkwhite,
            ),
          ),
          prefixIcon: widget.icon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          hintText: widget.hinttxt,
          hintStyle: TextStyle(color: MyThemes.txtdarkwhite),
        ),
      ),
    );
  }
}

class Horizontal_listview_item extends StatefulWidget {
  const Horizontal_listview_item(this.imageurl, this.title, {Key? key})
      : super(key: key);

  final String imageurl;
  final String title;

  @override
  State<Horizontal_listview_item> createState() =>
      _Horizontal_listview_itemState();
}

class _Horizontal_listview_itemState extends State<Horizontal_listview_item> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Container(
        // color: Colors.deepPurple,
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: "${widget.imageurl}",
                placeholder: (context, url) =>
                    CircularProgressIndicator(color: MyThemes.purple),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                height: 145,
                width: 110,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Vertical_listview_item extends StatefulWidget {
  const Vertical_listview_item(
      {Key? key,
      required this.image,
      required this.title,
      required this.rating,
      required this.address})
      : super(key: key);

  final String image;
  final String title;
  final String rating;
  final String address;

  @override
  State<Vertical_listview_item> createState() => _Vertical_listview_itemState();
}

class _Vertical_listview_itemState extends State<Vertical_listview_item> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              widget.image,
              fit: BoxFit.cover,
              height: 145,
              width: 110,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 16, overflow: TextOverflow.ellipsis),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.star_circle,
                        color: MyThemes.purple,
                        size: 20.0,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.rating,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 13, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  Text(
                    (widget.address.toString() == "null") ? "" : widget.address,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: 13, overflow: TextOverflow.ellipsis),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class custom_item_view extends StatefulWidget {
  const custom_item_view(
      {Key? key,
      required this.Name,
      required this.Price,
      this.Description,
      this.imagelink,
      required this.addedOrNot,
      this.onTapOnAddCart})
      : super(key: key);

  final String Name;
  final int Price;
  final String? Description;
  final String? imagelink;
  final bool addedOrNot;
  final GestureTapCallback? onTapOnAddCart;

  @override
  State<custom_item_view> createState() => _custom_item_viewState();
}

class _custom_item_viewState extends State<custom_item_view> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.Name}",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        color: MyThemes.txtwhite),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "${widget.Price} ₹",
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        color: MyThemes.txtwhite),
                  ),
                  SizedBox(height: 2),
                  widget.Description!.isNotEmpty
                      ? ReadMoreText(
                          "${widget.Description}",
                          textAlign: TextAlign.start,
                          trimLines: 2,
                          colorClickableText: MyThemes.purple,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' Show more',
                          trimExpandedText: ' Show less',
                          style: TextStyle(
                              fontSize: 13,
                              overflow: TextOverflow.ellipsis,
                              color: MyThemes.txtdarkwhite),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
          Stack(
            children: [
              widget.imagelink!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: "${widget.imagelink}",
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        height: 120,
                        width: 110,
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(
                      height: 50,
                      width: 110,
                    ),
              Positioned(
                bottom: -5.0,
                right: 0.0,
                left: 0.0,
                child: Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(0.0)),
                        onPressed: widget.onTapOnAddCart,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.addedOrNot
                                ? Icon(CupertinoIcons.minus)
                                : Icon(CupertinoIcons.add),
                            widget.addedOrNot
                                ? Text(
                                    "REMOVE",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  )
                                : Text("ADD",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class Final_cart extends StatefulWidget {
  const Final_cart(
      {Key? key,
      required this.cartServicesForBookingpage,
      required this.removeFromCart})
      : super(key: key);

  final ServiceModel cartServicesForBookingpage;
  final GestureTapCallback? removeFromCart;

  @override
  State<Final_cart> createState() => _Final_cartState();
}

class _Final_cartState extends State<Final_cart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.cartServicesForBookingpage.title}",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis,
                              color: MyThemes.txtwhite),
                        ),
                        Text(
                          "₹ ${widget.cartServicesForBookingpage.price}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                              color: MyThemes.txtwhite),
                        ),
                      ]),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shadowColor: MyThemes.purple,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(0.0),
                      primary: MyThemes.purple),
                  onPressed: widget.removeFromCart,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 14, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.minus),
                        Text(
                          "REMOVE",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Divider(
              color: MyThemes.purple,
            ),
          ],
        ),
      ),
    );
  }
}

class Common_Widget extends StatelessWidget {
  const Common_Widget(this.name, {Key? key}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: MyThemes.purple,
        child: Container(
          width: 130,
          height: 40,
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                  color: MyThemes.txtwhite, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
