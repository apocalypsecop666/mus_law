import 'package:flutter/material.dart';
import 'package:mus_law/presentation/providers/connectivity_provider.dart';
import 'package:mus_law/presentation/providers/mqtt_provider.dart';
import 'package:mus_law/presentation/widgets/connection_status.dart';
import 'package:mus_law/presentation/widgets/temperature_widget.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), _connectToMqtt);
  }

  void _connectToMqtt() {
    final mqttProvider = Provider.of<MqttProvider>(context, listen: false);
    if (!mqttProvider.isConnected) {
      mqttProvider.connect();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mqttProvider = Provider.of<MqttProvider>(context);
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Dashboard'),
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
                  'No internet connection. MQTT will not work.',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            if (mqttProvider.error.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'MQTT Error: ${mqttProvider.error}',
                  style: const TextStyle(color: Colors.red),
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
              'MQTT Status',
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
              'MQTT Info',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Topics:\n• sensor/temperature\n• sensor/humidity',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
