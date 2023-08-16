import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pitch_me_app/devApi%20Service/get_api.dart';

import '../../devApi Service/post_api.dart';

class NeedPageController extends GetxController {
  TextEditingController textController = TextEditingController();
  RxString customText = ''.obs;
  RxString itemType = ''.obs;

  RxInt checkColor = 0.obs;

  RxBool isChack = false.obs;
  RxBool hideList = false.obs;
  RxBool isLoading = false.obs;

  RxList searchingItems = RxList([]);
  RxList searchingSelectedItems = RxList([]);
  RxList selectedNeedType = RxList([].obs);

  List data = [
    {'value': 'Skill', 'isSelected': false},
    {'value': 'Service', 'isSelected': false},
    {'value': 'Connection', 'isSelected': false},
  ];
  List data2 = [
    {'value': 'Take Over', 'isSelected': false},
    {'value': 'Buy Out', 'isSelected': false},
  ];
  onselectValue(value) {
    for (var i = 0; i < data.length; i++) {
      if (value == i) {
        // log(data[i].toString());
        if (data[i]['isSelected'] != true) {
          selectedNeedType.value.add(data[i]);
          data[i]['isSelected'] = true;
          data2[0]['isSelected'] = false;
          data2[1]['isSelected'] = false;
          selectedNeedType.value.remove(data2[0]);
          selectedNeedType.value.remove(data2[1]);
          getServiceApiCall(data[i]['value'], data[i]['isSelected']);
          update();
        } else {
          data[i]['isSelected'] = false;
          selectedNeedType.value.remove(data[i]);
          getServiceApiCall(data[i]['value'], data[i]['isSelected']);
          update();
        }
      }
    }
    update();
  }

  onselectValue2(value, secondIndex) {
    for (var i = 0; i < data2.length; i++) {
      if (value == i) {
        // log(data[i].toString());
        if (data2[i]['isSelected'] != true) {
          selectedNeedType.value.add(data2[i]);
          data2[i]['isSelected'] = true;
          data2[secondIndex]['isSelected'] = false;
          selectedNeedType.value.remove(data2[secondIndex]);
          selectedNeedType.value.remove(data[0]);
          selectedNeedType.value.remove(data[1]);
          selectedNeedType.value.remove(data[2]);
          isChack.value = true;
          data[0]['isSelected'] = false;
          data[1]['isSelected'] = false;
          data[2]['isSelected'] = false;
          update();
        } else {
          data2[i]['isSelected'] = false;
          selectedNeedType.value.remove(data2[i]);
          isChack.value = false;
          update();
        }
      }
    }
    update();
  }

  Future<List> getServiceApiCall(type, isChecked) async {
    isLoading.value = true;

    try {
      await GetApiService().getServiceApi().then((value) {
        var data = value.result.docs;
        for (var i = 0; i < data.length; i++) {
          if (isChecked == true) {
            if (type == data[i].type) {
              // log('add = ' + data[i].type.toString());
              searchingItems.add(data[i].name);
              update();
            }
          } else {
            if (type == data[i].type) {
              searchingItems.remove(data[i].name);
              //log('remove = ' + data[i].type.toString());
              update();
            }
          }
        }

        //log(searchingItems.toString());

        isLoading.value = false;
      });
    } catch (e) {
      //log('check = ' + e.toString());
      searchingItems.value = [];
      isLoading.value = false;
    }
    return searchingItems;
  }

  Future postServiceApiCall(type, body) async {
    try {
      await PostApiServer().postServiceApi(body).then((value) {
        if (value != null) {
          if (value['message'] != null) {
            Fluttertoast.showToast(
                msg: value['message'], gravity: ToastGravity.CENTER);
          }
        }
        getServiceApiCall(type, true);
      });
    } catch (e) {}
  }
}
