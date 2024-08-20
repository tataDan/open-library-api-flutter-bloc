# README

## About

This application lets users search for books and provides information (eg. authors, publishers, subject, languages, ect.) about the books found.

It uses the [openlibrary API](https://openlibrary.org/). Documentation can be found [here](https://openlibrary.org/developers/api).

It uses [Bloc](https://bloclibrary.dev/) for state management.

A running implementation of the application can found [here](https://danielgenecasey.net/open-library/).

This application has been tested on Windows, the web, and Linux.  (It runs on a Android phone, but the layout looks better on the desktop or web).

## Running & Building

To run the application you can use the `flutter run` command specifying the device like so: `flutter run -d windows`.

To run and build the application in release mode you can enter a command such as this: `flutter run -d windows --release`.

To build the application in release mode you can enter a command such as this: `flutter build windows`.

## Using the Application

The user can enter text into one or more of the eight search fields.  The search is performed in a "AND" manner and in not a "OR" manner.  For example, if the user enters "Rainbow" in the title field, then the search will match approximately 12,921 books. However, if the user also enters "Thomas Pynchon" in the author field as well, then the search will return only two books, both of which were written by Thomas Pynchon.

It should be noted that a search of "Tom Sawyer" in the title field will yeld books such as "The Adventures of Tom Sawyer" and "Tom Sawyer, Detective". If instead the user enters "Tom Sawyer, Detective" in the title field, then the search will still yeld books such as "Tom Sawer Detective and Other Stories".  If the user wants to see only books with the exact title of "Tom Sawyer, Detective", then he or she could click on the "Title Exact" checkbox in the filters area of the search page and move the Apply Filters to the on position. If the user wanted to see all the books that contain the substring of "Tom Sawyer, Detective" in the title field, then he or she could click on the "Title Substring" checkbox. Doing so would yeld books with a title of "Tom Sawyer, Detective" and books with a title of "Tom Sawyer, Detective Illustrated".

It should be noted that the user must click on the "Get book documents" button (or tab to it and press the `<Enter>` key) to invoke the search after any changes are made to any of the search fields.

It should be noted that the openlibrary api returns its data in pages, each page having a maximum of 100 records. Therefore, to see any additional books that meet the search criteria, the user should click on the "Next page" button on the search page.

If the user wants to use the keyboard to scrool through the list of books (in addition to using the mouse), he or she can use the keyboard to scrool using the `<Page Down>` key or the `<Page Up>` key.

