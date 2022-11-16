import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:music_world_app/screen/verify_number/view/verify_done.dart';
import 'package:music_world_app/util/colors.dart';
import 'package:music_world_app/util/text_style.dart';

import '../../../components/button.dart';
import '../../../util/globals.dart';
import '../../../util/navigate.dart';
import '../../../util/string.dart';

class Otp extends StatefulWidget{
  const Otp({Key? key}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigate.popPage(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.06, top: screenHeight * 0.0345),
              child: SizedBox(
                width: screenWidth * 0.6587,
                child: Text(
                  verifyNumberString,
                  style: titleMedium3.copyWith(
                    color: textPrimaryColor,
                    height: 1.3,
                  ),
                ),
              )

          ),
          SizedBox(height: screenHeight * 0.1576,),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.144,right: screenWidth * 0.144),
            child: VerificationCodeInput(
              keyboardType: TextInputType.number,
              length: 4,
              itemSize: 50,
              autofocus: true,
              textStyle: title2.copyWith(color: primaryColor),
              onCompleted: (String value) {
                //...
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.14267,right: screenWidth * 0.14267, top: screenHeight * 0.08,),
            child: Button(
              text: continueString,
              radius: 0,
              onPressed: () {
                Navigate.pushPage(context, const VerifyDonePage());
              }, minimumSize: screenHeight * 0.0566,
            ),
          ),
          SizedBox(height: screenHeight * 0.043,),
          Center(
            child: SizedBox(
              width: screenWidth * 0.17,
              child: Text(
                resentCodeString,
                style: labelBold1.copyWith(
                  color: primaryColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

}

class VerificationCodeInput extends StatefulWidget {
  final ValueChanged<String>? onCompleted;
  final TextInputType keyboardType;
  final int length;
  final double itemSize;
  final TextStyle textStyle;
  final bool autofocus;
  final bool forceUpperCase;
  const VerificationCodeInput(
      {Key? key,
        this.forceUpperCase = true,
        this.onCompleted,
        this.keyboardType = TextInputType.number,
        this.length = 4,
        this.itemSize = 50,
        this.textStyle = const TextStyle(fontSize: 25.0, color: Colors.black),
        this.autofocus = true})
      : assert(length > 0),
        assert(itemSize > 0),
        super(key: key);

  @override
  _VerificationCodeInputState createState() =>
      _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  final List<FocusNode> _listFocusNode = <FocusNode>[];
  final List<TextEditingController> _listControllerText =
  <TextEditingController>[];
  final List<String> _code = [];
  int _currentIndex = 0;
  @override
  void initState() {
    if (_listFocusNode.isEmpty) {
      for (var i = 0; i < widget.length; i++) {
        _listFocusNode.add(FocusNode());
        _listControllerText.add(TextEditingController());
        _code.add(' ');
      }
    }
    super.initState();
  }

  String _getInputVerify() {
    String verifycode = '';
    for (var i = 0; i < widget.length; i++) {
      for (var index = 0; index < _listControllerText[i].text.length; index++) {
        if (_listControllerText[i].text[index] != ' ') {
          verifycode += _listControllerText[i].text[index];
        }
      }
    }
    return verifycode;
  }

  Widget _buildInputItem(int index) {
    return TextField(
      keyboardType: widget.keyboardType,
      maxLines: 1,
      maxLength: 2,
      focusNode: _listFocusNode[index],
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 4),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 4),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: neutralColor1, width: 4),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: neutralColor3, width: 4),
          ),
          enabled: _currentIndex == index,
          counterText: "",
          errorMaxLines: 1,
          fillColor: primaryColor),
      onChanged: (String value) {
        if (value.length > 1 && index < widget.length ||
            index == 0 && value.isNotEmpty) {
          if (index == widget.length - 1) {
            widget.onCompleted!(_getInputVerify());
            return;
          }
          if (_listControllerText[index + 1].value.text.isEmpty) {
            _listControllerText[index + 1].value =
            const TextEditingValue(text: " ");
          }
          if (value.length == 2) {
            if (value[0] != _code[index]) {
              _code[index] = value[0];
            } else if (value[1] != _code[index]) {
              _code[index] = value[1];
            }
            if (value[0] == " ") {
              _code[index] = value[1];
            }
            _listControllerText[index].text = _code[index];
          }
          _next(index);

          return;
        }
        if (value.isEmpty && index >= 0) {
          if (_listControllerText[index - 1].value.text.isEmpty) {
            _listControllerText[index - 1].value =
            const TextEditingValue(text: " ");
          }
          _prev(index);
        }
      },
      controller: _listControllerText[index],
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      autocorrect: false,
      textAlign: TextAlign.center,
      autofocus: widget.autofocus,
      style: widget.textStyle,
      inputFormatters: widget.forceUpperCase ? [UpperCaseTextFormatter()] : [],
      cursorColor: primaryColor,
    );
  }

  void _next(int index) {
    if (index != widget.length) {
      setState(() {
        _currentIndex = index + 1;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_listFocusNode[index + 1]);
      });
    }
  }

  void _prev(int index) {
    if (index > 0) {
      setState(() {
        if (_listControllerText[index].text.isEmpty) {
          _listControllerText[index - 1].text = ' ';
        }
        _currentIndex = index - 1;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_listFocusNode[index - 1]);
      });
    }
  }

  List<Widget> _buildListWidget() {
    List<Widget> listWidget = [];
    for (int index = 0; index < widget.length; index++) {
      double left = (index == 0) ? 0.0 : (widget.itemSize * 0.66);
      listWidget.add(Container(
          height: widget.itemSize,
          width: widget.itemSize,
          margin: EdgeInsets.only(left: left),
          child: _buildInputItem(index)));
    }
    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildListWidget(),
        ));
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}