import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xff222747),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.grey.shade800,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(horizontal: 56, vertical: 16),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        cardColor: Color(0xff444968),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var assetAmount = 0;
  var liabilitiesAmount = 0;

  void setAssetAmmount(int asset) {
    setState(() {
      assetAmount = asset;
    });
  }

  void setLiabilitiesAmount(int liabilities) {
    setState(() {
      liabilitiesAmount = liabilities;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 48),
                Text(
                  'Add your assets and liabilities',
                  style: theme.textTheme.headline5,
                ),
                SizedBox(height: 102),
                AmmountCard(
                  title: 'Assests',
                  ammount: assetAmount,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return NumberInputDialog(
                        onTap: setAssetAmmount,
                        title: 'Assets',
                        ammount: assetAmount,
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                AmmountCard(
                  title: 'Liabilities',
                  ammount: liabilitiesAmount,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return NumberInputDialog(
                        onTap: setLiabilitiesAmount,
                        title: 'Liabilities',
                        ammount: liabilitiesAmount,
                      );
                    },
                  ),
                ),
                SizedBox(height: 102),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        NetWorthPage(amount: assetAmount - liabilitiesAmount),
                    fullscreenDialog: true,
                  )),
                  child: Text(
                    'Calculate',
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AmmountCard extends StatelessWidget {
  const AmmountCard({
    Key? key,
    required this.title,
    required this.ammount,
    this.onTap,
  }) : super(key: key);

  final String title;
  final int ammount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Container(
      height: 148,
      width: size.width * 0.8,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyText1,
              ),
              SizedBox(height: 4),
              Text(
                ammount.toString(),
                style: theme.textTheme.headline6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberInputDialog extends StatefulWidget {
  NumberInputDialog({
    Key? key,
    required this.onTap,
    required this.title,
    required this.ammount,
  }) : super(key: key);

  final Function(int) onTap;
  final String title;
  final int ammount;

  @override
  _NumberInputDialogState createState() => _NumberInputDialogState();
}

class _NumberInputDialogState extends State<NumberInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.ammount == 0 ? '' : widget.ammount.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    final outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade600),
    );
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(20),
        width: screenSize.width * 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.headline6
                  ?.copyWith(color: Colors.grey.shade800),
            ),
            SizedBox(height: 24),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autofocus: true,
              style: TextStyle(color: Colors.grey.shade600),
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  focusedBorder: outlineInputBorder,
                  enabledBorder: outlineInputBorder,
                  labelText: 'Write ammount'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).cardColor,
                padding: EdgeInsets.symmetric(horizontal: 56),
              ),
              onPressed: () {
                widget.onTap(int.parse(_controller.text));
                Navigator.of(context).pop();
              },
              child: Text(
                'Done',
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NetWorthPage extends StatefulWidget {
  NetWorthPage({
    Key? key,
    required this.amount,
  }) : super(key: key);

  final amount;

  @override
  _NetWorthPageState createState() => _NetWorthPageState();
}

class _NetWorthPageState extends State<NetWorthPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  late final Animation<int> _animation;

  @override
  void initState() {
    _animation = IntTween(
      begin: 0,
      end: widget.amount,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<int>(
                valueListenable: _animation,
                builder: (context, value, child) {
                  return Text(
                    'Your total net worth is $value',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  );
                },
              )
            ],
          ),
        ));
  }
}
