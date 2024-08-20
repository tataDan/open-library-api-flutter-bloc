import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/search_values/search_values_bloc.dart';
import '../utility_classes/url_launchers.dart';
import 'documents_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _personController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _personController.dispose();
    _placeController.dispose();
    _subjectController.dispose();
    _isbnController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Open Library API')),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const SizedBox(height: 6),
          searchEntriesColumn(),
          buttonRow(),
        ],
      ),
    );
  }

  void clearSearchEntries() {
    _titleController.text = '';
    _authorController.text = '';
    _publisherController.text = '';
    _personController.text = '';
    _placeController.text = '';
    _subjectController.text = '';
    _isbnController.text = '';
    _languageController.text = '';
  }

  Future<void> _showEmptyFieldsDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Empty Fields'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please enter text into at least one search field.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Padding searchEntriesColumn() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            children: [
              const SizedBox(width: 10.0),
              SizedBox(
                width: 200.0,
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter the title',
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
              SizedBox(
                width: 200.0,
                child: TextField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    hintText: 'Enter author',
                    labelText: 'Author',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
              SizedBox(
                width: 200.0,
                child: TextField(
                  controller: _publisherController,
                  decoration: const InputDecoration(
                    hintText: 'Enter publisher',
                    labelText: 'Publisher',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
              SizedBox(
                width: 200.0,
                child: TextField(
                  controller: _personController,
                  decoration: const InputDecoration(
                    hintText: 'Enter person',
                    labelText: 'Person',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
          const SizedBox(height: 20.0),
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            children: [
              const SizedBox(width: 4.0),
              SizedBox(
                width: 200.0,
                child: TextField(
                  controller: _placeController,
                  decoration: const InputDecoration(
                    hintText: 'Enter place',
                    labelText: 'Place',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
              const SizedBox(width: 4),
              SizedBox(
                width: 200.0,
                child: TextField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    hintText: 'Enter subject',
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
              const SizedBox(width: 4.0),
              SizedBox(
                width: 200.0,
                child: TextField(
                  controller: _isbnController,
                  decoration: const InputDecoration(
                    hintText: 'Enter ISBN',
                    labelText: 'ISBN',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              const SizedBox(width: 4),
              SizedBox(
                width: 200.0,
                child: TextField(
                  controller: _languageController,
                  decoration: const InputDecoration(
                    hintText: 'Enter language code (3-letters)',
                    labelText: 'Language Code (3-letters)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding buttonRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          ElevatedButton(
            onPressed: () {
              Uri url = Uri.parse(
                  'https://www.loc.gov/standards/iso639-2/php/code_list.php');
              launchUrlForLanguageCodes(url);
            },
            child: const Text('Visit web page for language codes'),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            onPressed: clearSearchEntries,
            child: const Text('Clear search entries'),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.trim().isEmpty &&
                  _authorController.text.trim().isEmpty &&
                  _publisherController.text.trim().isEmpty &&
                  _personController.text.trim().isEmpty &&
                  _placeController.text.trim().isEmpty &&
                  _subjectController.text.trim().isEmpty &&
                  _isbnController.text.trim().isEmpty &&
                  _languageController.text.trim().isEmpty) {
                _showEmptyFieldsDialog();
                return;
              }
              Map<String, String> searchValues = {};
              if (_titleController.text.trim().isNotEmpty) {
                searchValues['title'] = _titleController.text.trim();
              }
              if (_authorController.text.trim().isNotEmpty) {
                searchValues['author'] = _authorController.text.trim();
              }
              if (_publisherController.text.trim().isNotEmpty) {
                searchValues['publisher'] = _publisherController.text.trim();
              }
              if (_personController.text.trim().isNotEmpty) {
                searchValues['person'] = _personController.text.trim();
              }
              if (_placeController.text.trim().isNotEmpty) {
                searchValues['place'] = _placeController.text.trim();
              }
              if (_subjectController.text.trim().isNotEmpty) {
                searchValues['subject'] = _subjectController.text.trim();
              }
              if (_isbnController.text.trim().isNotEmpty) {
                searchValues['isbn'] = _isbnController.text.trim();
              }
              if (_languageController.text.trim().isNotEmpty) {
                searchValues['language'] = _languageController.text.trim();
              }

              SearchValuesBloc searchValuesBloc =
                  context.read<SearchValuesBloc>();
              Map<String, String> newSearchValues = searchValues;
              searchValuesBloc.add(
                UpdateSearchValuesEvent(
                  searchValues: newSearchValues,
                ),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DocumentsPage(),
                ),
              );
            },
            child: const Text('Get book documents'),
          ),
        ],
      ),
    );
  }
}
