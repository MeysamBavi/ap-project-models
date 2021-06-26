import 'dart:io';
import 'dart:typed_data';

class CustomSocket {
  late Socket _socket;
  String host;
  int port;
  CustomSocket(this.host, this.port);

  Future<String> writeString(String message) async {
    _socket = await Socket.connect(host, port);
    _socket.add([...intToBytes(message.length), ...message.codeUnits,]);
    await _socket.flush();
    List<Uint8List> events = [];
    await for (var data in _socket) {
      events.add(data);
    }
    String result = events.map<String>((e) => String.fromCharCodes(e)).join();
    await _socket.close();
    return result;
  }

  List<int> intToBytes(int value) {
    return [(value & 0xFF000000) >> 24, (value & 0x00FF0000) >> 16, (value & 0x0000FF00) >> 8, value & 0x000000FF];
  }

}