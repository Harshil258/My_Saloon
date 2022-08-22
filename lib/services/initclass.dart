import 'package:get/get.dart';
import 'package:my_saloon/services/detailPageController.dart';
import 'package:my_saloon/services/sqlServices.dart';

import 'FirebaseService.dart';
import 'itemService.dart';

Future<void> init() async{
  Get.lazyPut(() => sqlServices());
  Get.lazyPut(() => FirebaseService());
  Get.lazyPut(() => ItemService());
  Get.lazyPut(() => DetailPageController());
}