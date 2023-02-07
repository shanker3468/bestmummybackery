import 'package:bestmummybackery/CustomerMaster.dart';
import 'package:bestmummybackery/LoyaltyMaster.dart';
import 'package:bestmummybackery/Masters/CounterMaster.dart';
import 'package:bestmummybackery/Masters/DistrictMaster.dart';
import 'package:bestmummybackery/Masters/Mixboxmaster.dart';
import 'package:bestmummybackery/Masters/MyRollAunthMaster.dart';
import 'package:bestmummybackery/Masters/OSRDMaster.dart';
import 'package:bestmummybackery/Masters/PettyCashMaster.dart';
import 'package:bestmummybackery/Masters/PromotionMasterHome.dart';
import 'package:bestmummybackery/Masters/ShiftMaster.dart';
import 'package:bestmummybackery/Masters/ShiftMasterHomePage.dart';
import 'package:bestmummybackery/Masters/TableMaster.dart';
import 'package:bestmummybackery/Masters/UserMaster.dart';
import 'package:bestmummybackery/Masters/VehicleMaster.dart';
import 'package:bestmummybackery/PriceList/PriceListMaster.dart';
import 'package:bestmummybackery/ROLStock.dart';
import 'package:bestmummybackery/TarWeightMaster.dart';
import 'package:bestmummybackery/Variance/VarianceMaster.dart';
import 'package:bestmummybackery/screens/Dashboard.dart';
import 'package:bestmummybackery/screens/DiscountApprovedScreen.dart';
import 'package:bestmummybackery/screens/Pallete.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MastersScreen extends StatefulWidget {
  const MastersScreen({Key key}) : super(key: key);

  @override
  _MastersScreenState createState() => _MastersScreenState();
}

class _MastersScreenState extends State<MastersScreen> {
  final List<String> imageList = [
    "http://www.bestmummy.in/wp-content/uploads/2022/01/m7-s3-2.jpg",
    "http://www.bestmummy.in/wp-content/uploads/2022/01/m8-bg-3.jpg",
    "http://www.bestmummy.in/wp-content/uploads/2022/01/m7-s1-2.jpg",
    "http://www.bestmummy.in/wp-content/uploads/2022/01/m7-s1-3.png",
    "https://static.zingyhomes.com/projectImages/cache/8d/be/8dbe46253736d7551f2a335a72088cc6.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Master Screen'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Dashboard(),
                    ),
                  );
                },
              )
            ],
          ),
          body: Container(
            padding: EdgeInsets.only(top: 100),
            //width: 400,
            child: CarouselSlider(
              options: CarouselOptions(
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                height: 300,
                initialPage: 0,
                autoPlay: true,
              ),
              items: imageList
                  .map((e) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Image.network(
                              e,
                              width: 300,
                              height: 350,
                              fit: BoxFit.cover,
                            )
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(
                      color: Pallete.mycolor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Text(
                          'Name',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Location',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ],
                    )),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListTile(
                    leading: Icon(
                      Icons.ac_unit_outlined,
                      color: Colors.blueGrey,
                      size: 30,
                    ),
                    title: Text('OSRD Master'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OSRDMaster()));
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.list,
                    color: Colors.red,
                    size: 30,
                  ),
                  title: Text('ROL Stock Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ROLStock()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.person_add,
                    color: Colors.blueGrey,
                    size: 30,
                  ),
                  title: Text('User Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserMaster()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.person_add,
                    color: Colors.blueGrey,
                    size: 30,
                  ),
                  title: Text('Customer Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerMaster()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.view_agenda_rounded,
                    color: Colors.teal,
                    size: 30,
                  ),
                  title: Text('Variance Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VarianceMaster()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.countertops,
                    color: Colors.green,
                    size: 30,
                  ),
                  title: Text('Counter Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CounterMaster()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.attach_money_outlined,
                    color: Colors.orange,
                    size: 30,
                  ),
                  title: Text('Price Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PriceListMaster(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.microwave_rounded,
                    color: Colors.deepPurpleAccent,
                    size: 30,
                  ),
                  title: Text('Mix Box Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyMixBoxMaster()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.view_agenda_rounded,
                    color: Colors.deepPurpleAccent,
                    size: 30,
                  ),
                  title: Text('Table Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyTableMaster(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.payment,
                    color: Colors.indigoAccent,
                    size: 30,
                  ),
                  title: Text('Promotion Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PromotionMasterHome(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.filter_tilt_shift,
                    color: Colors.amber,
                    size: 30,
                  ),
                  title: Text('Shift Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShiftHomeMaster(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.attach_money_outlined,
                    color: Colors.deepPurple,
                    size: 30,
                  ),
                  title: Text('Petty Cash Master'),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PettyCashMaster()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.bus_alert,
                    color: Colors.deepOrangeAccent,
                    size: 30,
                  ),
                  title: Text('Vehicle Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => VehicleMaster()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.copyright_sharp,
                    color: Colors.deepOrangeAccent,
                    size: 30,
                  ),
                  title: Text('Roll Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => MyRollAunthMaster()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('District & Place Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DistrictMaster()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.compare,
                    color: Colors.deepPurple,
                    size: 30,
                  ),
                  title: Text('Loyalty Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoyaltyMaster()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.line_weight,
                    color: Colors.grey,
                    size: 30,
                  ),
                  title: Text('TarWeight Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TarWeightMaster()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.line_weight,
                    color: Colors.grey,
                    size: 30,
                  ),
                  title: Text('District Master'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DistrictMaster()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.wallet_membership,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                  title: Text('Discount Approval'),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DiscountApproved()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
