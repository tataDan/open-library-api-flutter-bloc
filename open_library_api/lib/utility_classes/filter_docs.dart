import 'package:open_library_api/utility_classes/docs_filters.dart';

import '../models/open_library_response.dart';

class FilterDocs {
  List<Doc> docs;
  Map<String, String> searchValues;
  DocFilters docFilters;
  FilterDocs(
      {required this.docs,
      required this.searchValues,
      required this.docFilters});

  List<Doc> get filterDocs {
    List<Doc> filteredDocs = [];

    for (Doc doc in docs) {
      if (!filtered(doc)) {
        filteredDocs.add(doc);
      }
    }

    return filteredDocs;
  }

  bool setExactFilter(
      List<dynamic>? itemArray, String fieldText, bool searchType) {
    bool itemFiltered = false;
    if (itemArray != null) {
      if (searchType) {
        int unFilterCount = 0;
        for (String item in itemArray) {
          if (fieldText.toUpperCase().trim() == item.toUpperCase().trim()) {
            unFilterCount++;
          }
        }
        if (unFilterCount > 0) {
          itemFiltered = false;
        } else {
          itemFiltered = true;
        }
      }
    }
    return itemFiltered;
  }

  bool setSubstringFilter(
      List<dynamic>? itemArray, String fieldText, bool searchType) {
    bool itemFiltered = false;
    if (itemArray != null) {
      if (searchType) {
        int unFilterCount = 0;
        for (String item in itemArray) {
          if (item
              .toUpperCase()
              .trim()
              .contains(fieldText.toUpperCase().trim())) {
            unFilterCount++;
          }
        }
        if (unFilterCount > 0) {
          itemFiltered = false;
        } else {
          itemFiltered = true;
        }
      }
    }
    return itemFiltered;
  }

  bool filtered(Doc doc) {
    bool authorExactFiltered = false;
    bool authorSubstringFiltered = false;
    bool publisherExactFiltered = false;
    bool publisherSubstringFiltered = false;
    bool personExactFiltered = false;
    bool personSubstringFiltered = false;
    bool placeExactFiltered = false;
    bool placeSubstringFiltered = false;
    bool subjectExactFiltered = false;
    bool subjectSubstringFiltered = false;

    bool titleExactFiltered = (docFilters.titleExact) &&
        (searchValues['title']?.toUpperCase().trim() !=
            doc.title.toUpperCase().trim());

    bool titleSubstringFiltered = docFilters.titleSubstring &&
        !doc.title
            .toUpperCase()
            .trim()
            .contains(searchValues['title']!.toUpperCase().trim());

    if (searchValues['author'] != null) {
      authorExactFiltered = setExactFilter(
        doc.authorName,
        searchValues['author']!,
        docFilters.authorExact,
      );

      authorSubstringFiltered = setSubstringFilter(
        doc.authorName,
        searchValues['author']!,
        docFilters.authorSubstring,
      );
    }

    if (searchValues['publisher'] != null) {
      publisherExactFiltered = setExactFilter(
        doc.publisher,
        searchValues['publisher']!,
        docFilters.publisherExact,
      );

      publisherSubstringFiltered = setSubstringFilter(
        doc.publisher,
        searchValues['publisher']!,
        docFilters.publisherSubstring,
      );
    }

    if (searchValues['person'] != null) {
      personExactFiltered = setExactFilter(
        doc.person,
        searchValues['person']!,
        docFilters.personExact,
      );

      personSubstringFiltered = setSubstringFilter(
        doc.person,
        searchValues['person']!,
        docFilters.personSubstring,
      );
    }

    if (searchValues['place'] != null) {
      placeExactFiltered = setExactFilter(
        doc.place,
        searchValues['place']!,
        docFilters.placeExact,
      );

      placeSubstringFiltered = setSubstringFilter(
        doc.place,
        searchValues['place']!,
        docFilters.placeSubstring,
      );
    }

    if (searchValues['subject'] != null) {
      subjectExactFiltered = setExactFilter(
        doc.subject,
        searchValues['subject']!,
        docFilters.subjectExact,
      );

      subjectSubstringFiltered = setSubstringFilter(
        doc.subject,
        searchValues['subject']!,
        docFilters.subjectSubstring,
      );
    }

    if ((titleExactFiltered ||
        titleSubstringFiltered ||
        authorExactFiltered ||
        authorSubstringFiltered ||
        publisherExactFiltered ||
        publisherSubstringFiltered ||
        personExactFiltered ||
        personSubstringFiltered ||
        placeExactFiltered ||
        placeSubstringFiltered ||
        subjectExactFiltered ||
        subjectSubstringFiltered)) {
      return true;
    } else {
      return false;
    }
  }
}
