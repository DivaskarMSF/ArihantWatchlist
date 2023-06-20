import 'package:acml/changes/widgets/filter_bottomsheet.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  int selectedTabIndex;
  final String text;
  final VoidCallback onPress;
  bool isBtnSelected;

  CustomButton(
      {super.key,
      required this.selectedTabIndex,
      required this.onPress,
      required this.text,
      required this.isBtnSelected});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width: 150,
      height: 30,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
              side: getButtonBorder(widget.isBtnSelected),
            ),
          ),
        ),

        onPressed: widget.onPress,
        child: Text(widget.text, style: getStyle(widget.isBtnSelected)),
      ),
    );
  }

  TextStyle getStyle(bool isBtnSelected) {
    if (isBtnSelected) {
      return const TextStyle(color: Color.fromARGB(255, 10, 95, 164), fontSize: 18);
    } else {
      return const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500);
    }
  }

  BorderSide getButtonBorder(bool isBtnSelected) {
    if (isBtnSelected) {
      return const BorderSide(color: Color.fromARGB(255, 56, 139, 207));
    } else {
      return const BorderSide(color: Colors.grey);
    }
  }
}
