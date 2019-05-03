import 'package:flutter/material.dart';

class FancyFab extends StatefulWidget {

  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  FancyFab({this.onPressed, this.tooltip, this.icon});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab> with SingleTickerProviderStateMixin {
  bool isOpen = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500))
    ..addListener((){
      setState(() {});
    });
    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blueAccent,
      end: Colors.redAccent,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.00, 1.00, curve: Curves.linear,
      ),
      ));
      _translateButton = Tween<double>(
        begin: _fabHeight,
        end: -14.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.75, curve: _curve,),
      ));
      super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    !isOpen ? _animationController.forward() : _animationController.reverse();
    isOpen = !isOpen;
  }

  Widget addProduct(){
    return new Container(
      child: Hero(
        tag: 'product',
        child: FloatingActionButton(
        heroTag: 'producto',
        onPressed: (){
          animate();
          Navigator.pushNamed(context, '/createProduct');
        },
        tooltip: 'Add Producto',
        child: Icon(Icons.add_shopping_cart),
      ),
        )
    );
  }

  Widget addProveedor(){
    return Container(
      child: FloatingActionButton(
        heroTag: 'proveedor',
        onPressed: (){ 
          animate();
          Navigator.pushNamed(context, '/createProvider');
          },
        tooltip: 'add Proveedor',
        child: Icon(Icons.store),
      ),
    );
  }

  Widget addMarca(){
    return Container(
      child: FloatingActionButton(
        heroTag: 'marca',
        onPressed: (){
          animate();
          Navigator.pushNamed(context, '/createBrand');
          },
        tooltip: 'add marca',
        child: Icon(Icons.loyalty),
      ),
    );
  }

  Widget toggle(){
   return Container(
      child: FloatingActionButton(
        heroTag: 'toggle',
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
   );
  }

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(0.0, _translateButton.value *3.0, 0.0),
          child: addProduct(),
        ),
        Transform(
          transform: Matrix4.translationValues(0.0, _translateButton.value * 2.0, 0.0),
          child: addProveedor(),
        ),
        Transform(
          transform: Matrix4.translationValues(0.0, _translateButton.value, 0.0),
          child: addMarca(),
        ),
        toggle()
      ],
    );
  }
}