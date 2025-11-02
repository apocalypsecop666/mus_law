import 'dart:async';
import 'package:flutter/material.dart';

class MqttProvider with ChangeNotifier {
  Timer? _simulationTimer;
  bool _isConnected = false;
  double _temperature = 20;
  double _humidity = 50;
  String _status = 'Disconnected';
  String _error = '';

  bool get isConnected => _isConnected;
  double get temperature => _temperature;
  double get humidity => _humidity;
  String get status => _status;
  String get error => _error;

  Future<void> connect() async {
    try {
      _updateStatus('Simulating MQTT data (Web restrictions)');

      // ignore: inference_failure_on_instance_creation
      await Future.delayed(const Duration(seconds: 2));

      _isConnected = true;
      _error = '';
      _updateStatus('Connected (Simulation)');

      _startSimulation();
    } catch (e) {
      _error = 'Simulation error: $e';
      _updateStatus('Connection failed');
    }
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _temperature = 20.0 + (DateTime.now().second % 15);
      _humidity = 50.0 + (DateTime.now().second % 30);
      _scheduleNotify();
    });
  }

  void _updateStatus(String newStatus) {
    _status = newStatus;
    _scheduleNotify();
  }

  void _scheduleNotify() {
    Future.microtask(() {
      if (_status != 'Disposed') {
        notifyListeners();
      }
    });
  }

  void disconnect() {
    _simulationTimer?.cancel();
    _isConnected = false;
    _status = 'Disconnected';
    _scheduleNotify();
  }

  @override
  void dispose() {
    _status = 'Disposed';
    _simulationTimer?.cancel();
    super.dispose();
  }
}
