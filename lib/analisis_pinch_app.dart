import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math';
import 'dart:ui';

class AnalisisPinchApp extends StatelessWidget {
  final model;
  AnalisisPinchApp({this.model});
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AnalisisPinchData>(
      child: MaterialApp(
        title: 'Analisis Pinch',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: MyHomePage(),
      ),
      model: model,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizing) => AnalisisPinchLayout(
        screenType: sizing,
      ),
    );
  }
}

class AnalisisPinchLayout extends StatelessWidget {
  final SizingInformation screenType;
  const AnalisisPinchLayout({this.screenType, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (screenType.isMobile) return MobileLayout();
    return WebLayout();
  }
}

class MobileLayout extends StatefulWidget {
  MobileLayout({Key key}) : super(key: key);

  @override
  _MobileLayoutState createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  PageController pageController;
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void toPage1() {
    pageController.animateToPage(
      1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeIn,
    );
  }

  void toPage2() {
    pageController.animateToPage(
      1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    //    final model =  ScopedModel.of<AnalisisPinchData>(context, rebuildOnChange: true);

    return Scaffold(
      appBar: AppBar(
        title: Text("Analisis Pinch"),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      backgroundColor: Colors.blueGrey.shade700,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey.shade100,
        currentIndex: currentPage,
        selectedItemColor: Colors.blueGrey.shade900,
        unselectedItemColor: Colors.blueGrey.shade500,
        onTap: (int page) {
          setState(() {
            currentPage = page;
            pageController.animateToPage(
              page,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree_rounded),
            activeIcon: Icon(Icons.account_tree_rounded),
            label: "Corrientes",
            tooltip: "Editar Corrientes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ac_unit_outlined),
            label: "Calores",
            tooltip: "Ver Calculos",
          ),
        ],
      ),
      floatingActionButton: CreateCurrentButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PageView(
        controller: pageController,
        children: <Widget>[
          CurrentBuilder(),
          Card(
            elevation: 0,
            margin: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            color: Colors.grey[900],
            child: CascadePainter(),
          ),
        ],
      ),
    );
  }
}

class WebLayout extends StatefulWidget {
  @override
  _WebLayoutState createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  @override
  Widget build(BuildContext context) {
    final model =
        ScopedModel.of<AnalisisPinchData>(context, rebuildOnChange: true);

    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            child: Card(
              elevation: 10,
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              color: Colors.grey[900],
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      CurrentBuilder(),
                    ],
                  )),
            ),
            flex: model.flex1.toInt(),
          ),
          VerticalDivider(
            endIndent: 0,
            indent: 0,
            width: 1,
            thickness: 1,
            color: Colors.blueGrey,
          ),
          Expanded(
            child: Card(
              elevation: 0,
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              color: Colors.grey[900],
              child: CascadePainter(),
            ),
            flex: model.flex2.toInt(),
          ),
        ],
      ),
    );
  }
}

Color bg300 = Colors.blueGrey[300];
TextStyle tsN = TextStyle(color: bg300);

class CurrentBuilder extends StatefulWidget {
  @override
  _CurrentBuilderState createState() => _CurrentBuilderState();
}

class _CurrentBuilderState extends State<CurrentBuilder> {
  @override
  Widget build(BuildContext context) {
    final model =
        ScopedModel.of<AnalisisPinchData>(context, rebuildOnChange: true);

    return ListView(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        ...model.currents.map((e) {
          return CurrentView(
            currentModel: e,
          );
        }).toList(),
      ],
    );
  }

/*
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    final model =
        ScopedModel.of<AnalisisPinchData>(context, rebuildOnChange: true);
    return CurrentView(
      animation: animation,
      currentModel: model.currents[index],
    );
  }
  */
}

class CreateCurrentButton extends StatelessWidget {
  const CreateCurrentButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onCreateCurrent() {
      showDialog(
        context: context,
        builder: (context) => AddCurrentWidget(),
      );
    }

