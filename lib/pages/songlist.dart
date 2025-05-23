import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ukll/pages/Addsong.dart';
import 'package:ukll/pages/song.dart';
import '../models/song.dart';

class SongListPage extends StatefulWidget {
  final String playlistId;
  final String playlistName;

  const SongListPage({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  List<Song> _songs = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    setState(() => _isLoading = true);
    final uri = Uri.parse(
      'https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song-list/${widget.playlistId}'
      '${_searchQuery.isNotEmpty ? '?search=$_searchQuery' : ''}',
    );

    try {
      final response = await http.get(uri);
      final body = jsonDecode(response.body);

      if (body['success']) {
        setState(() {
          _songs = (body['data'] as List).map((e) => Song.fromJson(e)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to load songs: $e');
    }
  }

  void _onSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
    fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.playlistName),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: _onSearch,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search song...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[900],
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
                : ListView.separated(
                    itemCount: _songs.length,
                    separatorBuilder: (context, index) => const Divider(color: Colors.white12),
                    itemBuilder: (context, index) {
                      final song = _songs[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://learn.smktelkom-mlg.sch.id/ukl2/thumbnail/${song.thumbnail}',
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 55,
                              height: 55,
                              color: Colors.grey[800],
                              child: const Icon(Icons.music_note, color: Colors.white),
                            ),
                          ),
                        ),
                        title: Text(
                          song.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(song.artist, style: const TextStyle(color: Colors.white70)),
                            Text(
                              song.description,
                              style: const TextStyle(color: Colors.white38, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.favorite_border, color: Colors.white60, size: 18),
                            const SizedBox(height: 4),
                            Text('${song.likes}', style: const TextStyle(color: Colors.white60)),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SongDetailPage(songId: song.uuid),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSongPage()),
          );
        },
      ),
    );
  }
}
