import 'package:flutter/material.dart';

/// JUIDropdownController use to show and hide drop-down menus.
/// Used for GZXDropdownHeader and JUIDropdown passing[dropdownMenuTop], [_showedIndex], [_isShow] and [_isShowHideAnimation].
class JUIDropdownController extends ChangeNotifier {
  GlobalKey? stackKey;

  /// [dropdownMenuTop] that the JUIDropdown top edge is inset from the top of the stack.
  ///
  /// Since the JUIDropdown actually returns a Positioned widget, the JUIDropdown must be inside the Stack
  /// vertically.
  double? dropdownMenuTop;

  /// Current or last dropdown menu index, default is 0.
  int? _showedIndex = 0;

  /// Whether to display a dropdown menu.
  bool _isShow = false;

  /// Whether to display animations when hiding dropdown menu.
  bool _isShowHideAnimation = false;

  JUIDropdownController({this.stackKey});

  /// Use to display JUIDropdown specified dropdown menu index.
  void show(int index, {GlobalKey? behind, bool hideWhenShowed = true}) {
    if (index == _showedIndex) {
      if (_isShow) {
        hide();
        return;
      }
    } else {
      if (_isShow) {
        hide(isShowHideAnimation: false);
      }
    }

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

      dropdownMenuTop = size.height + position.dy;
    } else {
      dropdownMenuTop = 0;
    }

    notifyListeners();
  }

  /// Use to hide JUIDropdown. If you don't need to show the hidden animation, [isShowHideAnimation] pass in false, Like when you click on another GZXDropdownHeaderItem.
  void hide({bool isShowHideAnimation = true}) {
    _isShowHideAnimation = isShowHideAnimation;
    _isShow = false;
    notifyListeners();
  }
}

/// Information about the dropdown menu widget, such as the height of the drop down menu to be displayed.
class JUIDropdownBuilder {
  /// A dropdown menu displays the widget.
  final Widget dropDownWidget;

  /// Dropdown menu height.
  final double dropDownHeight;

  JUIDropdownBuilder({
    required this.dropDownWidget,
    required this.dropDownHeight,
  });
}

typedef DropdownMenuChange = void Function(bool isShow, int? index);

/// Dropdown menu widget.
class JUIDropdown extends StatefulWidget {
  final JUIDropdownController controller;
  final List<JUIDropdownBuilder> builders;
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
    required this.builders,
    this.animationMilliseconds = 500,
    this.maskColor = const Color.fromRGBO(0, 0, 0, 0.5),
    this.dropdownChanging,
    this.dropdownChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _JUIDropdownState();
  }
}

class _JUIDropdownState extends State<JUIDropdown>
    with SingleTickerProviderStateMixin {
  bool _isShowDropDownItemWidget = false;
  bool _isShowMask = false;
  bool _isControllerDisposed = false;
  Animation<double>? _animation;
  late AnimationController _controller;

  late double _maskColorOpacity;

  double? _dropDownHeight;

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
//    print('_JUIDropdownState._onController ${widget.controller.menuIndex}');

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
    if (_currentShowedIndex! >= widget.builders.length) {
      return;
    }

    _isShowDropDownItemWidget = !_isShowDropDownItemWidget;
    widget.dropdownChanging
        ?.call(_isShowDropDownItemWidget, _currentShowedIndex);

    if (!_isShowMask) {
      _isShowMask = true;
    }

    _dropDownHeight = widget.builders[_currentShowedIndex!].dropDownHeight;

    _animation?.removeListener(_animationListener);
    _animation?.removeStatusListener(_animationStatusListener);
    _animation = Tween(begin: 0.0, end: _dropDownHeight).animate(_controller)
      ..addListener(_animationListener)
      ..addStatusListener(_animationStatusListener);

    if (_isControllerDisposed) return;

//    print('${widget.controller.isShow}');

    if (widget.controller._isShow) {
      _controller.forward();
    } else if (widget.controller._isShowHideAnimation) {
      _controller.reverse();
    } else {
      _controller.value = 0;
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
    var heightScale = _animation!.value / _dropDownHeight!;
    _maskColorOpacity = widget.maskColor.opacity * heightScale;
//    print('$_maskColorOpacity');
    //这行如果不写，没有动画效果
    setState(() {});
  }

  Widget _mask() {
    if (_isShowMask) {
      return GestureDetector(
        onTap: () {
          widget.controller.hide();
        },
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: widget.maskColor.withOpacity(_maskColorOpacity),
//          color: widget.maskColor,
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget _buildDropDownWidget() {
    int? menuIndex = widget.controller._showedIndex;

    if (menuIndex == null || menuIndex >= widget.builders.length) {
      return Container();
    }

    return Positioned(
        top: widget.controller.dropdownMenuTop,
        left: 0,
        right: 0,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              width: double.infinity,
              height: _animation == null ? 0 : _animation!.value,
              child: widget.builders[menuIndex].dropDownWidget,
            ),
            _mask(),
          ],
        ));
  }
}
