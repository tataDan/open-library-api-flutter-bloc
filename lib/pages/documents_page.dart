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
  int docCountBase = 1;
  Map<int, int> pageCounts = {};
  Map<int, int> pageCountsFiltered = {};
  bool filtersApplied = false;
  bool shouldCallServer = true;
  int numFiltersChecked = 0;
  bool shouldShowFilters = false;

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

  @override
  Widget build(BuildContext context) {
    final openLibraryBloc = context.read<OpenLibraryBloc>();
    List<Doc> docs = [];

    _searchValues = context.watch<SearchValuesBloc>().state.searchValues;
    _page = context.watch<PageBloc>().state.page;

    if (shouldCallServer) {
      openLibraryBloc.add(
          FetchOpenLibraryEvent(searchValues: _searchValues!, page: _page!));
      shouldCallServer = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Open Library'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<PageBloc>().add(ResetToOnePageEvent());
            Navigator.pop(context, true);
          },
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
            pageCountsFiltered[_page! - 1] = docs.length;
          } else {
            pageCounts[_page! - 1] = docs.length;
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
            child: Column(
              children: [
                if (!shouldShowFilters) showOptionsRow(),
                if (!shouldShowFilters) showPageRow(numFound, context),
                const SizedBox(height: 10.0),
                if (shouldShowFilters) showFilters(),
                if (!shouldShowFilters) const Divider(),
                if (!shouldShowFilters)
                  Expanded(
                    child: ListView.builder(
                      primary: true,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        return showDoc(index, docs);
                      },
                    ),
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
        alignment: WrapAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                shouldShowFilters = true;
              });
            },
            child: const Text('Show filters'),
          ),
          const SizedBox(width: 20.0),
          Text(
            'Page: $_page',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 10.0),
          ElevatedButton(
            onPressed: _page! >= (numFound / docsPerPage)
                ? null
                : () {
                    BlocProvider.of<PageBloc>(context)
                        .add(IncrementPageEvent());
                    if (filtersApplied) {
                      docCountBase += pageCountsFiltered[_page! - 1]!;
                    } else {
                      docCountBase += pageCounts[_page! - 1]!;
                    }
                    shouldCallServer = true;
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
                    if (filtersApplied) {
                      docCountBase -= pageCountsFiltered[_page! - 2]!;
                    } else {
                      docCountBase -= pageCounts[_page! - 2]!;
                    }
                    shouldCallServer = true;
                  },
            child: const Text('Previous Page'),
          ),
          const SizedBox(width: 20.0),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<PageBloc>(context).add(ResetToOnePageEvent());
              docCountBase = 1;
              shouldCallServer = true;
            },
            child: const Text('Go to first page'),
          ),
          const SizedBox(width: 20.0),
          Text(
            'Unfiltered documents: ${numFound.toString()}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void computerNumFiltersChecked(bool value) {
    if (value) {
      numFiltersChecked++;
    } else {
      numFiltersChecked--;
    }
    if (numFiltersChecked > 0) {
      filtersApplied = true;
    }
  }

  Padding showFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10.0),
          Wrap(
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
                    const Text('Title:  Exact'),
                    Checkbox(
                      value: docFilters.titleExact,
                      onChanged: _page == 1
                          ? (bool? value) {
                              setState(
                                () {
                                  docFilters.titleExact = value!;
                                  docFilters.titleSubstring = false;
                                  computerNumFiltersChecked(value);
                                },
                              );
                            }
                          : null,
                    ),
                    const SizedBox(width: 12),
                    const Text('Substring'),
                    Checkbox(
                      value: docFilters.titleSubstring,
                      onChanged: _page == 1
                          ? (bool? value) {
                              setState(
                                () {
                                  docFilters.titleSubstring = value!;
                                  docFilters.titleExact = false;
                                  computerNumFiltersChecked(value);
                                },
                              );
                            }
                          : null,
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
                    const Text('Author:  Exact'),
                    Checkbox(
                      value: docFilters.authorExact,
                      onChanged: _page == 1
                          ? (bool? value) {
                              setState(() {
                                docFilters.authorExact = value!;
                                docFilters.authorSubstring = false;
                                computerNumFiltersChecked(value);
                              });
                            }
                          : null,
                    ),
                    const SizedBox(width: 12),
                    const Text('Substring'),
                    Checkbox(
                      value: docFilters.authorSubstring,
                      onChanged: _page == 1
                          ? (bool? value) {
                              setState(() {
                                docFilters.authorSubstring = value!;
                                docFilters.authorExact = false;
                                computerNumFiltersChecked(value);
                              });
                            }
                          : null,
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
                    const Text('Publisher:  Exact'),
                    Checkbox(
                      value: docFilters.publisherExact,
                      onChanged: _page == 1
                          ? (bool? value) {
                              setState(() {
                                docFilters.publisherExact = value!;
                                docFilters.publisherSubstring = false;
                                computerNumFiltersChecked(value);
                              });
                            }
                          : null,
                    ),
                    const SizedBox(width: 12),
                    const Text('Substring'),
                    Checkbox(
                      value: docFilters.publisherSubstring,
                      onChanged: _page == 1
                          ? (bool? value) {
                              setState(() {
                                docFilters.publisherSubstring = value!;
                                docFilters.publisherExact = false;
                                computerNumFiltersChecked(value);
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 10.0),
          Wrap(
            children: [
              const SizedBox(width: 60),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(border: Border.all()),
                child: Wrap(
                  children: [
                    const Text('Person:  Exact'),
                    Checkbox(
                      value: docFilters.personExact,
                      onChanged: _page == 1
                          ? (bool? value) {
                              setState(() {
                                docFilters.personExact = value!;
                                docFilters.personSubstring = false;
                                computerNumFiltersChecked(value);
                              });
                            }
                          : null,
                    ),
                    const SizedBox(width: 15),
                    const Text('Substring'),
                    Checkbox(
                      value: docFilters.personSubstring,
                      onChanged: _page == 1
                          ? (bool? value) {
                              setState(() {
                                docFilters.personSubstring = value!;
                                docFilters.personExact = false;
                                computerNumFiltersChecked(value);
                              });
                            }
                          : null,
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
                    const Text('Place:  Exact'),
                    Checkbox(
                      value: docFilters.placeExact,
                      onChanged: _page == 1
                          ? (bool? value) {
                              setState(() {
                                docFilters.placeExact = value!;
                                docFilters.placeSubstring = false;
                                computerNumFiltersChecked(value);
                              });
                            }
                          : null,
                    ),
                    const SizedBox(width: 12),
                    const Text('Substring'),
                    Checkbox(
                      value: docFilters.placeSubstring,
                      onChanged: _page == 1
                          ? (bool? value) {
                              setState(() {
                                docFilters.placeSubstring = value!;
                                docFilters.placeExact = false;
                                computerNumFiltersChecked(value);
                              });
                            }
                          : null,
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
                    const Text('Subject:  Exact'),
                    Checkbox(
                      value: docFilters.subjectExact,
                      onChanged: _page == 1
                          ? (bool? value) {
                              setState(() {
                                docFilters.subjectExact = value!;
                                docFilters.subjectSubstring = false;
                                computerNumFiltersChecked(value);
                              });
                            }
                          : null,
                    ),
                    const SizedBox(width: 12),
                    const Text('Substring'),
                    Checkbox(
                      value: docFilters.subjectSubstring,
                      onChanged: _page == 1
                          ? (bool? value) {
                              setState(() {
                                docFilters.subjectSubstring = value!;
                                docFilters.subjectExact = false;
                                computerNumFiltersChecked(value);
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              setState(() {
                shouldShowFilters = false;
              });
            },
            child: const Text('Return to documents screen'),
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
            'Document #${index + docCountBase}',
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
          if (docs[index].authorName != null && showOptions.showAuthor)
            for (var author in docs[index].authorName!)
              Row(
                children: [
                  const Text('Author:'),
                  const SizedBox(width: 6),
                  Expanded(child: Text(author)),
                ],
              ),
          if (docs[index].publisher != null && showOptions.showPublisher)
            for (var publisher in docs[index].publisher!)
              Row(
                children: [
                  const Text('Publisher:'),
                  const SizedBox(width: 6),
                  Expanded(child: Text(publisher)),
                ],
              ),
          if (docs[index].person != null && showOptions.showPerson)
            for (var person in docs[index].person!)
              Row(
                children: [
                  const Text('Person:'),
                  const SizedBox(width: 6),
                  Expanded(child: Text(person)),
                ],
              ),
          if (docs[index].place != null && showOptions.showPlace)
            for (var place in docs[index].place!)
              Row(
                children: [
                  const Text('Place:'),
                  const SizedBox(width: 6),
                  Expanded(child: Text(place)),
                ],
              ),
          if (docs[index].subject != null && showOptions.showSubject)
            for (var subject in docs[index].subject!)
              Row(
                children: [
                  const Text('Subject:'),
                  const SizedBox(width: 6),
                  Expanded(child: Text(subject)),
                ],
              ),
          if (docs[index].isbn != null && showOptions.showIsbn)
            for (var isbn in docs[index].isbn!)
              Row(
                children: [
                  const Text('ISBN:'),
                  const SizedBox(width: 6),
                  Expanded(child: Text(isbn)),
                ],
              ),
          if (docs[index].language != null && showOptions.showLanguage)
            for (var language in docs[index].language!)
              Row(
                children: [
                  const Text('Language::'),
                  const SizedBox(width: 6),
                  Expanded(child: Text(language)),
                ],
              ),
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
