import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewStripe extends StatefulWidget {
  WebViewStripe({super.key, this.urlSetted});
  String? urlSetted;
  @override
  State<WebViewStripe> createState() => _WebViewStripeState();
}

class _WebViewStripeState extends State<WebViewStripe> {
  var loadingPercentage = 0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    print("Print Url : ${widget.urlSetted}");
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          print("Heavy url : $url");
          setState(() {
            loadingPercentage = 100;
          });
        },
        onNavigationRequest: (navigation) {
          print("NAVIGATION as : ${navigation.url}");
          // final host = Uri.parse(navigation.url);
          if (navigation.url.contains('get-started')) {
            Get.to(SuccessAccountCreation(
              text: "Your account has been successfully created on Stripe.",
              func: () async {
                Get.back();
                Get.back();
              },
            ));

            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        // Uri.parse('${widget.urlSetted}'),
        Uri.parse('https://flutter.dev'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Stripe'),
        actions: <Widget>[
          NavigationControls(webViewController: controller),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({super.key, required this.webViewController});

  final WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await webViewController.canGoBack()) {
              await webViewController.goBack();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('No back history item',
                          style: TextStyle(color: Colors.black)),
                      backgroundColor: Colors.white),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await webViewController.canGoForward()) {
              await webViewController.goForward();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('No forward history item',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.black));
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => webViewController.reload(),
        ),
      ],
    );
  }
}

class SuccessAccountCreation extends StatefulWidget {
  SuccessAccountCreation({super.key, required this.text, required this.func});
  String text;
  void Function()? func;

  @override
  State<SuccessAccountCreation> createState() => _SuccessAccountCreationState();
}

class _SuccessAccountCreationState extends State<SuccessAccountCreation> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/loginSelection1.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check_circle,
                  // color: Colors.white,
                  color: Color(0xffd8a735),
                  size: 100.0,
                ),
                SizedBox(height: 20.0),
                Text(
                  'Congratulations!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  width: w * .8,
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: h * .3),
                Container(
                  margin: EdgeInsets.all(12.0),
                  child: CustomButton(
                    heights: 50,
                    text: "Done",
                    borderRadius: 100,
                    onTap: widget.func,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
