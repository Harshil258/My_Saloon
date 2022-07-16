import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  const Horizontal_listview_item({Key? key}) : super(key: key);

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
            // Container(
            //   height: 150,
            //   width: 110,
            //   decoration:
            //       BoxDecoration(borderRadius: BorderRadius.circular(20)),
            //   child: Image.network(
            //     "https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg",
            //     fit: BoxFit.cover,
            //   ),
            // ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                "https://images.pexels.com/photos/4625616/pexels-photo-4625616.jpeg?cs=srgb&dl=pexels-antoni-shkraba-4625616.jpg&fm=jpg",
                fit: BoxFit.cover,
                height: 145,
                width: 110,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                "Men Hair Cutting",
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
                    widget.address,
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
      this.imagelink})
      : super(key: key);

  final String Name;
  final int Price;
  final String? Description;
  final String? imagelink;

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
          widget.imagelink!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    "${widget.imagelink}",
                    fit: BoxFit.cover,
                    height: 110,
                    width: 110,
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
