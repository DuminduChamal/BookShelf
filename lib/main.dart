import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import './models/book.dart';

void main()=>runApp(BookApp());

class BookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookShelf',
      home: Text('sadasf'),
    );
  }
}

class BookFireBaseDemo extends StatefulWidget {

  BookFireBaseDemo(): super();
  final String appTitle = "Book DB";

  @override
  _BookFireBaseDemoState createState() => _BookFireBaseDemoState();
}

class _BookFireBaseDemoState extends State<BookFireBaseDemo> {

  TextEditingController bookNameContoller = TextEditingController();
  TextEditingController bookAuthorContoller = TextEditingController();

  bool isEditing = false;
  bool textFieldVisibility = false;

  String firestoreCollectionName = "Books";

  Book currentBook;

  getAllBooks()
  {
    return Firestore.instance.collection(firestoreCollectionName).snapshots();
  }

  addBook() async
  {
    Book book = Book(bookName: bookNameContoller.text, authorName: bookAuthorContoller.text);
    try {
      Firestore.instance.runTransaction(
        (Transaction transaction) async {
          await Firestore.instance
                          .collection(firestoreCollectionName)
                          .document()
                          .setData(book.toJason());
        }
      );
    } catch (e) {
      print(e.toString());
    }
  }

  updateBook(Book book, String bookName, String authorName)
  {
    try 
    {
      Firestore.instance.runTransaction((transaction)async
      {
        await transaction.update(book.documentReference, {'bookName':bookName, 'authorName':authorName});
      });
    } 
    catch (e) 
    {
      print(e.toString());
    }
  }

  updateIfEditing()
  {
    if(isEditing)
    {
      //update
      updateBook(currentBook, bookNameContoller.text, bookAuthorContoller.text);
      setState(() {
        isEditing=false;
      });
    }
  }

  deleteBook(Book book)
  {
    Firestore.instance.runTransaction(
      (Transaction transaction) async {
        await transaction.delete(book.documentReference);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}