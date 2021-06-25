import 'dart:io';
import 'dart:typed_data';

class CustomSocket {
  Socket _socket;
  List<Uint8List> _buffer;
  CustomSocket(this._socket) :
      _buffer = <Uint8List>[]
  {
    _socket.listen((Uint8List event) {
      _buffer.add(event);
    });
  }

  String readString() {
    return String.fromCharCodes(_buffer[0]);
  }

  void writeString(String message) async {
    _socket.add(intToBytes(message.length));
    _socket.add(message.codeUnits);
    await _socket.flush();
  }

  List<int> intToBytes(int value) {
    return [(value & 0xFF000000) >> 24, (value & 0x00FF0000) >> 16, (value & 0x0000FF00) >> 8, value & 0x000000FF];
  }

}