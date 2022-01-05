import 'messge_wrapper.dart';

class ChatWrapper{

  List<MessageWrapper> _messages = [];

  List<MessageWrapper> get messages => _messages;
  String address;

  int _sentAmount = 0;

  int get sentAmount => _sentAmount;

  set sentAmount(int value) {
    _sentAmount = value;
  }

  int _receivedAmount = 0;

  void addMessages(List<MessageWrapper> newMessages){
    newMessages.sort((a,b) => a.createdOn.compareTo(b.createdOn));
    _messages.addAll(newMessages);
  }

  ChatWrapper(this.address);

  int get receivedAmount => _receivedAmount;

  set receivedAmount(int value) {
    _receivedAmount = value;
  }
}