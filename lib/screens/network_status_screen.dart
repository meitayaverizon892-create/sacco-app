import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/api_service.dart';

class NetworkStatusScreen extends StatefulWidget {
  const NetworkStatusScreen({super.key});

  @override
  State<NetworkStatusScreen> createState() => _NetworkStatusScreenState();
}

class _NetworkStatusScreenState extends State<NetworkStatusScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  String _apiTestResult = '';
  bool _isTesting = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();

    // Listen for connection changes in real-time
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectionStatus = result;
      });
    });
  }

  Future<void> _checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<void> _testApiConnection() async {
    setState(() {
      _isTesting = true;
      _apiTestResult = '';
    });

    try {
      final members = await ApiService.fetchOnlineMembers();
      setState(() {
        _apiTestResult =
            '✅ Success! Retrieved ${members.length} records from API.';
        _isTesting = false;
      });
    } catch (e) {
      setState(() {
        _apiTestResult = '❌ ${e.toString().replaceAll('Exception: ', '')}';
        _isTesting = false;
      });
    }
  }

  bool get _isConnected => _connectionStatus != ConnectivityResult.none;

  String get _connectionLabel {
    switch (_connectionStatus) {
      case ConnectivityResult.wifi:
        return 'Connected via WiFi';
      case ConnectivityResult.mobile:
        return 'Connected via Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Connected via Ethernet';
      case ConnectivityResult.none:
        return 'No Internet Connection';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            color: const Color(0xFF1A3C5E),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Network Status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Connection Status Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _isConnected ? Icons.wifi : Icons.wifi_off,
                          size: 60,
                          color: _isConnected ? Colors.green : Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isConnected
                              ? '🟢 Connected'
                              : '🔴 No Internet Connection',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _isConnected ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _connectionLabel,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Why Networking Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A3C5E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Why This App Needs Networking',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'The app needs networking to fetch live partner SACCO data, sync member records, and provide real-time updates beyond local storage.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFA8C7E8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Test API Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isTesting ? null : _testApiConnection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E86C1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isTesting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Test API Connection',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_apiTestResult.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _apiTestResult.startsWith('✅')
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      child: Text(
                        _apiTestResult,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: _apiTestResult.startsWith('✅')
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
