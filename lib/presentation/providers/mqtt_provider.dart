import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mus_law/core/constants/mqtt_constants.dart';

class MqttProvider with ChangeNotifier {
  MqttServerClient? _client;
  bool _isConnected = false;
  double _temperature = 0;
  double _humidity = 0;
  String _status = 'Disconnected';

  bool get isConnected => _isConnected;
  double get temperature => _temperature;
  double get humidity => _humidity;
  String get status => _status;

  Future<void> connect() async {
    try {
      _client = MqttServerClient(
        MqttConstants.broker,
        MqttConstants.clientIdentifier,
      );
      _client!.port = MqttConstants.port;
      _client!.logging(on: false);
      _client!.keepAlivePeriod = MqttConstants.keepAlivePeriod;

      _client!.onConnected = _onConnected;
      _client!.onDisconnected = _onDisconnected;

      final connMessage = MqttConnectMessage()
          .withClientIdentifier(MqttConstants.clientIdentifier)
          .startClean()
          .withWillQos(MqttQos.atMostOnce);

      _client!.connectionMessage = connMessage;

      _status = 'Connecting...';
      notifyListeners();

      await _client!.connect();

      if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
        _subscribeToTopics();
      }
    } catch (e) {
      _status = 'Connection failed: $e';
      notifyListeners();
    }
  }

  void _onConnected() {
    _isConnected = true;
    _status = 'Connected to MQTT Broker';
    notifyListeners();
  }

  void _onDisconnected() {
    _isConnected = false;
    _status = 'Disconnected';
    notifyListeners();
  }

  void _subscribeToTopics() {
    _client!.subscribe(MqttConstants.temperatureTopic, MqttQos.atMostOnce);
    _client!.subscribe(MqttConstants.humidityTopic, MqttQos.atMostOnce);

    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final message = messages[0];
      final topic = message.topic;

      if (topic == MqttConstants.temperatureTopic) {
        final payload = _parsePayload(message);
        _temperature = double.tryParse(payload) ?? _temperature;
        notifyListeners();
      } else if (topic == MqttConstants.humidityTopic) {
        final payload = _parsePayload(message);
        _humidity = double.tryParse(payload) ?? _humidity;
        notifyListeners();
      }
    });
  }

  String _parsePayload(MqttReceivedMessage<MqttMessage> message) {
    final publishMessage = message.payload as MqttPublishMessage;
    return MqttPublishPayload.bytesToStringAsString(
      publishMessage.payload.message,
    );
  }

  void disconnect() {
    _client?.disconnect();
    _isConnected = false;
    _status = 'Disconnected';
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
