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

  Future<File> receiveFile(String message, String path) async {
    _socket = await Socket.connect(host, port);
    _socket.add([...intToBytes(message.length), ...message.codeUnits,]);
    await _socket.flush();
    List<Uint8List> events = [];
    await for (var data in _socket) {
      events.add(data);
    }
    await _socket.close();
    File file = File(path);
    events.forEach((element) async => await file.writeAsBytes(element, mode: FileMode.append));
    return file;
  }

  Future<void> sendFile(String message, File file) async {
    _socket = await Socket.connect(host, port);
    _socket.add([...intToBytes(message.length), ...message.codeUnits,]);
    await _socket.addStream(file.openRead());
    await _socket.close();
  }

  List<int> intToBytes(int value) {
    return [(value & 0xFF000000) >> 24, (value & 0x00FF0000) >> 16, (value & 0x0000FF00) >> 8, value & 0x000000FF];
  }

  List<int> longToBytes(int value) {
    return [
      (value & 0xFF00000000000000) >> 56,
      (value & 0x00FF000000000000) >> 48,
      (value & 0x0000FF0000000000) >> 40,
      (value & 0x000000FF00000000) >> 32,
      (value & 0x00000000FF000000) >> 24,
      (value & 0x0000000000FF0000) >> 16,
      (value & 0x000000000000FF00) >> 8,
      (value & 0x00000000000000FF)
    ];
  }

}