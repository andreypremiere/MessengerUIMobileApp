import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocketChannel? _channel;
  Function(dynamic)? _onMessage;

  bool get isConnected => _channel != null;

  /// Подключение к WebSocket
  void connect(String url, {Function(dynamic)? onMessage}) {
    if (_channel != null) {
      print('WebSocket уже подключен');
      return;
    }

    print('Подключение к $url...');
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _onMessage = onMessage;

    _channel!.stream.listen(
      (message) {
        print('📩 WS: $message');
        if (_onMessage != null) {
          _onMessage!(message);
        }
      },
      onError: (error) {
        print('❌ Ошибка WS: $error');
      },
      onDone: () {
        print('🔌 Соединение закрыто');
        _channel = null;
      },
    );
  }

  /// Отправка данных
  void send(dynamic data) {
    if (_channel == null) {
      print('⚠️ Невозможно отправить: WebSocket не подключен');
      return;
    }
    if (data is Map) {
      _channel!.sink.add(jsonEncode(data));
    } else {
      _channel!.sink.add(data.toString());
    }
  }

  /// Закрытие соединения
  void disconnect() {
    if (_channel != null) {
      print('🔌 Закрытие WebSocket соединения...');
      _channel!.sink.close();
      _channel = null;
    }
  }
}
