class MqttConstants {
  static const String broker = 'broker.hivemq.com';
  static const int port = 1883;
  static const int wsPort = 8884;
  static const String temperatureTopic = 'sensor/temperature';
  static const String humidityTopic = 'sensor/humidity';
  static const int keepAlivePeriod = 60;
  static const String clientIdentifier = 'flutter_mus_client';
}
