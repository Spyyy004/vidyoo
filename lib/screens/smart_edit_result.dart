// models/video_segment.dart
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../utils/consts.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
class VideoSegment {
  final String startTime;
  final String endTime;
  final String description;
  VideoPlayerController? controller;
  bool isPlaying = false;

  VideoSegment({
    required this.startTime,
    required this.endTime,
    required this.description,
  });

  factory VideoSegment.fromJson(Map<String, dynamic> json) {
    return VideoSegment(
      startTime: json['startTime'],
      endTime: json['endTime'],
      description: json['description'],
    );
  }
}

// screens/video_segments_screen.dart
class VideoSegmentsScreen extends StatefulWidget {
  final List<dynamic> segments;
  final dynamic videoFile;

  const VideoSegmentsScreen({
    super.key,
    required this.segments,
    required this.videoFile,
  });

  @override
  State<VideoSegmentsScreen> createState() => _VideoSegmentsScreenState();
}

class _VideoSegmentsScreenState extends State<VideoSegmentsScreen> {
  List<VideoSegment> videoSegments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeSegments();
  }

  Future<void> _initializeSegments() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Convert JSON segments to VideoSegment objects
      videoSegments = widget.segments.map((segment) {
        return VideoSegment.fromJson(segment);
      }).toList();

      // Initialize video controllers for each segment
      for (var segment in videoSegments) {
        await _initializeVideoController(segment);
      }
    } catch (e) {
      print('Error initializing segments: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _initializeVideoController(VideoSegment segment) async {
    if (kIsWeb) {
      final blob = html.Blob([widget.videoFile]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      segment.controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
      );

      await segment.controller!.initialize();

      // Set the start position
      final startParts = segment.startTime.split(':');
      final startSeconds = int.parse(startParts[0]) * 3600 +
          int.parse(startParts[1]) * 60 +
          int.parse(startParts[2]);

      // Set the end position
      final endParts = segment.endTime.split(':');
      final endSeconds = int.parse(endParts[0]) * 3600 +
          int.parse(endParts[1]) * 60 +
          int.parse(endParts[2]);

      segment.controller!.setLooping(true);
      await segment.controller!.seekTo(Duration(seconds: startSeconds));

      // Add listener to handle loop within segment
      segment.controller!.addListener(() {
        final position = segment.controller!.value.position.inSeconds;
        if (position >= endSeconds) {
          segment.controller!.seekTo(Duration(seconds: startSeconds));
        }
      });
    }
  }

  @override
  void dispose() {
    for (var segment in videoSegments) {
      segment.controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Segments'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Extracted Segments',
              style: VidyooTheme.h2,
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                MediaQuery.of(context).size.width > 1200 ? 3 :
                MediaQuery.of(context).size.width > 800 ? 2 : 1,
                childAspectRatio: 16 / 11,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: videoSegments.length,
              itemBuilder: (context, index) {
                return _buildSegmentCard(videoSegments[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentCard(VideoSegment segment) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(VidyooTheme.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Player
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(VidyooTheme.radiusM),
                topRight: Radius.circular(VidyooTheme.radiusM),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (segment.controller != null)
                    AspectRatio(
                      aspectRatio: segment.controller!.value.aspectRatio,
                      child: VideoPlayer(segment.controller!),
                    ),
                  // Play/Pause Button
                  IconButton(
                    icon: Icon(
                      segment.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 48,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        segment.isPlaying = !segment.isPlaying;
                        if (segment.isPlaying) {
                          segment.controller?.play();
                        } else {
                          segment.controller?.pause();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // Segment Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  segment.description,
                  style: VidyooTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '${segment.startTime} - ${segment.endTime}',
                  style: VidyooTheme.bodySmall.copyWith(
                    color: VidyooTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}