import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_place_holder/model.dart';
import 'package:http/http.dart' as http;

class DataSetPage extends StatefulWidget {
  const DataSetPage({super.key});

  @override
  State<DataSetPage> createState() => _DataSetPageState();
}

class _DataSetPageState extends State<DataSetPage> {
  late Future<List<Post>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = _fetchPosts();
  }

  Future<List<Post>> _fetchPosts() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List<dynamic>;
      final posts = jsonList.map((json) => Post.fromJson(json)).toList();
      return posts;
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSONPlaceholder Demo'),
      ),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: _posts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final res = snapshot.data;
              if (res == null) {
                return const Center(
                  child: Text('No data'),
                );
              }

              return MediaQuery.of(context).size.width < 600
                  ? _buildMobileLayout(res)
                  : _buildDesktopLayout(res);
            } else if (snapshot.hasError) {
              return const Text('Failed to fetch posts');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(List<Post> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return ListTile(
          title: Text(post.title),
          subtitle: Text(post.body),
        );
      },
    );
  }

  Widget _buildDesktopLayout(List<Post> posts) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('Title')),
        DataColumn(label: Text('Body')),
      ],
      rows: posts
          .map((post) => DataRow(cells: [
                DataCell(Text(post.title)),
                DataCell(Text(post.body)),
              ]))
          .toList(),
    );
  }
}
