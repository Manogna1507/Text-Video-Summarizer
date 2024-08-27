import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TextScreen(),
    );
  }
}

class TextScreen extends StatefulWidget {
  const TextScreen({super.key});

  @override
  _TextScreenState createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  final TextEditingController _controller = TextEditingController();
  String _summary = '';
  String _selectedFileName = '';

  Future<void> _sendText(String text) async {
    setState(() {
      _summary = 'Generating summary...';
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://your-ngrok-url.ngrok-free.app/summarize'),
      );
      request.fields['input_text'] = text;

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        setState(() {
          _summary = data['summary_text'];
        });
      } else {
        setState(() {
          _summary = 'Error: ${response.statusCode} ${response.reasonPhrase}\nBody: $responseData';
        });
      }
    } catch (e, stackTrace) {
      setState(() {
        _summary = 'Error: $e';
      });
    }
  }

  Future<void> _uploadDocument(PlatformFile file) async {
    if (file.bytes == null) {
      setState(() {
        _summary = 'Error: No file selected.';
      });
      return;
    }

    setState(() {
      _selectedFileName = file.name;
      _summary = 'Generating summary...';
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://c873-34-83-231-88.ngrok-free.app/summarize'),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          file.bytes!,
          filename: file.name,
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        setState(() {
          _summary = data['summary_text'];
        });
      } else {
        setState(() {
          _summary = 'Error: ${response.statusCode} ${response.reasonPhrase}\nBody: $responseData';
        });
      }
    } catch (e, stackTrace) {
      setState(() {
        _summary = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_selectedFileName.isNotEmpty)
                        Text(
                          'Selected file: $_selectedFileName',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      SizedBox(height: 10),
                      Text(
                        _summary,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle),
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'docx', 'txt'],
                        );

                        if (result != null && result.files.isNotEmpty) {
                          PlatformFile file = result.files.first;
                          await _uploadDocument(file);
                        }
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Enter prompt',
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        _sendText(_controller.text);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
