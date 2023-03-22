import 'package:flutter/material.dart';

/// JUIDropdownController use to show and hide drop-down menus.
/// Used for GZXDropdownHeader and JUIDropdown passing[dropdownTop], [_showedIndex], [_isShow] and [_isAnimation].
class JUIDropdownController extends ChangeNotifier {
  GlobalKey? stackKey;

  /// [dropdownTop] that the JUIDropdown top edge is inset from the top of the stack.
  ///
  /// Since the JUIDropdown actually returns a Positioned widget, the JUIDropdown must be inside the Stack
  /// vertically.
  double? dropdownTop;

  /// 有值时，动画效果只有渐变，为空时，有下拉动画，是否设置根据内容是否超过屏幕高度
  double? positionHeight;

  /// Current or last dropdown menu index, default is 0.
  int? _showedIndex = 0;
  int? _lastShowedIndex;

  /// Whether to display a dropdown menu.
  bool _isShow = false;

  /// Whether to display animations when hiding dropdown menu.
  bool _isAnimation = false;

  JUIDropdownController({this.stackKey});

  /// Use to display JUIDropdown specified dropdown menu index.
  /// 返回值表示：最终是显示还是隐藏
  bool show(int index, {GlobalKey? behind, bool hideWhenShowed = true}) {
    if (index == _showedIndex) {
      if (_isShow) {
        hide();
        return false;
      }
    } else {
      if (_isShow) {
        hide(isAnimation: false);
      }
    }

    _lastShowedIndex = _showedIndex;
    _isShow = true;
    _showedIndex = index;

    if (behind != null && stackKey != null) {
      final RenderBox? overlay =
          stackKey!.currentContext!.findRenderObject() as RenderBox?;

      final RenderBox dropDownItemRenderBox =
          behind.currentContext!.findRenderObject() as RenderBox;

      var position =
          dropDownItemRenderBox.localToGlobal(Offset.zero, ancestor: overlay);
//        print("POSITION : $position ");
      var size = dropDownItemRenderBox.size;
//        print("SIZE : $size");
      dropdownTop = size.height + position.dy;
    } else {
      dropdownTop = 0;
    }

    notifyListeners();
    return true;
  }

  /// Use to hide JUIDropdown. If you don't need to show the hidden animation, [isShowHideAnimation] pass in false, Like when you click on another GZXDropdownHeaderItem.
  void hide({bool isAnimation = true}) {
    _isAnimation = isAnimation;
    _isShow = false;
    notifyListeners();
    _lastShowedIndex = null;
  }
}

typedef DropdownMenuChange = void Function(bool isShow, int? index);

/// Dropdown menu widget.
class JUIDropdown extends StatefulWidget {
  final JUIDropdownController controller;
  final List<Widget> widgets;
  final int animationMilliseconds;
  final Color maskColor;

  /// Called when dropdown menu start showing or hiding.
  final DropdownMenuChange? dropdownChanging;

  /// Called when dropdown menu has been shown or hidden.
  final DropdownMenuChange? dropdownChanged;

  /// Creates a dropdown menu widget.
  /// The widget must be inside the Stack because the widget is a Positioned.
  const JUIDropdown({
    Key? key,
    required this.controller,
    required this.widgets,
    this.animationMilliseconds = 250,
    this.maskColor = const Color.fromRGBO(0, 0, 0, 0.5),
    this.dropdownChanging,
    this.dropdownChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _JUIDropdownState();
  }

  static Widget container(
      {Widget? child,
      EdgeInsets? padding,
      double? height,
      double? width = double.infinity}) {
    return Container(
      padding: padding,
      height: height,
      width: width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: child,
    );
  }
}

class _JUIDropdownState extends State<JUIDropdown>
    with SingleTickerProviderStateMixin {
  bool _isShowDropDownItemWidget = false;
  bool _isShowMask = false;
  bool _isControllerDisposed = false;
  Animation<double>? _animation;
  late AnimationController _controller;

  int? _currentShowedIndex;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onController);
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.animationMilliseconds),
        vsync: this);
  }

  _onController() {
//    print('_JUIDropdownState._onController ${widget.controller.showedIndex}');

    _showDropDownItemWidget();
  }

  @override
  Widget build(BuildContext context) {
    _controller.duration = Duration(milliseconds: widget.animationMilliseconds);
    return _buildDropDownWidget();
  }

  @override
  dispose() {
    _animation?.removeListener(_animationListener);
    _animation?.removeStatusListener(_animationStatusListener);
    widget.controller.removeListener(_onController);
    _controller.dispose();
    _isControllerDisposed = true;
    super.dispose();
  }

  _showDropDownItemWidget() {
    _currentShowedIndex = widget.controller._showedIndex;
    if (_currentShowedIndex! >= widget.widgets.length) {
      return;
    }

    setState(() {});
    _isShowDropDownItemWidget = !_isShowDropDownItemWidget;
    widget.dropdownChanging
        ?.call(_isShowDropDownItemWidget, _currentShowedIndex);

    if (!_isShowMask) {
      _isShowMask = true;
    }

    _animation?.removeListener(_animationListener);
    _animation?.removeStatusListener(_animationStatusListener);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(_animationListener)
      ..addStatusListener(_animationStatusListener);

    if (_isControllerDisposed) return;

//    print('${widget.controller.isShow}');

    if (widget.controller._isShow) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _animationStatusListener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
        _isShowMask = false;
        widget.dropdownChanged?.call(false, _currentShowedIndex);
        break;
      case AnimationStatus.forward:
        // TODO: Handle this case.
        break;
      case AnimationStatus.reverse:
        // TODO: Handle this case.
        break;
      case AnimationStatus.completed:
        widget.dropdownChanged?.call(true, _currentShowedIndex);
        break;
    }
  }

  void _animationListener() {
    //这行如果不写，没有动画效果
    setState(() {});
  }

  Widget _mask() {
    if (_isShowMask) {
      return FadeTransition(
        opacity: _animation!,
        child: GestureDetector(
          onTap: () {
            widget.controller.hide();
          },
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            color: widget.maskColor,
            //          color: widget.maskColor,
          ),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget _buildDropDownWidget() {
    if (_currentShowedIndex == null ||
        _currentShowedIndex! >= widget.widgets.length) {
      return Container();
    }

    // if (!widget.controller._isShow) {
    //   return Container();
    // }

    Widget lastShowedWidget() {
      return Container();
    }

    return Positioned(
        top: widget.controller.dropdownTop,
        left: 0,
        right: 0,
        height: widget.controller.positionHeight,
        child: Stack(
          children: [
            _mask(),
            AnimatedCrossFade(
                firstChild: lastShowedWidget(),
                duration: Duration(milliseconds: widget.animationMilliseconds),
                crossFadeState: widget.controller._isShow
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                secondChild: widget.widgets[_currentShowedIndex!]),

            // Container(
            //   color: Colors.white,
            //   width: double.infinity,
            //   height: _animation == null ? 0 : _animation!.value * 2,
            //   child: widget.builders[showedIndex].dropDownWidget,
            // ),
          ],
        ));
  }
}
