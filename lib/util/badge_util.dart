import 'dart:ui' as ui;
import 'package:flutter/material.dart';
class Badge extends StatelessWidget {
  final double size;
  final String text;
  final Widget icon;
  Badge({String text, double size, Widget icon})
      : this.text = text ?? "",
        this.size = size ?? 40.0,
        this.icon = icon ??
            Icon(
              Icons.star,
              color: Colors.white,
              size: size * 0.7,
            );
  @override
  Widget build(BuildContext context) {
    double rectScale = 0.85;
    double paddingScale = 0.4; //kalo size 50, total padding 20, jadinya 20 / 50
    double paddingLeftScale =
    0.4; //kalo total padding 20, left 8, right 12, makanya 8 / 20
    double paddingRightScale =
    0.6; //kalo total padding 20, left 8, right 12, makanya 8 / 20
    double textScale =
    0.5; //budget untuk text di dalam rect stengahnya dari height container, untuk padding atas bawah
    double fontScale =
    1.2; //untuk font 16, heightnya 19, untuk font 90, height nya 107, jadinya 19/16 atau 107/90
    Text child = new Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: size * rectScale * textScale / fontScale),
      overflow: TextOverflow.ellipsis,
    );
    double innerTextPadding = size * paddingScale;
    double innerTextPaddingRight = innerTextPadding * paddingRightScale;
    double innerTextPaddingLeft = innerTextPadding * paddingLeftScale;
    var tp = new TextPainter(
        text: new TextSpan(text: child.data, style: child.style),
        textDirection: ui.TextDirection.ltr);
    tp.layout();
    return Stack(
      children: [
        new Container(
          width: tp.size.width + size + innerTextPadding,
          margin: EdgeInsets.symmetric(vertical: size * ((1 - rectScale) / 2)),
          height: size * rectScale,
          color: Colors.transparent,
          child: new Container(
              padding: EdgeInsets.only(
                  left: innerTextPaddingLeft + size,
                  right: innerTextPaddingRight),
              alignment: Alignment.centerRight,
              decoration: new BoxDecoration(
                  color: Color(0xff0e153a),
                  borderRadius:
                  new BorderRadius.all(Radius.circular(size * rectScale))),
              child: child),
        ),
        new Container(
          width: size,
          height: size,
          decoration: new BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          child: icon,
        ),
      ],
    );
  }
}