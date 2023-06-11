import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kel_1_api/controller/post_controller.dart';
import 'package:kel_1_api/models/post.dart';
import 'package:kel_1_api/utils/app_route.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PostController postController = PostController();
  late Future<List<Post>> _fetchPostsFuture;
  List<Post> _allPosts = [];
  List<Post> _filteredPosts = [];
  late int _selectedUserId = 0; // Nilai awal filter

  @override
  void initState() {
    super.initState();
    _fetchPostsFuture = postController.fetchAll();
  }

  void _filterPosts(int userId) {
    setState(() {
      if (userId == 0) {
        _filteredPosts = _allPosts;
      } else {
        _filteredPosts =
            _allPosts.where((post) => post.userId == userId).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Post>>(
          future: _fetchPostsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                _allPosts = snapshot.data!; // Assign data ke _allPosts
                _filteredPosts = _selectedUserId == 0
                    ? _allPosts
                    : _allPosts
                        .where((post) => post.userId == _selectedUserId)
                        .toList(); // Filter data
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButton<int>(
                        value: _selectedUserId,
                        onChanged: (value) {
                          setState(() {
                            _selectedUserId = value!;
                            _filterPosts(_selectedUserId);
                          });
                        },
                        items: const [
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text('All'),
                          ),
                          DropdownMenuItem<int>(
                            value: 1,
                            child: Text('User 1'),
                          ),
                          DropdownMenuItem<int>(
                            value: 2,
                            child: Text('User 2'),
                          ),
                          DropdownMenuItem<int>(
                            value: 3,
                            child: Text('User 3'),
                          ),
                          DropdownMenuItem<int>(
                            value: 4,
                            child: Text('User 4'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.01),
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            final Post post =
                                _filteredPosts[index]; // Gunakan _filteredPosts
                            return Dismissible(
                              key: Key(post.id.toString()),
                              onDismissed: (direction) {
                                postController.delete(post.id).then((result) {
                                  if (result) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Post Deleted"),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    setState(() {});
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Failed to Delete Post"),
                                      ),
                                    );
                                    setState(() {});
                                  }
                                });
                              },
                              child: Card(
                                child: ListTile(
                                  onLongPress: () {
                                    Approutes.goRouter.pushNamed(
                                        Approutes.editPost,
                                        extra: post);
                                  },
                                  onTap: () {
                                    GoRouter.of(context)
                                        .pushNamed(Approutes.post, extra: post);
                                  },
                                  title: Text(
                                    post.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    post.body,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: size.height * 0.0005,
                            );
                          },
                          itemCount: _filteredPosts
                              .length, // Ubah menjadi _filteredPosts.length
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Text("Tidak ada Data");
              }
            } else {
              return const Text("Error");
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          GoRouter.of(context).pushNamed(Approutes.addPost);
        },
        label: const Text("Tambah Berita"),
      ),
    );
  }
}


// class _HomePageState extends State<HomePage> {
//   final PostController postController = PostController();

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home Page"),
//       ),
//       body: SafeArea(
//         child: FutureBuilder<List<Post>>(
//           future: postController.fetchAll(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.hasData) {
//               if (snapshot.data!.isNotEmpty) {
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
//                   child: ListView.separated(
//                     itemBuilder: (context, index) {
//                       return Dismissible(
//                         key: Key(snapshot.data![index].id.toString()),
//                         onDismissed: (direction) {
//                           postController
//                               .delete(snapshot.data![index].id)
//                               .then((result) {
//                             if (result) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text("Post deleted"),
//                                   behavior: SnackBarBehavior.floating,
//                                 ),
//                               );
//                               setState(() {});
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text("Failed to deleted post"),
//                                 ),
//                               );
//                               setState(() {});
//                             }
//                           });
//                         },
//                         child: Card(
//                           child: ListTile(
//                             onLongPress: () {
//                               Approutes.goRouter.pushNamed(Approutes.editPost,
//                                   extra: snapshot.data![index]);
//                             },
//                             onTap: () {
//                               GoRouter.of(context).pushNamed(Approutes.post,
//                                   extra: snapshot.data![index]);
//                             },
//                             title: Text(
//                               snapshot.data![index].title,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             subtitle: Text(
//                               snapshot.data![index].body,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     separatorBuilder: (context, index) {
//                       return SizedBox(
//                         height: size.height * 0.0005,
//                       );
//                     },
//                     itemCount: snapshot.data!.length,
//                   ),
//                 );
//               } else {
//                 return const Text("Tidak ada data");
//               }
//             } else {
//               return const Text("Error");
//             }
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           GoRouter.of(context).pushNamed(Approutes.addPost);
//         },
//         label: const Text("Tambah Berita"),
//       ),
//     );
//   }
// }
