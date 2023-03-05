import 'package:flutter/material.dart';
import 'package:auor/models/chat_message.dart';
import 'package:auor/models/user.dart';
import 'package:auor/networking/api_provider.dart';
import 'package:auor/providers/auth_provider.dart';
import 'package:auor/utils/urls.dart';

class ReceivedMsgsProvider extends ChangeNotifier {
  User? _currentUser;
  String? _currentLang;

  void update(AuthProvider authProvider) {
    _currentUser = authProvider.currentUser;
    _currentLang = authProvider.currentLang;
  }

  ApiProvider _apiProvider = ApiProvider();

  Future<List<ChatMessage>> getReceivedMsgsList() async {
    final response = await _apiProvider.get(Urls.RECEIVED_MESSAGES_URL +
        '?user_id=${_currentUser!.userId}&page=1&api_lang=$_currentLang');
    List<ChatMessage> messageList = <ChatMessage>[];
    if (response['response'] == '1') {
      Iterable iterable = response['messages'];
      messageList =
          iterable.map((model) => ChatMessage.fromJson(model)).toList();
    }
    return messageList;
  }

  bool _isLoading = false;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
}
