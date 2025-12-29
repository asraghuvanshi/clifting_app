import 'package:clifting_app/core/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String title;
  final String type; // 'terms', 'privacy', 'help', 'about'

  const WebViewScreen({super.key, required this.title, required this.type});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;
  String? _lastUrl;

  @override
  void initState() {
    super.initState();
    _lastUrl = _getApiUrl();
    print('Loading URL: $_lastUrl'); // Debug print
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false) // Optional: disable zoom
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print('Loading progress: $progress%');
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print('WebResourceError: ${error.errorCode} - ${error.description}');
            setState(() {
              _isLoading = false;
              _errorMessage = 'Failed to load: ${error.description}\nURL: $_lastUrl';
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            print('Navigation request to: ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            print('URL changed from ${change.url} to ${change.url}');
          },
        ),
      )
      ..loadRequest(Uri.parse(_lastUrl!));
  }

  String _getApiUrl() {
    final baseUrl = '${ApiConstants.baseUrl}/content';
    switch (widget.type) {
      case 'terms':
        return '$baseUrl/terms';
      case 'privacy':
        return '$baseUrl/privacy';
      case 'help':
        return '$baseUrl/help';
      case 'about':
        return '$baseUrl/about';
      default:
        return '$baseUrl/terms';
    }
  }

  void _retryLoading() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _controller.loadRequest(Uri.parse(_getApiUrl()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  
                  if (_isLoading)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading ${widget.title}...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  if (_errorMessage != null)
                    Container(
                      color: Colors.black.withOpacity(0.8),
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 64,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Failed to Load Content',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _retryLoading,
                              child: Text('Retry'),
                            ),
                            SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                // Copy URL to clipboard for debugging
                                // clipboard.setData(ClipboardData(text: _lastUrl ?? ''));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('URL: $_lastUrl'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              },
                              child: Text(
                                'Show URL',
                                style: TextStyle(color: Colors.blue),
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
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.blue.shade900,
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (!_isLoading && _errorMessage == null)
            IconButton(
              onPressed: () => _controller.reload(),
              icon: Icon(Icons.refresh, color: Colors.white),
            ),
        ],
      ),
    );
  }
}