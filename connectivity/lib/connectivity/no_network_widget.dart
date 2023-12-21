import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity/connectivity_management.dart';
import 'package:connectivity/const/size_config.dart';
import 'package:connectivity/const/space.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NoNetworkWidget extends StatefulWidget {
  const NoNetworkWidget({super.key});

  @override
  State<NoNetworkWidget> createState() => _NoNetworkWidgetState();
}

class _NoNetworkWidgetState extends State<NoNetworkWidget> with StateMixin {
  late final INetworkChangeManager _networkChange;
  NetworkResult? _networkResult;

  @override
  void initState() {
    super.initState();
    _networkChange = NetworkChangeManager();

    _networkChange.checkNetworkFirstTime().then((value) {
      checkInternetConnection(value);
      print(value);
    });

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      debugPrint("internet kontrol ediliyor...");
      await _networkChange.checkNetworkFirstTime().then((value) {
        checkInternetConnection(value);
      });
    });
  }

  Future<void> checkInternetConnection(NetworkResult result) async {
    const String urlToCheck =
        'https://visit.gaziantep.bel.tr'; //You can be change and put your url.
    try {
      final response = await http
          .get(Uri.parse(urlToCheck))
          .timeout(const Duration(milliseconds: 1000));
      if (response.statusCode == 200) {
        debugPrint('İnternet erişim var');
        setState(() {
          _networkResult = result;
        });
      }
    } on SocketException catch (_) {
      debugPrint("internet yok");
      setState(() {
        _networkResult = NetworkResult.off;
      });
    } on TimeoutException catch (_) {
      debugPrint("internet yavaş");
      setState(() {
        _networkResult = NetworkResult.on;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              "İnternetiniz çok yavaş. Lütfen bağlantınızı güçlendiriniz."),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      debugPrint("internet kontrolü cath de. $e");
      setState(() {
        _networkResult = NetworkResult.off;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _networkChange.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 500),
      crossFadeState: _networkResult == NetworkResult.off
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: _noConnectivityInternet(context),
      secondChild: const SizedBox(),
    );
  }

  Container _noConnectivityInternet(BuildContext context) {
    return Container(
      height: sizeConfig.scrHeight(context),
      width: sizeConfig.scrWidth(context),
      color: Colors.white,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: sizeConfig.widthSize(context, 20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "İntenet Bağlantısı Yok",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: sizeConfig.sp(context, 20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Lütfen internet bağlantınızı kontrol ediniz.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: sizeConfig.sp(context, 20),
              ),
            ),
            const VerticalSpace(height: 20),
            Center(
              child: CircleAvatar(
                radius: sizeConfig.heightSize(context, 100),
                backgroundColor: Colors.blueGrey.withOpacity(0.2),
                child: Icon(
                  Icons.wifi_off_sharp,
                  size: sizeConfig.heightSize(context, 100),
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

mixin StateMixin<T extends StatefulWidget> on State<T> {
  void waitForScreen(VoidCallback onComplete) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onComplete.call();
    });
  }
}
