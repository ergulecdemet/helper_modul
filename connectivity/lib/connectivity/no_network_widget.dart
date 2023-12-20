import 'package:connectivity/connectivity/connectivity_management.dart';
import 'package:connectivity/const/size_config.dart';
import 'package:connectivity/const/space.dart';
import 'package:flutter/material.dart';
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

    waitForScreen(() {
      _networkChange.handleNetworkChange((result) {
        print(result);
        _updateView(result);
      });
    });
  }

  Future<void> fetchFirstResult() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final result = await _networkChange.checkNetworkFirstTime();
      _updateView(result);
    });
  }

  void _updateView(NetworkResult result) {
    setState(() {
      _networkResult = result;
    });
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
        padding: EdgeInsets.symmetric(
            horizontal: sizeConfig.widthSize(context, 20)),
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
                  color:Colors.grey,
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