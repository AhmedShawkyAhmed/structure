import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../localization/generated/app_localizations.dart';
import '../data/issue_report.dart';

class AttachmentPreview extends StatefulWidget {
  const AttachmentPreview({required this.attachment, super.key});
  final ReportAttachment attachment;

  @override
  State<AttachmentPreview> createState() => _AttachmentPreviewState();
}

class _AttachmentPreviewState extends State<AttachmentPreview> {
  VideoPlayerController? _player;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    if (widget.attachment.kind == AttachmentKind.video) {
      _initialize();
    }
  }

  Future<void> _initialize() async {
    final player = VideoPlayerController.file(File(widget.attachment.path));
    _player = player;
    try {
      await player.initialize();
      if (mounted) {
        setState(() {});
      }
    } on Object {
      if (mounted) {
        setState(() => _failed = true);
      }
    }
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = _player;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(AppLocalizations.of(context).previewAttachment),
      ),
      body: Center(
        child: widget.attachment.kind == AttachmentKind.image
            ? InteractiveViewer(child: Image.file(File(widget.attachment.path)))
            : _failed
            ? Text(
                AppLocalizations.of(context).videoPreviewFailed,
                style: const TextStyle(color: Colors.white),
              )
            : player == null || !player.value.isInitialized
            ? const CircularProgressIndicator()
            : ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: player,
                builder: (context, value, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AspectRatio(
                      aspectRatio: value.aspectRatio,
                      child: VideoPlayer(player),
                    ),
                    VideoProgressIndicator(player, allowScrubbing: true),
                    IconButton(
                      color: Colors.white,
                      icon: Icon(
                        value.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: () async {
                        if (value.isPlaying) {
                          await player.pause();
                        } else {
                          if (value.position >= value.duration) {
                            await player.seekTo(Duration.zero);
                          }
                          await player.play();
                        }
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
