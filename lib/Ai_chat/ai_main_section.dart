import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const String _apiKey = "AIzaSyCMSLDltyJxX6I7vKxOqPf0Johvy2H2KZY";

class AiMainSec extends StatefulWidget {
  const AiMainSec({super.key});

  @override
  State<AiMainSec> createState() => _AiMainSecState();
}

class _AiMainSecState extends State<AiMainSec> {
  String apiKey = "AIzaSyCMSLDltyJxX6I7vKxOqPf0Johvy2H2KZY";

  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _apiKey);
    _chat = _model.startChat();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 750),
          curve: Curves.easeOutCirc),
    );
  }

  Future<void> _sendChartMessage(String message) async {
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
    });

    try{
      final response = await _chat.sendMessage(Content.text(message));
      final text = response.text;
      setState(() {
        _messages.add(ChatMessage(text: text!, isUser: false));
        _scrollDown();
      });
    }catch(error){
      setState(() {
        _messages.add(ChatMessage(text: "Error occured", isUser: false));
      });
    } finally {
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/chatbot1.jpg',height: 45,),
            Text("  ChatBot",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
          ],
        )
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context , index){
                return ChatBubble(message: _messages[index]);
              },
              )),
          Padding(padding: EdgeInsets.only(bottom: 20,left: 15),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Enter message",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  )
                ),
              )),
              // IconButton(
              //   onPressed: ()=>_sendChartMessage(_textController.text),
              //   icon: Icon(Icons.send),),
              SizedBox(width: 10,),
              GestureDetector(
                onTap: ()=>_sendChartMessage(_textController.text),
                  child: Image.asset('images/sendlogo.jpg',height: 30,))
            ],
          ),
          )
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
      alignment: message.isUser ? Alignment.centerRight : Alignment.bottomLeft,
      child: Container(
        // constraints: BoxConstraints(
        //   maxHeight: MediaQuery.of(context).size.width/1.25,
        // ),
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 14),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue[200] : Colors.green[200],
          borderRadius: BorderRadius.only(
              topLeft:Radius.circular(12),
              topRight: Radius.circular(12),
            bottomLeft:message.isUser ? Radius.circular(20): Radius.zero,
            bottomRight: message.isUser? Radius.zero :Radius.circular(20),
          )
        ),
        child: Text(message.text, style: TextStyle(
          fontSize: 16
        ),),
      ),
    );
  }
}
