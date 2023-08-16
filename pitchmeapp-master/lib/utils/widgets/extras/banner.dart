import 'package:flutter/material.dart';
import 'package:pitch_me_app/utils/colors/colors.dart';

class BannerWidget extends StatelessWidget {
  VoidCallback onPressad;
  BannerWidget({super.key, required this.onPressad});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.10,
      child: InkWell(
        onTap: null,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: colors.bannerColor,
            ),
            child: Center(
              child: Text(
                'Banner',
                style: TextStyle(
                    color: colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
