import 'dart:convert';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jpmcompanion/apiConst.dart';
import 'package:jpmcompanion/model/RequestModel.dart';
import 'package:jpmcompanion/model/trackingPositionModel.dart';
import 'package:jpmcompanion/routeTransition.dart';
import 'package:jpmcompanion/service/mainService.dart';
import 'package:jpmcompanion/view/loginView.dart';
import 'package:jpmcompanion/widget/mapDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:stacked/stacked.dart';
import '../const.dart';

class HomeViewModel extends BaseViewModel {
  // SETTER
  TabController _tabController;
  TextEditingController _search = TextEditingController();
  TextEditingController _routeText = TextEditingController();
  TextEditingController _namaText = TextEditingController();
  TextEditingController _emailText = TextEditingController();
  TextEditingController _telponText = TextEditingController();
  TextEditingController _passwordText = TextEditingController();

  List<FlSpot> _pendapatanSpots = [
    FlSpot(0, 0),
    FlSpot(1, 2567895670),
    FlSpot(2, 3756970345),
  ];

  List<FlSpot> _deliveryOrderSpots = [
    FlSpot(0, 0),
    FlSpot(1, 120000.0),
    FlSpot(2, 60444),
  ];

  int _index = 0;
  User _user;
  bool _isSnapOpen = false;
  TrackingPosition _trackingPosition = TrackingPosition();
  List<TrackingResult> _trackingResult = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TrackingResult _activeTracking = TrackingResult();
  List<Map> _shortcut = [];
  bool _darken = false;
  bool _isApiBusy = false;
  String _snappingStatus;
  SnappingSheetController _snappingRouteController = SnappingSheetController();

  // GETTER
  TextEditingController get search => _search;
  bool get darken => _darken;
  bool get isApiBusy => _isApiBusy;
  String get snappingStatus => _snappingStatus;

  TextEditingController get routeText => _routeText;
  TextEditingController get namaText => _namaText;
  TextEditingController get emailText => _emailText;
  TextEditingController get telponText => _telponText;
  TextEditingController get passwordText => _passwordText;
  TabController get tabController => _tabController;
  TrackingResult get activeTracking => _activeTracking;
  List<FlSpot> get pendapatanSpots => _pendapatanSpots;
  List<FlSpot> get deliveryOrderSpots => _deliveryOrderSpots;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  bool get isSnapOpen => _isSnapOpen;
  User get user => _user;
  SnappingSheetController get snappingRouteController =>
      _snappingRouteController;

