// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_schema.dart';

// **************************************************************************
// Borsh Struct Generator
// **************************************************************************

ChatMessageSchema _ChatMessageSchemaFromBorsh(List<int> _data) {
  ByteData _view = ByteData.sublistView(Uint8List.fromList(_data));
  int offset = 0;

  final messages = _view.readFixedArray<String>(Borsh.string, 20, offset);
  offset += messages.fold(0, (t, i) => t + i.length + 4);

  return ChatMessageSchema(
    messages: messages,
  );
}

List<int> _ChatMessageSchemaToBorsh(ChatMessageSchema s) {
  int size = 0;
  size += s.messages.fold(0, (t, i) => t + i.length + 4);
  size += 0;

  final data = ByteData(size);
  int offset = 0;
  offset += data.writeFixedArray<String>(Borsh.string, offset, s.messages);

  return data.buffer.asUint8List();
}
