import 'package:flutter/material.dart';
import 'package:flutter_json_place_holder/model.dart';
import 'package:flutter_json_place_holder/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataRiverPodPage extends ConsumerWidget {
  const DataRiverPodPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSONPlaceholder Demo'),
      ),
      body: posts.when(
        data: (posts) {
          return MediaQuery.of(context).size.width < 600
              ? _buildMobileLayout(posts)
              : _buildDesktopLayout(posts);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Text('Failed to fetch posts'),
      ),
    );
  }

  Widget _buildMobileLayout(List<Post> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              title: Text(post.title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.deepOrange[600],
                    fontStyle: FontStyle.italic,
                  )),
              subtitle: Text(post.body),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(List<Post> posts) {
    return DataTable(
      dataRowHeight: 52,
      columns: const <DataColumn>[
        DataColumn(label: Text('Title')),
        DataColumn(label: Text('Body')),
      ],
      dividerThickness: 3.0,
      rows: posts
          .map((post) => DataRow(cells: [
                DataCell(Text(post.title)),
                DataCell(Text(post.body)),
              ]))
          .toList(),
    );
  }
}