  List<Map> get shortcut => _shortcut;
  // FUNCTION
  init(context, vsync, firebase) async {
    await redirectToLogin(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp = prefs.getString('token');
    if (temp != null) {
      await getDataUser();
      setBusy(true);
      _tabController = TabController(length: 4, vsync: vsync);
      firebase.subscribeToTopic('cabang${_user.kodeCabang}');
      firebase.subscribeToTopic('courier');
      await getAllNopolActive();
      await generateShortcut(context);
      await saveTokenFirebase(vsync);
      setBusy(false);
    }

    setBusy(false);
    notifyListeners();
  }

  getDataUser() async {
    await MainService().user().then((value) async {
      if (value['status'] == 1) {
        _user = User.fromJson(value['data']);
        for (HakAkses item in _user.hakAkses) {
          switch (item.masterMenu.url) {
            case createDoRoute:
              if (item.view == 'true') {
                createDoAccess = true;
              }
              break;
            case trackingDoRoute:
              if (item.view == 'true') {
                trackingDoAccess = true;
              }
              break;
            case updateDoRoute:
              if (item.view == 'true') {
                updateDoAccess = true;
              }
              break;
            case purchaseOrderRoute:
              if (item.view == 'true') {
                purchaseOrderAccess = true;
              }
              break;
            case map:
              if (item.view == 'true') {
                mapAccess = true;
              }
              break;
            case pickupCourierRoute:
              if (item.view == 'true') {
                pickupCourierAccess = true;
              }
              break;
            default:
          }
        }
      } else if (value['status'] == 0) {
        // await redirectToLogin(context);
      }
    });
    notifyListeners();
  }

  saveTokenFirebase(args) async {
    await MainService().saveTokenFireBase(args.token);
  }

  changeRoute(context, param) async {
    _snappingStatus = param;
    _darken = true;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 200)).then((value) {
      if (_snappingRouteController != null) {
        _snappingRouteController.snapToPosition(
          SnapPosition(
            positionPixel: 0.5.hp,
            positionFactor: 0.5,
            snappingCurve: Curves.ease,
            snappingDuration: Duration(milliseconds: 200),
          ),
        );
      }
      notifyListeners();
    });
  }

  generateShortcut(context) async {
    _shortcut = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('shortcut1') != null) {
      var temp = prefs.getString('shortcut1');
      var data = jsonDecode(temp);
      data['isSet'] = true;
      _shortcut.add(data);
    } else {
      Map data = {"isSet": false};
      _shortcut.add(data);
    }

    if (prefs.getString('shortcut2') != null) {
      var temp = prefs.getString('shortcut2');
      var data = jsonDecode(temp);
      data['isSet'] = true;
      _shortcut.add(data);
    } else {
      Map data = {"isSet": false};
      _shortcut.add(data);
    }

    if (prefs.getString('shortcut3') != null) {
      var temp = prefs.getString('shortcut3');
      var data = jsonDecode(temp);
      data['isSet'] = true;
      _shortcut.add(data);
    } else {
      Map data = {"isSet": false};
      _shortcut.add(data);
    }

    if (prefs.getString('shortcut4') != null) {
      var temp = prefs.getString('shortcut4');
      var data = jsonDecode(temp);
      data['isSet'] = true;
      _shortcut.add(data);
    } else {
      Map data = {"isSet": false};
      _shortcut.add(data);
    }

    print(_shortcut);
    notifyListeners();
  }

  getAllNopolActive() async {
    _trackingResult = [];
    var result = await MainService().getNopolActive(_trackingPosition);
    print(result);
    if (result['status'] != 502) {
      for (var item in result['Data']) {
        if (result['ResponseCode'] == 1) {
          item = jsonEncode(item);
          _trackingResult.add(TrackingResult.fromJson(jsonDecode(item)));
        }
      }
    }
    notifyListeners();
  }

  logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('id');
    prefs.remove('user');
    prefs.remove('shortcut1');
    prefs.remove('shortcut2');
    prefs.remove('shortcut3');
    prefs.remove('shortcut4');
    Navigator.pushAndRemoveUntil(
      context,
      RouteAnimationDurationFade(
        widget: LoginView(),
      ),
      (route) => false,
    );
  }

  collapseSnapping() {
    _darken = false;
    _snappingRouteController.snapToPosition(
      SnapPosition(
        positionPixel: 0,
        positionFactor: 0.5,
        snappingCurve: Curves.ease,
        snappingDuration: Duration(milliseconds: 200),
      ),
    );
    notifyListeners();
  }

  changeTab(index) async {
    _index = index;
    _tabController.animateTo(index);
    await getDataUser();

    notifyListeners();
  }

  hideTab(value) {
    if (value == 'open') {
      _isSnapOpen = true;
    } else {
      _isSnapOpen = false;
    }
    notifyListeners();
  }

  submitRoutePickUp(context) async {
    switch (_snappingStatus) {
      case 'rute':
        Map data = {
          'rute': _routeText.text,
        };
        _isApiBusy = true;
        notifyListeners();
        await MainService().changeRouteCourier(data).then((value) async {
          if (value['status'] == 1) {
            messageToast(value['message'], Colors.black54);
          } else {
            messageToast(value['message'], Colors.black54);
          }
        });
        _isApiBusy = false;
        break;
      case 'user':
        Map data = {
          'nama': _namaText.text,
          'email': _emailText.text,
          'telpon': _telponText.text,
        };
        _isApiBusy = true;
        notifyListeners();
        await MainService().updateUser(data).then((value) async {
          if (value['status'] == 1) {
            messageToast(value['message'], Colors.black54);
          } else {
            messageToast(value['message'], Colors.black54);
          }
        });
        _isApiBusy = false;
        break;
      case 'password':
        Map data = {
          'password': _passwordText.text,
        };
        _isApiBusy = true;
        notifyListeners();
        await MainService().updatePassword(data).then((value) async {
          if (value['status'] == 1) {
            messageToast(value['message'], Colors.black54);
          } else {
            messageToast(value['message'], Colors.black54);
          }
        });
        _isApiBusy = false;
        break;
      default:
    }
    collapseSnapping();
    notifyListeners();
  }

  submitUser(context) async {
    Map data = {
      'rute': _routeText.text,
    };
    _isApiBusy = true;
    notifyListeners();
    await MainService().updateUser(data).then((value) async {
      if (value['status'] == 1) {
        messageToast(value['message'], Colors.black54);
      } else {
        messageToast(value['message'], Colors.black54);
      }
    });
    _isApiBusy = false;
    collapseSnapping();
    notifyListeners();
  }

  drawer(context) {
    ScreenUtil.init(context);
    if (isBusy) {
      return Container();
    } else {
      switch (_index) {
        case 1:
          return MapDrawer(
            result: _trackingResult,
            onTap: (e) async {
              _scaffoldKey.currentState.openEndDrawer();
              _activeTracking = e;
              notifyListeners();
            },
            onRefresh: () async {
              await getAllNopolActive();
              notifyListeners();
            },
          );
          break;
        case 0:
          return Drawer(
            child: SafeArea(
              child: Container(
                child: Column(
                  children: [
                    if (_user != null && _user.image != null)
                      UserAccountsDrawerHeader(
                        margin: EdgeInsets.only(bottom: 0.02.hp),
                        currentAccountPicture: CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage('$baseApi${_user.image}'),
                        ),
                        accountName: Text(_user.nama),
                        accountEmail: Text(_user.email),
                      ),
                    if (createDoAccess)
                      Container(
                        width: 1.wp,
                        height: 0.07.hp,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(createDoRoute);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/Asset 47300 2.png'),
                                  width: 0.1.wp,
                                  height: 0.1.wp,
                                ),
                                SizedBox(
                                  width: 0.05.wp,
                                ),
                                Text(
                                  'Delivery Order',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 45.ssp,
                                    color: textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (purchaseOrderAccess)
                      Container(
                        width: 1.wp,
                        height: 0.07.hp,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(purchaseOrderRoute);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/Asset 48300 1.png'),
                                  width: 0.1.wp,
                                  height: 0.1.wp,
                                ),
                                SizedBox(
                                  width: 0.05.wp,
                                ),
                                Text(
                                  'Shipping Order',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 45.ssp,
                                    color: textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (updateDoAccess)
                      Container(
                        width: 1.wp,
                        height: 0.07.hp,
                        child: FlatButton(
                          onPressed: () {
                            return print('tes');
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/Asset 57300 1.png'),
                                  width: 0.1.wp,
                                ),
                                SizedBox(
                                  width: 0.05.wp,
                                ),
                                Text(
                                  'Update DO V1',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 45.ssp,
                                    color: textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (updateDoAccess)
                      Container(
                        width: 1.wp,
                        height: 0.07.hp,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(updateDoRoute);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/Asset 8@4x.png'),
                                  width: 0.1.wp,
                                ),
                                SizedBox(
                                  width: 0.05.wp,
                                ),
                                Text(
                                  'Update DO V2',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 45.ssp,
                                    color: textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (pickupCourierAccess)
                      Container(
                        width: 1.wp,
                        height: 0.07.hp,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(pickupCourierRoute);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/Asset 55300 1.png'),
                                  width: 0.1.wp,
                                ),
                                SizedBox(
                                  width: 0.05.wp,
                                ),
                                Text(
                                  'Pick Up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 45.ssp,
                                    color: textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Container(
                      width: 1.wp,
                      height: 0.07.hp,
                      child: FlatButton(
                        onPressed: () {
                          Map data = {
                            "route": trackingDoRoute,
                          };

                          Navigator.of(context).pushNamed(
                            listDoRoute,
                            arguments: data,
                          );
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Image(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/magnificient.png'),
                                width: 0.1.wp,
                              ),
                              SizedBox(
                                width: 0.05.wp,
                              ),
                              Text(
                                'Tracking DO',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 45.ssp,
                                  color: textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 1.wp,
                              height: 0.07.hp,
                              child: FlatButton(
                                onPressed: () {
                                  return logout(context);
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.powerOff,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 0.05.wp,
                                      ),
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 45.ssp,
                                          color: textGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          break;
        default:
          return Drawer(
            child: Text('hello'),
          );
      }
    }
  }
}
