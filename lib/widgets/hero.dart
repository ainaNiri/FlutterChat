  import 'package:flutter/material.dart';
import 'package:myapp/utilities/constants.dart';
import 'package:myapp/widgets/dialog.dart';

// ignore: must_be_immutable
class ImageView extends StatefulWidget {
  dynamic image;
  String index;
  ImageView({ Key? key ,required this.image, required this.index}) : super(key: key);

  @override
  _HeroViewState createState() => _HeroViewState();
}

class _HeroViewState extends State<ImageView> with SingleTickerProviderStateMixin{

  final _transformationController = TransformationController();
  late TapDownDetails _doubleTapDetails;
  late AnimationController _animationController;
  late Animation<Matrix4> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    )..addListener(() {
        _transformationController.value = _animation.value;
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: GestureDetector(
        onDoubleTapDown: _handleDoubleTapDown,
        onDoubleTap: _handleDoubleTap,
        onLongPress: (){
          BuildDialog(context, widget.image);
        },
        child: InteractiveViewer(
          transformationController: _transformationController,
          maxScale: 4.0,
          minScale: 0.8,
          child: Center(
            child: Hero(
              tag: 'image' + widget.index,
              child: (widget.image is String) ? Image.network(widget.image) : Image.file(widget.image)
            )
          ),
        ),
      ),
    );
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    Matrix4 _endMatrix;
    Offset _position = _doubleTapDetails.localPosition;

    if (_transformationController.value != Matrix4.identity()) {
      _endMatrix = Matrix4.identity();
    } else {
      _endMatrix = Matrix4.identity()
        ..translate(-_position.dx * 2, -_position.dy * 2)
        ..scale(3.0);
    }

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: _endMatrix,
    ).animate(
      CurveTween(curve: Curves.easeOut).animate(_animationController),
    );
    _animationController.forward(from: 0);
  }
}
