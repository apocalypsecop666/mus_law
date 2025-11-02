import paho.mqtt.client as mqtt
import random
import time

client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, "simple_test")

try:
    print("Підключення до MQTT брокера...")
    client.connect("broker.hivemq.com", 1883, 60)
    print("Підключено!")
    
    for i in range(10):
        temp = round(random.uniform(20.0, 30.0), 1)
        humidity = round(random.uniform(50.0, 80.0), 1)
        
        client.publish("sensor/temperature", str(temp))
        client.publish("sensor/humidity", str(humidity))
        
        print(f"📊 [{i+1}/10] Температура: {temp}°C, Вологість: {humidity}%")
        time.sleep(2)
        
except Exception as e:
    print(f"Помилка: {e}")
finally:
    client.disconnect()
    print("Завершено")