    return Tooltip(
      message: "Añadir Corriente",
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: br10,
          color: Colors.blueGrey.shade900,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: br10,
            onTap: onCreateCurrent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.add,
                color: Colors.blueGrey.shade100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddCurrentWidget extends StatefulWidget {
  const AddCurrentWidget({
    Key key,
  }) : super(key: key);

  @override
  _AddCurrentWidgetState createState() => _AddCurrentWidgetState();
}

class _AddCurrentWidgetState extends State<AddCurrentWidget> {
  TextEditingController nameController;
  TextEditingController startTemperatureController;
  TextEditingController finalTemperatureController;
  TextEditingController calorificValueController;

  CurrentModel currentModel = CurrentModel().random();
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    startTemperatureController = TextEditingController();
    finalTemperatureController = TextEditingController();
    calorificValueController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    startTemperatureController.dispose();
    finalTemperatureController.dispose();
    calorificValueController.dispose();
    super.dispose();
  }

  void onNameEdit(String newName) {
    setState(() {
      currentModel.changeName(newName);
    });
  }

  void onStartTemperatureEdit(String newTemperature) {
    setState(() {
      double newT = double.tryParse(newTemperature);
      if (newT != null) {
        currentModel.changeSourceTemperature(newT);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Temperatura Invalida"),
          ),
        );
      }
    });
  }

  void onFinalTemperatureEdit(String newTemperature) {
    setState(() {
      double newT = double.tryParse(newTemperature);
      if (newT != null) {
        currentModel.changeTargetTemperature(newT);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Temperatura Invalida"),
          ),
        );
      }
    });
  }

  void onCpEdit(String newTemperature) {
    setState(() {
      double newCp = double.tryParse(newTemperature);
      if (newCp != null) {
        currentModel.changeCp(newCp);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Poder Calorifico Invalido"),
          ),
        );
      }
    });
  }

  void addCurrent(BuildContext context) {
    final model =
        ScopedModel.of<AnalisisPinchData>(context, rebuildOnChange: true);
    model.addCurrentModel(currentModel);
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.blueGrey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.elliptical(10, 10),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CurrentView(
                padding: EdgeInsets.all(0),
                currentModel: currentModel,
                duration: 500,
                editable: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 5),
              child: TextField(
                controller: nameController,
                onChanged: onNameEdit,
                style: TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Nombre",
                  hintStyle: TextStyle(
                    color: Colors.blueGrey.shade200,
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey.shade700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: TextField(
                controller: startTemperatureController,
                onChanged: onStartTemperatureEdit,
                style: TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Temperatura Inicial",
                  hintStyle: TextStyle(
                    color: Colors.blueGrey.shade200,
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey.shade700,
                  suffix: Text(
                    "[K]",
                    style: TextStyle(
                      color: Colors.blueGrey.shade200,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: TextField(
                controller: finalTemperatureController,
                onChanged: onFinalTemperatureEdit,
                style: TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Temperatura Final",
                  hintStyle: TextStyle(color: Colors.blueGrey.shade200),
                  filled: true,
                  fillColor: Colors.blueGrey.shade700,
                  suffix: Text("[K]",
                      style: TextStyle(color: Colors.blueGrey.shade200)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: TextField(
                controller: calorificValueController,
                onChanged: onCpEdit,
                style: TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: "Poder Calorifico (Cp)",
                  hintStyle: TextStyle(
                    color: Colors.blueGrey.shade200,
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey.shade700,
                  suffix: Text(
                    "[kJ/kg-K]",
                    style: TextStyle(
                      color: Colors.blueGrey.shade200,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: br10,
                      color: Colors.blueGrey.shade900,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: br10,
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            "Cancelar",
                            style: TextStyle(
                              color: Colors.blueGrey.shade200,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: br10,
                      color: Colors.blueGrey.shade400,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: br10,
                        onTap: () {
                          addCurrent(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            "Agregar",
                            style: TextStyle(
                              color: Colors.blueGrey.shade100,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CurrentView extends StatefulWidget {
  final CurrentModel currentModel;
  final double duration;
  final bool editable;
  final EdgeInsets padding;
  final Animation<double> animation;
  CurrentView(
      {Key key,
      this.currentModel,
      this.animation,
      this.editable: true,
      this.padding,
      this.duration})
      : super(key: key);

  @override
  _CurrentViewState createState() => _CurrentViewState();
}

class _CurrentViewState extends State<CurrentView>
    with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController _controller;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.duration != null ? widget.duration : 1500,
      ),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void editCurrent() {
    showDialog(context: context, builder: (context) => AddCurrentWidget());
  }

  @override
  Widget build(BuildContext context) {
    CurrentModel model = widget.currentModel;

    return Padding(
      padding: widget.padding == null
          ? EdgeInsets.only(top: 5, left: 5, right: 5)
          : widget.padding,
      child: SizeTransition(
        sizeFactor: animation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: br10,
            gradient: model.deleting
                ? LinearGradient(colors: [
                    Colors.yellow.shade300,
                    Colors.transparent,
                    Colors.yellow.shade300
                  ])
                : model.gradient,
            border: Border.all(
              color: model.color,
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
          child: Material(
            //color: Colors.blueGrey.shade900,
            color: Colors.transparent,
            borderRadius: br10,
            elevation: 10,
            child: ListTile(
              tileColor: Colors.transparent,
              selectedTileColor: Colors.blueGrey.shade900,
              shape: RoundedRectangleBorder(borderRadius: br10),
              dense: false,
              leading: widget.editable ? buildDeleteButton(context) : null,
              trailing: widget.editable ? buildEditButton(context) : null,
              title: buildCurrentName(model),
              subtitle: buildCurrentInfo(model),
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDeleteButton(context) {
    void deleteCurrent() {
      AnalisisPinchData model =
          ScopedModel.of<AnalisisPinchData>(context, rebuildOnChange: true);
      model.deleteCurrent(widget.currentModel);
      _controller.reverse().then((value) {
        model.removeCurrentModel(widget.currentModel);
      });
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: br10,
        color: Colors.blueGrey.shade700,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: br10,
          onTap: deleteCurrent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Text buildCurrentName(CurrentModel model) {
    return Text(
      "Corriente:  " + model.name,
      style: TextStyle(
        color: Colors.blueGrey.shade100,
        fontSize: 18,
      ),
    );
  }

  Widget buildCurrentInfo(CurrentModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.blueGrey.shade100,
                  fontSize: 15,
                ),
                children: [
                  TextSpan(text: "Temperatura"),
                  TextSpan(
                    text: "(inicial)",
                    style: TextStyle(
                      color: Colors.blueGrey.shade200,
                      fontSize: 10,
                    ),
                  ),
                  TextSpan(text: ":  "),
                  TextSpan(
                    text: model.ti.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  TextSpan(text: "  [K]"),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.blueGrey.shade100,
                  fontSize: 15,
                ),
                children: [
                  TextSpan(text: "Temperatura"),
                  TextSpan(
                    text: "(final)",
                    style: TextStyle(
                      color: Colors.blueGrey.shade200,
                      fontSize: 10,
                    ),
                  ),
                  TextSpan(text: ":  "),
                  TextSpan(
                    text: model.tf.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  TextSpan(text: "  [K]"),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.blueGrey.shade100,
                  fontSize: 15,
                ),
                children: [
                  TextSpan(text: "Cp:  "),
                  TextSpan(
                    text: model.cp.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  TextSpan(text: "  [kJ/kg-K]"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildEditButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: br10,
        color: Colors.blueGrey.shade700,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: br10,
          onTap: () {
            editCurrent();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

BorderRadius br10 = BorderRadius.circular(10);

class AnalisisPinchData extends Model {
  List<CurrentModel> currents = []..add(CurrentModel().random());
  List<Temperatura> sortedTemps = [];
  int currentAmount = 2;
  double flex1 = 10;
  double flex2 = 20;
  double valueSlider = 0.3;
  double yScale = 50.0;
  double dec = 0;

  void changeDecimals(double newVal) {
    dec = newVal.roundToDouble();
    notifyListeners();
  }

  void upDecimal() {
    dec++;
    if (dec > 6) {
      dec = 6;
    }
    notifyListeners();
  }

  void deleteCurrent(CurrentModel model) {
    model.delete();

    notifyListeners();
  }

  void downDecimal() {
    dec--;
    if (dec <= 0) {
      dec = 0;
    }
    notifyListeners();
  }

  void moveYScale(double newVal) {
    yScale = newVal;
    notifyListeners();
  }

  void moveFlex(double preference) {
    flex1 = 20 * preference;
    flex2 = 20 * (1 - preference);
    valueSlider = preference;
    notifyListeners();
  }

  void addCurrent() {
    currents.add(CurrentModel(name: currentAmount.toString()));
    currentAmount++;
    notifyListeners();
  }

  void addCurrentModel(CurrentModel model) {
    currents.add(model);
    currentAmount++;
    notifyListeners();
  }

  void changeCurrentCp(int _index, double newCp) {
    if (newCp != 0 && newCp != null) {
      currents[_index].changeCp(newCp);
      notifyListeners();
    }
  }

  void changeCurrentSourceTemperature(int _index, double newT) {
    if (newT != 0 && newT != null) {
      currents[_index].changeSourceTemperature(newT);
      notifyListeners();
    }
  }

  void changeCurrentTargetTemperature(int _index, double newT) {
    if (newT != 0 && newT != null) {
      currents[_index].changeTargetTemperature(newT);
      notifyListeners();
    }
  }

  void removeCurrent(int index) {
    if (!currents[index].lock) {
      currents.removeAt(index);
    }

    notifyListeners();
  }

  void removeCurrentModel(CurrentModel model) {
    int index = currents.indexOf(model);
    currents.removeAt(index);

    notifyListeners();
  }

  void changeCurrentName(int _index, String newName) {
    currents[_index].changeName(newName);
    notifyListeners();
  }

  void toggleCurrentLock(int _index, bool _newState) {
    currents[_index].toggleLock(_newState);
    notifyListeners();
  }

  List<Temperatura> getTemperatures() {
    List<double> _temperatures = [];
    currents.forEach((e) {
      _temperatures.add(e.ti);
    });
    currents.forEach((e) {
      _temperatures.add(e.tf);
    });
    _temperatures.sort((a, b) => a.compareTo(b));
    sortedTemps = cleanTemperatures(_temperatures);

    return sortedTemps;
  }

  List<Temperatura> cleanTemperatures(List<double> oldT) {
    List<double> newTs = oldT.toSet().toList();
    List<Temperatura> realT = [];
    double _yPos = 0;
    newTs.forEach((element) {
      realT.add(Temperatura(t: element, y: _yPos));
      _yPos = _yPos + 50;
    });

    return realT;
  }

  List<DeltaH> getDeltaHs() {
    List<DeltaH> _deltas = [];
    for (int i = 0; i < sortedTemps.length - 1; i++) {
      double t1 = sortedTemps[i].t;
      double t2 = sortedTemps[i + 1].t;
      double deltaCp = getDeltaCp(t1, t2);
      _deltas.add(
        DeltaH(
          t1: sortedTemps[i].t,
          t2: sortedTemps[i + 1].t,
          sumCp: deltaCp,
          yPos: sortedTemps[i].y + 25,
        ),
      );
    }
    _deltas.forEach((element) {
      element.calculateEntalpy();
    });
    return _deltas;
  }

  double getDeltaCp(double t1, double t2) {
    double deltaCp = 0;
    currents.forEach((element) {
      if (element.hotCurrent) {
        if (element.tf <= t1 && element.ti >= t2) {
          deltaCp = deltaCp + element.cp;
        }
      } else {
        if (element.tf >= t2 && element.ti <= t1) {
          deltaCp = deltaCp - element.cp;
        }
      }
    });

    return deltaCp;
  }

  void randomizer() {
    currents.forEach(
        (e) => e.changeCp((Random.secure().nextInt(10) + 1).toDouble()));

    currents.forEach((e) => e.changeSourceTemperature(
        (Random.secure().nextInt(500) + 1).toDouble()));

    currents.forEach((e) => e.changeTargetTemperature(
        (Random.secure().nextInt(500) + 1).toDouble()));

    notifyListeners();
  }

  List<CalorCascada> getCaloresCascada() {
    List<DeltaH> _deltas = getDeltaHs();
    double sumEntalpy = 0;
    List<CalorCascada> caloresCascada = [];
    for (int i = _deltas.length - 1; i >= 0; i--) {
      sumEntalpy = sumEntalpy + _deltas[i].entalpy;
      caloresCascada.add(CalorCascada(
        entalpy: sumEntalpy,
        temperature: _deltas[i].yPos,
      ));
    }

    return caloresCascada;
  }

  List<CalorCascada> getCaloresCascadaCorregidos() {
    List<CalorCascada> qCascada = getCaloresCascada();
    double sumEntalpy = getLower(qCascada);
    if (sumEntalpy < 0) {
      sumEntalpy = -sumEntalpy;
    }
    double lastT = 0;
    List<DeltaH> _deltas = getDeltaHs();
    List<CalorCascada> caloresCascadaCorregidos = [];
    for (int i = _deltas.length - 1; i >= 0; i--) {
      caloresCascadaCorregidos.add(CalorCascada(
        entalpy: sumEntalpy,
        temperature: _deltas[i].yPos,
      ));
      sumEntalpy = sumEntalpy + _deltas[i].entalpy;
      lastT = _deltas[i].yPos;
    }
    caloresCascadaCorregidos.add(CalorCascada(
      entalpy: sumEntalpy,
      temperature: lastT - 20,
    ));

    return caloresCascadaCorregidos;
  }

  double getLower(List<CalorCascada> list) {
    double minor = 10000000;
    list.forEach((element) {
      if (element.entalpy < minor) {
        minor = element.entalpy;
      }
    });
    return minor;
  }
}

class RatioSlider extends StatefulWidget {
  @override
  _RatioSliderState createState() => _RatioSliderState();
}

class _RatioSliderState extends State<RatioSlider> {
  @override
  Widget build(BuildContext context) {
    final model =
        ScopedModel.of<AnalisisPinchData>(context, rebuildOnChange: true);
    return Align(
      alignment: Alignment.bottomLeft,
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                "Expandir UI",
                style: TextStyle(
                    color: Colors.blue[300], fontStyle: FontStyle.italic),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey[900],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Slider(
                      activeColor: Colors.blue[300],
                      value: model.valueSlider,
                      max: 0.8,
                      min: 0.23,
                      onChanged: (val) {
                        model.moveFlex(val);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          YScaleSlider(),
          DecimalSlider(),
        ],
      ),
    );
  }
}

class YScaleSlider extends StatefulWidget {
  @override
  _YScaleSliderState createState() => _YScaleSliderState();
}

class _YScaleSliderState extends State<YScaleSlider> {
  @override
  Widget build(BuildContext context) {
    final model =
        ScopedModel.of<AnalisisPinchData>(context, rebuildOnChange: true);

    return Column(
      children: <Widget>[
        Text(
          "Expandir Y",
          style:
              TextStyle(color: Colors.blue[300], fontStyle: FontStyle.italic),
        ),
        Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueGrey[900],
            ),
            child: Material(
              color: Colors.transparent,
              child: Slider(
                activeColor: Colors.blue[300],
                value: model.yScale,
                min: 1,
                max: 300,
                onChanged: (val) {
                  model.moveYScale(val);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DecimalSlider extends StatefulWidget {
  @override
  _DecimalSliderState createState() => _DecimalSliderState();
}

class _DecimalSliderState extends State<DecimalSlider> {
  @override
  Widget build(BuildContext context) {
    final model =
        ScopedModel.of<AnalisisPinchData>(context, rebuildOnChange: true);

    return Column(
      children: <Widget>[
        Text(
          "Decimales",
          style:
              TextStyle(color: Colors.blue[300], fontStyle: FontStyle.italic),
        ),
        Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueGrey[900],
            ),
            child: Material(
              color: Colors.transparent,
              child: Slider(
                activeColor: Colors.blue[300],
                value: model.dec,
                divisions: 7,
                min: 0,
                max: 8,
                onChanged: (val) {
                  model.changeDecimals(val);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CascadePainter extends StatefulWidget {
  @override
  _CascadePainterState createState() => _CascadePainterState();
}

class _CascadePainterState extends State<CascadePainter> {
  Offset deltaOffset = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    final model =
        ScopedModel.of<AnalisisPinchData>(context, rebuildOnChange: true);
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    void _handlePanUpdate(DragUpdateDetails details) {
      setState(() {
        deltaOffset = deltaOffset + details.delta;
      });
    }

    return Container(
      height: h,
      width: w,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: _handlePanUpdate,
        child: CustomPaint(
          size: Size(w, h),
          painter: _CascadePainter(
            model: model,
            offset: deltaOffset,
          ),
        ),
      ),
    );
  }
}

class _CascadePainter extends CustomPainter {
  AnalisisPinchData model;
  Offset offset;
  double yScale;
  _CascadePainter({this.model, this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint();
    yScale = model.yScale;
    int dec = model.dec.toInt();
    double deb = dec.toDouble() * 0.1;
    List<Temperatura> tArray = model.getTemperatures();
    Offset sD = Offset(50, size.height * 0.8) + offset;
    paint.color = Colors.grey;

    //Draw Temperature Marks
    for (int i = 0; i < tArray.length; i++) {
      double _yPos = -tArray[i].y;
      Offset lineStart = sD + Offset(50, _yPos);
      Offset lineEnd = sD + Offset(size.width / 3 + deb * 50, _yPos);
      String _text = "T= " + tArray[i].t.toStringAsFixed(dec);
      TextPainter tp = customText(_text);
      canvas.drawLine(lineStart, lineEnd, paint);
      tp.layout();
      tp.paint(canvas, Offset(-40 * deb, _yPos) + sD);
    }

    //Draw Current Colored Lines
    for (int i = 0; i < model.currents.length; i++) {
      CurrentModel current = model.currents[i];
      paint.color = current.color;
      double _yStart;
      double _yEnd;
      for (int i = 0; i < tArray.length; i++) {
        if (current.tf == tArray[i].t) {
          _yEnd = -tArray[i].y;
        }
        if (current.ti == tArray[i].t) {
          _yStart = -tArray[i].y;
        }
      }
      Offset lineStart = sD + Offset(50 + i * 20.toDouble(), _yStart);
      Offset lineEnd = sD + Offset(50 + i * 20.toDouble(), _yEnd);
      canvas.drawLine(lineStart, lineEnd, paint);
      TextPainter tp = customText(current.name);
      tp.layout();
      tp.paint(canvas, lineStart);
    }

    //Draw Entalpy
    List<DeltaH> deltas = model.getDeltaHs();

    deltas.forEach((delta) {
      if (delta.entalpy != 0) {
        paint.color = Colors.grey;
        double yPos = delta.yPos;
        double entalpy = delta.entalpy;
        Offset _pos = sD + Offset(size.width / 3 + 50 * deb, -yPos);
        String text =
            "ΔT = ${(delta.t2 - delta.t1).toStringAsFixed(model.dec.toInt())}    CP = ${delta.sumCp.toStringAsFixed(model.dec.toInt())}   ΔH = ${entalpy.toStringAsFixed(model.dec.toInt())}";
        TextPainter tp = customText(text);
        tp.layout();
        tp.paint(canvas, _pos);
      }
    });

    //Calor Titulo Cascada y Corregida
    TextPainter tp = customText("Calor de Cascada");
    TextPainter tpCC = customText("Calor de Corregido");
    double xPos = size.width / 3 + 350;
    Offset _pos =
        sD + Offset(xPos + deb * 50, -tArray[tArray.length - 1].y - 50);
    Offset _posCC =
        sD + Offset(xPos + 200 + deb * 50, -tArray[tArray.length - 1].y - 50);
    tp.layout();
    tpCC.layout();
    tp.paint(canvas, _pos);
    tpCC.paint(canvas, _posCC);

    //Calores De Cascada
    List<CalorCascada> qCascada = model.getCaloresCascada();
    qCascada.forEach((element) {
      TextSpan span = new TextSpan(
        style: new TextStyle(color: Colors.grey[600]),
        text: element.entalpy.toStringAsFixed(model.dec.toInt()),
      );
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);

      Offset _pos = sD +
          Offset(size.width / 3 + 350 + deb * 50,
              -element.temperature * yScale / 50);
      tp.layout();
      tp.paint(canvas, _pos);
    });

    //Calores De Cascada Corregidos
    List<CalorCascada> qCascadaCorregidos = model.getCaloresCascadaCorregidos();
    qCascadaCorregidos.forEach((element) {
      TextSpan span = new TextSpan(
        style: new TextStyle(color: Colors.grey[600]),
        text: element.entalpy.toStringAsFixed(model.dec.toInt()),
      );
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);

      Offset _pos = sD +
          Offset(size.width / 3 + 550 + deb * 50,
              -element.temperature * yScale / 50);
      tp.layout();
      tp.paint(canvas, _pos);
    });
  }

  @override
  bool shouldRepaint(_CascadePainter old) => true;
}

TextSpan customSpan(String text) {
  return TextSpan(
    style: new TextStyle(color: Colors.grey[600]),
    text: text,
  );
}

TextPainter customText(String text) {
  TextSpan span = customSpan(text);
  return new TextPainter(
    text: span,
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
}

class DeltaH {
  double t1 = 1.0;
  double t2 = 2.0;
  double sumCp = 1.0;
  double yPos = 1.0;
  double entalpy = 1.0;

  DeltaH({this.t1: 1, this.t2: 1, this.sumCp: 1, this.yPos: 1});

  void calculateEntalpy() {
    entalpy = (t2 - t1) * (sumCp);
  }
}

class CurrentModel {
  String name;
  bool hotCurrent;
  double cp;
  double heatCapacityFlowRate;
  double ti;
  double tf;
  bool lock;
  bool deleting = false;
  Color color;
  Gradient gradient;

  CurrentModel({
    this.name: "1",
    this.cp: 0.0,
    this.ti: 0.0,
    this.tf: 0.0,
    this.lock: false,
    this.hotCurrent,
    this.color: Colors.transparent,
  });

  CurrentModel one() {
    return CurrentModel(name: "K234-P245", cp: 2355, tf: 2500, ti: 21500)
        .determinateType();
  }

  CurrentModel random() {
    int id1 = Random.secure().nextInt(1000);
    int id2 = Random.secure().nextInt(1000);
    double cp = Random.secure().nextInt(1000).toDouble();
    double tf = Random.secure().nextInt(1000).toDouble();
    double ti = Random.secure().nextInt(1000).toDouble();
    return CurrentModel(name: "K$id1-P$id2", cp: cp, tf: tf, ti: ti)
        .determinateType();
  }

  CurrentModel determinateType() {
    if (tf > ti) {
      // Cold Type
      this.color = Colors.blue.shade300;
      this.gradient = LinearGradient(colors: [
        Colors.blue.shade300,
        Colors.transparent,
        Colors.blue.shade300,
      ]);
      this.hotCurrent = false;
    } else {
      // Hot Type
      this.color = Colors.red.shade300;
      this.gradient = LinearGradient(colors: [
        Colors.red.shade300,
        Colors.transparent,
        Colors.red.shade400,
      ]);
      this.hotCurrent = true;
    }
    return this;
  }

  void changeName(newName) {
    name = newName;
  }

  void changeCp(newCp) {
    cp = newCp;
  }

  void delete() {
    deleting = true;
  }

  void changeSourceTemperature(newT) {
    ti = newT;
    determinateType();
  }

  void changeTargetTemperature(newT) {
    tf = newT;
    determinateType();
  }

  void toggleLock(bool _newState) {
    lock = _newState;
  }

  bool isValid() {
    if (tf != 0 && ti != 0 && cp != 0) return true;
    return false;
  }
}

class CalorCascada {
  double entalpy;
  double temperature;
  double yPos;
  CalorCascada({this.entalpy: 1, this.temperature: 1, this.yPos: 0});
}

class Temperatura {
  double t;
  double y;
  Temperatura({this.t: 1, this.y: 1});
}
