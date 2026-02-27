import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class KhaltiWebViewPage extends StatefulWidget {
  final String paymentUrl;
  final String successUrl;
  final String failureUrl;

  const KhaltiWebViewPage({
    super.key,
    required this.paymentUrl,
    required this.successUrl,
    required this.failureUrl,
  });

  @override
  State<KhaltiWebViewPage> createState() => _KhaltiWebViewPageState();
}

class _KhaltiWebViewPageState extends State<KhaltiWebViewPage> {
  late WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController();

    // Fix for Android text input not working
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);

    _controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (progress) {
          setState(() {
            _progress = progress;
          });
        },
        onNavigationRequest: (request) {
          final url = request.url;
          if (url.contains('/payment/callback') || url.contains('pidx=')) {
            final uri = Uri.parse(url);
            final pidx = uri.queryParameters['pidx'];
            Navigator.pop(context, pidx ?? true);
            return NavigationDecision.prevent;
          }

          if (url.startsWith(widget.successUrl)) {
            Navigator.pop(context, true);
            return NavigationDecision.prevent;
          }

          if (url.startsWith(widget.failureUrl)) {
            Navigator.pop(context, false);
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ),
    );

    _controller.loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Khalti Payment"),
      ),
      body: Column(
        children: [
          if (_progress < 100)
            LinearProgressIndicator(value: _progress / 100),
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}