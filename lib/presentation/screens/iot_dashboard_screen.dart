import 'package:flutter/material.dart';
import 'package:mus_law/presentation/providers/connectivity_provider.dart';
import 'package:mus_law/presentation/providers/mqtt_provider.dart';
import 'package:mus_law/presentation/widgets/connection_status.dart';
import 'package:mus_law/presentation/widgets/temperature_widget.dart';
import 'package:provider/provider.dart';

class IotDashboardScreen extends StatefulWidget {
  const IotDashboardScreen({super.key});

  @override
  State<IotDashboardScreen> createState() => _IotDashboardScreenState();
}

class _IotDashboardScreenState extends State<IotDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _connectToMqtt();
  }

  void _connectToMqtt() {
    final mqttProvider = Provider.of<MqttProvider>(context, listen: false);
    mqttProvider.connect();
  }

  @override
  Widget build(BuildContext context) {
    final mqttProvider = Provider.of<MqttProvider>(context);
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('IoT Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _connectToMqtt,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConnectionStatus(
              isConnected: connectivityProvider.isConnected,
              mqttStatus: mqttProvider.status,
            ),
            const SizedBox(height: 20),
            if (!connectivityProvider.isConnected)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'No internet connection. Some features may be limited.',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                children: [
                  TemperatureWidget(
                    value: mqttProvider.temperature,
                    type: 'Temperature',
                    unit: '°C',
                    icon: Icons.thermostat,
                    color: Colors.red,
                  ),
                  TemperatureWidget(
                    value: mqttProvider.humidity,
                    type: 'Humidity',
                    unit: '%',
                    icon: Icons.water_drop,
                    color: Colors.blue,
                  ),
                  _buildConnectionCard(mqttProvider),
                  _buildInfoCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionCard(MqttProvider mqttProvider) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              mqttProvider.isConnected ? Icons.cloud_done : Icons.cloud_off,
              size: 40,
              color: mqttProvider.isConnected ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              mqttProvider.isConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: mqttProvider.isConnected ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'MQTT Broker',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            const Text(
              'IoT Info',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Subscribe to sensor data',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
