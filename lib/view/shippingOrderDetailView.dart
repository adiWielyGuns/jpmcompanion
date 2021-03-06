import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jpmcompanion/const.dart';
import 'package:jpmcompanion/model/shippingOrderModel.dart';
import 'package:jpmcompanion/provider/shippingOrderDetailViewModel.dart';
import 'package:jpmcompanion/view/homeView.dart';
import 'package:jpmcompanion/widget/loadingScreen.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

import '../routeTransition.dart';

class ShippingOrderDetailView extends StatefulWidget {
  final ShippingOrderData param;

  const ShippingOrderDetailView({Key key, this.param}) : super(key: key);
  @override
  _ShippingOrderDetailViewState createState() =>
      _ShippingOrderDetailViewState();
}

class _ShippingOrderDetailViewState extends State<ShippingOrderDetailView> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ShippingOrderDetailViewModel(),
      onModelReady: (model) => model.init(context, widget.param),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          Navigator.pushAndRemoveUntil(
            context,
            RouteAnimationDurationFade(
              widget: HomeView(),
            ),
            (route) => false,
          );
          return;
        },
        child: LoadingScreen(
          showLoadingApi: model.isBusy,
          showLoadingScreen: false,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              key: model.scaffoldKey,
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  Container(
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (notification) {
                        notification.disallowGlow();
                        return;
                      },
                      child: NestedScrollView(
                        headerSliverBuilder: (context, box) {
                          return [
                            SliverAppBar(
                              elevation: 0,
                              leading: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.arrowAltCircleLeft,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    RouteAnimationDurationFade(
                                      widget: HomeView(),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                              title: Text(
                                'Shipping Order Detail',
                                style: TextStyle(
                                  fontFamily: "PlexSans",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.amber,
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(kToolbarHeight),
                                child: Container(
                                  width: 1.wp,
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [Colors.amber, Colors.amber],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 0.05.hp,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.amber,
                                              Colors.amber
                                            ],
                                          ),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(0),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 0.05.hp,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.white,
                                              Colors.white
                                            ],
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              pinned: true,
                              flexibleSpace: Container(
                                alignment: Alignment.topRight,
                                width: 1.wp,
                                child: Image(
                                  width: 0.5.wp,
                                  image: AssetImage('assets/Asset 57300 1.png'),
                                ),
                              ),
                              expandedHeight: kToolbarHeight + 0.1.hp,
                            ),
                          ];
                        },
                        body: Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 0.05.wp,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image(
                                      width: 0.1.wp,
                                      image: AssetImage(
                                        'assets/Asset 61300 2.png',
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 0.05.wp),
                                      child: Text(
                                        'Shipping Order Detail',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 50.ssp,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "PlexSans",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 0.03.hp,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 0.05.wp,
                                ),
                                color: Color(
                                  hexStringToHexInt('#F5F5F5'),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 0.01.hp,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Shipping Order Detail',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 40.ssp,
                                                color: textGrey,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "PlexSans",
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              '${widget.param.nomor}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 40.ssp,
                                                color: textGrey,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "PlexSans",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 0.01.hp,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Status',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 40.ssp,
                                                color: textGrey,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "PlexSans",
                                              ),
                                            ),
                                          ),
                                          if (widget.param.status == null)
                                            Container(
                                              child: Text(
                                                'On Going',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 40.ssp,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "PlexSans",
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 0.01.hp,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Tgl berangkat',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 40.ssp,
                                                color: textGrey,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "PlexSans",
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              '${DateFormat('d MMMM y').format(DateTime.parse(widget.param.tanggal))}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 40.ssp,
                                                color: textGrey,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "PlexSans",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 0.05.wp,
                                  vertical: 0.02.hp,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Tipe/Type',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 40.ssp,
                                                color: textGrey,
                                                fontFamily: "PlexSans",
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.01.hp,
                                          ),
                                          Container(
                                            child: Text(
                                              'KILOGRAM',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 40.ssp,
                                                color: textGrey,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "PlexSans",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Jenis/Category',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 40.ssp,
                                                color: textGrey,
                                                fontFamily: "PlexSans",
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.01.hp,
                                          ),
                                          Container(
                                            child: Text(
                                              'REGULER',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 40.ssp,
                                                color: textGrey,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "PlexSans",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 0.05.wp,
                                  vertical: 0.02.hp,
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                'Asal',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 40.ssp,
                                                  color: textGrey,
                                                  fontFamily: "PlexSans",
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 0.01.hp,
                                            ),
                                            Container(
                                              child: Text(
                                                '${widget.param.kota.nama}',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 40.ssp,
                                                  color: textGrey,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "PlexSans",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                'Tujuan',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 40.ssp,
                                                  color: textGrey,
                                                  fontFamily: "PlexSans",
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 0.01.hp,
                                            ),
                                            Container(
                                              child: Text(
                                                'REGULER',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 40.ssp,
                                                  color: textGrey,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "PlexSans",
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
