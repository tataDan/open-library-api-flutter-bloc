import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/constants.dart';
import '../blocs/blocs.dart';
import '../utility_classes/docs_filters.dart';
import '../models/open_library_response.dart';
import '../widgets/error_dialog.dart';
import '../utility_classes/show_options.dart';
import '../utility_classes/url_launchers.dart';
import '../utility_classes/filter_docs.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  var showOptions = ShowOptions(
    showAuthor: true,
    showPublisher: true,
    showPerson: true,
    showPlace: true,
    showSubject: true,
    showIsbn: true,
    showLanguage: true,
  );

  Map<String, String>? _searchValues;
  int? _page;

  DocFilters docFilters = DocFilters(
      titleExact: false,
      authorExact: false,
      publisherExact: false,
      personExact: false,
      placeExact: false,
      subjectExact: false,
      titleSubstring: false,
      authorSubstring: false,
      publisherSubstring: false,
      personSubstring: false,
      placeSubstring: false,
      subjectSubstring: false);

  bool filtersApplied = false;

  @override
  Widget build(BuildContext context) {
    final openLibraryBloc = context.read<OpenLibraryBloc>();

    List<Doc> docs = [];

    _searchValues = context.watch<SearchValuesBloc>().state.searchValues;

    _page = context.watch<PageBloc>().state.page;
    openLibraryBloc
        .add(FetchOpenLibraryEvent(searchValues: _searchValues!, page: _page!));

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Open Library'),
        ),
      ),
      body: BlocConsumer<OpenLibraryBloc, OpenLibraryState>(
        listener: (context, state) {
          if (state.status == OpenLibraryStatus.error) {
            errorDialog(context, state.error.errMsg);
          }
        },
        builder: (context, state) {
          int numFound = state.openLibrary.numFound;
          docs = state.openLibrary.docs;

          if (filtersApplied) {
            docs = FilterDocs(
                    docs: docs,
                    searchValues: _searchValues!,
                    docFilters: docFilters)
                .filterDocs;
          }

          if (state.status == OpenLibraryStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.openLibrary.docs.isEmpty) {
            return const Center(
              child: Text(
                'NO DOCUMENTS WERE FOUND',
                style: TextStyle(fontSize: 20.0),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              primary: true,
              scrollDirection: Axis.vertical,
              children: [
                showOptionsRow(),
                showPageRow(numFound, context),
                const SizedBox(height: 10.0),
                showSearchFilters(),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return showDoc(index, docs);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Padding showOptionsRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          const Text(
            'Show Options:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 10),
          const Text('Author'),
          Checkbox(
            value: showOptions.showAuthor,
            onChanged: (bool? value) {
              setState(() {
                showOptions.showAuthor = value!;
              });
            },
          ),
          const SizedBox(width: 10),
          const Text('Publisher'),
          Checkbox(
            value: showOptions.showPublisher,
            onChanged: (bool? value) {
              setState(() {
                showOptions.showPublisher = value!;
              });
            },
          ),
          const SizedBox(width: 10),
          const Text('Person'),
          Checkbox(
            value: showOptions.showPerson,
            onChanged: (bool? value) {
              setState(() {
                showOptions.showPerson = value!;
              });
            },
          ),
          const SizedBox(width: 10),
          const Text('Place'),
          Checkbox(
            value: showOptions.showPlace,
            onChanged: (bool? value) {
              setState(() {
                showOptions.showPlace = value!;
              });
            },
          ),
          const SizedBox(width: 10),
          const Text('Subject'),
          Checkbox(
            value: showOptions.showSubject,
            onChanged: (bool? value) {
              setState(() {
                showOptions.showSubject = value!;
              });
            },
          ),
          const SizedBox(width: 10),
          const Text('ISBN'),
          Checkbox(
            value: showOptions.showIsbn,
            onChanged: (bool? value) {
              setState(() {
                showOptions.showIsbn = value!;
              });
            },
          ),
          const SizedBox(width: 10),
          const Text('Language'),
          Checkbox(
            value: showOptions.showLanguage,
            onChanged: (bool? value) {
              setState(() {
                showOptions.showLanguage = value!;
              });
            },
          ),
          const SizedBox(width: 15),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  showOptions.showAll();
                });
              },
              child: const Text('Set All Options')),
          const SizedBox(width: 15),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  showOptions.hideAll();
                });
              },
              child: const Text('Hide All Options')),
        ],
      ),
    );
  }

  Padding showPageRow(int numFound, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: [
          Text(
            'Page: $_page',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 10.0),
          ElevatedButton(
            onPressed: _page! > (numFound / docsPerPage)
                ? null
                : () {
                    BlocProvider.of<PageBloc>(context)
                        .add(IncrementPageEvent());
                  },
            child: const Text('Next Page'),
          ),
          const SizedBox(width: 10.0),
          ElevatedButton(
            onPressed: _page! <= 1
                ? null
                : () {
                    BlocProvider.of<PageBloc>(context)
                        .add(DecrementPageEvent());
                  },
            child: const Text('Previous Page'),
          ),
          const SizedBox(width: 20.0),
          Text(
            'Unfiltered documents: ${numFound.toString()}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 200.0),
          const Text(
            'Apply Filters',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 10.0),
          Switch(
            value: filtersApplied,
            activeColor: Colors.red,
            onChanged: (bool value) {
              setState(() {
                filtersApplied = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Padding showSearchFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10.0),
          Wrap(
            direction: Axis.horizontal,
            children: [
              const Text(
                'Filters:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(border: Border.all()),
                child: Wrap(
                  children: [
                    const Text('Title Exact'),
                    Checkbox(
                      value: docFilters.titleExact,
                      onChanged: (bool? value) {
                        setState(() {
                          docFilters.titleExact = value!;
                          docFilters.titleSubstring = false;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    const Text('Title Substring'),
                    Checkbox(
                      value: docFilters.titleSubstring,
                      onChanged: (bool? value) {
                        setState(() {
                          docFilters.titleSubstring = value!;
                          docFilters.titleExact = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(border: Border.all()),
                child: Wrap(
                  children: [
                    const Text('Author Exact'),
                    Checkbox(
                      value: docFilters.authorExact,
                      onChanged: (bool? value) {
                        setState(() {
                          docFilters.authorExact = value!;
                          docFilters.authorSubstring = false;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    const Text('Author Substring'),
                    Checkbox(
                      value: docFilters.authorSubstring,
                      onChanged: (bool? value) {
                        setState(() {
                          docFilters.authorSubstring = value!;
                          docFilters.authorExact = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(border: Border.all()),
                child: Wrap(
                  children: [
                    const Text('Publisher Exact'),
                    Checkbox(
                      value: docFilters.publisherExact,
                      onChanged: (bool? value) {
                        setState(() {
                          docFilters.publisherExact = value!;
                          docFilters.publisherSubstring = false;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    const Text('Publisher Substring'),
                    Checkbox(
                      value: docFilters.publisherSubstring,
                      onChanged: (bool? value) {
                        setState(() {
                          docFilters.publisherSubstring = value!;
                          docFilters.publisherExact = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 10.0),
          Wrap(
            direction: Axis.horizontal,
            children: [
              const SizedBox(width: 60),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(border: Border.all()),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                    const Text('Person Exact'),
                    Checkbox(
                      value: docFilters.personExact,
                      onChanged: (bool? value) {
                        setState(() {
                          docFilters.personExact = value!;
                          docFilters.personSubstring = false;
                        });
                      },
                    ),
                    const SizedBox(width: 15),
                    const Text('Person Substring'),
                    Checkbox(
                      value: docFilters.personSubstring,
                      onChanged: (bool? value) {
                        setState(() {
                          docFilters.personSubstring = value!;
                          docFilters.personExact = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(border: Border.all()),
                child: Wrap(
                  children: [
                    const Text('Place Exact'),
                    Checkbox(
                      value: docFilters.placeExact,
                      onChanged: (bool? value) {
                        setState(() {
                          docFilters.placeExact = value!;
                          docFilters.placeSubstring = false;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    const Text('Place Substring'),
                    Checkbox(
                      value: docFilters.placeSubstring,
                      onChanged: (bool? value) {
                        setState(() {
                          docFilters.placeSubstring = value!;
                          docFilters.placeExact = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(border: Border.all()),
                // child: Row(
                child: Wrap(
                  children: [
                    const Text('Subject Exact'),
                    Checkbox(
                      value: docFilters.subjectExact,
                      onChanged: (bool? value) {
                        setState(() {
                          docFilters.subjectExact = value!;
                          docFilters.subjectSubstring = false;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    const Text('Subject Substring'),
                    Checkbox(
                      value: docFilters.subjectSubstring,
                      onChanged: (bool? value) {
                        setState(() {
                          docFilters.subjectSubstring = value!;
                          docFilters.subjectExact = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding showDoc(int index, List<Doc> docs) {
    if (docs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Document filtered out'),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (index == 0)
              ? const SizedBox(height: 0.0)
              : const SizedBox(height: 8.0),
          Text(
            'Document #${index + 1}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 2.0),
          Row(
            children: [
              const Text('Title:'),
              const SizedBox(width: 6),
              Expanded(child: Text(docs[index].title)),
            ],
          ),
          Row(
            children: [
              const Text('Subtitle:'),
              const SizedBox(width: 6),
              docs[index].subtitle != null
                  ? Expanded(child: Text(docs[index].subtitle!))
                  : const Text(''),
            ],
          ),
          if (docs[index].authorName != null && showOptions.showAuthor) ...[
            for (var author in docs[index].authorName!)
              Row(
                children: [
                  const Text('Author:'),
                  const SizedBox(width: 6),
                  Expanded(child: Text(author)),
                ],
              ),
          ] else ...[
            const Text('Authors:')
          ],
          if (docs[index].publisher != null && showOptions.showPublisher) ...[
            for (var publisher in docs[index].publisher!)
              Row(
                children: [
                  const Text('Publisher:'),
                  const SizedBox(width: 6),
                  Expanded(child: Text(publisher)),
                ],
              ),
          ] else ...[
            const Text('Publishers:')
          ],
          if (docs[index].person != null && showOptions.showPerson) ...[
            for (var person in docs[index].person!)
              Row(
                children: [
                  const Text('Person:'),
                  const SizedBox(width: 6),
                  Expanded(child: Text(person)),
                ],
              ),
          ] else ...[
            const Text('Persons:'),
          ],
          if (docs[index].place != null && showOptions.showPlace) ...[
            for (var place in docs[index].place!)
              Row(
                children: [
                  const Text('Place:'),
                  const SizedBox(width: 6),
                  Expanded(child: Text(place)),
                ],
              ),
          ] else ...[
            const Text('Places:'),
          ],
          if (docs[index].subject != null && showOptions.showSubject) ...[
            for (var subject in docs[index].subject!)
              Row(
                children: [
                  const Text('Subject:'),
                  const SizedBox(width: 6),
                  Expanded(child: Text(subject)),
                ],
              ),
          ] else ...[
            const Text('Subjects:'),
          ],
          if (docs[index].isbn != null && showOptions.showIsbn) ...[
            for (var isbn in docs[index].isbn!)
              Row(
                children: [
                  const Text('ISBN:'),
                  const SizedBox(width: 6),
                  Expanded(child: Text(isbn)),
                ],
              ),
          ] else ...[
            const Text('ISBNs:'),
          ],
          if (docs[index].language != null && showOptions.showLanguage) ...[
            for (var language in docs[index].language!)
              Row(
                children: [
                  const Text('Language::'),
                  const SizedBox(width: 6),
                  Expanded(child: Text(language)),
                ],
              ),
          ] else ...[
            const Text('Languages:'),
          ],
          Row(
            children: [
              const Text('Key:'),
              const SizedBox(width: 6),
              Text(docs[index].key),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Uri url = Uri.parse('https://openlibrary.org/${docs[index].key}');
              launchUrlForBook(url);
            },
            child: const Text('Visit web page for this book'),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
