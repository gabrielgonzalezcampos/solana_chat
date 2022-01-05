// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// Borsh Struct Generator
// **************************************************************************

ChatMessage _ChatMessageFromBorsh(List<int> _data) {
  ByteData _view = ByteData.sublistView(Uint8List.fromList(_data));
  int offset = 0;

  final message = _view.readString(offset);
  offset += 4 + message.length;

  final createdOn = _view.readString(offset);
  offset += 4 + createdOn.length;

  return ChatMessage(
    message: message,
    createdOn: createdOn,
  );
}

List<int> _ChatMessageToBorsh(ChatMessage s) {
  int size = 0;
  size += s.message.length;
  size += s.createdOn.length;
  size += 8;

  final data = ByteData(size);
  int offset = 0;
  offset += data.writeString(offset, s.message);
  offset += data.writeString(offset, s.createdOn);

  return data.buffer.asUint8List();
}
