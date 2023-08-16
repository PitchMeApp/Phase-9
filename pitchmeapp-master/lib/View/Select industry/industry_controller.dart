import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pitch_me_app/devApi%20Service/get_api.dart';
import 'package:pitch_me_app/devApi%20Service/post_api.dart';
import 'package:pitch_me_app/models/industry_model.dart';

class InsdustryController extends GetxController {
  TextEditingController textController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool hideList = false.obs;

  late IndustryModel industryList;
  RxString selectedIndustry = ''.obs;

  RxList searchingSelectedItems = RxList([]);

  Future<IndustryModel> getIndustryApiCall() async {
    isLoading.value = true;
    try {
      await GetApiService().getIndusrtyApi().then((value) {
        industryList = value;
        isLoading.value = false;
      });
    } catch (e) {
      industryList.result.docs = [];
      isLoading.value = false;
    }
    return industryList;
  }

  Future postIndustryApiCall(industry) async {
    try {
      await PostApiServer().postIndustryApi(industry).then((value) {
        if (value != null) {
          if (value['message'] != null) {
            Fluttertoast.showToast(
                msg: value['message'], gravity: ToastGravity.CENTER);
          }
        }

        getIndustryApiCall();
      });
    } catch (e) {}
  }

  @override
  void onInit() {
    getIndustryApiCall();
    super.onInit();
  }
}
