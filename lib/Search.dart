import 'package:flutter/material.dart';
import 'Models/BooksData.dart';
import 'Models/MembersData.dart';

class BooksSearch extends SearchDelegate<List<BooksData>> {
  Future<List<BooksData>> futureBooksData;

  BooksSearch() {
    futureBooksData = fetchBooks();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<BooksData>>(
      future: futureBooksData,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else if (snapshot.hasData) {
          final data = snapshot.data;
          final suggestionsList = query.isEmpty
              ? data
              : data
                  .where((e) =>
                      e.judul.toLowerCase().contains(query.toLowerCase()) ||
                      e.pengarang.toLowerCase().contains(query.toLowerCase()))
                  .toList();
          if (suggestionsList.isEmpty) {
            return Center(
              child: Text("No Result Found..."),
            );
          } else {
            return ListView.builder(
              itemCount: suggestionsList.length,
              itemBuilder: (context, index) {
                final bookItem = suggestionsList[index];
                return ListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, 5, 20, 5),
                  title: Text(
                    "${bookItem.judul}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    "${bookItem.pengarang}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(Icons.search),
                  onTap: () {},
                );
              },
            );
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class MembersSearch extends SearchDelegate<List<MembersData>> {
  Future<List<MembersData>> futureMembersData;

  MembersSearch() {
    futureMembersData = fetchMembers();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<MembersData>>(
      future: fetchMembers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else if (snapshot.hasData) {
          final data = snapshot.data;
          final suggestionsList = query.isEmpty
              ? data
              : data
                  .where((e) =>
                      e.nama.toLowerCase().contains(query.toLowerCase()) ||
                      e.id.startsWith(query))
                  .toList();
          if (suggestionsList.isEmpty) {
            return Center(
              child: Text("No Result Found..."),
            );
          } else {
            return ListView.builder(
              itemCount: suggestionsList.length,
              itemBuilder: (context, index) {
                final memberItem = suggestionsList[index];
                return listMembers(memberItem);
              },
            );
          }
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text("Loading..."),
            ],
          ),
        );
      },
    );
  }

  ListTile listMembers(MembersData memberItem) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(15, 5, 20, 5),
      leading: Container(
        height: 40,
        width: 40,
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              memberItem.gender == 'L' ? Colors.orange[300] : Colors.blue[400],
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  memberItem.gender == 'L'
                      ? "images/boy.png"
                      : "images/girl.png",
                ),
                fit: BoxFit.cover),
          ),
        ),
      ),
      title: Text(
        "${memberItem.nama}",
        style: TextStyle(
          fontSize: 15,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        "${memberItem.id}",
        style: TextStyle(
          fontSize: 12,
          color: Colors.black54,
          //fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Icon(Icons.search),
      onTap: () {},
    );
  }
}
