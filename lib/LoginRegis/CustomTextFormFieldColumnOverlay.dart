import 'package:flutter/material.dart';

import 'CustomFormFields.dart';

class CustomTextFormFieldColumnOverlay extends StatefulWidget {
  CustomTextFormFieldColumnOverlay({
    required this.title,
    required this.controller,
    required this.maxLine,
    this.onTap,
    required this.items,
    this.height,
  });
  final title;
  final controller;
  final maxLine;
  final onTap;
  final List items;
  final height;
  @override
  _CustomTextFormFieldColumnOverlayState createState() => _CustomTextFormFieldColumnOverlayState();
}

class _CustomTextFormFieldColumnOverlayState extends State<CustomTextFormFieldColumnOverlay> {
  late final FocusNode _focusNode;
  TextEditingController controller = TextEditingController();
  late OverlayEntry _overlayEntry;
  var filteredHeight;

  final LayerLink _layerLink = LayerLink();

  List itemsName = [];
  var itemId;
  late String buttonText;
  GlobalKey keyTextField = GlobalKey();
  var size;

  OverlayEntry _createOverlayEntry(screenSize) {
    return OverlayEntry(
        builder: (context) => Positioned(
              bottom: 0.0,
              right: 0.0,
              width: size,
              height: filteredHeight ?? widget.height ?? 150,
              child: CompositedTransformFollower(
                link: this._layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, 90.0),
                child: Material(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Container(
                    width: size,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: itemsName.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            itemsName[index],
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            //normal
                            widget.onTap(itemsName[index]);

                            _focusNode.unfocus();
                            widget.controller.text = itemsName[index];

                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    itemId = null;
    itemsName = [];

    itemsName = widget.items;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry(MediaQuery.of(context).size);
        Overlay.of(context)!.insert(this._overlayEntry);
      } else {
        this._overlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: this._layerLink,
        child: LayoutBuilder(
          builder: (c, cc) {
            size = cc.maxWidth;
            return CustomTextFormFieldColumn(
              key: keyTextField,
              focusNode: _focusNode,
              controller: widget.controller,
              maxLine: widget.maxLine,
              title: widget.title,
              onChange: (v) {
                itemsName = [];
                if (v.isEmpty) {
                  filteredHeight = null;

                  itemsName = widget.items;
                } else {
                  itemsName = [];

                  for (var d in widget.items) {
                    if (d.toString().toLowerCase().contains(v.toString().toLowerCase())) {
                      itemsName.add(d);
                    }
                  }

                  filteredHeight = (itemsName.length * 50) > 170 ? 170 : itemsName.length * 50;
                }
                setState(() {});
              },
            );
          },
        ));
  }
}
