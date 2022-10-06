import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaperads/WallpaperApp/fullscreen_image.dart';
import 'package:wallpaperads/listwallfy/calling_constructor.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = '';

class WallScreen extends StatefulWidget {
  @override
  _WallScreenState createState() => new _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {

  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['wallpapers', 'walls', 'amoled'],
    birthday: new DateTime.now(),
    childDirected: true,
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;


  BannerAd createBannerAd() {
    return new BannerAd(
        adUnitId: BannerAd.testAdUnitId,  //"ca-app-pub-4252364201498947/3350664917"
        size: AdSize.banner,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Banner event : $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return new InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,  //"ca-app-pub-4252364201498947/5536052541"
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Interstitial event : $event");
        });
  }

  ConsList list;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: FirebaseAdMob.testAppId);   //"ca-app-pub-4252364201498947~9120074333"
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    refreshList();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(); //atTop: false
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      list = ConsList();
    });
    return null;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd.dispose();
    refreshList();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallpaper App"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.add, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.update, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.delete, color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: refreshList,
        child: list != null
            ? StaggeredGridView.countBuilder(
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 6 : 4,
                itemCount: list.wallpaper.length,
                itemBuilder: (context, i) {
                  String imgPath = list.wallpapername(i);

                  return Material(
                    elevation: 9.0,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    child: InkWell(
                      onTap: () { 
                        createInterstitialAd()
                          ..load()
                          ..show();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FullScreenImagePage(imgPath)));
                  },
                      child: Hero(
                        tag: imgPath,
                        child: FadeInImage(
                          image: AssetImage("assets/${imgPath}"),
                          fit: BoxFit.cover,
                          placeholder: AssetImage("assets/wallfy.png"),
                        ),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (i) =>
                    StaggeredTile.count(2, i.isEven ? 2 : 3),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: new Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        onPressed: () {
          refreshList();
          print("Refresh");
        },
      ),
      drawer: Drawer(),
    );
  }
}
